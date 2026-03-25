-- U14 players for Ranchi (district 1) — for Ranchi Fighters
INSERT INTO players (jsca_player_id, full_name, date_of_birth, gender, age_category, district_id, role, batting_style, bowling_style, phone, status, registration_type, created_at) VALUES
('JSCA-P-2026-00042', 'Rohan Sahu',         '2012-02-14', 'Male',   'U14', 1, 'Batsman',       'Right-hand', 'N/A',                '9833300001', 'Active', 'manual', NOW()),
('JSCA-P-2026-00043', 'Tushar Pandey',      '2013-06-09', 'Male',   'U14', 1, 'Bowler',        'Right-hand', 'Right-arm Fast',     '9833300002', 'Active', 'manual', NOW()),
('JSCA-P-2026-00044', 'Manav Gupta',        '2012-10-23', 'Male',   'U14', 1, 'All-rounder',   'Right-hand', 'Right-arm Medium',   '9833300003', 'Active', 'manual', NOW()),
('JSCA-P-2026-00045', 'Shivam Tiwari',      '2013-03-17', 'Male',   'U14', 1, 'Wicket-keeper', 'Right-hand', 'N/A',                '9833300004', 'Active', 'manual', NOW()),
('JSCA-P-2026-00046', 'Aditya Verma',       '2012-07-31', 'Male',   'U14', 1, 'Batsman',       'Left-hand',  'N/A',                '9833300005', 'Active', 'manual', NOW()),
('JSCA-P-2026-00047', 'Nitin Rajak',        '2013-01-05', 'Male',   'U14', 1, 'Bowler',        'Right-hand', 'Right-arm Off-spin', '9833300006', 'Active', 'manual', NOW()),
('JSCA-P-2026-00048', 'Gaurav Mahto',       '2012-05-19', 'Male',   'U14', 1, 'Batsman',       'Right-hand', 'N/A',                '9833300007', 'Active', 'manual', NOW()),
('JSCA-P-2026-00049', 'Sanjay Kumar',       '2013-09-28', 'Male',   'U14', 1, 'All-rounder',   'Left-hand',  'Left-arm Orthodox',  '9833300008', 'Active', 'manual', NOW()),
('JSCA-P-2026-00050', 'Piyush Oraon',       '2012-12-11', 'Male',   'U14', 1, 'Bowler',        'Left-hand',  'Left-arm Fast',      '9833300009', 'Active', 'manual', NOW()),
('JSCA-P-2026-00051', 'Ananya Singh',       '2013-04-02', 'Female', 'U14', 1, 'Batsman',       'Right-hand', 'N/A',                '9833300010', 'Active', 'manual', NOW()),
('JSCA-P-2026-00052', 'Ritesh Hembrom',     '2012-08-26', 'Male',   'U14', 1, 'Bowler',        'Right-hand', 'Right-arm Leg-spin', '9833300011', 'Active', 'manual', NOW());

INSERT INTO player_career_stats (player_id)
SELECT id FROM players WHERE jsca_player_id BETWEEN 'JSCA-P-2026-00042' AND 'JSCA-P-2026-00052';

-- 2 more coaches for Ranchi district
INSERT INTO coaches (jsca_coach_id, full_name, date_of_birth, gender, phone, district_id, specialization, level, experience_years, status, registered_by, created_at) VALUES
('JSCA-C-2026-0003', 'Manoj Kumar Sharma',  '1980-04-15', 'Male', '9844400001', 1, 'Batting',  'NCA Level 2', 12, 'Active', 1, NOW()),
('JSCA-C-2026-0004', 'Pradeep Tirkey',      '1985-09-22', 'Male', '9844400002', 1, 'Bowling',  'NCA Level 1',  8, 'Active', 1, NOW());
