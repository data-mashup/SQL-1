select * 
from PortfolioProject..CovidDeaths$
where continent is not null
order by location,date

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths$
order by location,date



select location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location= 'africa'
order by location,date


select location,date,population,total_cases,new_cases,total_deaths,(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$

order by location,date


select location,population,date,MAX(total_cases)as HighestInfectionCount,MAX(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths$
group by location,population,date
order by PercentPopulationInfected desc



select location,MAX(cast(total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths$
where continent is not null
group by  location
order by TotalDeathcount desc



select continent,MAX(cast(total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathcount desc



select location,SUM(cast(new_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths$
where continent is  null
and location not in ('world','European union','International')
group by location
order by TotalDeathcount desc








select continent,MAX(cast(total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathcount desc


select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2





with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select 
d.continent,
d.location,
d.date,
d.population,
v.new_vaccinations,
SUM(convert(int,v.new_vaccinations )) over (partition by d.location order by d.location,d.date) as RollingPeopleVaccinated

from PortfolioProject..CovidDeaths$ d
join PortfolioProject..CovidVaccinations$ v
	on d.location=v.location
	and d.date=v.date
where d.continent is not null

)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac




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

insert into #PercentPopulationVaccinated
select 
d.continent,
d.location,
d.date,
d.population,
v.new_vaccinations,
SUM(convert(int,v.new_vaccinations )) over (partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ d
join PortfolioProject..CovidVaccinations$ v
	on d.location=v.location
	and d.date=v.date
where d.continent is not null

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



create view PercentPopulationVaccinated as
select 
d.continent,
d.location,
d.date,
d.population,
v.new_vaccinations,
SUM(convert(int,v.new_vaccinations )) over (partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ d
join PortfolioProject..CovidVaccinations$ v
	on d.location=v.location
	and d.date=v.date
where d.continent is not null

select * 
from  PercentPopulationVaccinated