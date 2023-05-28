CREATE TABLE IF NOT EXISTS supervisor_salaries (
	id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	town text,
	county text,
	supervisor text,
	start_date date,
	salary numeric(10,2),
	benefits numeric(10,2)
);

-- specifies which columns in the table are present in the CSV
COPY supervisor_salaries (town, supervisor, salary)
FROM '/Users/eric/Documents/postgres_stuff/supervisor_salaries/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

DELETE FROM supervisor_salaries;

-- imports data from the csv based on a condition
COPY supervisor_salaries (town, supervisor, salary)
FROM '/Users/eric/Documents/postgres_stuff/supervisor_salaries/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER)
WHERE town = 'New Brillig';

DELETE FROM supervisor_salaries;

-- When importing data, before loading it into an existing table, we can load it
-- into an intermediate, temporary table to perform intermediary operations
CREATE TEMPORARY TABLE supervisor_salaries_temp
	(LIKE supervisor_salaries INCLUDING ALL);

-- import the csv data into the temporary table
COPY supervisor_salaries_temp (town, supervisor, salary)
FROM '/Users/eric/Documents/postgres_stuff/supervisor_salaries/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- Instead of specifying values when inserting into the supervisor_salaries table,
-- we query the temporary table and insert those values in supervisor_salaries
INSERT INTO supervisor_salaries (town, county, supervisor, salary)
SELECT town, 'Mills', supervisor, salary
FROM supervisor_salaries_temp;

-- remove the temp table
DROP TABLE supervisor_salaries_temp;


SELECT * FROM supervisor_salaries











