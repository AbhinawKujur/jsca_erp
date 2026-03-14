<?php
// app/Libraries/FixtureEngine.php
namespace App\Libraries;

/**
 * JSCA Fixture Engine
 * Generates optimised cricket fixtures considering:
 *  - Round-robin, Knockout, Group+Knockout, Zonal formats
 *  - Venue availability & floodlight constraints
 *  - Travel minimisation across Jharkhand's 24 districts
 *  - Official workload balancing
 *  - Rest days between back-to-back matches for same team
 */
class FixtureEngine
{
    private array $config;
    private array $matchSlots   = [];   // date => [time slots used]
    private array $venueSlots   = [];   // venue_id+date => matches count
    private array $teamLastMatch= [];   // team_id => last match date
    private array $officialSlots= [];   // official_id+date => count
    private array $umpireIndex  = 0;
    private array $scorerIndex  = 0;
    private array $refereeIndex = 0;

    public function generate(array $config): array
    {
        $this->config = $config;

        $teams     = $config['teams'];
        $structure = $config['tournament']['structure'];
        $travelMode= $config['travel_constraint'];

        // Sort teams by zone for zonal grouping
        if ($travelMode === 'Zonal') {
            usort($teams, fn($a, $b) => strcmp($a['zone'], $b['zone']));
        }

        $matches = match ($structure) {
            'Round Robin'      => $this->generateRoundRobin($teams),
            'Knockout'         => $this->generateKnockout($teams),
            'Group+Knockout'   => $this->generateGroupKnockout($teams),
            'Zonal'            => $this->generateZonal($teams, $config['zonal_config']),
            default            => $this->generateRoundRobin($teams),
        };

        // Apply scheduling (dates, times, venues, officials)
        $scheduled = $this->scheduleMatches($matches);

        return [
            'success' => true,
            'matches' => $scheduled,
            'summary' => [
                'total_matches' => count($scheduled),
                'venues_used'   => count(array_unique(array_column($scheduled, 'venue_id'))),
                'date_range'    => [
                    'start' => $scheduled[0]['date']  ?? $config['start_date'],
                    'end'   => end($scheduled)['date'] ?? $config['end_date'],
                ],
                'night_matches' => count(array_filter($scheduled, fn($m) => $m['is_night'])),
                'officials_assigned' => count(array_filter($scheduled, fn($m) => !empty($m['umpire1_id']))),
            ],
        ];
    }

    // ── Round Robin: every team plays every other once ────────
    private function generateRoundRobin(array $teams): array
    {
        $matches = [];
        $n       = count($teams);
        for ($i = 0; $i < $n - 1; $i++) {
            for ($j = $i + 1; $j < $n; $j++) {
                $matches[] = [
                    'stage'     => 'League',
                    'team_a_id' => $teams[$i]['id'],
                    'team_b_id' => $teams[$j]['id'],
                    'team_a'    => $teams[$i],
                    'team_b'    => $teams[$j],
                    'zone'      => null,
                    'is_night'  => false,
                ];
            }
        }
        return $matches;
    }

    // ── Knockout: seeded bracket ──────────────────────────────
    private function generateKnockout(array $teams): array
    {
        $matches = [];
        $n       = count($teams);
        $round   = 1;
        $current = $teams;

        while (count($current) > 1) {
            $nextRound = [];
            $stageName = $this->getStageName(count($current));

            for ($i = 0; $i < count($current); $i += 2) {
                if (!isset($current[$i + 1])) {
                    $nextRound[] = $current[$i]; // bye
                    continue;
                }
                $matches[] = [
                    'stage'     => $stageName,
                    'team_a_id' => $current[$i]['id'],
                    'team_b_id' => $current[$i + 1]['id'],
                    'team_a'    => $current[$i],
                    'team_b'    => $current[$i + 1],
                    'zone'      => null,
                    'is_night'  => false,
                ];
                $nextRound[] = ['id' => 'TBD', 'name' => 'Winner ' . ($i / 2 + 1)];
            }
            $current = $nextRound;
            $round++;
        }

        return $matches;
    }

