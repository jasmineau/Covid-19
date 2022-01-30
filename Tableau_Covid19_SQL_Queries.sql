/*

Queries used for Tableau Project Covid
Dataset: https://ourworldindata.org/covid-deaths
Date: 22 Jan 2022

*/

-- Tableau Project Covid Sheet 1
-- Total Cases vs Total Deaths worldwide up tp 22 Jan 22
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_death, ROUND((SUM(new_deaths)/SUM(new_cases)*100),2) AS death_percentage
FROM `jasmineproject-338111.Covid.Covid_Death` 
WHERE continent IS NOT NULL


-- Tableau Project Covid Sheet 2
-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe
SELECT location, SUM(new_deaths) AS total_death
FROM `jasmineproject-338111.Covid.Covid_Death` 
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International', 'Upper middle income', 'High income', 'Lower middle income','Low income')
GROUP BY location
ORDER BY total_death DESC


-- Tableau Project Covid Sheet 3
-- looking at the Countries with Highest Infection Rate compared to Population up to 22 Jan 22
SELECT location, population, MAX(total_cases) AS highest_infection_count, ROUND(MAX((total_cases/population)*100),2) AS infected_percentage
FROM `jasmineproject-338111.Covid.Covid_Death` 
GROUP BY Location, Population
ORDER BY infected_percentage DESC



-- Tableau Project Covid Sheet 4 & 5
-- looking at the total number of infected population by country everyday
SELECT location, date, population, new_cases, 
SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) AS Rolling_people_infected
FROM `jasmineproject-338111.Covid.Covid_Death` 
WHERE continent IS NOT NULL 
ORDER BY 1,2 DESC

