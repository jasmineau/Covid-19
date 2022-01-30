/*
Covid 19 Data Exploration

Skill used: Joins, Aggregate Functions, Creating Views, Windows Functions, Temp Tables
*/


-- select Data that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `jasmineproject-338111.Covid.Covid_Death`
ORDER BY location, date
LIMIT 100


-- Total Cases vs Total Deaths in Hong Kong
-- shows likelihood of dying if contract covid in Hong Kong
SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) AS death_percentage
FROM `jasmineproject-338111.Covid.Covid_Death` 
WHERE location like 'Hong%'
ORDER BY date DESC


-- Total Cases vs population in Hong Kong
-- shows percentage of population infected covid in Hong Konh
SELECT location, date, population, total_cases, round((total_cases/population)*100,2) AS infected_population_percentage
FROM `jasmineproject-338111.Covid.Covid_Death` 
WHERE location like 'Hong%'
ORDER BY date DESC


-- Total number of infected population by country everyday
-- Tableau sheet 4
SELECT location, date, population, new_cases, 
SUM(new_cases) OVER (PARTITION BY location ORDER BY location, date) AS Rolling_people_infected
FROM `jasmineproject-338111.Covid.Covid_Death` 
WHERE continent IS NOT NULL 
ORDER BY 1,2 DESC


-- Countries with Highest Infection Rate
SELECT location, population, MAX(total_cases) AS highest_infection_count, ROUND(MAX((total_cases/population)*100),2) AS infected_percentage
FROM `jasmineproject-338111.Covid.Covid_Death` 
GROUP BY Location, Population
ORDER BY infected_percentage DESC


-- Countires with highest Death Count
SELECT location, MAX(total_deaths) AS total_death_count
FROM `jasmineproject-338111.Covid.Covid_Death` 
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC


-- Continent with highest Death Count
SELECT continent, MAX(total_deaths) AS total_death_count
FROM `jasmineproject-338111.Covid.Covid_Death` 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC


-- Global numbers
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_death, ROUND(SUM(new_deaths)/SUM(new_cases),2) AS death_percentage
FROM `jasmineproject-338111.Covid.Covid_Death`
WHERE continent IS NOT NULL
GROUP BY date 
ORDER BY date DESC


-- total population vs Vaccinations
-- Use joint table and Windows Functions
SELECT *, round((RollingPeopleVaccinated/population)*100, 2) AS VaccintedPercent
FROM (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM `jasmineproject-338111.Covid.Covid_Death` dea
JOIN `jasmineproject-338111.Covid.Covid_Vaccaintion` vac
ON  dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2,3 ) d1


--  create table
CREATE TABLE PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvchar(255),
    Date datetime,
    Population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccainted
)


-- creating view to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM `jasmineproject-338111.Covid.Covid_Death` dea
JOIN `jasmineproject-338111.Covid.Covid_Vaccaintion` vac
ON  dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--ORDER BY 2,3
