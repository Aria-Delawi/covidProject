
--Selected queries for Tableau Visualization

Select  SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, 
			SUM(CAST(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
from covidProject.dbo.CovidDeaths$
Where continent is not null
order by 1,2


Select location, SUM(cast(new_deaths as int)) as TotalDeaths
From covidProject.dbo.CovidDeaths$
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeaths desc

 Select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population))*100 as CasesPercentage
from covidProject.dbo.CovidDeaths$
Group by location, population
order by CasesPercentage desc

select location, population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as CasesPercentage
from covidProject.dbo.CovidDeaths$
Group by Location, Population, date
order by CasesPercentage desc



