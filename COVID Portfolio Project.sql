/*
COVID-19 Data Exploration 
Skills used: Joins, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM [Portfolio Project]..CovidDeaths
WHERE Continent IS NOT NULL
ORDER BY 3, 4


-- Select usable data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
ORDER BY 1, 2

-- Total cases vs deaths; shows how likley you are to die if you have contracted COVID in the US

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%states%'
ORDER BY 1, 2

-- Total cases vs population; shows % of population that had COVID

SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectedPopulationPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%states%'
ORDER BY 1, 2

-- Highest COVID infection rates per country

SELECT location, population, MAX(total_cases) AS HighestInfectionRate , MAX((total_cases/population))*100 AS InfectedPopulationPercentage
FROM [Portfolio Project]..CovidDeaths
GROUP BY location, population 
ORDER BY InfectedPopulationPercentage DESC

-- Countries with highest death rates per capita

SELECT location, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE Continent IS NOT NULL
GROUP BY location 
ORDER BY TotalDeathCount DESC

-- Countries with highest death rates per capita (Continents)

SELECT continent, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY TotalDeathCount DESC

-- Global statistics

SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) AS total_deaths , SUM(cast(new_deaths AS INT))/SUM(New_cases)*100 AS DeathRate
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date 
ORDER BY 1, 2

-- Total population vs vaccinations

SELECT dea. continent, dea. location, dea.date, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- TEMP Table

DROP table IF exists PercentagePopulationVaccinated
Create Table PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentagePopulationVaccinated
SELECT dea. continent, dea. location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentagePopulationVaccinated

-- Views

Create View Total_cases_vs_deaths AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%states%'

Create View COVID_Infection_Percentage AS
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectedPopulationPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%states%'

Create View Population_vs_Vaccinations AS
SELECT dea. continent, dea. location, dea.date, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL