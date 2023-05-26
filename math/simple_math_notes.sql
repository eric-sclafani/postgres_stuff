CREATE TABLE IF NOT EXISTS percent_change (
	department text,
	spend_2019 numeric(10,2),
	spend_2022 numeric(10,2)
);

INSERT INTO percent_change
VALUES
	('Assessor', 178556, 179500),
    ('Building', 250000, 289000),
    ('Clerk', 451980, 650000),
    ('Library', 87777, 90001),
    ('Parks', 250000, 223000),
    ('Water', 199000, 195000);


-- To find a percent change: (new_number - old_number) / old_number
-- Calculates which departments had the greatest percent change in money spend
SELECT 
	department,
	spend_2019,
	spend_2022,
	round(((spend_2022 - spend_2019) / spend_2019) * 100, 1) AS pct_change
FROM percent_change;