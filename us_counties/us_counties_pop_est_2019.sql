-- This query shows the top 3 records with the most area_land
SELECT county_name, state_name, area_land
FROM us_counties_pop_est_2019
ORDER BY area_land DESC
LIMIT 3;

-- Longitude is east to west
-- Prime Meridian is at 0, which intercept London
-- The higher negative number = more west of meridian
-- Antimeridian is at 180 degress longitude
-- This query shows the 5 US counties closest to the Prime Meridian
-- Alaska is a surprising one; the Aluetians islands extend far west that they cross the antimeridian at 180 degrees longitude
SELECT county_name, state_name, internal_point_lat, internal_point_lon
FROM us_counties_pop_est_2019
ORDER BY internal_point_lon DESC
LIMIT 5;

-- export the data to a .txt file with a pipe (|) delimiter
COPY us_counties_pop_est_2019
TO '/Users/eric/Documents/postgres_stuff/us_counties/us_counties_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');


-- export only select columns to a file
COPY us_counties_pop_est_2019 (county_name, internal_point_lat, internal_point_lon)
TO '/Users/eric/Documents/postgres_stuff/us_counties/us_counties_latlon_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');


-- we can add a query to COPY to further fine-tune the output
COPY(
	SELECT county_name, state_name
	FROM us_counties_pop_est_2019
	WHERE county_name ILIKE '%mill%'
	)
TO '/Users/eric/Documents/postgres_stuff/us_counties/us_counties_mil_export.txt'
WITH (FORMAT CSV, HEADER);

COPY (
	SELECT county_name, state_name, births_2019
	FROM us_counties_pop_est_2019
	ORDER BY births_2019 DESC
	LIMIT 20
)
TO '/Users/eric/Documents/postgres_stuff/us_counties/us_counties_births_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- subtract the deaths column from births to get the difference between the two, save it as natural_increase
SELECT 
	county_name AS county,
	state_name AS state,
	births_2019 AS births,
	deaths_2019 AS deaths,
	births_2019 - deaths_2019 AS natural_increase
FROM us_counties_pop_est_2019
ORDER BY state_name, county_name;

-- verfiying that pop_est_2019 is correct by combining the other population columns
-- pop_est_2019 should equal the sum of the 2018 estimate and the columns about births, deaths, migration, and residual factor
-- Also, subtract that combined amount from pop_est_2019 to show the difference. Should be 0 for all records.
SELECT county_name AS county,
       state_name AS state,
       pop_est_2019 AS pop,
       pop_est_2018 + births_2019 - deaths_2019 + 
           international_migr_2019 + domestic_migr_2019 +
           residual_2019 AS components_total,
       pop_est_2019 - (pop_est_2018 + births_2019 - deaths_2019 + 
           international_migr_2019 + domestic_migr_2019 +
           residual_2019) AS difference
FROM us_counties_pop_est_2019
ORDER BY difference DESC;


-- Get what percentage of land is made of water
-- Need to cast area_water to a numeric to get a fractional result
SELECT county_name AS county,
       state_name AS state,
       area_water::numeric / (area_land + area_water) * 100 AS pct_water
FROM us_counties_pop_est_2019
ORDER BY pct_water DESC;

-- Calculate the total and average populations of all counties
SELECT 
	SUM(pop_est_2019) AS county_pop_sum,
	ROUND(AVG(pop_est_2019), 0) AS county_pop_avg
FROM us_counties_pop_est_2019;
		
		
-- To find the median, Postgres (and other SQL langs) don't have a built in median function
-- Instead, we use the percentile function to find the median and 
-- use quantiles to divide a group of numbers into equal sizes
-- The median is equivalent to the 50th percentile
-- The percentile_cont(n) function works on continous values
-- The percentile_disc(n) function works on discrete values
CREATE TABLE IF NOT EXISTS percentile_test (
	numbers integer
);

INSERT INTO percentile_test
VALUES (1),(2),(3),(4),(5),(6);


-- We enter .5 to get the 50th percentile
-- I think WITHIN GROUP specifies which column to calculate 
-- and we need to order the numbers to get the percentiles
SELECT
	PERCENTILE_CONT(.5)
	WITHIN GROUP (ORDER BY numbers),
	
	PERCENTILE_DISC(.5)
	WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;
	

-- Now calculate the median county population
-- The mean and median differ greatly, meaning that the average, in this case, is not reliable.
-- Half the counties have less than 25,726 people (25,726 is the middle value of the pop_est_2019 column)
SELECT 
	SUM(pop_est_2019) AS county_pop_sum,
	ROUND(AVG(pop_est_2019),0) AS county_pop_avg,
	PERCENTILE_CONT(.5)
	WITHIN GROUP (ORDER BY pop_est_2019) AS county_pop_median,
	MAX(pop_est_2019) AS county_pop_max,
	MIN(pop_est_2019) AS county_pop_min
FROM us_counties_pop_est_2019;

-- We can also slice data into smaller groups:
	-- quartiles (4 equal groups)
	-- quintiles (five groups)
	-- deciles (10 groups)
	
-- Quantiles is when data is split into groups.
-- Quartiles, quintiles, deciles, and percentiles are specific types of quantiles, 
-- for which they separate data into groups (4,5,10,100 respectively)

-- If we want to generate multiple cut points, we can pass an ARRAY of cut points into PERCENTILE_CONT
SELECT 
	PERCENTILE_CONT(ARRAY[.25,.5,.75])
	WITHIN GROUP (ORDER BY pop_est_2019) AS quartiles
FROM us_counties_pop_est_2019;
		

-- When working with arrays, we can use the UNNEST function to convert an array into rows instead
SELECT
	UNNEST(
	PERCENTILE_CONT(ARRAY[.25,.5,.75])
	WITHIN GROUP (ORDER BY pop_est_2019))
	AS quartiles
FROM us_counties_pop_est_2019;


SELECT MODE() WITHIN GROUP (ORDER BY births_2019)
FROM us_counties_pop_est_2019;


-- Inspecting the births to deaths ratio for New York
SELECT 
	state_name,
	county_name,
	(births_2019 / deaths_2019) AS birth_to_death_ratio
FROM us_counties_pop_est_2019
WHERE state_name = 'New York'
ORDER BY birth_to_death_ratio DESC;

-- Check the median county pops for NY and California

SELECT state_name,
       percentile_cont(0.5)
          WITHIN GROUP (ORDER BY pop_est_2019) AS median
FROM us_counties_pop_est_2019
WHERE state_name IN ('New York', 'California')
GROUP BY state_name;


