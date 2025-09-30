-- ============================================================
-- ANALYSIS QUERIES
-- ============================================================

-- Forest cover joined with land area, population, income
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
FROM Deforestation d
LEFT JOIN Population p
  ON d.country_code = p.country_code  
LEFT JOIN Income_per_capita i
  ON d.country_code = i.country_code 
LEFT JOIN Country_land_area la
  ON d.country_code = la.country_code;

-- CO₂ emissions with per-capita + income group
SELECT c.country_name,
       c.country_code,
       c.substance,
       c.emission_value_MtCo2,                                                     
       ROUND(c.emission_value_MtCo2 * 1000000 / NULLIF(p.population,0), 4) AS emissions_per_capita_tonnes,                                    
       i.income_per_capita_us$ AS income_per_capita,
       CASE  WHEN i.income_per_capita_us$ <= 1135 THEN 'Low income'
             WHEN i.income_per_capita_us$ <= 4465 THEN 'Lower-middle income'
             WHEN i.income_per_capita_us$ <= 13845 THEN 'Upper-middle income'
             WHEN i.income_per_capita_us$ > 13845 THEN 'High income'
             ELSE 'Unknown'
       END AS income_group,
       p.population
FROM Co2_emissions c
LEFT JOIN Population p
  ON c.country_code = p.country_code
LEFT JOIN Income_per_capita i
  ON c.country_code = i.country_code
ORDER BY c.country_name, c.year;
