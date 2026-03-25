INSERT INTO players
  (jsca_player_id, full_name, date_of_birth, gender, age_category, district_id, role, batting_style, bowling_style, phone, status, registration_type, created_at)
VALUES
  ('JSCA-P-2026-00007', 'Rohit Kumar Singh',    '2000-03-15', 'Male', 'Senior',  1, 'Batsman',        'Right-hand', 'N/A',                   '9801234501', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00008', 'Amit Sharma',          '1998-07-22', 'Male', 'Senior',  1, 'Bowler',         'Right-hand', 'Right-arm Fast',         '9801234502', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00009', 'Vikash Oraon',         '2001-11-05', 'Male', 'Senior',  1, 'All-rounder',    'Right-hand', 'Right-arm Medium',       '9801234503', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00010', 'Deepak Mahto',         '1999-01-30', 'Male', 'Senior',  1, 'Wicket-keeper',  'Right-hand', 'N/A',                   '9801234504', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00011', 'Suraj Tirkey',         '2002-09-18', 'Male', 'Senior',  1, 'Batsman',        'Left-hand',  'N/A',                   '9801234505', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00012', 'Manish Gupta',         '1997-04-12', 'Male', 'Senior',  1, 'Bowler',         'Right-hand', 'Right-arm Off-spin',     '9801234506', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00013', 'Priya Kumari',         '2003-06-25', 'Female','Senior', 1, 'Batsman',        'Right-hand', 'N/A',                   '9801234507', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00014', 'Arjun Prasad',         '2008-02-14', 'Male', 'U19',     1, 'All-rounder',    'Right-hand', 'Right-arm Medium',       '9801234508', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00015', 'Rahul Minz',           '2009-08-03', 'Male', 'U19',     1, 'Batsman',        'Left-hand',  'Left-arm Orthodox',      '9801234509', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00016', 'Sanjay Hembrom',       '2010-12-20', 'Male', 'U16',     1, 'Bowler',         'Right-hand', 'Right-arm Leg-spin',     '9801234510', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00017', 'Anita Devi',           '2011-05-09', 'Female','U16',    1, 'Batsman',        'Right-hand', 'N/A',                   '9801234511', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00018', 'Ravi Shankar Yadav',   '2012-10-17', 'Male', 'U14',     1, 'All-rounder',    'Right-hand', 'Right-arm Medium',       '9801234512', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00019', 'Nikhil Toppo',         '2013-03-28', 'Male', 'U14',     1, 'Bowler',         'Left-hand',  'Left-arm Fast',          '9801234513', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00020', 'Kavita Soren',         '1985-07-11', 'Female','Masters',1, 'Batsman',        'Right-hand', 'N/A',                   '9801234514', 'Active', 'manual', NOW()),
  ('JSCA-P-2026-00021', 'Dinesh Mahali',        '1983-01-04', 'Male', 'Masters', 1, 'Bowler',         'Right-hand', 'Right-arm Off-spin',     '9801234515', 'Active', 'manual', NOW());

INSERT INTO player_career_stats (player_id)
SELECT id FROM players WHERE jsca_player_id BETWEEN 'JSCA-P-2026-00007' AND 'JSCA-P-2026-00021';
