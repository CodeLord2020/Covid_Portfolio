select *
from PorfolioProject..Covid_Deaths
order by 3,4

select *
from PorfolioProject..Covid_Vaccination
-order by 3,4

select Location, date, total_cases, population, new_cases, total_deaths
from PorfolioProject..Covid_Deaths
order by 1,2

---------------------DeathPercentage%-------------------------------
select Location, date, total_cases, population, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage,
(total_cases/population)*100 as Positive_Percentage
from PorfolioProject..Covid_Deaths
where continent is not Null
order by Location, total_cases 

select Location, population ,max( total_deaths) as Peak_Deaths_wrong, max(total_cases) as Peak_Positive_cases, 
--casting bcos total_deaths data type is nvarchar
MAX (cast (total_deaths as int)) as Peak_death,

max(total_deaths/total_cases)*100 as Peak_Death_Percentage,
max(total_cases/population)*100 as Positive_Per_Pop
from PorfolioProject..Covid_Deaths
group by location, population 
order by Peak_death desc

select Location,max(cast(total_deaths as int)) as Peak_Deaths
from PorfolioProject..Covid_Deaths 
where continent is Null
group by location
order by Peak_Deaths desc

----Global Numbers-----------
select     date, 
           sum(new_cases) as Total_cases,
           sum(cast(new_deaths as int)) as Total_deaths,
           sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_percentage
from PorfolioProject..Covid_Deaths 
where continent is not null
group by date
order by 1, 2

select     date,
           sum(total_cases) as Total_cases,
           sum(cast(total_deaths as int)) as Total_deaths,
           sum(cast(total_deaths as int))/sum(total_cases)*100 as Death_percentage
from PorfolioProject..Covid_Deaths 
where continent is not null
group by date
order by 1, 2

SELECT dea.continent, dea.location,dea.date,  dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) 
                  over (Partition by dea.location order by dea.location, dea.date)
				  as Running_Vac_Total
FROM PorfolioProject..Covid_Deaths dea
JOIN PorfolioProject..Covid_Vaccinations vac
 ON  dea.location = vac.location
 and vac.date = vac.date
 where dea.continent is not null
-- order by dea.date,vac.date