
-- using the license id as a natural primary key, specifying it at the column level
-- you can ommit the CONSTRAINT. Postgres will automatically name the key for you then
-- this is an example of a column constraint
CREATE TABLE IF NOT EXISTS natural_key_example(
	license_id text CONSTRAINT license_key PRIMARY KEY,
	first_name text,
	last_name text
);


DROP TABLE natural_key_example;


-- this is an example of a table constraint
-- when making a primary key of more than one column, you must use the table constraint syntax
CREATE TABLE IF NOT EXISTS natural_key_example(
	license_id text,
	first_name text,
	last_name text,
	CONSTRAINT license_key PRIMARY KEY (license_id)
);

-- the following two INSERT statements violate the key constraint of uniqueness
-- INSERT INTO natural_key_example (license_id, first_name, last_name)
-- VALUES
-- 	('T229901', 'Gem', 'Godfrey');
	
-- INSERT INTO natural_key_example (license_id, first_name, last_name)
-- VALUES
-- 	('T229901', 'John', 'Mitchell');
	

-- we can create a composite primary key made of more than one column
-- remember, composite keys can only be made by using the table constraint syntax
CREATE TABLE IF NOT EXISTS natural_key_composite(
	student_id text,
	school_day date,
	present boolean,
	CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
);


-- the following INSERT statements violate the constraint on the natural_key_composite table
-- INSERT INTO natural_key_composite (student_id, school_day, present)
-- VALUES(775, '2022-01-22', 'Y');

-- INSERT INTO natural_key_composite(student_id, school_day, present)
-- VALUES(775, '2022-01-23', 'Y');

-- INSERT INTO natural_key_composite (student_id, school_day, present)
-- VALUES(775, '2022-01-23', 'N');


-- in this table, we use IDENTITY to generate an auto-incrementing surrogate key (IDENTITY is part of the ANSI SQL standard)
-- GENERATE ALWAYS AS IDENTITY prevents users from manually inserting data into this column, which avoids duplication issues
CREATE TABLE IF NOT EXISTS surrogate_key_example(
	order_number bigint GENERATED ALWAYS AS IDENTITY,
	product_name text,
	order_time timestamp with time zone,
	CONSTRAINT order_number_key PRIMARY KEY (order_number)
);

-- INSERT INTO surrogate_key_example (product_name, order_time)
-- VALUES ('Beachball Polish', '2020-03-15 09:21-07'),
--        ('Wrinkle De-Atomizer', '2017-05-22 14:00-07'),
--        ('Flux Capacitor', '1985-10-26 01:18:00-07');
	
SELECT * FROM surrogate_key_example;

	
-- we can allow manual insertions by restarting the IDENTITY sequence

-- INSERT INTO surrogate_key_example
-- OVERRIDING SYSTEM VALUE
-- 	VALUES (4, 'Chicken Coop', '2021-09-03 10:33-07');
	
-- ALTER TABLE modifies tables and columns in numerous ways (chap10 has more info)

-- ALTER TABLE surrogate_key_example ALTER COLUMN order_number
-- RESTART WITH 5;
	
-- INSERT INTO surrogate_key_example (product_name, order_time)
-- VALUES ('Aloe Plant', '2020-03-15 10:09-07');