    // ── Group + Knockout ──────────────────────────────────────
    private function generateGroupKnockout(array $teams): array
    {
        $matches    = [];
        $groupSize  = 4;
        $groups     = array_chunk($teams, $groupSize);

        foreach ($groups as $gi => $group) {
            $groupLetter = chr(65 + $gi);
            foreach ($this->generateRoundRobin($group) as $m) {
                $m['stage'] = 'Group ' . $groupLetter;
                $matches[]  = $m;
            }
        }

        // Knockout stubs (QF, SF, F)
        $qfStubs = min(count($groups) * 2, 8);
        for ($i = 0; $i < $qfStubs / 2; $i++) {
            $matches[] = ['stage' => 'Quarter Final', 'team_a_id' => 'TBD', 'team_b_id' => 'TBD', 'team_a' => ['id' => 'TBD'], 'team_b' => ['id' => 'TBD'], 'zone' => null, 'is_night' => false];
        }
        $matches[] = ['stage' => 'Semi Final 1', 'team_a_id' => 'TBD', 'team_b_id' => 'TBD', 'team_a' => ['id' => 'TBD'], 'team_b' => ['id' => 'TBD'], 'zone' => null, 'is_night' => false];
        $matches[] = ['stage' => 'Semi Final 2', 'team_a_id' => 'TBD', 'team_b_id' => 'TBD', 'team_a' => ['id' => 'TBD'], 'team_b' => ['id' => 'TBD'], 'zone' => null, 'is_night' => false];
        $matches[] = ['stage' => 'Final',         'team_a_id' => 'TBD', 'team_b_id' => 'TBD', 'team_a' => ['id' => 'TBD'], 'team_b' => ['id' => 'TBD'], 'zone' => null, 'is_night' => true];

        return $matches;
    }

    // ── Zonal format ──────────────────────────────────────────
    private function generateZonal(array $teams, array $zoneConfig): array
    {
        $matches = [];
        $zones   = ['North', 'South', 'East', 'West', 'Central'];

        foreach ($zones as $zone) {
            $zoneTeams = array_filter($teams, fn($t) => $t['zone'] === $zone);
            $zoneTeams = array_values($zoneTeams);

            if (count($zoneTeams) < 2) continue;

            foreach ($this->generateRoundRobin($zoneTeams) as $m) {
                $m['stage'] = $zone . ' Zone';
                $m['zone']  = $zone;
                $matches[]  = $m;
            }
        }

        // Zone finals at JSCA Stadium
        $zoneCount = count($zones);
        for ($i = 0; $i < $zoneCount; $i++) {
            $matches[] = ['stage' => 'Zone Final', 'team_a_id' => 'TBD', 'team_b_id' => 'TBD', 'team_a' => ['id' => 'TBD'], 'team_b' => ['id' => 'TBD'], 'zone' => $zones[$i], 'is_night' => false];
        }
        $matches[] = ['stage' => 'Semi Final 1',  'team_a_id' => 'TBD', 'team_b_id' => 'TBD', 'team_a' => ['id' => 'TBD'], 'team_b' => ['id' => 'TBD'], 'zone' => null, 'is_night' => false];
        $matches[] = ['stage' => 'Semi Final 2',  'team_a_id' => 'TBD', 'team_b_id' => 'TBD', 'team_a' => ['id' => 'TBD'], 'team_b' => ['id' => 'TBD'], 'zone' => null, 'is_night' => false];
        $matches[] = ['stage' => 'Grand Final',   'team_a_id' => 'TBD', 'team_b_id' => 'TBD', 'team_a' => ['id' => 'TBD'], 'team_b' => ['id' => 'TBD'], 'zone' => null, 'is_night' => true];

        return $matches;
    }

