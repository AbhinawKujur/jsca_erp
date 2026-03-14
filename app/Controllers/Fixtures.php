<?php
// app/Controllers/Fixtures.php
namespace App\Controllers;

use App\Libraries\FixtureEngine;

class Fixtures extends BaseController
{
    // ── GET /fixtures ─────────────────────────────────────────
    public function index()
    {
        $fixtures = $this->db->table('fixtures f')
            ->select('f.*, t.name as tournament_name, ta.name as team_a_name, tb.name as team_b_name, v.name as venue_name, v.has_floodlights')
            ->join('tournaments t',  't.id = f.tournament_id')
            ->join('teams ta',       'ta.id = f.team_a_id')
            ->join('teams tb',       'tb.id = f.team_b_id')
            ->join('venues v',       'v.id = f.venue_id')
            ->orderBy('f.match_date', 'ASC')
            ->orderBy('f.match_time', 'ASC')
            ->get()->getResultArray();

        return $this->render('fixtures/index', [
            'pageTitle' => 'Fixtures — JSCA ERP',
            'fixtures'  => $fixtures,
            'tournaments' => $this->db->table('tournaments')->orderBy('name')->get()->getResultArray(),
        ]);
    }

    // ── GET /fixtures/tournament/:id ─────────────────────────
    public function tournament(int $tournamentId)
    {
        $tournament = $this->db->table('tournaments')->where('id', $tournamentId)->get()->getRowArray();
        if (!$tournament) return redirect()->to('/fixtures')->with('error', 'Tournament not found.');

        $fixtures = $this->db->table('fixtures f')
            ->select('f.*, ta.name as team_a_name, tb.name as team_b_name, v.name as venue_name,
                      v.has_floodlights, o1.full_name as umpire1_name, o2.full_name as umpire2_name,
                      sc.full_name as scorer_name, rf.full_name as referee_name, ms.team_a_score, ms.team_b_score')
            ->join('teams ta',    'ta.id = f.team_a_id')
            ->join('teams tb',    'tb.id = f.team_b_id')
            ->join('venues v',    'v.id = f.venue_id')
            ->join('officials o1','o1.id = f.umpire1_id', 'left')
            ->join('officials o2','o2.id = f.umpire2_id', 'left')
            ->join('officials sc','sc.id = f.scorer_id',  'left')
            ->join('officials rf','rf.id = f.referee_id', 'left')
            ->join('match_scorecards ms', 'ms.fixture_id = f.id', 'left')
            ->where('f.tournament_id', $tournamentId)
            ->orderBy('f.match_date', 'ASC')
            ->orderBy('f.match_time', 'ASC')
            ->get()->getResultArray();

        return $this->render('fixtures/tournament', [
            'pageTitle'  => $tournament['name'] . ' — Fixtures',
            'tournament' => $tournament,
            'fixtures'   => $fixtures,
        ]);
    }

    // ── GET /fixtures/generate/:tournamentId ─────────────────
    public function generateForm(int $tournamentId)
    {
        $this->requirePermission('fixtures');

        $tournament = $this->db->table('tournaments')->where('id', $tournamentId)->get()->getRowArray();
        if (!$tournament) return redirect()->to('/fixtures')->with('error', 'Tournament not found.');

        $teams   = $this->db->table('teams')->where('tournament_id', $tournamentId)->get()->getResultArray();
        $venues  = $this->db->table('venues v')
            ->select('v.*, d.name as district_name')
            ->join('districts d', 'd.id = v.district_id')
            ->where('v.is_active', 1)
            ->orderBy('v.has_floodlights', 'DESC')
            ->get()->getResultArray();
        $officials = $this->db->table('officials')->where('is_active', 1)->orderBy('role')->orderBy('full_name')->get()->getResultArray();
        $districts = $this->db->table('districts')->orderBy('zone')->orderBy('name')->get()->getResultArray();

        return $this->render('fixtures/generate', [
            'pageTitle'  => 'Generate Fixture — ' . $tournament['name'],
            'tournament' => $tournament,
            'teams'      => $teams,
            'venues'     => $venues,
            'officials'  => $officials,
            'districts'  => $districts,
        ]);
    }

    // ── POST /fixtures/auto-generate/:tournamentId ───────────
    public function autoGenerate(int $tournamentId)
    {
        $this->requirePermission('fixtures');

        $tournament = $this->db->table('tournaments')->where('id', $tournamentId)->get()->getRowArray();
        if (!$tournament) {
            return $this->response->setJSON(['success' => false, 'message' => 'Tournament not found.']);
        }

        $post = $this->request->getPost();

        // Validate required inputs
        $venueIds    = $post['venue_ids']    ?? [];
        $teamIds     = $post['team_ids']     ?? [];
        $startDate   = $post['start_date']   ?? date('Y-m-d');
        $endDate     = $post['end_date']     ?? date('Y-m-d', strtotime('+60 days'));
        $matchesPerDay  = (int)($post['matches_per_day']    ?? 3);
        $startTime      = $post['start_time'] ?? '09:00:00';
        $matchDuration  = (int)($post['match_duration_hrs'] ?? 4); // hours
        $nightMatches   = (bool)($post['allow_night'] ?? false);
        $travelMode     = $post['travel_constraint'] ?? 'None';
        $officialMode   = $post['official_mode']     ?? 'auto';
        $umpirePerMatch = (int)($post['umpires_per_match'] ?? 2);

        if (empty($teamIds) || count($teamIds) < 2) {
            return $this->response->setJSON(['success' => false, 'message' => 'At least 2 teams required.']);
        }
        if (empty($venueIds)) {
            return $this->response->setJSON(['success' => false, 'message' => 'At least 1 venue required.']);
        }

        // Load teams with district info
        $teams = $this->db->table('teams t')
            ->select('t.*, d.lat, d.lng, d.zone')
            ->join('districts d', 'd.id = t.district_id')
            ->whereIn('t.id', $teamIds)
            ->get()->getResultArray();

        // Load venues
        $venues = $this->db->table('venues')
            ->whereIn('id', $venueIds)
            ->get()->getResultArray();

        // Load available officials
        $umpires  = $this->db->table('officials')->where('role', 'Umpire')->where('is_active', 1)->get()->getResultArray();
        $scorers  = $this->db->table('officials')->where('role', 'Scorer')->where('is_active', 1)->get()->getResultArray();
        $referees = $this->db->table('officials')->where('role', 'Match Referee')->where('is_active', 1)->get()->getResultArray();

        // ── Generate using FixtureEngine ──────────────────────
        $engine   = new FixtureEngine();
        $fixtures = $engine->generate([
            'tournament'       => $tournament,
            'teams'            => $teams,
            'venues'           => $venues,
            'umpires'          => $umpires,
            'scorers'          => $scorers,
            'referees'         => $referees,
            'start_date'       => $startDate,
            'end_date'         => $endDate,
            'matches_per_day'  => $matchesPerDay,
            'start_time'       => $startTime,
            'match_duration'   => $matchDuration,
            'allow_night'      => $nightMatches,
            'travel_constraint'=> $travelMode,
            'official_mode'    => $officialMode,
            'umpires_per_match'=> $umpirePerMatch,
            'zonal_config'     => $post['zones'] ?? [],
        ]);

        if (!$fixtures['success']) {
            return $this->response->setJSON($fixtures);
        }

        // ── Persist to database ───────────────────────────────
        $this->db->transStart();

        // Clear existing scheduled fixtures for this tournament
        $this->db->table('fixtures')
            ->where('tournament_id', $tournamentId)
            ->where('status', 'Scheduled')
            ->delete();

        foreach ($fixtures['matches'] as $match) {
            $this->db->table('fixtures')->insert([
                'tournament_id' => $tournamentId,
                'match_number'  => $match['match_number'],
                'stage'         => $match['stage'],
                'zone'          => $match['zone'] ?? null,
                'match_date'    => $match['date'],
                'match_time'    => $match['time'],
                'team_a_id'     => $match['team_a_id'],
                'team_b_id'     => $match['team_b_id'],
                'venue_id'      => $match['venue_id'],
                'is_day_night'  => $match['is_night'] ? 1 : 0,
                'umpire1_id'    => $match['umpire1_id'] ?? null,
                'umpire2_id'    => $match['umpire2_id'] ?? null,
                'scorer_id'     => $match['scorer_id'] ?? null,
                'referee_id'    => $match['referee_id'] ?? null,
                'status'        => 'Scheduled',
                'created_by'    => session('user_id'),
                'created_at'    => date('Y-m-d H:i:s'),
            ]);
        }

        // Update tournament status
        $this->db->table('tournaments')->where('id', $tournamentId)->update([
            'total_matches' => count($fixtures['matches']),
            'status'        => 'Fixture Ready',
            'updated_at'    => date('Y-m-d H:i:s'),
        ]);

        $this->db->transComplete();

        if (!$this->db->transStatus()) {
            return $this->response->setJSON(['success' => false, 'message' => 'Database error while saving fixture.']);
        }

        $this->audit('FIXTURE_GENERATED', 'fixtures', $tournamentId, null, ['total_matches' => count($fixtures['matches'])]);

        return $this->response->setJSON([
            'success'  => true,
            'message'  => count($fixtures['matches']) . ' matches generated successfully!',
            'matches'  => $fixtures['matches'],
            'summary'  => $fixtures['summary'],
            'redirect' => '/fixtures/tournament/' . $tournamentId,
        ]);
    }

    // ── GET /fixtures/upload/:tournamentId ───────────────────
    public function uploadForm(int $tournamentId)
    {
        $this->requirePermission('fixtures');

        $tournament = $this->db->table('tournaments')->where('id', $tournamentId)->get()->getRowArray();
        if (!$tournament) return redirect()->to('/fixtures')->with('error', 'Tournament not found.');

        return $this->render('fixtures/upload', [
            'pageTitle'  => 'Upload Fixture — ' . $tournament['name'],
            'tournament' => $tournament,
        ]);
    }

    // ── POST /fixtures/upload-process/:tournamentId ──────────
    public function uploadProcess(int $tournamentId)
    {
        $this->requirePermission('fixtures');

        $file = $this->request->getFile('fixture_file');

        if (!$file || !$file->isValid()) {
            return redirect()->back()->with('error', 'No file uploaded or file is invalid.');
        }

        $ext = strtolower($file->getExtension());
        if (!in_array($ext, ['csv', 'xlsx', 'xls'])) {
            return redirect()->back()->with('error', 'Only CSV or Excel files are accepted.');
        }

        // Move file to writable
        $fileName = 'fixture_upload_' . $tournamentId . '_' . time() . '.' . $ext;
        $file->move(WRITEPATH . 'uploads/fixtures', $fileName);
        $filePath = WRITEPATH . 'uploads/fixtures/' . $fileName;

        // Parse the file
        $rows = ($ext === 'csv')
            ? $this->parseCSV($filePath)
            : $this->parseExcel($filePath);

        if (empty($rows)) {
            return redirect()->back()->with('error', 'File is empty or could not be parsed.');
        }

        $errors   = [];
        $inserted = 0;

        $this->db->transStart();

        // Clear existing scheduled fixtures
        $this->db->table('fixtures')
            ->where('tournament_id', $tournamentId)
            ->where('status', 'Scheduled')
            ->delete();

        foreach ($rows as $i => $row) {
            $line = $i + 2;

            // Required field checks
            if (empty($row['match_date']) || empty($row['team_a']) || empty($row['team_b'])) {
                $errors[] = "Row {$line}: Match date, Team A and Team B are required.";
                continue;
            }

            // Resolve team names to IDs
            $teamA = $this->db->table('teams')
                ->where('tournament_id', $tournamentId)
                ->like('name', $row['team_a'])
                ->get()->getRowArray();
            $teamB = $this->db->table('teams')
                ->where('tournament_id', $tournamentId)
                ->like('name', $row['team_b'])
                ->get()->getRowArray();

            if (!$teamA) { $errors[] = "Row {$line}: Team A '{$row['team_a']}' not found in this tournament."; continue; }
            if (!$teamB) { $errors[] = "Row {$line}: Team B '{$row['team_b']}' not found in this tournament."; continue; }

            // Resolve venue
            $venue = null;
            if (!empty($row['venue'])) {
                $venue = $this->db->table('venues')->like('name', $row['venue'])->get()->getRowArray();
            }

            // Resolve officials
            $umpire1  = $this->resolveOfficial($row['umpire_1'] ?? null, 'Umpire');
            $umpire2  = $this->resolveOfficial($row['umpire_2'] ?? null, 'Umpire');
            $scorer   = $this->resolveOfficial($row['scorer']   ?? null, 'Scorer');
            $referee  = $this->resolveOfficial($row['referee']  ?? null, 'Match Referee');

            $matchCount = $this->db->table('fixtures')
                ->where('tournament_id', $tournamentId)->countAllResults() + 1;

            $this->db->table('fixtures')->insert([
                'tournament_id' => $tournamentId,
                'match_number'  => $row['match_number'] ?? ('M' . str_pad($matchCount, 2, '0', STR_PAD_LEFT)),
                'stage'         => $row['stage'] ?? 'League',
                'zone'          => $row['zone'] ?? null,
                'match_date'    => date('Y-m-d', strtotime($row['match_date'])),
                'match_time'    => !empty($row['match_time']) ? date('H:i:s', strtotime($row['match_time'])) : '09:00:00',
                'team_a_id'     => $teamA['id'],
                'team_b_id'     => $teamB['id'],
                'venue_id'      => $venue['id'] ?? null,
                'umpire1_id'    => $umpire1,
                'umpire2_id'    => $umpire2,
                'scorer_id'     => $scorer,
                'referee_id'    => $referee,
                'is_day_night'  => (!empty($row['floodlights']) && strtolower($row['floodlights']) === 'y') ? 1 : 0,
                'status'        => 'Scheduled',
                'created_by'    => session('user_id'),
                'created_at'    => date('Y-m-d H:i:s'),
            ]);
            $inserted++;
        }

        $this->db->transComplete();

        $this->audit('FIXTURE_UPLOADED', 'fixtures', $tournamentId, null, ['rows' => $inserted]);

        if (!empty($errors)) {
            session()->setFlashdata('upload_errors', $errors);
        }

        return redirect()->to('/fixtures/tournament/' . $tournamentId)
            ->with('success', "{$inserted} match(es) imported successfully." . (count($errors) ? ' Some rows had errors — see details.' : ''));
    }

    // ── GET /fixtures/download-template ─────────────────────
    public function downloadTemplate()
    {
        $filename = 'JSCA_Fixture_Template_v2.csv';
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . $filename . '"');

        $handle = fopen('php://output', 'w');
        fputcsv($handle, [
            'match_number','match_date (YYYY-MM-DD)','match_time (HH:MM)','stage',
            'team_a','team_b','venue','format','zone',
            'umpire_1','umpire_2','scorer','referee',
            'floodlights (Y/N)','notes'
        ]);
        // Sample rows
        fputcsv($handle, ['M01','2024-04-15','09:00','League','Ranchi XI','Dhanbad FC','JSCA International Stadium','T20','South Zone','Ravi Sharma','Priya Tiwari','Anil Das','Mohan Referee','Y','']);
        fputcsv($handle, ['M02','2024-04-15','13:00','League','Bokaro Stars','Jamshedpur Royals','JSCA International Stadium','T20','East Zone','','','','','Y','']);
        fclose($handle);
        exit;
    }

