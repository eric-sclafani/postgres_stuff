
-- set dept_id as the primary key
-- primary keys MUST contain unique values as well
-- constrain dept and city to only have unique values 
CREATE TABLE IF NOT EXISTS departments (
	dept_id integer,
	dept text,
	city text,
	CONSTRAINT dept_key PRIMARY KEY (dept_id),
	CONSTRAINT dept_city_unique UNIQUE (dept, city)
);


-- set dept_id to be a foreign key in this table that references the primary key dept_id in the departments table
-- set emp_key as this tables's primary key
-- foreign keys CAN have duplicate values
CREATE TABLE IF NOT EXISTS employees (
	emp_id integer,
	first_name text,
	last_name text,
	salary numeric(10,2),
	dept_id integer REFERENCES departments (dept_id),
	CONSTRAINT emp_key PRIMARY KEY (emp_id)
);

-- INSERT INTO departments
-- VALUES
-- 	(1, 'Tax', 'Atlanta'),
-- 	(2, 'IT', 'Boston');
	
-- INSERT INTO employees
-- VALUES
-- 	(1, 'Julia', 'Reyes', 115300, 1),
-- 	(2, 'Janet', 'King', 98000, 1),
-- 	(3, 'Authur', 'Pappas', 72700, 2),
-- 	(4, 'Michael', 'Taylor', 89500, 2);


-- join the employees table's primary key (dept_id) with the departments table's foreign key (dept_id)
SELECT *
FROM employees JOIN departments
ON employees.dept_id  = departments.dept_id
ORDER BY employees.dept_id;


CREATE TABLE IF NOT EXISTS district_2020 (
	id integer CONSTRAINT id_key_2020 PRIMARY KEY,
	school_2020 text
);

CREATE TABLE IF NOT EXISTS district_2035 (
	id integer CONSTRAINT id_key_2023 PRIMARY KEY,
	school_2035 text
);

-- INSERT INTO district_2020 VALUES
--     (1, 'Oak Street School'),
--     (2, 'Roosevelt High School'),
--     (5, 'Dover Middle School'),
--     (6, 'Webutuck High School');

-- INSERT INTO district_2035 VALUES
--     (1, 'Oak Street School'),
--     (2, 'Roosevelt High School'),
--     (3, 'Morrison Elementary'),
--     (4, 'Chase Magnet Academy'),
--     (6, 'Webutuck High School');

-- retrieves values that appear in BOTH tables (equivalent to INNER JOIN)
SELECT * 
FROM district_2020 JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;


-- If you're using identical names for columns to JOIN on, you can use the USING clause in place of ON
SELECT *
FROM district_2020 JOIN district_2035
USING (id)
ORDER BY district_2020.id;


-- LEFT and RIGHT joins return all rows from ONE table and, 
-- when a row with a matching value exists in the other table, values from
-- that row are included as well. Otherwise, no value is included (NULL)

-- Use cases for LEFT, RIGHT joins:
------------ Need a query to contain all rows from one table
------------ Need to look for missing values in one of the tables. 
------------ When you know some rows in a joined table won't have matching values
SELECT *
FROM district_2020 LEFT JOIN district_2035
USING (id)
ORDER BY district_2020.id;

SELECT *
FROM district_2020 RIGHT JOIN district_2035
USING (id)
ORDER BY district_2020.id;


-- a FULL OUTER JOIN can be done to see all rows from both tables, regardless of matching
-- used less often, but useful for linking partially overlapping data or visualize to which degree tables share matching values
SELECT *
FROM district_2020 FULL OUTER JOIN district_2035
USING (id)
ORDER BY district_2020.id;


-- CROSS JOIN displays all possible row combinations for all given tables
-- since no matches are being used here, we don't provide an ON or USING clause
-- in this case, district_2020 has 4 rows, district_2035 has 5 rows, so 4 * 5 = 20 possible combinations
SELECT *
FROM district_2020 CROSS JOIN district_2035
ORDER BY district_2020.id;

-- Any time we join tables, its wise to investigate the key values in one table
-- exist in the other, and which values are missing, if any
-- Missing values are represented at NULL
-- this query looks for null values that occur after performing LEFT JOIN on the tables
SELECT *
FROM district_2020 LEFT JOIN district_2035
USING(id)
WHERE district_2035.id IS NUll
;

SELECT *
FROM district_2020 RIGHT JOIN district_2035
USING(id)
WHERE district_2020.id IS NUll
;

-- There are three types of relational models in database design:
	----- one to one 
					-- Any given id in either table will find no more than 1 match in the other table
					-- strictly one match for each key
	----- one to many
					-- a key value in one table has multiple matching values in another table
	----- many to many
					-- multiple items in one table can relate to multiple items in another table
					-- many to many relationships usually feature a third, intermediate table between the two


-- the following query results in an error because both tables have the id column,
-- so its ambiguous as to which table id to display

-- SELECT id
-- FROM district_2020 lEFT JOIN district_2035
-- ON district_2020.id  = district_2035.id;


-- here we specify that we want to see the district_2020 id
SELECT 
	district_2020.id,
	district_2020.school_2020,
	district_2035.school_2035
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id  = district_2035.id
ORDER BY district_2020.id;


SELECT 
	d20.id,
	d20.school_2020,
	d35.school_2035
FROM district_2020 AS d20 LEFT JOIN district_2035 AS d35
USING (id)
ORDER BY d20.id;

CREATE TABLE IF NOT EXISTS district_2020_enrollment(
	id integer,
	enrollment integer
);

CREATE TABLE IF NOT EXISTS district_2020_grades(
	id integer,
	grades varchar(10)
);

-- INSERT INTO district_2020_enrollment
-- VALUES
-- 	(1, 360),
-- 	(2, 1001),
-- 	(5, 450),
-- 	(6, 927);
	
-- INSERT INTO district_2020_grades
-- VALUES
-- 	(1, 'K-3'),
-- 	(2, '9-12'),
-- 	(5, '6-8'),
-- 	(6, '9-12');

-- join three tables together on a their respective id keys
SELECT 
	d20.id,
	d20.school_2020,
	en.enrollment,
	gr.grades
FROM
	district_2020 AS d20 JOIN district_2020_enrollment AS en
	ON d20.id = en.id
	JOIN district_2020_grades AS gr
	ON d20.id = gr.id
ORDER BY d20.id;


-- use UNION to retrieve all rows from both district_2020 and district_2035
-- UNION by itself removes duplicates
-- the school names in the second query's column school_2035 were simply appended to the results from the first query
-- the columns in the second query must match those in the first and have compatible data types
SELECT * FROM district_2020
UNION 
SELECT * FROM district_2035
ORDER BY id;

-- UNION ALL includes duplicates	
SELECT * FROM district_2020
UNION ALL
SELECT * FROM district_2035
ORDER BY id;	


-- customizing merged results. By specifiying year as a string here, we can explicltly see which table reach record hails from
SELECT 
	'2020' AS year,
	school_2020 AS school
	FROM district_2020
	
UNION ALL

SELECT 
	'2035' AS year,
	school_2035
	FROM district_2035 
ORDER BY school, year;

-- returns only rows that exist in BOTH tables, removing duplicates
SELECT * FROM district_2020
INTERSECT
SELECT * FROM district_2035
ORDER BY id;

-- returns rows that exist in the results of the first query, but not the second query. Duplicates also removed
-- seems similar to set complement?
SELECT * FROM district_2020
EXCEPT
SELECT * FROM district_2035
ORDER BY id;












