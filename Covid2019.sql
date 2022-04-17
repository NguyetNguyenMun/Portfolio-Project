/*
COVID 19 DATA EXPLORATION
Skill used: Join, CTE, Temp Table, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

-- Total case vs Total deaths in Japan
-- Show likelihood of dying if you contract covid in Japan

Select 
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from PorfolioProject..CovidDeaths
where location like '%Japan%'
and continent is not null
order by 1, 2

-- Total cases vs Population 
-- Show what percentage of population infected with Covid

Select 
location,
date,
total_cases,
population,
(total_cases/population)*100 as InfectedPoplationPercentage
from PorfolioProject..CovidDeaths
group by location,date,total_cases,population
order by 1, 2

-- Country with highest death count per population

select
location,
max(cast(total_deaths as int)) as Max_total_death
from PorfolioProject..CovidDeaths
where continent is not null
group by location
order by 2 desc

-- Global numbers

select
sum(new_cases) as total_new_cases,
sum(cast(new_deaths as int)) as total_new_deaths,
sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from PorfolioProject..CovidDeaths
where continent is not null

-- Total Population vs Vaccination
-- Show Percentage of Population that has received at least one Covid vaccine

with PopvsVac
as
(
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *,
(RollingPeopleVaccinated/population)*100
from PopvsVac








