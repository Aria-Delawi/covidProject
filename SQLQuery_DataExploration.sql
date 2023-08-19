Select * from covidProject.dbo.CovidDeaths$
Where continent is not null
order by 3,4

Select * from covidProject.dbo.CovidVaccinations$
Where continent is not null
order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population 
from covidProject.dbo.CovidDeaths$
Where continent is not null
order by 1,2


-- Total cases vs Total deaths
-- Show likelihood of dying in your country
Select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
from covidProject.dbo.CovidDeaths$
Where continent is not null
--WHERE location like '%tan'
order by 1,2


-- Total cases vs Population
Select location, date, total_cases, population, (total_cases / population)*100 as CasesPercentage
from covidProject.dbo.CovidDeaths$
Where continent is not null
--WHERE location like '%tan'
order by 1,2

 -- Countries with highest infection rate compared to population
 Select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population))*100 as CasesPercentage
from covidProject.dbo.CovidDeaths$
Group by location, population
order by CasesPercentage desc

-- Countries with the higest death count 
Select location, MAX(cast(total_deaths as int)) as Total_Deaths
from covidProject.dbo.CovidDeaths$
Where continent is not null
Group by location
order by Total_Deaths desc 


-- Continent with highest death count
Select location, MAX(cast(total_deaths as int)) as Total_Deaths
from covidProject.dbo.CovidDeaths$
Where continent is null
Group by location
order by Total_Deaths desc 

Select continent, MAX(cast(total_deaths as int)) as Total_Deaths
from covidProject.dbo.CovidDeaths$
Where continent is not null
Group by continent
order by Total_Deaths desc 


-- Global Numbers
Select  SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, 
			SUM(CAST(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
from covidProject.dbo.CovidDeaths$
Where continent is not null
order by 1,2


-- looking at people vaccinated percentage per country
-- using CTE

with PopvsVac (continent, location, date, populaiton, new_vaccination, Total_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as Total_vaccinated
From covidProject.dbo.CovidDeaths$ dea
Join covidProject.dbo.CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (Total_vaccinated/populaiton)*100 as vaccinated_percentage
from PopvsVac
order by 2,3


-- creating view for later visualizations

CREATE VIEW PopvsVacView AS
WITH PopvsVac (continent, location, date, population, new_vaccination, Total_vaccinated)
AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Total_vaccinated
    FROM
        covidProject.dbo.CovidDeaths$ dea
    JOIN
        covidProject.dbo.CovidVaccinations$ vac
        ON dea.location = vac.location AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL
)
SELECT
    PopvsVac.*,
    (Total_vaccinated / population) * 100 AS vaccinated_percentage
FROM
    PopvsVac;


select * from PopvsVacView