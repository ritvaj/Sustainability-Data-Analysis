-- ============================================================
-- VALIDATION CHECKS
-- ============================================================

-- Row counts per table
SELECT 'Population' AS table_name, COUNT(*) AS totalrows FROM Population
UNION ALL
SELECT 'Income_per_capita', COUNT(*) FROM Income_per_capita
UNION ALL
SELECT 'Country_land_area', COUNT(*) FROM Country_land_area
UNION ALL
SELECT 'Co2_emissions', COUNT(*) FROM Co2_emissions
UNION ALL
SELECT 'Deforestation', COUNT(*) FROM Deforestation;

-- Null checks
SELECT 'Population' AS table_name, SUM(CASE WHEN population IS NULL THEN 1 ELSE 0 END) AS nulls FROM Population
UNION ALL
SELECT 'Income_per_capita', SUM(CASE WHEN income_per_capita_us$ IS NULL THEN 1 ELSE 0 END) FROM Income_per_capita
UNION ALL
SELECT 'Country_land_area', SUM(CASE WHEN land_area_squarekm IS NULL THEN 1 ELSE 0 END) FROM Country_land_area
UNION ALL
SELECT 'Co2_emissions', SUM(CASE WHEN emission_value_MtCo2 IS NULL THEN 1 ELSE 0 END) FROM Co2_emissions
UNION ALL
SELECT 'Deforestation', SUM(CASE WHEN forest_cover_percent IS NULL THEN 1 ELSE 0 END) FROM Deforestation;

-- Year range sanity check
SELECT 'Population' AS table_name, MIN(year) AS min_year, MAX(year) AS max_year FROM Population
UNION ALL
SELECT 'Income_per_capita', MIN(year), MAX(year) FROM Income_per_capita
UNION ALL
SELECT 'Country_land_area', MIN(year), MAX(year) FROM Country_land_area
UNION ALL
SELECT 'Co2_emissions', MIN(year), MAX(year) FROM Co2_emissions
UNION ALL
SELECT 'Deforestation', MIN(year), MAX(year) FROM Deforestation;
