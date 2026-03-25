INSERT INTO players (jsca_player_id, full_name, date_of_birth, gender, age_category, district_id, role, batting_style, bowling_style, phone, status, registration_type, created_at) VALUES
('JSCA-P-2026-00022', 'Aryan Singh',      '2012-03-11', 'Male',   'U14', 1,  'Batsman',       'Right-hand', 'N/A',                '9822200001', 'Active', 'manual', NOW()),
('JSCA-P-2026-00023', 'Kartik Mahto',     '2013-07-04', 'Male',   'U14', 1,  'Bowler',        'Right-hand', 'Right-arm Fast',     '9822200002', 'Active', 'manual', NOW()),
('JSCA-P-2026-00024', 'Saurav Oraon',     '2012-11-19', 'Male',   'U14', 1,  'All-rounder',   'Left-hand',  'Left-arm Orthodox',  '9822200003', 'Active', 'manual', NOW()),
('JSCA-P-2026-00025', 'Deepak Tirkey',    '2013-02-28', 'Male',   'U14', 1,  'Wicket-keeper', 'Right-hand', 'N/A',                '9822200004', 'Active', 'manual', NOW()),
('JSCA-P-2026-00026', 'Rahul Gope',       '2012-08-15', 'Male',   'U14', 1,  'Batsman',       'Right-hand', 'N/A',                '9822200005', 'Active', 'manual', NOW()),
('JSCA-P-2026-00027', 'Amit Kujur',       '2013-05-22', 'Male',   'U14', 1,  'Bowler',        'Right-hand', 'Right-arm Off-spin', '9822200006', 'Active', 'manual', NOW()),
('JSCA-P-2026-00028', 'Vishal Hembrom',   '2012-09-30', 'Male',   'U14', 1,  'Batsman',       'Left-hand',  'N/A',                '9822200007', 'Active', 'manual', NOW()),
('JSCA-P-2026-00029', 'Priya Minj',       '2013-01-17', 'Female', 'U14', 1,  'Batsman',       'Right-hand', 'N/A',                '9822200008', 'Active', 'manual', NOW()),
('JSCA-P-2026-00030', 'Suresh Barla',     '2012-06-08', 'Male',   'U14', 1,  'Bowler',        'Left-hand',  'Left-arm Fast',      '9822200009', 'Active', 'manual', NOW()),
('JSCA-P-2026-00031', 'Neeraj Kandulna',  '2013-04-25', 'Male',   'U14', 1,  'All-rounder',   'Right-hand', 'Right-arm Medium',   '9822200010', 'Active', 'manual', NOW()),
('JSCA-P-2026-00032', 'Aryan Lakra',      '2012-04-10', 'Male',   'U14', 13, 'Batsman',       'Right-hand', 'N/A',                '9811100001', 'Active', 'manual', NOW()),
('JSCA-P-2026-00033', 'Sunil Kujur',      '2013-01-22', 'Male',   'U14', 13, 'Bowler',        'Right-hand', 'Right-arm Medium',   '9811100002', 'Active', 'manual', NOW()),
('JSCA-P-2026-00034', 'Rajan Ekka',       '2012-09-05', 'Male',   'U14', 13, 'All-rounder',   'Left-hand',  'Left-arm Orthodox',  '9811100003', 'Active', 'manual', NOW()),
('JSCA-P-2026-00035', 'Deepa Minj',       '2013-06-18', 'Female', 'U14', 13, 'Batsman',       'Right-hand', 'N/A',                '9811100004', 'Active', 'manual', NOW()),
('JSCA-P-2026-00036', 'Rohit Tirkey',     '2012-11-30', 'Male',   'U14', 13, 'Wicket-keeper', 'Right-hand', 'N/A',                '9811100005', 'Active', 'manual', NOW()),
('JSCA-P-2026-00037', 'Ankit Horo',       '2013-03-14', 'Male',   'U14', 13, 'Bowler',        'Right-hand', 'Right-arm Fast',     '9811100006', 'Active', 'manual', NOW()),
('JSCA-P-2026-00038', 'Priti Oraon',      '2012-07-25', 'Female', 'U14', 13, 'All-rounder',   'Right-hand', 'Right-arm Off-spin', '9811100007', 'Active', 'manual', NOW()),
('JSCA-P-2026-00039', 'Vikram Kandulna',  '2013-08-09', 'Male',   'U14', 13, 'Batsman',       'Left-hand',  'N/A',                '9811100008', 'Active', 'manual', NOW()),
('JSCA-P-2026-00040', 'Suman Barla',      '2012-05-17', 'Male',   'U14', 13, 'Bowler',        'Left-hand',  'Left-arm Fast',      '9811100009', 'Active', 'manual', NOW()),
('JSCA-P-2026-00041', 'Nisha Dungdung',   '2013-02-28', 'Female', 'U14', 13, 'Batsman',       'Right-hand', 'N/A',                '9811100010', 'Active', 'manual', NOW());

INSERT INTO player_career_stats (player_id)
SELECT id FROM players WHERE jsca_player_id BETWEEN 'JSCA-P-2026-00022' AND 'JSCA-P-2026-00041';
