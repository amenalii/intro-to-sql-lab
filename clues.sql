\connect world
--------------------------------------------------------------------------------------------------- Clue 1 -------------------------------------------------------------------------------------------------------------------------------------
-- Clue #1: We recently got word that someone fitting Carmen Sandiego's description has been traveling through Southern Europe. She's most likely traveling someplace where she won't be noticed, so find the least populated country in Southern Europe, and we'll start looking for her there.

--SELECT * FROM countries WHERE region = 'Southern Europe' ORDER BY population ASC LIMIT 1;
SELECT name, population FROM countries WHERE region = 'Southern Europe' ORDER BY population ASC LIMIT 1;
--Answer =  Vatican City 



--------------------------------------------------------------------------------------------------- Clue 2 -------------------------------------------------------------------------------------------------------------------------------------
-- Clue #2: Now that we're here, we have insight that Carmen was seen attending language classes in this country's officially recognized language. Check our databases and find out what language is spoken in this country, so we can call in a translator to work with you.

SELECT language FROM countrylanguages WHERE countrycode = 'VAT' AND isofficial = 't';
--Answer = Italian



--------------------------------------------------------------------------------------------------- Clue 3 -------------------------------------------------------------------------------------------------------------------------------------
-- Clue #3: We have new news on the classes Carmen attended – our gumshoes tell us she's moved on to a different country, a country where people speak only the language she was learning. Find out which nearby country speaks nothing but that language.


-- Need to use JOIN to combine the two tables and retrieve country name
-- SELECT name FROM countries JOIN countrylanguages ON countries.code = countrylanguages.countrycode WHERE region = 'Southern Europe' AND countrylanguages.language = 'Italian' AND countries.code != 'VAT';

-- RESULTS
--     name    
-- ------------
--  Italy
--  San Marino

-- Need to further filter to find country that only speaks Italian

-- Data in CL table
--     countrycode 
--     language 
--     isofficial 
--     percentage 

-- SQL Alias is used to make the query more readable and quicker to write (https://hightouch.com/sql-dictionary/sql-aliases)
-- Works without c.code once we add percentage filter but keeping it for more clarity
SELECT c.name FROM countries c JOIN countrylanguages cl ON c.code = cl.countrycode WHERE c.region = 'Southern Europe' AND cl.language = 'Italian' AND cl.percentage = 100 AND c.code != 'VAT';  
-- Answer = San Marino



--------------------------------------------------------------------------------------------------- Clue 4 -------------------------------------------------------------------------------------------------------------------------------------
-- Clue #4: We're booking the first flight out – maybe we've actually got a chance to catch her this time. There are only two cities she could be flying to in the country. One is named the same as the country – that would be too obvious. We're following our gut on this one; find out what other city in that country she might be flying to.

-- DATA in Cities table
    -- id integer NOT NULL,
    -- name text NOT NULL,
    -- countrycode character(3) NOT NULL,
    -- district text NOT NULL,
    -- population integer NOT NULL

-- SELECT * FROM countries WHERE name = 'San Marino';
--  code |    name    | continent |     region      | surfacearea | indepyear | population | lifeexpectancy |  gnp   | gnpold | localname  | governmentform | headofstate | capital | code2 
-- ------+------------+-----------+-----------------+-------------+-----------+------------+----------------+--------+--------+------------+----------------+-------------+---------+-------
--  SMR  | San Marino | Europe    | Southern Europe |          61 |       885 |      27000 |           81.1 | 510.00 |        | San Marino | Republic       |             |    3171 | SM


SELECT name FROM cities WHERE countrycode = 'SMR' AND name != 'San Marino';
-- Answer = Serravalle



--------------------------------------------------------------------------------------------------- Clue 5 -------------------------------------------------------------------------------------------------------------------------------------
-- Clue #5: Oh no, she pulled a switch – there are two cities with very similar names, but in totally different parts of the globe! She's headed to South America as we speak; go find a city whose name is like the one we were headed to, but doesn't end the same. Find out the city, and do another search for what country it's in. Hurry!

-- to search for partial text in a SQL query, use the LIKE keyword with wildcards (% and _) in the WHERE clause to specify the partial text pattern you want to search for. % represents zero or more characters, while _ represents a single character. 
--https://www.dummies.com/article/technology/programming-web-design/sql/how-to-use-like-and-not-like-predicates-in-sql-statements-160787/#:~:text=To%20identify%20partial%20matches%2C%20SQL,stands%20for%20any%20single%20character.


-- SELECT * FROM table WHERE name LIKE '%abc%'
SELECT * FROM cities WHERE name LIKE 'Serra%' AND name != 'Serravalle';
-- Answer = Serra Brazil (BRA)



--------------------------------------------------------------------------------------------------- Clue 6 -------------------------------------------------------------------------------------------------------------------------------------
-- Clue #6: We're close! Our South American agent says she just got a taxi at the airport, and is headed towards
-- the capital! Look up the country's capital, and get there pronto! Send us the name of where you're headed and we'll
-- follow right behind you!

--SELECT capital FROM countries WHERE code = 'BRA';
-- Capital number in countries table is the same as the id number in the cities table. 

SELECT ct.name FROM cities ct JOIN countries c ON ct.id = c.capital WHERE c.code = 'BRA';
-- Answer = Brasilia



--------------------------------------------------------------------------------------------------- Clue 7 -------------------------------------------------------------------------------------------------------------------------------------
-- Clue #7: She knows we're on to her – her taxi dropped her off at the international airport, and she beat us to the boarding gates. We have one chance to catch her, we just have to know where she's heading and beat her to the landing dock. Lucky for us, she's getting cocky. She left us a note (below), and I'm sure she thinks she's very clever, but if we can crack it, we can finally put her where she belongs – behind bars.


--               Our playdate of late has been unusually fun –
--               As an agent, I'll say, you've been a joy to outrun.
--               And while the food here is great, and the people – so nice!
--               I need a little more sunshine with my slice of life.
--               So I'm off to add one to the population I find
--               In a city of ninety-one thousand and now, eighty five.


-- We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.


-- city population = 91084

SELECT * FROM cities WHERE population = 91084;
--RESULTS
--   id  |     name     | countrycode |  district  | population 
-- ------+--------------+-------------+------------+------------
--  4060 | Santa Monica | USA         | California |      91084
-- (1 row)



-- CASE CLOSED......GET TO SANTA MONICA BEFORE SHE LANDS!