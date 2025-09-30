-- ============================================================
--  Sustainability Analysis Project
--  Relational schema + ETL inserts + validation checks
--  Author: Ritvaj Madotra
-- ============================================================

CREATE DATABASE IF NOT EXISTS Sustainability_Analysis2;
USE Sustainability_Analysis2;

-- ============================================================
-- TABLE CREATION
-- ============================================================

-- Population
CREATE TABLE IF NOT EXISTS Population (
    Country_code VARCHAR(5),
    Country_name VARCHAR(250),
    year INT,
    Population BIGINT
);
ALTER TABLE Population
ADD PRIMARY KEY (country_code, year);

-- Income per capita
CREATE TABLE IF NOT EXISTS Income_per_capita (
    Country_code VARCHAR(5),
    Country_name VARCHAR(250),
    year INT,
    Income_per_capita_US$ DOUBLE
);
ALTER TABLE Income_per_capita
ADD PRIMARY KEY (country_code, year);

-- Land area
CREATE TABLE IF NOT EXISTS Country_land_area (
    Country_code VARCHAR(5),
    Country_name VARCHAR(250),
    year INT,
    Land_area_squarekm DOUBLE
);
ALTER TABLE Country_land_area
ADD PRIMARY KEY (country_code, year);

-- CO₂ emissions
CREATE TABLE IF NOT EXISTS Co2_emissions (
    substance VARCHAR(3), 
    Country_code VARCHAR(5),
    Country_name VARCHAR(250),
    year INT,
    emission_value_MtCo2 DOUBLE
);
ALTER TABLE Co2_emissions
ADD PRIMARY KEY (country_code, year, substance);

-- Deforestation
CREATE TABLE IF NOT EXISTS Deforestation (
    Country_code VARCHAR(5),
    Country_name VARCHAR(250),
    year INT,
    forest_cover_percent DOUBLE
);
ALTER TABLE Deforestation
ADD PRIMARY KEY (country_code, year);

-- ============================================================
-- ETL: Insert from staging tables (loaded from CSVs)
-- ============================================================

INSERT INTO Population (country_code, country_name, year, population)
SELECT `Country Code`, `Country Name`, year, Population
FROM population_temporary;

INSERT INTO Income_per_capita (country_code, country_name, year, income_per_capita_us$)
SELECT `Country Code`, `Country Name`, year, Income_per_capita
FROM income_per_capita_temporary;

INSERT INTO Country_land_area (country_code, country_name, year, land_area_squarekm)
SELECT `Country Code`, `Country Name`, year, land_area
FROM land_area_temp;

INSERT INTO Co2_emissions (substance, country_code, country_name, year, emission_value_MtCo2)
SELECT substance, Country_Code, Country_Name, year, emission_value
FROM Co2_emissions_temp;

INSERT INTO Deforestation (country_code, country_name, year, forest_cover_percent)
SELECT Country_Code, Country_name, year, forest_cover_percent
FROM deforestation_temp;
