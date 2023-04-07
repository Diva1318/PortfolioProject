--Comparing Total Cases with Total Deaths
select location, date , total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeath
where location like '%ndia%'
order by 1,2

 --Comparing Total Cases with Population
select location, date ,total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage ,
(total_cases/population)*100 as Infected
from PortfolioProject..CovidDeath
where location like '%ndia%'
order by 1,2

-- Country having the highest number of cases
select location, population,MAX(total_cases)as HighestInfectionCount, max((total_cases/population))*100 as PercentInfected
from PortfolioProject..CovidDeath
--where location like '%ndia%''
where continent is not null
group by location, population
order by PercentInfected desc

--Countries with highest death count per population
select location, max(total_deaths) as TotalDeath
from PortfolioProject..CovidDeath
--where location like '%ndia%'
where continent is not null
group by location
order by TotalDeath desc

--Continents with the highest death count per population
select continent, max(total_deaths) as TotalDeath
from PortfolioProject..CovidDeath
--where location like '%ndia%'
where continent is not null
group by continent
order by TotalDeath desc

--Global Numbers
select date , sum(new_cases), sum(cast (new_deaths as int)), sum(cast (new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeath
--where location like '%ndia%'
where continent is not null
group by  date
order by 1,2


--Total population vs vaccinations
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date)
 as RollingPeopleVaccinated
 from PortfolioProject..CovidDeath dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location=vac.location
 and  dea.date=vac.date
 where dea.continent is not null
 --and dea.location like '%ndia%'
 order by 2,3

 --use CTE
  with popvsvac(continent, location, date,population, new_vaccinations, RollingPeopleVacccinated)
  as
  (
   select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date)
 as RollingPeopleVaccinated
 from PortfolioProject..CovidDeath dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location=vac.location
 and  dea.date=vac.date
 where dea.continent is not null
 --and dea.location like '%ndia%'
 --order by 2,3
 )
 select *, (RollingPeopleVacccinated/population)*100
 from popvsvac


 --Temp Table
 drop table if exists #PercentPopulationVaccinated
  create table #PercentPopulationVaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

  insert into #percentpopulationvaccinated 
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date)
 as RollingPeopleVaccinated
 from PortfolioProject..CovidDeath dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location=vac.location
 and  dea.date=vac.date
 where dea.continent is not null
 --and dea.location like '%ndia%'
 --order by 2,3
  select *, (RollingPeopleVaccinated/population)*100
 from #percentpopulationvaccinated


 --Creating Views
 --drop table if exists percentpopulationvaccinated
 create view percentpopulationvaccinated as
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date)
 as RollingPeopleVaccinated
 from PortfolioProject..CovidDeath dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location=vac.location
 and  dea.date=vac.date
 where dea.continent is not null
 --and dea.location like '%ndia%'

 select* 
 from percentpopulationvaccinated