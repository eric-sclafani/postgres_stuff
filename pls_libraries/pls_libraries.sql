CREATE TABLE IF NOT EXISTS pls_fy2018_libraries (
    stabr text NOT NULL,
    fscskey text CONSTRAINT fscskey_2018_pkey PRIMARY KEY,
    libid text NOT NULL,
    libname text NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    zip text NOT NULL,
    county text NOT NULL,
    phone text NOT NULL,
    c_relatn text NOT NULL,
    c_legbas text NOT NULL,
    c_admin text NOT NULL,
    c_fscs text NOT NULL,
    geocode text NOT NULL,
    lsabound text NOT NULL,
    startdate text NOT NULL,
    enddate text NOT NULL,
    popu_lsa integer NOT NULL,
    popu_und integer NOT NULL, 
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl integer NOT NULL,
    video_ph integer NOT NULL,
    video_dl integer NOT NULL,
    ec_lo_ot integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    reference integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    totpro integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    obereg text NOT NULL,
    statstru text NOT NULL,
    statname text NOT NULL,
    stataddr text NOT NULL,
    longitude numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL
);

-- COPY pls_fy2018_libraries
-- FROM '/Users/eric/Documents/postgres_stuff/pls_libraries/pls_fy2018_libraries.csv'
-- WITH (FORMAT CSV, HEADER);

-- CREATE INDEX libname_2018_idx ON pls_fy2018_libraries (libname);

-- Listing 9-2: Creating and filling the 2017 and 2016 Public Libraries Survey tables

CREATE TABLE IF NOT EXISTS pls_fy2017_libraries (
    stabr text NOT NULL,
    fscskey text CONSTRAINT fscskey_17_pkey PRIMARY KEY,
    libid text NOT NULL,
    libname text NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    zip text NOT NULL,
    county text NOT NULL,
    phone text NOT NULL,
    c_relatn text NOT NULL,
    c_legbas text NOT NULL,
    c_admin text NOT NULL,
    c_fscs text NOT NULL,
    geocode text NOT NULL,
    lsabound text NOT NULL,
    startdate text NOT NULL,
    enddate text NOT NULL,
    popu_lsa integer NOT NULL,
    popu_und integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl integer NOT NULL,
    video_ph integer NOT NULL,
    video_dl integer NOT NULL,
    ec_lo_ot integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    reference integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    totpro integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    obereg text NOT NULL,
    statstru text NOT NULL,
    statname text NOT NULL,
    stataddr text NOT NULL,
    longitude numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL
);

CREATE TABLE IF NOT EXISTS pls_fy2016_libraries (
    stabr text NOT NULL,
    fscskey text CONSTRAINT fscskey_16_pkey PRIMARY KEY,
    libid text NOT NULL,
    libname text NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    zip text NOT NULL,
    county text NOT NULL,
    phone text NOT NULL,
    c_relatn text NOT NULL,
    c_legbas text NOT NULL,
    c_admin text NOT NULL,
    c_fscs text NOT NULL,
    geocode text NOT NULL,
    lsabound text NOT NULL,
    startdate text NOT NULL,
    enddate text NOT NULL,
    popu_lsa integer NOT NULL,
    popu_und integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl integer NOT NULL,
    video_ph integer NOT NULL,
    video_dl integer NOT NULL,
    ec_lo_ot integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    reference integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    totpro integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    obereg text NOT NULL,
    statstru text NOT NULL,
    statname text NOT NULL,
    stataddr text NOT NULL,
    longitude numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL
);

-- COPY pls_fy2017_libraries
-- FROM '/Users/eric/Documents/postgres_stuff/pls_libraries/pls_fy2017_libraries.csv'
-- WITH (FORMAT CSV, HEADER);

-- COPY pls_fy2016_libraries
-- FROM '/Users/eric/Documents/postgres_stuff/pls_libraries/pls_fy2016_libraries.csv'
-- WITH (FORMAT CSV, HEADER);

-- CREATE INDEX libname_2017_idx ON pls_fy2017_libraries (libname);
-- CREATE INDEX libname_2016_idx ON pls_fy2016_libraries (libname);


-- now that the library data is imported, lets make sure the tables have the correct # of rows
-- 2018 should have 9261, 2017 should have 9245, 2016 should have 9252

SELECT COUNT(*) FROM pls_fy2018_libraries;
SELECT COUNT(*) FROM pls_fy2017_libraries;
SELECT COUNT(*) FROM pls_fy2016_libraries;


-- given a column name, COUNT will count the number of rows that are not NULL
SELECT COUNT(phone)
FROM pls_fy2018_libraries;