-- license_id is the primary key
CREATE TABLE IF NOT EXISTS licenses (
	license_id text,
	first_name text,
	last_name text,
	CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

-- (registration_id, license_id) is the composite primary key
-- license_id is also a foreign key
-- a single license_id might be connected to mutiple vehicle registrations,
-- which is an example of a one-to-many relationship
CREATE TABLE IF NOT EXISTS registrations (
	registration_id text,
	registration_date timestamp with time zone,
	license_id text REFERENCES licenses (license_id),
	CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

-- Important to note:
	-- Foreign key values must already exist in the primary key it references. This is called referential integrity.
	-- aka, makes sure that data in related tables doesn't end up unrelated
	-- aka, we ont end up with rows in one table that have no relation to rows in other tables (orpaned rows)
	-- additionally, foreign keys prevent us from deleting rows that would result in an orphaned row


-- INSERT INTO licenses (license_id, first_name, last_name)
-- VALUES ('T229901', 'Steve', 'Rothery');

-- this INSERT statement works because the license_id 'T229901' exists in the license_id column (primary key) of the licenses table

-- INSERT INTO registrations (registration_id, registration_date, license_id)
-- VALUES ('A203391', '2022-03-17', 'T229901');

-- this INSERT statement does not work because 'T000001' does not exixt in the licenses table primary key

-- INSERT INTO registrations (registration_id, registration_date, license_id)
-- VALUES ('A75772', '2022-03-17', 'T000001');


-- ON DELETE CASCADE makes it so deleting a row in licenses should also delete related rows in registrations
CREATE TABLE IF NOT EXISTS registrations(
	registration_id text,
	registration_date date,
	license_id text REFERENCES licenses (license_id) ON DELETE CASCADE,
	CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

-- the CHECK constraint evaluates whether data added to a column meets the expected criteria
-- CHECK can be implemented at the column or table levels
-- syntax: CONSTRAINT constraint_name CHECK (logical expression)

CREATE TABLE IF NOT EXISTS check_constraint_example (
	user_id bigint GENERATED ALWAYS AS IDENTITY,
	user_role text,
	salary numeric(10,2),
	CONSTRAINT user_id_key PRIMARY KEY (user_id),
	CONSTRAINT check_role_in_list CHECK (user_role IN ('Admin', 'Staff')),
	CONSTRAINT check_salary_not_below_zero CHECK (salary >= 0)
);


-- Both of these will fail:
-- INSERT INTO check_constraint_example (user_role)
-- VALUES ('admin');

-- INSERT INTO check_constraint_example (salary)
-- VALUES (-10000);


-- the UNIQUE constraint ensures that a column has a unique value in each row
-- note: UNIQUE permits multiple NULL values

-- CREATE TABLE IF NOT EXISTS unique_constraint_example(
-- 	contact_id bigint GENERATED ALWAYS AS IDENTITY,
-- 	first_name text,
-- 	last_name text,
-- 	email text,
-- 	CONSTRAINT contact_id_key PRIMARY KEY (contact_id),
-- 	CONSTRAINT email_unique UNIQUE (email))

-- first two will run fine, the last one will crash because of the unique constraint
-- INSERT INTO unique_constraint_example (first_name, last_name, email)
-- VALUES ('Samantha', 'Lee', 'slee@example.org');

-- INSERT INTO unique_constraint_example (first_name, last_name, email)
-- VALUES ('Betty', 'Diaz', 'bdiaz@example.org');

-- INSERT INTO unique_constraint_example (first_name, last_name, email)
-- VALUES ('Sasha', 'Lee', 'slee@example.org');


-- CREATE TABLE IF NOT EXISTS not_null_example (
--     student_id bigint GENERATED ALWAYS AS IDENTITY,
--     first_name text NOT NULL,
--     last_name text NOT NULL,
--     CONSTRAINT student_id_key PRIMARY KEY (student_id)
-- );

-- This will fail:
-- INSERT INTO not_null_example (first_name, last_name)
-- VALUES ('Sting', NULL);



-- using ALTER TABLE, you can remove or add constraints to existing tables

-- -- Drop
-- ALTER TABLE not_null_example DROP CONSTRAINT student_id_key;

-- -- Add
-- ALTER TABLE not_null_example ADD CONSTRAINT student_id_key PRIMARY KEY (student_id);

-- -- Drop
-- ALTER TABLE not_null_example ALTER COLUMN first_name DROP NOT NULL;

-- -- Add
-- ALTER TABLE not_null_example ALTER COLUMN first_name SET NOT NULL;


-- indexes let us speed up queries. Indexes are a separate data structure the database manages.
-- the database used indexes as a shortcut rather than scanning each row to find data
-- indexes are stored separately from the table data and are accessed automatically (if needed) when you run queries
-- primary keys and unique constraints are examples of indexes

-- in postgres, the dedault index type is the B-tree index. It's created automatically on the columns designated for the 
-- primary key or UNIQUE constraint, B-tree stands for "balanced tree"

-- lets use B-tree index to speed up queries on a larger dataset

CREATE TABLE IF NOT EXISTS new_york_addresses (
    longitude numeric(9,6),
    latitude numeric(9,6),
    street_number text,
    street text,
    unit text,
    postcode text,
    id integer CONSTRAINT new_york_key PRIMARY KEY
);


-- COPY new_york_addresses
-- FROM '/Users/eric/Documents/postgres_stuff/constraints_indexes_practice/city_of_new_york.csv'
-- WITH (FORMAT CSV, HEADER);


-- postgres has an EXPLAIN command which lists the query plan for a specific database query.
-- a query plan mgith include how the database plans to scan the table, use indexes, and so on.
-- when we add the ANALYZE keyword, EXPLAIN will also show the execution time


-- execution time of 38 ms
EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'BROADWAY';


-- now lets add an index to see if we can speed this up
-- CREATE INDEX street_idx ON new_york_addresses (street);



-- execution time of 2.3 ms
EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'BROADWAY';



CREATE TABLE albums (
	album_id bigint GENERATED ALWAYS AS IDENTITY,
	catalog_code text NOT NULL,
	title text NOT NULL,
	artist text NOT NULL,
	release_date date,
	genre text,
	description text,
	CONSTRAINT album_id_key PRIMARY KEY (album_id)
);

CREATE TABLE songs (
	song_id bigint GENERATED ALWAYS AS IDENTITY,
	title text NOT NULL,
	composers text NOT NULL,
	album_id bigint REFERENCES albums (album_id),
	CONSTRAINT song_id_key PRIMARY KEY (song_id)
	
);




	