use WideWorldImporters;


-- Crear datos necesarios
INSERT INTO [WideWorldImporters].[Application].[StateProvinces] 
    ([StateProvinceCode], [StateProvinceName], [CountryID], [SalesTerritory], [Border], [LatestRecordedPopulation], [LastEditedBy])
VALUES
    ('SJ', 'San José', 51, 'Central', NULL, 340000, 1),
    ('AL', 'Alajuela', 51, 'Central', NULL, 250000, 1),
    ('CR', 'Cartago', 51, 'Central', NULL, 200000, 1),
    ('HE', 'Heredia', 51, 'Central', NULL, 180000, 1),
    ('GU', 'Guanacaste', 51, 'North Pacific', NULL, 150000, 1),
    ('PU', 'Puntarenas', 51, 'South Pacific', NULL, 130000, 1),
    ('LI', 'Limón', 51, 'Caribbean', NULL, 120000, 1);
GO

CREATE TABLE #TempCities (
    OBJECTID INT,
    POBLAC_ INT,
    PROVINCIA NVARCHAR(50),
    CANTON NVARCHAR(50),
    PUEBLO NVARCHAR(50),
    POBLAC_ID INT,
    x FLOAT,
    y FLOAT,
	Latitude FLOAT,
    Longitude FLOAT
);

BULK INSERT #TempCities
FROM '/var/opt/mssql/data/Poblados_de_Costa_Rica.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


SELECT * FROM #TempCities

BEGIN TRANSACTION;

ALTER TABLE [Sales].[Customers] NOCHECK CONSTRAINT FK_Sales_Customers_DeliveryCityID_Application_Cities;
ALTER TABLE [Sales].[Customers] NOCHECK CONSTRAINT FK_Sales_Customers_PostalCityID_Application_Cities;

DELETE FROM [Application].[Cities]
WHERE CityID BETWEEN 1 AND 2258;

INSERT INTO [Application].[Cities] (CityID, CityName, StateProvinceID, LatestRecordedPopulation, Location, LastEditedBy)
SELECT OBJECTID,
       PUEBLO,
       CASE PROVINCIA
            WHEN 'SAN JOSE' THEN 54
            WHEN 'ALAJUELA' THEN 55
            WHEN 'CARTAGO' THEN 56
            WHEN 'HEREDIA' THEN 57
            WHEN 'GUANACASTE' THEN 58
            WHEN 'PUNTARENAS' THEN 59
            WHEN 'LIMON' THEN 60
       END,
       POBLAC_,
       geography::Point(Latitude, Longitude, 4326),
       1
FROM #TempCities;

ALTER TABLE [Sales].[Customers] WITH CHECK CHECK CONSTRAINT FK_Sales_Customers_DeliveryCityID_Application_Cities;
ALTER TABLE [Sales].[Customers] WITH CHECK CHECK CONSTRAINT FK_Sales_Customers_PostalCityID_Application_Cities;

COMMIT TRANSACTION;



-- Poner algunas tildes
BEGIN TRANSACTION;

UPDATE [Application].[Cities]
SET CityName = CASE CityName
    WHEN 'San Jose' THEN 'San José'
    WHEN 'Limon' THEN 'Limón'
    WHEN 'Escazu' THEN 'Escazú'
    WHEN 'Guapiles' THEN 'Guápiles'
    WHEN 'Pococi' THEN 'Pococí'
    ELSE CityName
END
WHERE CityName IN ('San Jose', 'Limon', 'Escazu', 'Guapiles', 'Pococi');

COMMIT TRANSACTION;



-- Reasignar direcciones de clientes
DECLARE @startCR INT = 1816;
DECLARE @endCR INT = 2020;

DECLARE @totalClientes INT;
SELECT @totalClientes = COUNT(*) FROM Sales.Customers;

DECLARE @totalCiudadesCR INT = @endCR - @startCR + 1;
DECLARE @clientesPorCiudad INT = 2;
DECLARE @maxClientesCR INT = @totalCiudadesCR * @clientesPorCiudad;

-- Asignar IDs de provincia Limón
;WITH Numerados AS (
    SELECT 
        CustomerID,
        ROW_NUMBER() OVER (ORDER BY CustomerID) AS rn
    FROM Sales.Customers
)
UPDATE c
SET 
    c.DeliveryCityID = @startCR + ((n.rn - 1) / @clientesPorCiudad),
    c.PostalCityID = @startCR + ((n.rn - 1) / @clientesPorCiudad),
    c.DeliveryAddressLine1 = sp.StateProvinceName + ', ' + city.CityName,
    c.DeliveryLocation = city.Location
FROM Sales.Customers c
JOIN Numerados n ON c.CustomerID = n.CustomerID
JOIN Application.Cities city ON city.CityID = @startCR + ((n.rn - 1) / @clientesPorCiudad)
JOIN Application.StateProvinces sp ON city.StateProvinceID = sp.StateProvinceID
WHERE n.rn <= @maxClientesCR;

-- Asignar el resto de clientes (desde 1 con SJ)
;WITH Numerados2 AS (
    SELECT 
        CustomerID,
        ROW_NUMBER() OVER (ORDER BY CustomerID) AS rn
    FROM Sales.Customers
)
UPDATE c
SET 
    c.DeliveryCityID = ((n.rn - @maxClientesCR - 1) % @startCR) + 1,
    c.PostalCityID = ((n.rn - @maxClientesCR - 1) % @startCR) + 1,
    c.DeliveryAddressLine1 = sp.StateProvinceName + ', ' + city.CityName,
    c.DeliveryLocation = city.Location
FROM Sales.Customers c
JOIN Numerados2 n ON c.CustomerID = n.CustomerID
JOIN Application.Cities city ON city.CityID = ((n.rn - @maxClientesCR - 1) % @startCR) + 1
JOIN Application.StateProvinces sp ON city.StateProvinceID = sp.StateProvinceID
WHERE n.rn > @maxClientesCR;
