CREATE TABLE IF NOT EXISTS us_counties_pop_est_2010 (
    state_fips text,                         -- State FIPS code
    county_fips text,                        -- County FIPS code
    region smallint,                         -- Region
    state_name text,                         -- State name
    county_name text,                        -- County name
    estimates_base_2010 integer,             -- 4/1/2010 resident total population estimates base
    CONSTRAINT counties_2010_key PRIMARY KEY (state_fips, county_fips)
);


-- create a raw_change column by subtracting the 2019 population estimate from the 2010 one
-- create a pct_change column by performing the (new - old / old) operation to find the percent changed from 2010 to 2019
-- join both tables on two keys: state_fips and county_fips. We do this because 
-- the combination of a state code and county code represents a unique county

SELECT 
	c2019.county_name,
	c2019.state_name,
	c2019.pop_est_2019 AS pop_2019,
	c2010.estimates_base_2010 AS pop_2010,
	c2019.pop_est_2019 - c2010.estimates_base_2010 AS raw_change,
	ROUND( (c2019.pop_est_2019::numeric - c2010.estimates_base_2010) / c2010.estimates_base_2010 * 100, 1 ) AS pct_change
FROM
	us_counties_pop_est_2019 AS c2019
	JOIN us_counties_pop_est_2010 AS c2010
	ON c2019.state_fips = c2010.state_fips
	AND c2019.county_fips = c2010.county_fips
ORDER BY pct_change ASC;


-- union both tables together
-- SELECT
-- 	'2019' AS year,
-- 	state_fips,
-- 	county_fips,
-- 	county_name,
-- 	state_name,
-- 	pop_est_2019 AS pop_2019
-- FROM us_counties_pop_est_2019
-- UNION
-- SELECT
-- 	'2010' AS year,
-- 	county_name,
-- 	state_name,
-- 	estimates_base_2010 AS pop_2010
-- FROM us_counties_pop_est_2010
-- ORDER BY county_name;



-- get the median of the percent change
SELECT 
	PERCENTILE_CONT(.5)
	WITHIN GROUP (ORDER BY ROUND( (c2019.pop_est_2019::numeric - c2010.estimates_base_2010) / c2010.estimates_base_2010 * 100, 1 ))
FROM
	us_counties_pop_est_2019 AS c2019
	JOIN us_counties_pop_est_2010 AS c2010
	ON c2019.state_fips = c2010.state_fips
	AND c2019.county_fips = c2010.county_fips
;

		