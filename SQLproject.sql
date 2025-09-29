CREATE DATABASE Sustainability_Analysis2;
USE Sustainability_Analysis2;

CREATE TABLE IF NOT EXISTS Population(
Country_code VARCHAR(5),
COUNTRY_NAME VARCHAR(250),
year int,
Population BIGINT);
ALTER TABLE population
ADD PRIMARY KEY (country_code, year);

INSERT INTO population (country_code, country_name, year, population)
SELECT `Country Code`, `Country Name`, year, Population
FROM population_temporary;
SELECT * FROM population;


SELECT * FROM population_temporary;

TRUNCATE TABLE population;

  


DROP TABLE population;

CREATE TABLE Income_per_capita(
Country_code VARCHAR(5),
Country_name VARCHAR(250),
year int,
Income_per_capita_US$ DOUBLE
);

ALTER TABLE income_per_capita
ADD PRIMARY KEY (country_code, year);
  
select * from income_per_capita;

DROP TABLE Income_per_capita;

select * from income_per_capita_temporary;

truncate table income_per_capita;

INSERT INTO income_per_capita (country_code, country_name, year, income_per_capita_us$)
SELECT 
  `Country Code`, 
  `Country Name`, 
  year, 
  Income_per_capita
FROM income_per_capita_temporary;


CREATE TABLE Country_land_area(
Country_code VARCHAR(5),
Country_name VARCHAR(250),
year int,
Land_area_squarekm DOUBLE
);

ALTER TABLE country_land_area
ADD PRIMARY KEY (country_code, year);
  
DROP TABLE Country_land_area;

truncate table country_land_area;

select * from land_area_temp;

INSERT INTO country_land_area(country_code, country_name, year, land_area_squarekm)
SELECT 
  `Country Code`, 
  `Country Name`, 
  year, 
  land_area
FROM land_area_temp;

select * from country_land_area;


CREATE TABLE Co2_emissions(
substance VARCHAR(3), 
Country_code VARCHAR(5),
Country_name VARCHAR(250),
year int,
emission_value_MtCo2 DOUBLE
);

ALTER TABLE co2_emissions
ADD PRIMARY KEY (country_code, year, substance);

drop table co2_emissions;

truncate table Co2_emissions;

select * from Co2_emissions_temp;

INSERT INTO Co2_emissions(substance, country_code, country_name, year, emission_value_MtCo2)
SELECT 
  substance,
  Country_Code, 
  Country_Name, 
  year, 
  emission_value
FROM Co2_emissions_temp;

select * from Co2_emissions;


CREATE TABLE Deforestation(
Country_code VARCHAR(5),
Country_name VARCHAR(250),
year int,
forest_cover_percent DOUBLE
);

ALTER TABLE deforestation
ADD PRIMARY KEY (country_code, year);

DROP TABLE Deforestation;

truncate table deforestation;

select * from deforestation_temp;

INSERT INTO deforestation(country_code, country_name, year, forest_cover_percent)
SELECT 
  Country_Code, 
  Country_name, 
  year, 
  forest_cover_percent
FROM deforestation_temp;

select * from deforestation;

-- Joining population, country land area, income per capita, and deforestation tables

SELECT d.country_code,
       d.year,
       d.country_name,
       d.forest_cover_percent,
       la.land_area_squarekm,
       ROUND(d.forest_cover_percent * la.land_area_squarekm / 100, 2) AS forested_area_squarekm,
       p.population,
       i.income_per_capita_us$,
       CASE WHEN i.income_per_capita_us$ <= 1135 THEN 'Low income'
            WHEN i.income_per_capita_us$ <= 4465 THEN 'Lower-middle income'
			WHEN i.income_per_capita_us$ <= 13845 THEN 'Upper-middle income'
			WHEN i.income_per_capita_us$ > 13845 THEN 'High income'
			ELSE 'Unknown'
			END AS income_group
FROM deforestation d
LEFT JOIN population p
  ON d.country_code = p.country_code  
LEFT JOIN income_per_capita i
  ON d.country_code = i.country_code 
LEFT JOIN country_land_area la
  ON d.country_code = la.country_code;
  

-- Joining population, income per capita, and Co2 emissions tables

SELECT c.country_name,
  c.country_code,
  c.substance,
  c.emission_value_MtCo2,                                                     
  ROUND(c.emission_value_MtCo2 * 1000000 / NULLIF(p.population,0), 4) 
    AS emissions_per_capita_tonnes,                                    
  i.income_per_capita_us$ AS income_per_capita,
  CASE  WHEN i.income_per_capita_us$ <= 1135 THEN 'Low income'
		WHEN i.income_per_capita_us$ <= 4465 THEN 'Lower-middle income'
		WHEN i.income_per_capita_us$ <= 13845 THEN 'Upper-middle income'
		WHEN i.income_per_capita_us$ > 13845 THEN 'High income'
		ELSE 'Unknown'
		END AS income_group,
  p.population
FROM co2_emissions c
LEFT JOIN population p
  ON c.country_code = p.country_code
LEFT JOIN income_per_capita i
  ON c.country_code = i.country_code
ORDER BY c.country_name, c.year;