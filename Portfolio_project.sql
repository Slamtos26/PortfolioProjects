SELECT *
FROM Covid_death$
where continent is not null
Order by 3,4

--SELECT *
--FROM Covid_vacination$
--Order by 3,4


----Select Data that we are going to be using 


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Covid_death$
Order by 1,2


-- looking at the total cases vs Total deaths
-- shows likelihood of dying if you contact covid19 in Your counrty

SELECT Location, date, total_cases, total_deaths, (CONVERT(DECIMAL(15,3),total_deaths)/ CONVERT(DECIMAL(15,3),total_cases))*100 as DeathPercentage
FROM Covid_death$
WHERE LOCATION LIKE'%Africa%'
Order by 1,2




---looking at the total cases vs population \
---Shows what percentage of the population contact covid
SELECT Location, date, population, total_cases,  (CONVERT(DECIMAL(15,3),total_cases)/ CONVERT(DECIMAL(15,3),population))*100 as CasesVsPopPercentage
FROM Covid_death$
--WHERE LOCATION LIKE'%Africa%'
where continent is not null
Order by 1,2


---looking at countries wit highest infection rate compared to population
SELECT Location, population, MAX(total_cases) as Highest_case, MAX(CONVERT(DECIMAL(15,3),total_cases)/ CONVERT(DECIMAL(15,3),population))*100 as PercentOfPopulationInfected
FROM Covid_death$
where continent is not null
Group by population, location 
Order by PercentOfPopulationInfected DESC


 

----Showing Countries with Highest Death Count Population 
SELECT Location,  MAX(CONVERT(DECIMAL(15,3),total_deaths)) as TotalDeathCount
FROM Covid_death$
where continent is  null
Group by  location 
Order by TotalDeathCount desc

     ---LET'S BRREAK THINGS DOWN BY CONTINENT
	 SELECT Continent,  MAX(CONVERT(DECIMAL(15,3),total_deaths)) as TotalDeathCount
     FROM Covid_death$
      where continent is not null
      Group by  continent 
      Order by TotalDeathCount desc


---- Showing the continent with highest death count per popultion
SELECT continent,  MAX(CONVERT(DECIMAL(15,3),total_deaths)) as TotalDeathCount
FROM Covid_death$
where continent is not null
Group by  continent 
Order by TotalDeathCount desc

----GLOBAL NUMBER 1
SELECT date, SUM(CONVERT(DECIMAL(15,3),new_cases)) AS sumNewcase, SUM(CONVERT(DECIMAL(15,3), new_deaths)) as sumNewDeath, total_deaths, MAX(CONVERT(DECIMAL(15,3),total_cases)/ CONVERT(DECIMAL(15,3),population))*100 as PercentOfPopulationInfected
FROM Covid_death$
where continent is not null
GROUP BY date, total_cases, total_deaths
Order by 1,2


----GLOBAL NUMBER 2
SELECT  SUM(CONVERT(DECIMAL(15,3),new_cases)) AS TotalCases, SUM(CONVERT(DECIMAL(15,3), new_deaths)) as Total_deaths, SUM(CONVERT(DECIMAL(15,3), New_deaths)) / SUM(CONVERT(DECIMAL(15,3), New_cases)) * 100 as DeathPercentage
FROM Covid_death$
where continent is not null
--GROUP BY date, total_cases, total_deaths
Order by 1,2

---Looking at total population VS vacination

Select de.continent, de.location, de.date, de.population, vc.new_vaccinations,
sum(CONVERT(DECIMAL(15,3),vc.new_vaccinations)) OVER (PARTITION BY de.location ORDER BY de.location, de.date ) as RollingPeopleVaccinated

From Covid_death$ de
Join Covid_vacination$ vc
 On de.location = vc.location AND de.date = vc.date
 where de.continent is not null
 order by 2,3

 ---USE CTE
 With PopvsVac (continent, location, date, population, new_vaccinations,RollingPeopleVaccinated)
 as
 (
 select de.continent, de.location, de.date, de.population, vc.new_vaccinations
 ,sum(CONVERT(DECIMAL(15,3),vc.new_vaccinations)) OVER (PARTITION BY de.location order by de.location, de.date) as RollingPeopleVaccinated

From PortfolioProject.dbo.Covid_death$ de
Join PortfolioProject.dbo.Covid_vacination$ vc
 On de.location = vc.location
 AND de.date = vc.date
 where de.continent is not null
 --Order by 2,3
 )

 SELECT* --(RollingPeopleVaccinated / population)*100
 From PopvsVac

 ----TEMP TABLE

 drop table if exists #temp_CovidInformation
 Create Table #temp_CovidInformation
 (Continent NVarchar(250),
 Location Nvarchar(250), 
 Date datetime, 
 Population numeric, 
 New_vaccinations numeric,
 RollingPeopleVaccinated Numeric
 )

 INSERT INTO #temp_CovidInformation
 

 select de.continent, de.location, de.date, de.population, vc.new_vaccinations
 ,sum(CONVERT(DECIMAL(15,3),vc.new_vaccinations)) OVER (PARTITION BY de.location order by de.location, de.date) as RollingPeopleVaccinated

From PortfolioProject.dbo.Covid_death$ de
Join PortfolioProject.dbo.Covid_vacination$ vc
 On de.location = vc.location
 AND de.date = vc.date
 where de.continent is not null
 --Order by 2,3
 SELECT* --(RollingPeopleVaccinated / population)*100
 From  #temp_CovidInformation