-- count all values from libname column
SELECT COUNT(libname)
FROM pls_fy2018_libraries;

-- count all DISTINCT values from libname
-- this returns 8478, showing that in the 2018 survey, 526 libraries share a name with one or more agencies
SELECT COUNT(DISTINCT libname)
FROM pls_fy2018_libraries;

-- use MIN and MAX to get the minimum and maximum value in a column
-- in this case, the min is -3. the table creators are using -1 to indicate "No response" and -3 to indidate "Not Applicable"
SELECT MIN(visits), MAX(visits)
FROM pls_fy2018_libraries;



-- on its own, GROUP BY eliminates duplicates, only showing unique values
SELECT stabr
FROM pls_fy2018_libraries
GROUP BY stabr
ORDER BY stabr;

-- we can also group by multiple columns.
-- returns 9013 rows, indicating that the file includes 248 instances where 
-- there's more than one library for a particular city and state combination
SELECT city, stabr
FROM pls_fy2018_libraries
GROUP BY city, stabr
ORDER BY city, stabr;


-- get a count of agencies by state and sort them to see which states have the most
SELECT stabr, COUNT(*)
FROM pls_fy2018_libraries
GROUP BY stabr
ORDER BY COUNT(*) DESC;

-- counting the number of agencies in each state that moved, has a minor address change, or no change
SELECT stabr, stataddr, COUNT(*)
FROM pls_fy2018_libraries
GROUP BY stabr, stataddr
ORDER BY stabr, stataddr;

-- the following three select statements get the total # of visits for that year
SELECT SUM(visits) AS visit_2018
FROM pls_fy2018_libraries
WHERE visits >= 0;

SELECT SUM(visits) AS visit_2017
FROM pls_fy2017_libraries
WHERE visits >= 0;

SELECT SUM(visits) AS visit_2016
FROM pls_fy2016_libraries
WHERE visits >= 0;

-- lets determine how the sum of vists will differ if we limit
-- the analysis to library agencies that exist in all three tables

-- reminder: JOIN here (same as INNER JOIN) will only include rows where values in fscskey match in all three tables
SELECT 
	SUM(pls18.visits) AS visits_2018,
	SUM(pls17.visits) AS visits_2017,
	SUM(pls16.visits) AS visits_2016
FROM 
	pls_fy2018_libraries AS pls18 
	JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
	JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
	pls18.visits >= 0
	AND pls17.visits >= 0
	AND pls16.visits >= 0;
	

-- now that we know that visits have decreases for US as a whole, we can ask the question:
-- "Did every part of the country see a decrease? Or did the degree of the trend vary by region?"
-- lets use a percent change to answer this question
SELECT 
	pls18.stabr,
	SUM(pls18.visits) AS visits_2018,
	SUM(pls17.visits) AS visits_2017,
	SUM(pls16.visits) AS visits_2016,
	ROUND( (SUM(pls18.visits::numeric) - SUM(pls17.visits)) / SUM(pls17.visits) *100, 1) AS chg_2018_17,
	ROUND( (SUM(pls17.visits::numeric) - SUM(pls16.visits)) / SUM(pls16.visits) *100, 1) AS chg_2017_16
FROM 
	pls_fy2018_libraries AS pls18
	JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
	JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
	pls18.visits >= 0
	AND pls17.visits >= 0
	AND pls16.visits >= 0
GROUP BY pls18.stabr
ORDER BY chg_2018_17 DESC;
	
-- the HAVING clause places conditions on groups created by aggregating
-- in this query, we only include rows with a sun of visits in 2018 greater than 50 million
SELECT 
	pls18.stabr,
	SUM(pls18.visits) AS visits_2018,
	SUM(pls17.visits) AS visits_2017,
	SUM(pls16.visits) AS visits_2016,
	ROUND( (SUM(pls18.visits::numeric) - SUM(pls17.visits)) / SUM(pls17.visits) *100, 1) AS chg_2018_17,
	ROUND( (SUM(pls17.visits::numeric) - SUM(pls16.visits)) / SUM(pls16.visits) *100, 1) AS chg_2017_16
FROM 
	pls_fy2018_libraries AS pls18
	JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
	JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
	pls18.visits >= 0
	AND pls17.visits >= 0
	AND pls16.visits >= 0
GROUP BY pls18.stabr
HAVING SUM(pls18.visits) > 50000000
ORDER BY chg_2018_17 DESC;