    // ── Schedule: assign dates, times, venues, officials ─────
    private function scheduleMatches(array $matches): array
    {
        $cfg           = $this->config;
        $startDate     = new \DateTime($cfg['start_date']);
        $endDate       = new \DateTime($cfg['end_date']);
        $matchesPerDay = $cfg['matches_per_day'];
        $durationHrs   = $cfg['match_duration'];
        $startTime     = $cfg['start_time'];
        $allowNight    = $cfg['allow_night'];
        $venues        = $cfg['venues'];
        $umpires       = $cfg['umpires'];
        $scorers       = $cfg['scorers'];
        $referees      = $cfg['referees'];
        $travelMode    = $cfg['travel_constraint'];
        $officialMode  = $cfg['official_mode'];

        $currentDate   = clone $startDate;
        $dayCounter    = 0;
        $matchNo       = 1;
        $scheduled     = [];

        // Precompute venue lat/lng index
        $venueMap = [];
        foreach ($venues as $v) {
            $venueMap[$v['id']] = $v;
        }

        foreach ($matches as $match) {
            // Skip TBD knockout stubs from scheduling
            if ($match['team_a_id'] === 'TBD') {
                $scheduled[] = array_merge($match, [
                    'match_number' => 'M' . str_pad($matchNo++, 2, '0', STR_PAD_LEFT),
                    'date'         => 'TBD',
                    'time'         => 'TBD',
                    'venue_id'     => null,
                    'is_night'     => false,
                    'umpire1_id'   => null,
                    'umpire2_id'   => null,
                    'scorer_id'    => null,
                    'referee_id'   => null,
                ]);
                continue;
            }

            // Find next available slot
            $slotFound = false;
            $attempts  = 0;
            while (!$slotFound && $attempts < 200) {
                if ($currentDate > $endDate) break;

                $dateStr    = $currentDate->format('Y-m-d');
                $dayMatches = $this->matchSlots[$dateStr] ?? 0;

                if ($dayMatches >= $matchesPerDay) {
                    $currentDate->modify('+1 day');
                    continue;
                }

                // Enforce rest day: team should not play 2 days in a row (if travel constraint)
                if ($travelMode !== 'None') {
                    $teamALast = $this->teamLastMatch[$match['team_a_id']] ?? null;
                    $teamBLast = $this->teamLastMatch[$match['team_b_id']] ?? null;

                    if ($teamALast && abs((new \DateTime($dateStr))->diff(new \DateTime($teamALast))->days) < 1) {
                        $currentDate->modify('+1 day');
                        $attempts++;
                        continue;
                    }
                    if ($teamBLast && abs((new \DateTime($dateStr))->diff(new \DateTime($teamBLast))->days) < 1) {
                        $currentDate->modify('+1 day');
                        $attempts++;
                        continue;
                    }
                }

                // Pick best venue
                $venueId  = $this->pickVenue($match, $venues, $dateStr, $travelMode);
                $venue    = $venueMap[$venueId] ?? $venues[0];

                // Pick time slot
                $slotIdx  = $dayMatches; // 0=morning, 1=afternoon, 2=evening
                $time     = $this->pickTimeSlot($slotIdx, $startTime, $durationHrs, $venue, $allowNight);
                $isNight  = (substr($time, 0, 2) >= 17);

                // If night requested but no lights at venue, skip to next venue or skip night
                if ($isNight && !$venue['has_floodlights']) {
                    $time    = $this->pickTimeSlot(0, $startTime, $durationHrs, $venue, false);
                    $isNight = false;
                }

                // Assign officials
                $officials = [];
                if ($officialMode === 'auto' || $officialMode === 'hybrid') {
                    $officials = $this->assignOfficials($umpires, $scorers, $referees, $dateStr, $match);
                }

                // Record slot usage
                $this->matchSlots[$dateStr]                    = ($this->matchSlots[$dateStr] ?? 0) + 1;
                $this->venueSlots[$venueId . '_' . $dateStr]   = ($this->venueSlots[$venueId . '_' . $dateStr] ?? 0) + 1;
                $this->teamLastMatch[$match['team_a_id']]       = $dateStr;
                $this->teamLastMatch[$match['team_b_id']]       = $dateStr;

                $scheduled[] = array_merge($match, [
                    'match_number' => 'M' . str_pad($matchNo++, 2, '0', STR_PAD_LEFT),
                    'date'         => $dateStr,
                    'time'         => $time,
                    'venue_id'     => $venueId,
                    'is_night'     => $isNight,
                    'umpire1_id'   => $officials['umpire1'] ?? null,
                    'umpire2_id'   => $officials['umpire2'] ?? null,
                    'scorer_id'    => $officials['scorer']  ?? null,
                    'referee_id'   => $officials['referee'] ?? null,
                ]);

                $slotFound = true;
            }
        }

        return $scheduled;
    }

