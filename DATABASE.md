# JSCA ERP — Database Schema Reference

> **Stack**: MariaDB 10.4 · InnoDB · utf8mb4  
> **App DB**: `jsca_erp` · App user: `dev_user` · Root: `root/root` (Docker only)

---

## Table of Contents

1. [Domain Overview](#domain-overview)
2. [Entity Relationship Diagram](#entity-relationship-diagram)
3. [Auth & Access](#auth--access)
4. [People — Players](#people--players)
5. [People — Coaches](#people--coaches)
6. [People — Officials](#people--officials)
7. [Venues](#venues)
8. [Tournaments & Teams](#tournaments--teams)
9. [Fixtures & Scoring](#fixtures--scoring)
10. [Finance](#finance)
11. [System](#system)
12. [RBAC Quick Reference](#rbac-quick-reference)
13. [ID Format Reference](#id-format-reference)

---

## Domain Overview

```
DISTRICTS (24 rows, 5 zones)
    │
    ├── USERS ──── ROLES (8 roles, JSON permissions)
    │       └── USER_DISTRICTS (many-to-many RBAC)
    │
    ├── PLAYERS ── PLAYER_CAREER_STATS
    │           └── PLAYER_DOCUMENTS
    │
    ├── COACHES ── COACH_DOCUMENTS
    │
    ├── OFFICIALS ── OFFICIAL_TYPES (4 types)
    │            └── OFFICIAL_CERTIFICATIONS
    │
    ├── VENUES
    │
    └── TOURNAMENTS ── TEAMS ── TEAM_PLAYERS
                   │        └── TEAM_COACHES
                   │        └── TEAM_DOCUMENTS
                   │
                   └── FIXTURES ── MATCH_SCORECARDS
                               ├── BATTING_STATS
                               ├── BOWLING_STATS
                               └── PAYMENT_VOUCHERS
```

---

## Entity Relationship Diagram

```
roles ──────────────────────────────────────────────────────────────────┐
  │ id, name, permissions(JSON)                                          │
  │                                                                      │
  ├──< users                                                             │
  │      id, role_id(FK), full_name, email*, phone                      │
  │      password_hash, is_active, last_login                           │
  │      reset_token, reset_expires                                      │
  │         │                                                            │
  │         ├──< user_districts >──── districts                         │
  │         │      user_id(FK)         id, name, zone, code*            │
  │         │      district_id(FK)     lat, lng, is_active              │
  │         │                               │                           │
  │         │      ┌────────────────────────┤                           │
  │         │      │                        │                           │
  │         │      ├──< players             │                           │
  │         │      │      id, jsca_player_id*                           │
  │         │      │      full_name, dob, gender, age_category          │
  │         │      │      district_id(FK), role, batting_style          │
  │         │      │      bowling_style, aadhaar_number, aadhaar_verified│
  │         │      │      photo_path, address, guardian_name            │
  │         │      │      guardian_phone, email, phone, status          │
  │         │      │      selection_pool, registered_by(FK→users)       │
  │         │      │      user_id(FK→users), registration_type          │
  │         │      │      verified_by(FK→users), verified_at            │
  │         │      │         │
  │         │      │         ├──── player_career_stats (1:1)
  │         │      │         │       player_id(FK), matches, runs
  │         │      │         │       highest_score, batting_avg
  │         │      │         │       strike_rate, fifties, hundreds
  │         │      │         │       wickets, best_bowling, bowling_avg
  │         │      │         │       economy, catches
  │         │      │         │
  │         │      │         ├──< player_documents
  │         │      │         │       player_id(FK), doc_type, label
  │         │      │         │       file_path, file_name, mime_type
  │         │      │         │       verified, verified_by, verified_at
  │         │      │         │       uploaded_by
  │         │      │         │
  │         │      │         └── player_otp_verifications (self-reg)
  │         │      │                 email, otp, expires_at, verified
  │         │      │
  │         │      ├──< coaches
  │         │      │      id, jsca_coach_id*, full_name, dob, gender
  │         │      │      phone, email, address, district_id(FK)
  │         │      │      photo_path, specialization, level
  │         │      │      bcci_coach_id, aadhaar_number, aadhaar_verified
  │         │      │      experience_years, previous_teams, achievements
  │         │      │      status, registered_by(FK→users)
  │         │      │         │
  │         │      │         └──< coach_documents
  │         │      │                 coach_id(FK), doc_type, label
  │         │      │                 file_path, file_name, mime_type
  │         │      │                 verified, verified_by, verified_at
  │         │      │
  │         │      ├──< venues
  │         │      │      id, name, district_id(FK), capacity
  │         │      │      has_floodlights, has_scoreboard, has_dressing
  │         │      │      pitch_type, contact_person, contact_phone
  │         │      │      address, lat, lng, is_active
  │         │      │
  │         │      └──< officials
  │                      id, jsca_official_id*, official_type_id(FK)
  │                      full_name, email, phone, gender, dob
  │                      district_id(FK), address, experience_years
  │                      profile_photo, user_id(FK→users), status
  │                      registered_by(FK→users)
  │                         │
  │                         ├── official_types (lookup)
  │                         │       id, name, prefix, role_id(FK→roles)
  │                         │       is_active
  │                         │       [Umpire/UMP→5, Scorer/SCR→6,
  │                         │        Referee/REF→7, MatchRef/MRF→8]
  │                         │
  │                         └──< official_certifications
  │                                 official_id(FK), certification_name
  │                                 body, level, certified_date
  │
  └──< tournaments
         id, name, season, age_category, gender, format, overs
         structure, is_zonal, start_date, end_date
         registration_deadline, total_teams, total_matches
         status, prize_pool, travel_constraint
         created_by(FK→users)
            │
            ├──── tournament_budgets (1:1)
            │       tournament_id(FK), total_budget, allocated, spent
            │
            ├──< tournament_documents
            │       tournament_id(FK), doc_type, label
            │       file_path, file_name, verified
            │
            └──< teams
                   id, tournament_id(FK), district_id(FK), name, zone
                   captain_id(FK→players), vice_captain_id(FK→players)
                   status
                      │
                      ├──< team_players
                      │       team_id(FK), player_id(FK)
                      │       jersey_number, is_captain
                      │       is_vice_captain, is_wk
                      │
                      ├──< team_coaches
                      │       team_id(FK), coach_id(FK)
                      │       role, from_date, to_date, is_current
                      │
                      ├──< team_documents
                      │       team_id(FK), doc_type, label
                      │       file_path, file_name, verified
                      │
                      └──< fixtures
                             id, tournament_id(FK), match_number, stage
                             zone, match_date, match_time
                             team_a_id(FK→teams), team_b_id(FK→teams)
                             venue_id(FK→venues), is_day_night
                             umpire1_id(FK→officials)
                             umpire2_id(FK→officials)
                             scorer_id(FK→officials)
                             referee_id(FK→officials)
                             status, winner_team_id(FK→teams)
                             result_summary, crichieros_id, youtube_url
                             created_by(FK→users)
                                │
                                ├──── match_scorecards (1:1)
                                │       fixture_id(FK), toss_winner_id
                                │       toss_decision, team_a_score
                                │       team_b_score, team_a_overs
                                │       team_b_overs
                                │       player_of_match(FK→players)
                                │       source, notes
                                │
                                ├──< batting_stats
                                │       fixture_id(FK), player_id(FK)
                                │       team_id(FK), innings, runs
                                │       balls_faced, fours, sixes
                                │       dismissal, bowler_id, fielder_id
                                │
                                ├──< bowling_stats
                                │       fixture_id(FK), player_id(FK)
                                │       team_id(FK), innings, overs
                                │       maidens, runs_conceded, wickets
                                │       wides, no_balls
                                │
                                └──< payment_vouchers
                                        voucher_number*, fixture_id(FK)
                                        tournament_id(FK), official_id(FK)
                                        payee_name, payee_type, amount
                                        description, bank_account
                                        bank_ifsc, bank_name, status
                                        created_by(FK→users)
                                        approved_by(FK→users)
                                        approved_at, paid_at
                                        payment_ref, payment_mode
                                        receipt_path, remarks
```

---

## Auth & Access

### `roles`
| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| name | VARCHAR(50) UNIQUE | |
| permissions | JSON | Array of permission strings |
| created_at | DATETIME | |

**Seeded roles:**
| ID | Name | Key Permissions |
|----|------|-----------------|
| 1 | superadmin | `["all"]` — bypasses all checks |
| 2 | admin | players, coaches, officials, venues, fixtures, reports… |
| 3 | selector | players.view, fixtures.view |
| 4 | accounts | finance, reports |
| 5 | umpire | officials, fixtures |
| 6 | data_entry | players.create, matches.score, fixtures.view |
| 7 | referee | officials, fixtures |
| 8 | match_referee | officials, fixtures |

---

### `users`
| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| role_id | FK → roles | |
| full_name | VARCHAR(100) | |
| email | VARCHAR(150) UNIQUE | Login username |
| phone | VARCHAR(15) | |
| password_hash | VARCHAR(255) | bcrypt |
| is_active | TINYINT(1) | 0 = blocked from login |
| last_login | DATETIME | |
| reset_token | VARCHAR(100) | Password reset |
| reset_expires | DATETIME | |

---

### `user_districts`
Many-to-many. Controls which districts a user can see/manage.  
`superadmin` bypasses this — sees all districts.

| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| user_id | FK → users CASCADE | |
| district_id | FK → districts CASCADE | |
| created_at | DATETIME | |

> Unique constraint on `(user_id, district_id)`.

---

### `districts`
| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| name | VARCHAR(100) | |
| zone | ENUM | North/South/East/West/Central |
| code | VARCHAR(5) UNIQUE | Short code e.g. RNC |
| lat / lng | DECIMAL(9,6) | Optional GPS |
| is_active | TINYINT(1) | |

---

## People — Players

### `players`
| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| jsca_player_id | VARCHAR(20) UNIQUE | Format: `JSCA-P-YYYY-00001` |
| full_name | VARCHAR(100) | |
| date_of_birth | DATE | |
| gender | ENUM | Male/Female/Other |
| age_category | ENUM | U14/U16/U19/Senior/Masters — auto-calculated |
| district_id | FK → districts | |
| role | ENUM | Batsman/Bowler/All-rounder/Wicket-keeper |
| batting_style | ENUM | Right-hand/Left-hand |
| bowling_style | ENUM | 8 options + N/A |
| aadhaar_number | VARCHAR(12) | |
| aadhaar_verified | TINYINT(1) | |
| photo_path | VARCHAR(255) | Stored in `writable/uploads/players/` |
| address | TEXT | |
| guardian_name / phone | VARCHAR | For minors |
| email / phone | VARCHAR | |
| status | ENUM | Active/Inactive/Suspended/Retired |
| selection_pool | ENUM | District/State/None |
| registered_by | FK → users | Admin who registered |
| user_id | FK → users | Linked login account |
| registration_type | ENUM | `manual` (admin) / `self` (self-register) |
| verified_by | FK → users | Admin who verified self-reg |
| verified_at | DATETIME | |

### `player_career_stats` (1:1 with players)
Aggregated stats recalculated after each match scored.  
`matches, runs, highest_score, batting_avg, strike_rate, fifties, hundreds, wickets, best_bowling, bowling_avg, economy, catches`

### `player_documents`
`doc_type`: aadhaar_front, aadhaar_back, birth_certificate, school_certificate, noc, medical_fitness, photo, other  
Files stored in `writable/uploads/player_docs/{player_id}/`

### `player_otp_verifications`
Temporary table for self-registration email OTP flow.  
`email, otp (6-digit), expires_at (10 min), verified`

---

## People — Coaches

### `coaches`
| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| jsca_coach_id | VARCHAR(30) UNIQUE | Format: `JSCA-C-YYYY-0001` |
| full_name | VARCHAR(100) | |
| date_of_birth | DATE | |
| gender | ENUM | |
| district_id | FK → districts | |
| specialization | ENUM | Batting/Bowling/Fielding/Wicket-keeping/Fitness/General |
| level | ENUM | NCA Level 1/2/3, Head Coach, etc. |
| bcci_coach_id | VARCHAR(50) | Optional BCCI ID |
| experience_years | TINYINT | |
| previous_teams | TEXT | Comma-separated or JSON |
| achievements | TEXT | |
| status | ENUM | Active/Inactive/Suspended |
| registered_by | FK → users | |

### `coach_documents`
`doc_type`: aadhaar_front/back, coaching_certificate, bcci_certificate, nca_certificate, medical_fitness, police_verification, photo, other

---

## People — Officials

### `official_types` (lookup)
| ID | Name | Prefix | Role |
|----|------|--------|------|
| 1 | Umpire | UMP | umpire (5) |
| 2 | Scorer | SCR | data_entry (6) |
| 3 | Referee | REF | referee (7) |
| 4 | Match Referee | MRF | match_referee (8) |

> Adding a new official type = insert a row here. No code change needed.

### `officials`
| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| jsca_official_id | VARCHAR(30) UNIQUE | Format: `JSCA-UMP-0001` (counter per type) |
| official_type_id | FK → official_types | |
| full_name | VARCHAR(100) | |
| email / phone | VARCHAR | |
| gender | ENUM | Male/Female/Other |
| dob | DATE | |
| district_id | FK → districts | |
| address | TEXT | |
| experience_years | TINYINT UNSIGNED | |
| grade | ENUM | A/B/C/D/Panel — determines fee tier |
| fee_per_match | DECIMAL(8,2) | Default fee for voucher auto-fill |
| bank_name | VARCHAR(100) | |
| bank_account | VARCHAR(20) | |
| bank_ifsc | VARCHAR(11) | |
| profile_photo | VARCHAR(255) | `writable/uploads/officials/` |
| user_id | FK → users | Linked login account (auto-created on register) |
| status | ENUM | Active/Inactive |
| registered_by | FK → users | |

### `official_certifications`
One official → many certifications.  
`official_id(FK), certification_name, body (ICC/BCCI/etc.), level, certified_date`  
Cascade deletes when official is deleted.

---

## Venues

### `venues`
| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| name | VARCHAR(150) | |
| district_id | FK → districts | |
| capacity | INT | |
| has_floodlights | TINYINT(1) | |
| has_scoreboard | TINYINT(1) | |
| has_dressing | TINYINT(1) | Dressing rooms |
| pitch_type | ENUM | Grass/Turf/Concrete/Red-soil |
| contact_person / phone | VARCHAR | |
| address | TEXT | |
| lat / lng | DECIMAL(9,6) | Google Maps link |
| is_active | TINYINT(1) | |

---

## Tournaments & Teams

### `tournaments`
| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| name | VARCHAR(200) | |
| season | VARCHAR(10) | e.g. `2024-25` |
| age_category | ENUM | U14/U16/U19/Senior/Masters/Women |
| gender | ENUM | Male/Female/Mixed |
| format | ENUM | T10/T20/ODI-40/ODI-50/Test/Custom |
| overs | INT | |
| structure | ENUM | Round Robin/Knockout/Group+Knockout/League+Playoffs/Zonal |
| is_zonal | TINYINT(1) | |
| start_date / end_date | DATE | |
| registration_deadline | DATE | |
| status | ENUM | Draft→Registration→Fixture Ready→Ongoing→Completed/Cancelled |
| prize_pool | DECIMAL(12,2) | |
| travel_constraint | ENUM | Minimize/Zonal/Centralized/None |
| created_by | FK → users | |

### `tournament_budgets` (1:1)
`total_budget, allocated, spent`

### `teams`
Belongs to one tournament. District-based.  
`tournament_id(FK), district_id(FK), name, zone, captain_id(FK→players), vice_captain_id(FK→players), status`

### `team_players`
Junction: team ↔ player.  
`team_id(FK), player_id(FK), jersey_number, is_captain, is_vice_captain, is_wk`  
Unique on `(team_id, player_id)`.

### `team_coaches`
Junction: team ↔ coach.  
`team_id(FK), coach_id(FK), role, from_date, to_date, is_current`

---

## Fixtures & Scoring

### `fixtures`
The central match record.

| Column | Type | Notes |
|--------|------|-------|
| id | INT UNSIGNED PK | |
| tournament_id | FK → tournaments | |
| match_number | VARCHAR(10) | e.g. `M01`, `SF1` |
| stage | VARCHAR(50) | League/Quarter-Final/Semi-Final/Final |
| zone | VARCHAR(20) | For zonal tournaments |
| match_date / time | DATE / TIME | |
| team_a_id / team_b_id | FK → teams | |
| venue_id | FK → venues | |
| is_day_night | TINYINT(1) | |
| umpire1_id / umpire2_id | FK → officials | |
| scorer_id | FK → officials | |
| referee_id | FK → officials | |
| status | ENUM | Scheduled/Live/Completed/Abandoned/Postponed |
| winner_team_id | FK → teams | |
| result_summary | TEXT | e.g. "Team A won by 5 wickets" |
| crichieros_id | VARCHAR(50) | CricHeroes sync ID |
| youtube_url | VARCHAR(255) | |

### `match_scorecards` (1:1 with fixtures)
`toss_winner_id, toss_decision, team_a_score, team_b_score, team_a_overs, team_b_overs, player_of_match(FK→players), source (Manual/CricHeroes/API)`

### `batting_stats`
Per-innings batting record per player per fixture.  
`fixture_id(FK), player_id(FK), team_id(FK), innings, runs, balls_faced, fours, sixes, dismissal, bowler_id, fielder_id`

### `bowling_stats`
Per-innings bowling record per player per fixture.  
`fixture_id(FK), player_id(FK), team_id(FK), innings, overs, maidens, runs_conceded, wickets, wides, no_balls`

### `live_matches`
Lightweight table for manually entered live scores (not tied to fixtures).  
`team_a_id/team_b_id (nullable FK→teams), team_a/b_custom (free text), team_a/b_score, venue, tournament_name, match_type, status, notes`

---

## Finance

### `payment_vouchers`
| Column | Type | Notes |
|--------|------|-------|
| voucher_number | VARCHAR(20) UNIQUE | Format: `VCH-YYYYMM-0001` |
| fixture_id | FK → fixtures (nullable) | |
| tournament_id | FK → tournaments (nullable) | |
| official_id | FK → officials (nullable) | |
| payee_name / type | VARCHAR / ENUM | Umpire/Scorer/Referee/Vendor/Player/Staff/Other |
| amount | DECIMAL(10,2) | |
| bank_account / ifsc / name | VARCHAR | |
| status | ENUM | Draft→Pending Approval→Approved→Paid / Rejected / Cancelled |
| created_by / approved_by | FK → users | |
| payment_mode | ENUM | NEFT/RTGS/UPI/Cash/Cheque |
| receipt_path | VARCHAR(255) | |

### `account_groups`
Legacy accounting table. `G_Name (PK), Acc_Name, Acc_Type, YesNo`

### `ledger_heads`
`group_id(FK→account_groups), name, opening_balance, balance_type (Dr/Cr)`

---

## System

### `audit_logs`
Every CREATE/UPDATE/DELETE/TOGGLE action is logged here.

| Column | Type | Notes |
|--------|------|-------|
| id | BIGINT UNSIGNED PK | |
| user_id | INT (nullable) | Who did it |
| action | VARCHAR(100) | CREATE, UPDATE, DELETE, TOGGLE, VERIFY, etc. |
| module | VARCHAR(50) | players, coaches, officials, venues, fixtures… |
| record_id | INT | ID of the affected record |
| old_data | JSON | State before change |
| new_data | JSON | State after change |
| ip_address | VARCHAR(45) | |
| user_agent | VARCHAR(255) | |

---

## RBAC Quick Reference

```
superadmin  → sees everything, no district filter
admin       → all modules, filtered by user_districts
selector    → players.view, fixtures.view
accounts    → finance, reports
umpire      → officials, fixtures
data_entry  → players.create, matches.score, fixtures.view
referee     → officials, fixtures
match_referee → officials, fixtures
```

**District filtering pattern** (used in every controller):
```php
$allowedIds = $this->getAllowedDistrictIdsFlat();
// superadmin: returns all district IDs
// others: returns only their assigned district IDs from user_districts

if ($role !== 'superadmin') {
    if (empty($allowedIds)) $builder->where('1=0');  // sees nothing
    else $builder->whereIn('district_id', $allowedIds);
}
```

**Session cache**: `allowed_district_ids` is cached in session after first load. Cleared when user is updated via Admin panel.

---

## ID Format Reference

| Entity | Format | Example | Counter |
|--------|--------|---------|---------|
| Player | `JSCA-P-YYYY-00001` | `JSCA-P-2025-00001` | Global |
| Coach | `JSCA-C-YYYY-0001` | `JSCA-C-2025-0001` | Global |
| Umpire | `JSCA-UMP-0001` | `JSCA-UMP-0001` | Per type |
| Scorer | `JSCA-SCR-0001` | `JSCA-SCR-0001` | Per type |
| Referee | `JSCA-REF-0001` | `JSCA-REF-0001` | Per type |
| Match Referee | `JSCA-MRF-0001` | `JSCA-MRF-0001` | Per type |
| Voucher | `VCH-YYYYMM-0001` | `VCH-202503-0001` | Per month |

---

## File Storage

All uploads go to `writable/uploads/` (outside `public/`):

```
writable/uploads/
  players/          ← player profile photos
  player_docs/{id}/ ← player documents (aadhaar, certs, etc.)
  officials/        ← official profile photos
  coaches/          ← coach photos (if added)
  vouchers/         ← payment receipts
```

Served via a controller or symlink — never directly accessible from the web.