SELECT 
	pls18.stabr,
	SUM(pls18.totstaff) AS totstaff_2018,
	SUM(pls17.totstaff) AS totstaff_2017,
	SUM(pls16.totstaff) AS totstaff_2016,
	ROUND( (SUM(pls18.totstaff::numeric) - SUM(pls17.totstaff)) / SUM(pls17.totstaff) *100, 1) AS chg_2018_17,
	ROUND( (SUM(pls17.totstaff::numeric) - SUM(pls16.totstaff)) / SUM(pls16.totstaff) *100, 1) AS chg_2017_16
FROM 
	pls_fy2018_libraries AS pls18
	JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
	JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
	pls18.totstaff >= 0
	AND pls17.totstaff >= 0
	AND pls16.totstaff >= 0
GROUP BY pls18.stabr
ORDER BY chg_2018_17 DESC;


SELECT 
	pls18.stabr,
	SUM(pls18.totstaff) AS totstaff_2018,
	SUM(pls17.totstaff) AS totstaff_2017,
	SUM(pls16.totstaff) AS totstaff_2016,
	ROUND( (SUM(pls18.totstaff::numeric) - SUM(pls17.totstaff)) / SUM(pls17.totstaff) *100, 1) AS chg_2018_17,
	ROUND( (SUM(pls17.totstaff::numeric) - SUM(pls16.totstaff)) / SUM(pls16.totstaff) *100, 1) AS chg_2017_16
FROM 
	pls_fy2018_libraries AS pls18
	JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
	JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
	pls18.totstaff >= 0
	AND pls17.totstaff >= 0
	AND pls16.totstaff >= 0
GROUP BY pls18.stabr
HAVING SUM(pls18.visits) > 50000000
ORDER BY chg_2018_17 DESC;


SELECT 
	pls18.obereg,
	SUM(pls18.visits) AS visits_2018,
	SUM(pls17.visits) AS visits_2017,
	SUM(pls16.visits) AS visits_2016,
	ROUND( (SUM(pls18.visits::numeric) - SUM(pls17.visits)) / SUM(pls17.visits) *100, 1) AS chg_2018_17,
	ROUND( (SUM(pls17.visits::numeric) - SUM(pls16.visits)) / SUM(pls16.visits) *100, 1) AS chg_2017_16
FROM 
	pls_fy2018_libraries AS pls18
	JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
	JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
	pls18.visits >= 0
	AND pls17.visits >= 0
	AND pls16.visits >= 0
GROUP BY pls18.obereg
ORDER BY chg_2018_17 DESC;

CREATE TABLE IF NOT EXISTS obereg_codes (
    obereg text CONSTRAINT obereg_key PRIMARY KEY,
    region text
);

-- INSERT INTO obereg_codes
-- VALUES ('01', 'New England (CT ME MA NH RI VT)'),
--        ('02', 'Mid East (DE DC MD NJ NY PA)'),
--        ('03', 'Great Lakes (IL IN MI OH WI)'),
--        ('04', 'Plains (IA KS MN MO NE ND SD)'),
--        ('05', 'Southeast (AL AR FL GA KY LA MS NC SC TN VA WV)'),
--        ('06', 'Soutwest (AZ NM OK TX)'),
--        ('07', 'Rocky Mountains (CO ID MT UT WY)'),
--        ('08', 'Far West (AK CA HI NV OR WA)'),
--        ('09', 'Outlying Areas (AS GU MP PR VI)');

-- sum() visits by region.

SELECT obereg_codes.region,
       sum(pls18.visits) AS visits_2018,
       sum(pls17.visits) AS visits_2017,
       sum(pls16.visits) AS visits_2016,
       round( (sum(pls18.visits::numeric) - sum(pls17.visits)) /
            sum(pls17.visits) * 100, 1 ) AS chg_2018_17,
       round( (sum(pls17.visits::numeric) - sum(pls16.visits)) /
            sum(pls16.visits) * 100, 1 ) AS chg_2017_16
FROM pls_fy2018_libraries pls18
       JOIN pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
       JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
       JOIN obereg_codes ON pls18.obereg = obereg_codes.obereg
WHERE pls18.visits >= 0
       AND pls17.visits >= 0
       AND pls16.visits >= 0
GROUP BY obereg_codes.region
ORDER BY chg_2018_17 DESC;


SELECT pls18.libname, pls18.city, pls18.stabr, pls18.statstru, 
       pls17.libname, pls17.city, pls17.stabr, pls17.statstru, 
       pls16.libname, pls16.city, pls16.stabr, pls16.statstru
FROM pls_fy2018_libraries AS pls18
FULL OUTER JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
FULL OUTER JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls16.fscskey IS NULL OR pls17.fscskey IS NULL

;






