    // ── GET /fixtures/view/:id ───────────────────────────────
    public function view(int $id)
    {
        $fixture = $this->db->table('fixtures f')
            ->select('f.*, t.name as tournament_name, ta.name as team_a_name, tb.name as team_b_name,
                      v.name as venue_name, v.has_floodlights, v.address as venue_address,
                      o1.full_name as umpire1_name, o2.full_name as umpire2_name,
                      sc.full_name as scorer_name, rf.full_name as referee_name')
            ->join('tournaments t',  't.id = f.tournament_id')
            ->join('teams ta',       'ta.id = f.team_a_id')
            ->join('teams tb',       'tb.id = f.team_b_id')
            ->join('venues v',       'v.id = f.venue_id')
            ->join('officials o1',   'o1.id = f.umpire1_id', 'left')
            ->join('officials o2',   'o2.id = f.umpire2_id', 'left')
            ->join('officials sc',   'sc.id = f.scorer_id',  'left')
            ->join('officials rf',   'rf.id = f.referee_id', 'left')
            ->where('f.id', $id)
            ->get()->getRowArray();

        if (!$fixture) return redirect()->to('/fixtures')->with('error', 'Fixture not found.');

        $scorecard = $this->db->table('match_scorecards')->where('fixture_id', $id)->get()->getRowArray();

        return $this->render('fixtures/view', [
            'pageTitle' => 'Match ' . $fixture['match_number'],
            'fixture'   => $fixture,
            'scorecard' => $scorecard,
        ]);
    }

    // ── Export fixture to CSV ─────────────────────────────────
    public function export(int $tournamentId)
    {
        $tournament = $this->db->table('tournaments')->where('id', $tournamentId)->get()->getRowArray();

        $fixtures = $this->db->table('fixtures f')
            ->select('f.match_number, f.match_date, f.match_time, f.stage, f.zone,
                      ta.name as team_a, tb.name as team_b, v.name as venue, t.format,
                      o1.full_name as umpire1, o2.full_name as umpire2,
                      sc.full_name as scorer, rf.full_name as referee,
                      IF(f.is_day_night, "Y", "N") as floodlights, f.status')
            ->join('teams ta',    'ta.id = f.team_a_id')
            ->join('teams tb',    'tb.id = f.team_b_id')
            ->join('venues v',    'v.id = f.venue_id')
            ->join('tournaments t','t.id = f.tournament_id')
            ->join('officials o1','o1.id = f.umpire1_id', 'left')
            ->join('officials o2','o2.id = f.umpire2_id', 'left')
            ->join('officials sc','sc.id = f.scorer_id',  'left')
            ->join('officials rf','rf.id = f.referee_id', 'left')
            ->where('f.tournament_id', $tournamentId)
            ->orderBy('f.match_date')->orderBy('f.match_time')
            ->get()->getResultArray();

        $filename = 'JSCA_Fixture_' . str_replace(' ', '_', $tournament['name'] ?? $tournamentId) . '_' . date('Ymd') . '.csv';
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . $filename . '"');

        $handle = fopen('php://output', 'w');
        fputcsv($handle, array_keys($fixtures[0] ?? []));
        foreach ($fixtures as $row) fputcsv($handle, array_values($row));
        fclose($handle);
        exit;
    }

    // ─── Private helpers ──────────────────────────────────────
    private function parseCSV(string $path): array
    {
        $rows    = [];
        $headers = [];
        if (($handle = fopen($path, 'r')) !== false) {
            while (($data = fgetcsv($handle)) !== false) {
                if (empty($headers)) {
                    $headers = array_map('strtolower', array_map('trim', $data));
                    $headers = array_map(fn($h) => str_replace([' ', '(', ')'], ['_', '', ''], $h), $headers);
                } else {
                    $rows[] = array_combine($headers, $data);
                }
            }
            fclose($handle);
        }
        return $rows;
    }

    private function parseExcel(string $path): array
    {
        // Requires phpoffice/phpspreadsheet
        $spreadsheet = \PhpOffice\PhpSpreadsheet\IOFactory::load($path);
        $sheet       = $spreadsheet->getActiveSheet()->toArray(null, true, true, false);
        $rows        = [];
        $headers     = [];
        foreach ($sheet as $i => $row) {
            $row = array_map('trim', $row);
            if ($i === 0) {
                $headers = array_map('strtolower', $row);
            } else {
                if (array_filter($row)) {
                    $rows[] = array_combine($headers, $row);
                }
            }
        }
        return $rows;
    }

    private function resolveOfficial(?string $name, string $role): ?int
    {
        if (empty($name)) return null;
        $official = $this->db->table('officials')
            ->where('role', $role)
            ->like('full_name', $name)
            ->get()->getRowArray();
        return $official['id'] ?? null;
    }
}
