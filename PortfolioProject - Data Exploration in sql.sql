use portfolioproject;

select * from coviddeaths;

select * from covidvaccinations;

select location, date, total_cases, new_cases, total_deaths, population 
from coviddeaths 
order by 1, 2;

-- Looking at the total cases vs total deaths

select location, date, total_cases, total_deaths,  (total_deaths/total_cases)* 100 as Deathpercentage 
from coviddeaths 
where location like '%states%'
order by 1, 2;

-- Looking at the total cases vs Population

select location, date, total_cases, Population ,(total_cases/Population)* 100 as casespercentage 
from coviddeaths 
order by 1, 2;

-- looking at the countries with Highest Infection Rate compared to Population

select location, Population ,  max(total_cases) as Highestinfected, max((total_cases/Population))* 100 as casespercentage 
from coviddeaths 
group by location, Population 
order by casespercentage desc;

-- Showing countries with Highest Death count Per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
From coviddeaths
-- Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc;

-- Lets Break things by continent
-- showing the continents with the highest death count  per population

Select  continent, MAX(Total_deaths) as TotalDeathCount
From coviddeaths
-- Where location like '%states%'
Where continent is not null 
Group by  continent
order by TotalDeathCount desc;

-- Global Numbers 

select  sum(total_cases), sum(total_deaths),  sum(total_deaths)/sum(total_cases)* 100 as Deathpercentage 
from coviddeaths 
where continent is not null
-- group by date
order by 1, 2;

---- 
select * from covidddeaths;
select * from covidvaccinations;

-- Looking at Total Population vs Vaccinations

select cd.continent, cd.location, cd.date, cd.Population , cv.new_vaccinations, 
sum(cv.new_vaccinations) over (partition by cd.location  order by cd.date, cd.location) as RolledPeopleVaccinated
from coviddeaths as cd
join covidvaccinations  as cv
on  cd.location = cv.location and cd.date = cv.date
where cd.continent is not null
order by 2,3 ;

--  Use CTE

with PopvsVacc (continent, location, date, Population, new_vaccinations, RolledPeopleVaccinated)
as
(select cd.continent, cd.location, cd.date, cd.Population , cv.new_vaccinations, 
sum(cv.new_vaccinations) over (partition by cd.location  order by cd.date, cd.location) as RolledPeopleVaccinated
from coviddeaths as cd
join covidvaccinations  as cv
on  cd.location = cv.location and cd.date = cv.date
where cd.continent is not null)

select * , (RolledPeopleVaccinated/Population)*100
from PopvsVacc;


-- Using Temp Table

Drop table if exists PercentPopulationVaccinated ;
CREATE TEMPORARY TABLE  PercentPopulationVaccinated 
(continent varchar(55),
 location varchar(55), 
 date datetime, 
 Population numeric, 
 new_vaccinations numeric, 
 RolledPeopleVaccinated numeric);
 
 Insert into PercentPopulationVaccinated( 
 select cd.continent, cd.location, cd.date, cd.Population , cv.new_vaccinations, 
sum(cv.new_vaccinations) over (partition by cd.location  order by cd.location,cd.date) as RolledPeopleVaccinated
from coviddeaths as cd
join covidvaccinations  as cv
on  cd.location = cv.location 
and cd.date = cv.date
-- where cd.continent is not null
);

select * , (RolledPeopleVaccinated/Population)*100
from PercentPopulationVaccinated;
 
 
 -- creating view to store data fro later visualisations
 
 create view PercentPopulationVaccinateds as 
select cd.continent, cd.location, cd.date, cd.Population , cv.new_vaccinations, 
sum(cv.new_vaccinations) over (partition by cd.location  order by cd.location,cd.date) as RolledPeopleVaccinated
from coviddeaths as cd
join covidvaccinations  as cv
on  cd.location = cv.location 
and cd.date = cv.date 
where cd.continent is not null;

select * from PercentPopulationVaccinateds;
