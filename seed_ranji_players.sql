-- Seed 33 Senior Male players for Ranji Trophy (Open, State, Male)
-- 11 from Ranchi (district 1), 11 from Dhanbad (district 2), 11 from Jamshedpur (district 4)

INSERT INTO players
  (jsca_player_id, full_name, date_of_birth, gender, age_category, district_id, role, batting_style, bowling_style, phone, status, registration_type, created_at)
VALUES
-- Ranchi (district 1) — 11 players
('JSCA-P-2026-00055', 'Amit Kumar Singh',       '1998-04-12', 'Male', 'Senior', 1, 'Batsman',       'Right-hand', 'N/A',                   '9800100001', 'Active', 'manual', NOW()),
('JSCA-P-2026-00056', 'Rahul Prasad',            '1999-07-23', 'Male', 'Senior', 1, 'Bowler',        'Right-hand', 'Right-arm Fast',         '9800100002', 'Active', 'manual', NOW()),
('JSCA-P-2026-00057', 'Vikash Kumar',            '2000-01-15', 'Male', 'Senior', 1, 'All-rounder',   'Right-hand', 'Right-arm Medium',       '9800100003', 'Active', 'manual', NOW()),
('JSCA-P-2026-00058', 'Deepak Oraon',            '1997-09-30', 'Male', 'Senior', 1, 'Wicket-keeper', 'Right-hand', 'N/A',                   '9800100004', 'Active', 'manual', NOW()),
('JSCA-P-2026-00059', 'Suraj Mahto',             '2001-03-08', 'Male', 'Senior', 1, 'Batsman',       'Left-hand',  'N/A',                   '9800100005', 'Active', 'manual', NOW()),
('JSCA-P-2026-00060', 'Manish Tirkey',           '1996-11-19', 'Male', 'Senior', 1, 'Bowler',        'Right-hand', 'Right-arm Off-spin',     '9800100006', 'Active', 'manual', NOW()),
('JSCA-P-2026-00061', 'Pankaj Gupta',            '2002-06-25', 'Male', 'Senior', 1, 'Batsman',       'Right-hand', 'N/A',                   '9800100007', 'Active', 'manual', NOW()),
('JSCA-P-2026-00062', 'Sanjay Hembrom',          '1999-12-04', 'Male', 'Senior', 1, 'All-rounder',   'Left-hand',  'Left-arm Orthodox',      '9800100008', 'Active', 'manual', NOW()),
('JSCA-P-2026-00063', 'Ravi Shankar',            '1998-08-17', 'Male', 'Senior', 1, 'Bowler',        'Right-hand', 'Right-arm Leg-spin',     '9800100009', 'Active', 'manual', NOW()),
('JSCA-P-2026-00064', 'Nikhil Verma',            '2000-05-22', 'Male', 'Senior', 1, 'Batsman',       'Right-hand', 'N/A',                   '9800100010', 'Active', 'manual', NOW()),
('JSCA-P-2026-00065', 'Arjun Minz',              '1997-02-14', 'Male', 'Senior', 1, 'Bowler',        'Left-hand',  'Left-arm Fast',          '9800100011', 'Active', 'manual', NOW()),