    // ── Pick best venue based on travel constraint ────────────
    private function pickVenue(array $match, array $venues, string $date, string $travelMode): int
    {
        // Finals always at first venue (JSCA Stadium)
        if (in_array($match['stage'], ['Final', 'Grand Final', 'Zone Final'])) {
            return $venues[0]['id'];
        }

        if ($travelMode === 'Minimize' || $travelMode === 'Zonal') {
            // Prefer venue closest to average of both team districts
            $teamA = $match['team_a'];
            $teamB = $match['team_b'];
            $aLat  = (float)($teamA['lat'] ?? 0);
            $aLng  = (float)($teamA['lng'] ?? 0);
            $bLat  = (float)($teamB['lat'] ?? 0);
            $bLng  = (float)($teamB['lng'] ?? 0);
            $midLat = ($aLat + $bLat) / 2;
            $midLng = ($aLng + $bLng) / 2;

            $best     = null;
            $bestDist = PHP_FLOAT_MAX;

            foreach ($venues as $v) {
                $vLat  = (float)($v['lat'] ?? 0);
                $vLng  = (float)($v['lng'] ?? 0);
                $dist  = sqrt(pow($vLat - $midLat, 2) + pow($vLng - $midLng, 2));
                $used  = $this->venueSlots[$v['id'] . '_' . $date] ?? 0;

                // Penalise over-used venues
                $score = $dist + ($used * 0.5);

                if ($score < $bestDist) {
                    $bestDist = $score;
                    $best     = $v['id'];
                }
            }
            return $best ?? $venues[0]['id'];
        }

        if ($travelMode === 'Centralized') {
            return $venues[0]['id'];
        }

        // Default: rotate venues
        $idx = array_sum(array_map(fn($v) => $this->venueSlots[$v['id'] . '_' . $date] ?? 0, $venues));
        return $venues[$idx % count($venues)]['id'];
    }

    // ── Pick time slot ────────────────────────────────────────
    private function pickTimeSlot(int $slotIdx, string $baseTime, int $durationHrs, array $venue, bool $allowNight): string
    {
        $base    = strtotime($baseTime);
        $seconds = $slotIdx * ($durationHrs * 3600 + 1800); // duration + 30 min gap
        $ts      = $base + $seconds;
        $hour    = (int)date('H', $ts);

        // Cap at 18:00 if no floodlights
        if (!$venue['has_floodlights'] && $hour >= 18) {
            return '09:00:00';
        }

        return date('H:i:s', $ts);
    }

    // ── Assign officials balancing workload ───────────────────
    private function assignOfficials(array $umpires, array $scorers, array $referees, string $date, array $match): array
    {
        $result = [];

        // Umpires — exclude anyone from same district as either team
        $teamADist = $match['team_a']['district_id'] ?? null;
        $teamBDist = $match['team_b']['district_id'] ?? null;

        $eligibleUmpires = array_filter($umpires, fn($u) =>
            $u['district_id'] != $teamADist &&
            $u['district_id'] != $teamBDist &&
            ($this->officialSlots[$u['id'] . '_' . $date] ?? 0) < 2
        );
        $eligibleUmpires = array_values($eligibleUmpires);

        usort($eligibleUmpires, fn($a, $b) =>
            ($this->officialSlots[$a['id'] . '_' . $date] ?? 0) <=>
            ($this->officialSlots[$b['id'] . '_' . $date] ?? 0)
        );

        if (!empty($eligibleUmpires)) {
            $result['umpire1'] = $eligibleUmpires[0]['id'];
            $this->officialSlots[$eligibleUmpires[0]['id'] . '_' . $date] = ($this->officialSlots[$eligibleUmpires[0]['id'] . '_' . $date] ?? 0) + 1;
        }
        if (isset($eligibleUmpires[1]) && $this->config['umpires_per_match'] >= 2) {
            $result['umpire2'] = $eligibleUmpires[1]['id'];
            $this->officialSlots[$eligibleUmpires[1]['id'] . '_' . $date] = ($this->officialSlots[$eligibleUmpires[1]['id'] . '_' . $date] ?? 0) + 1;
        }

        // Scorer
        usort($scorers, fn($a, $b) =>
            ($this->officialSlots[$a['id'] . '_' . $date] ?? 0) <=>
            ($this->officialSlots[$b['id'] . '_' . $date] ?? 0)
        );
        if (!empty($scorers)) {
            $result['scorer'] = $scorers[0]['id'];
            $this->officialSlots[$scorers[0]['id'] . '_' . $date] = ($this->officialSlots[$scorers[0]['id'] . '_' . $date] ?? 0) + 1;
        }

        // Referee
        if (!empty($referees)) {
            usort($referees, fn($a, $b) =>
                ($this->officialSlots[$a['id'] . '_' . $date] ?? 0) <=>
                ($this->officialSlots[$b['id'] . '_' . $date] ?? 0)
            );
            $result['referee'] = $referees[0]['id'];
        }

        return $result;
    }

    private function getStageName(int $teamsRemaining): string
    {
        return match ($teamsRemaining) {
            2  => 'Final',
            4  => 'Semi Final',
            8  => 'Quarter Final',
            16 => 'Round of 16',
            default => 'Round',
        };
    }
}
