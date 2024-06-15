SELECT * FROM CovidDeaths
Where continent is not NULL
Order by 3,4

--SELECT * FROM CovidVaccinations$
--Order by 3,4

-- Selecting Data we will be using.

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by 1,2

-- Looking at total cases vs Total Deaths
-- Also can look at Percentages, shows likelihood of Dying if covid Contracted in country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
WHERE location LIKE '%Kingdom%'
AND continent is not NULL
Order by 1,2 


-- Looking at total cases vs Population
-- Shows what % of population got Covid
Select Location, date, total_cases, Population, (total_deaths/total_cases)*100 as InfectionRate
From CovidDeaths
WHERE location LIKE '%Kingdom%'
Order by 1,2 

-- Looking at Countries with highest Infection rate compared to population

Select Location, MAX(total_cases)as HighestInfectionCount, Population,MAX((total_cases/population))*100 as InfectionRate
From CovidDeaths
--WHERE location LIKE '%Kingdom%'
Group by Location, population
Order by InfectionRate DESC


-- Showing Countries with Highest Death Count Per Population

Select Location, MAX(cast(total_deaths as int))as DeathCount --
FROM CovidDeaths
--WHERE location LIKE '%Kingdom%'
WHERE continent is not null
Group by Location 
Order by DeathCount DESC

-- Breaking things down by Continents 

-- SHOWING CONTINENTS WITH HIGHEST DEATH COUNT Per population

Select location, MAX(cast(total_deaths as int))as DeathCount --
FROM CovidDeaths
--WHERE location LIKE '%Kingdom%'
WHERE continent is null
Group by location
Order by DeathCount DESC


 -- GLOBAL NUMBERS

 Select date,SUM(New_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int)) / SUM(new_cases)*100
 as DeathPercentage
From CovidDeaths
--WHERE location LIKE '%Kingdom%'
Where continent is not NULL
Group by date
Order by 1,2 
-- CAN Remove date from group by + select statement to see covids impact in general at final date. 


-- Looking at Total Population vs Vaccinations total ppl in world that have been vacc'd

With PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingVaccinationCount)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) 
as RollingVaccinationCount
--(RollingVaccinationCount/dea.population)*100 as VaccinationRate (cant do this as RVC is column YOU made)
-- Partition is So count stops as location changes and keeps adding up at new date. e.g. 60 + 78 = 138 for Albania
FROM CovidDeaths dea
Join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingVaccinationCount/Population)*100
FROM PopvsVac


-- ^ CTE IS ABOVE. USE CTE (when you do a CTE specify column you will input)


-- if you need to recreate the table just drop it "drop table if exists (table name) above the create table command
--TEMP TABLE
-- DROP TABLE if exists #PercentPopulationVaccinated


Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingVaccinationCount numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) 
as RollingVaccinationCount
--(RollingVaccinationCount/dea.population)*100 as VaccinationRate (cant do this as RVC is column YOU made)
-- Partition is So count stops as location changes and keeps adding up at new date. e.g. 60 + 78 = 138 for Albania
FROM CovidDeaths dea
Join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingVaccinationCount/Population)*100
FROM #PercentPopulationVaccinated



-- Creating View to store data for later visualisations 
-- TO ME (A VIEW IS ESSENTIALLY A PERMANENT NEW TABLE with your created columns involved in them)
-- you make views to help with the visualisation process for when you put it into PowerBI

Create View PercentPopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) 
as RollingVaccinationCount
--(RollingVaccinationCount/dea.population)*100 as VaccinationRate 
FROM CovidDeaths dea
Join CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3

Select * 
From PercentPopulationVaccinated