-- Dhanbad (district 2) — 11 players
('JSCA-P-2026-00066', 'Rohit Kumar Sharma',      '1999-03-11', 'Male', 'Senior', 2, 'Batsman',       'Right-hand', 'N/A',                   '9800200001', 'Active', 'manual', NOW()),
('JSCA-P-2026-00067', 'Anil Yadav',              '1998-08-27', 'Male', 'Senior', 2, 'Bowler',        'Right-hand', 'Right-arm Fast',         '9800200002', 'Active', 'manual', NOW()),
('JSCA-P-2026-00068', 'Suresh Kumar',            '2000-12-05', 'Male', 'Senior', 2, 'All-rounder',   'Right-hand', 'Right-arm Medium',       '9800200003', 'Active', 'manual', NOW()),
('JSCA-P-2026-00069', 'Manoj Pandey',            '1997-06-18', 'Male', 'Senior', 2, 'Wicket-keeper', 'Right-hand', 'N/A',                   '9800200004', 'Active', 'manual', NOW()),
('JSCA-P-2026-00070', 'Dinesh Mahato',           '2001-09-23', 'Male', 'Senior', 2, 'Batsman',       'Left-hand',  'N/A',                   '9800200005', 'Active', 'manual', NOW()),
('JSCA-P-2026-00071', 'Rajesh Singh',            '1996-04-30', 'Male', 'Senior', 2, 'Bowler',        'Right-hand', 'Right-arm Off-spin',     '9800200006', 'Active', 'manual', NOW()),
('JSCA-P-2026-00072', 'Santosh Kumar',           '2002-01-14', 'Male', 'Senior', 2, 'Batsman',       'Right-hand', 'N/A',                   '9800200007', 'Active', 'manual', NOW()),
('JSCA-P-2026-00073', 'Pradeep Mahali',          '1999-10-08', 'Male', 'Senior', 2, 'All-rounder',   'Left-hand',  'Left-arm Orthodox',      '9800200008', 'Active', 'manual', NOW()),
('JSCA-P-2026-00074', 'Ganesh Prasad',           '1998-07-21', 'Male', 'Senior', 2, 'Bowler',        'Right-hand', 'Right-arm Leg-spin',     '9800200009', 'Active', 'manual', NOW()),
('JSCA-P-2026-00075', 'Vivek Kumar',             '2000-02-16', 'Male', 'Senior', 2, 'Batsman',       'Right-hand', 'N/A',                   '9800200010', 'Active', 'manual', NOW()),
('JSCA-P-2026-00076', 'Hemant Oraon',            '1997-11-03', 'Male', 'Senior', 2, 'Bowler',        'Left-hand',  'Left-arm Fast',          '9800200011', 'Active', 'manual', NOW()),

-- Jamshedpur (district 4) — 11 players
('JSCA-P-2026-00077', 'Ajay Kumar Tiwari',       '1999-05-09', 'Male', 'Senior', 4, 'Batsman',       'Right-hand', 'N/A',                   '9800400001', 'Active', 'manual', NOW()),
('JSCA-P-2026-00078', 'Saurav Singh',            '1998-10-24', 'Male', 'Senior', 4, 'Bowler',        'Right-hand', 'Right-arm Fast',         '9800400002', 'Active', 'manual', NOW()),
('JSCA-P-2026-00079', 'Rajan Kumar',             '2000-03-17', 'Male', 'Senior', 4, 'All-rounder',   'Right-hand', 'Right-arm Medium',       '9800400003', 'Active', 'manual', NOW()),
('JSCA-P-2026-00080', 'Deepak Mahato',           '1997-08-12', 'Male', 'Senior', 4, 'Wicket-keeper', 'Right-hand', 'N/A',                   '9800400004', 'Active', 'manual', NOW()),
('JSCA-P-2026-00081', 'Ankit Sharma',            '2001-12-28', 'Male', 'Senior', 4, 'Batsman',       'Left-hand',  'N/A',                   '9800400005', 'Active', 'manual', NOW()),
('JSCA-P-2026-00082', 'Nitin Kumar',             '1996-06-07', 'Male', 'Senior', 4, 'Bowler',        'Right-hand', 'Right-arm Off-spin',     '9800400006', 'Active', 'manual', NOW()),
('JSCA-P-2026-00083', 'Gaurav Tiwari',           '2002-04-19', 'Male', 'Senior', 4, 'Batsman',       'Right-hand', 'N/A',                   '9800400007', 'Active', 'manual', NOW()),
('JSCA-P-2026-00084', 'Suman Hembrom',           '1999-09-11', 'Male', 'Senior', 4, 'All-rounder',   'Left-hand',  'Left-arm Orthodox',      '9800400008', 'Active', 'manual', NOW()),
('JSCA-P-2026-00085', 'Piyush Gupta',            '1998-01-26', 'Male', 'Senior', 4, 'Bowler',        'Right-hand', 'Right-arm Leg-spin',     '9800400009', 'Active', 'manual', NOW()),
('JSCA-P-2026-00086', 'Ritesh Singh',            '2000-07-04', 'Male', 'Senior', 4, 'Batsman',       'Right-hand', 'N/A',                   '9800400010', 'Active', 'manual', NOW()),
('JSCA-P-2026-00087', 'Shivam Pandey',           '1997-04-15', 'Male', 'Senior', 4, 'Bowler',        'Left-hand',  'Left-arm Fast',          '9800400011', 'Active', 'manual', NOW());

INSERT INTO player_career_stats (player_id)
SELECT id FROM players WHERE jsca_player_id BETWEEN 'JSCA-P-2026-00055' AND 'JSCA-P-2026-00087';
