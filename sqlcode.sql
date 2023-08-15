use CovidProject;
go
select *
from CovidDeaths
where continent is not null
order by 3,4;

select * 
from CovidVaccinations;

-- What is the likelihood of dying?

select location, date, format(total_cases,'#,0') as TotalCases, format(total_deaths,'#,0') as TotalDeaths, (total_deaths/total_cases) * 100 as DeathPercentage
from CovidDeaths
where continent is not null
-- and location = 'egypt'
order by 1,2;

-- What is the percentage of population infected?

select location, date, format(population,'#,0') as Population, format(total_cases,'#,0') as TotalCases, (total_cases/population) * 100 as PercentPopulationInfected
from CovidDeaths
where continent is not null
-- and location = 'egypt'
order by 1,2;

-- What are the countries with highest infection rate?

select location, format(population,'#,0') as Population, max(total_cases) as total_cases, max((total_cases/population)) * 100 as PercentPopulationInfected
from CovidDeaths
where continent is not null
-- and location = 'egypt'
group by location, Population
order by PercentPopulationInfected desc;

-- What are the countries with Highest death rate?

select location, format(population,'#,0') as Population, max(total_deaths) as total_deaths, max((total_deaths/population)) * 100 as PercentPopulationDeaths
from CovidDeaths
where continent is not null
-- and location = 'egypt'
group by location, Population
order by PercentPopulationDeaths desc;

-- What are the continents with Highest death count?

select continent, format(sum(total_deaths), '#,0') as TotalDeaths
from CovidDeaths
where continent is not null
group by continent
order by sum(total_deaths) desc;

-- Across the whoe world:

select sum(new_cases) as TotalNewCases, sum(cast(new_deaths as int)) as TotalNewDeaths, round(sum(cast(new_deaths as int))/sum(new_cases) * 100,2) as DeathPercentage
from CovidDeaths
where continent is not null;

-- What is the percentage of people vaccinated?

select d.location, d.date, format(d.population,'#,0') as Population, v.new_vaccinations, 
sum(cast(v.new_vaccinations as int)) over(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeaths d inner join CovidVaccinations v on d.location = v.location
and d.date = v.date
where d.continent is not null
-- and location = 'egypt'
order by 1,2

-- Calculate The percentage of RollingPeopleVaccinated

with PeopleVaccinated as (select d.location, d.date, d.population, v.new_vaccinations, 
sum(cast(v.new_vaccinations as int)) over(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from CovidDeaths d inner join CovidVaccinations v on d.location = v.location
and d.date = v.date
where d.continent is not null)
-- and location = 'egypt'

select *, RollingPeopleVaccinated/population * 100 as PeopleVaccinatedPercentage
from PeopleVaccinated