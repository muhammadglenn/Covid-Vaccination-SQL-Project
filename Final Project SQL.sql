-- Looking All Data CovidDeath

Select*
From PortofolioProject..CovidDeath
Where continent is not null
Order by 2, 3, 4


-- Select Some Column for Country

Select location, date, new_cases, total_cases, CAST(new_deaths AS INT) as NewDeaths, CAST(total_deaths AS INT) as TotalDeaths, population
From PortofolioProject..CovidDeath
Where continent is not null
-- And location = 'indonesia'
Order by 1, 2



-- Select Some Column for Region

Select location, date, new_cases, total_cases, CAST(new_deaths AS INT) as NewDeaths, CAST(total_deaths AS INT) as TotalDeaths, population
From PortofolioProject..CovidDeath
Where continent is null
-- And location = 'Asia' (Optional)
Order by 1, 2



-- Total Cases vs Total Deaths for Country

Select location, date, total_cases, CAST(total_deaths AS INT) as TotalDeaths, (CAST(total_deaths AS INT)/total_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeath
Where continent is not null
-- And location = 'indonesia' (Optional)
Order by 1, 2



-- Total cases & Total Deaths vs Population for Country

Select location, date, total_cases, CAST(total_deaths AS INT) as TotalDeaths, (total_cases/population)*100 as PercentPopulationInfected,
(CAST(total_deaths AS INT)/population)*100 as PercentPopulationDeath
From PortofolioProject..CovidDeath
Where continent is not null
-- And location = 'indonesia'
Order by 1, 2

Select location, MAX(Population) as Population, MAX(total_cases/population)*100 as PercentPopulationInfected, 
MAX(CAST(total_deaths AS INT)/population)*100 as PercentPopulationDeath
From PortofolioProject..CovidDeath
Where continent is not null
Group by location
Order by 3 desc



-- Total cases & Total Deaths vs Population for Region

Select location, Max(total_cases) as TotalCases, Max(cast(total_deaths as int)) as TotalDeaths, MAX(total_cases/population)*100 as PercentPopulationInfected, MAX(CAST(total_deaths AS INT)/population)*100 as PercentPopulationDeath
From PortofolioProject..CovidDeath
Where continent is null
Group by location
Having MAX(total_cases/population)*100 is not null
Order by 5 desc



-- Highest Cases and Deaths

Select location, Max(new_cases) as HighestNewCases, Max(CAST(new_deaths AS INT)) as HighestNewDeaths
From PortofolioProject..CovidDeath
Where continent is not null
Group by location
Order by 3 desc

Select location, Max(total_cases) as TotalCases, Max(CAST(total_deaths AS INT)) as TotalDeaths, Max(CAST(total_deaths AS INT))/ Max(total_cases)*100 as DeathRate
From PortofolioProject..CovidDeath
Where continent is not null
AND location <> 'North Korea'
Group by location
Order by 4 desc


-- Global Number

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortofolioProject..CovidDeath
Where continent is not null
Group by date
order by 1


-- Looking All Data CovidVaccination

Select*
From PortofolioProject..CovidVaccination
-- Where location = 'indonesia'
Order by 3, 4


-- Join CovidDeath & CovidVaccination

Select dea.continent, dea.location, dea.date, dea.population, CONVERT(int,vac.new_vaccinations) as NewVaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeath dea
Join PortofolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
And dea.location = 'indonesia'
And vac.new_vaccinations is not null
order by 2,3


-- USe CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeath dea
Join PortofolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

)
Select *, (RollingPeopleVaccinated/Population)*100 as PeopleVaccinationPercentage
From PopvsVac
Where Continent is not null
And Location = 'indonesia'
Order by 2, 3



Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProject..CovidDeath dea
Join PortofolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 