
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
-- that row are included as well. Otherwise, no value is included
SELECT *
FROM district_2020 LEFT JOIN district_2035
USING (id)
ORDER BY district_2020.id;

SELECT *
FROM district_2020 RIGHT JOIN district_2035
USING (id)
ORDER BY district_2020.id;














