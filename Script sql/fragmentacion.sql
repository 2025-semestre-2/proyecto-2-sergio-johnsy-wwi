use WideWorldImporters
GO

CREATE DATABASE SJSucursal
CREATE DATABASE LimSucursal
CREATE DATABASE Corporativo
GO

USE SJSucursal
GO

CREATE SCHEMA Application
go
CREATE SCHEMA Purchasing
go
CREATE SCHEMA Sales
go
CREATE SCHEMA Warehouse



CREATE TABLE Application.People(
	PersonID int NOT NULL PRIMARY KEY IDENTITY,
	FullName nvarchar(50) NOT NULL,
	PreferredName nvarchar(50) NOT NULL,
	SearchName AS (concat(PreferredName, N' ', FullName)) PERSISTED NOT NULL,
	IsPermittedToLogon bit NOT NULL,
	LogonName nvarchar(50) NULL,
	IsExternalLogonProvider bit NOT NULL,
	HashedPassword varbinary(max) NULL,
	IsSystemUser bit NOT NULL,
	IsEmployee bit NOT NULL,
	IsSalesperson bit NOT NULL,
	UserPreferences nvarchar(max) NULL,
	PhoneNumber nvarchar(20) NULL,
	FaxNumber nvarchar(20) NULL,
	EmailAddress nvarchar(256) NULL,
	Photo varbinary(max) NULL,
	CustomFields nvarchar(max) NULL,
	OtherLanguages AS (json_query(CustomFields, N'$.OtherLanguages')),
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO
CREATE TABLE Sales.BuyingGroups(
	BuyingGroupID int NOT NULL PRIMARY KEY,
	BuyingGroupName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO
CREATE TABLE Sales.CustomerCategories(
	CustomerCategoryID int IDENTITY PRIMARY KEY NOT NULL,
	CustomerCategoryName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
CREATE TABLE Application.Countries (
	CountryID int NOT NULL PRIMARY KEY,
	CountryName nvarchar(60) NOT NULL,
	FormalName nvarchar(60) NOT NULL,
	IsoAlpha3Code nvarchar(3) NULL,
	IsoNumericCode int NULL,
	CountryType nvarchar(20) NULL,
	LatestRecordedPopulation bigint NULL,
	Continent nvarchar(30) NOT NULL,
	Region nvarchar(30) NOT NULL,
	Subregion nvarchar(30) NOT NULL,
	Border geography NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Application.StateProvinces(
	StateProvinceID int NOT NULL PRIMARY KEY,
	StateProvinceCode nvarchar(5) NOT NULL,
	StateProvinceName nvarchar(50) NOT NULL,
	CountryID int NOT NULL FOREIGN KEY REFERENCES Application.Countries(CountryID),
	SalesTerritory nvarchar(50) NOT NULL,
	Border geography NULL,
	LatestRecordedPopulation bigint NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Application.Cities (
	CityID int NOT NULL PRIMARY KEY,
	CityName nvarchar(50) NOT NULL,
	StateProvinceID int NOT NULL FOREIGN KEY REFERENCES Application.StateProvinces(StateProvinceID),
	Location geography NULL,
	LatestRecordedPopulation bigint NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Application.DeliveryMethods(
	DeliveryMethodID int NOT NULL PRIMARY KEY,
	DeliveryMethodName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

--Solo datos que no sean sensibles
CREATE TABLE Sales.Customers (
	CustomerID int IDENTITY PRIMARY KEY NOT NULL, 
	CustomerCategoryID int NOT NULL FOREIGN KEY REFERENCES Sales.CustomerCategories(CustomerCategoryID),
	BuyingGroupID int NULL FOREIGN KEY REFERENCES Sales.BuyingGroups(BuyingGroupID),
	DeliveryMethodID int NOT NULL FOREIGN KEY REFERENCES Application.DeliveryMethods(DeliveryMethodID), 
	AccountOpenedDate date NOT NULL,
	StandardDiscountPercentage decimal(18, 3) NOT NULL,
	IsStatementSent bit NOT NULL,
	PaymentDays int NOT NULL,
	DeliveryRun nvarchar(5) NULL,
	RunPosition nvarchar(5) NULL, 
	WebsiteURL nvarchar(256) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
GO

CREATE TABLE Purchasing.SupplierCategories(
	SupplierCategoryID int NOT NULL PRIMARY KEY,
	SupplierCategoryName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Purchasing.Suppliers(
	SupplierID int NOT NULL PRIMARY KEY,
	SupplierName nvarchar(100) NOT NULL,
	SupplierCategoryID int NOT NULL FOREIGN KEY REFERENCES Purchasing.SupplierCategories(SupplierCategoryID),
	PrimaryContactPersonID int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	AlternateContactPersonID int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	DeliveryMethodID int NULL FOREIGN KEY REFERENCES Application.DeliveryMethods(DeliveryMethodID),
	DeliveryCityID int NOT NULL FOREIGN KEY REFERENCES Application.Cities(CityID),
	PostalCityID int NOT NULL FOREIGN KEY REFERENCES Application.Cities(CityID),
	SupplierReference nvarchar(20) NULL,
	BankAccountName nvarchar(50) MASKED WITH (FUNCTION = 'default()') NULL,
	BankAccountBranch nvarchar(50) MASKED WITH (FUNCTION = 'default()') NULL,
	BankAccountCode nvarchar(20) MASKED WITH (FUNCTION = 'default()') NULL,
	BankAccountNumber nvarchar(20) MASKED WITH (FUNCTION = 'default()') NULL,
	BankInternationalCode nvarchar(20) MASKED WITH (FUNCTION = 'default()') NULL,
	PaymentDays int NOT NULL,
	InternalComments nvarchar(max) NULL,
	PhoneNumber nvarchar(20) NOT NULL,
	FaxNumber nvarchar(20) NOT NULL,
	WebsiteURL nvarchar(256) NOT NULL,
	DeliveryAddressLine1 nvarchar(60) NOT NULL,
	DeliveryAddressLine2 nvarchar(60) NULL,
	DeliveryPostalCode nvarchar(10) NOT NULL,
	DeliveryLocation geography NULL,
	PostalAddressLine1 nvarchar(60) NOT NULL,
	PostalAddressLine2 nvarchar(60) NULL,
	PostalPostalCode nvarchar(10) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Warehouse.Colors(
	ColorID int NOT NULL PRIMARY KEY,
	ColorName nvarchar(20) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Warehouse.PackageTypes(
	PackageTypeID int NOT NULL PRIMARY KEY,
	PackageTypeName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Warehouse.StockItems (
	StockItemID int NOT NULL PRIMARY KEY,
	StockItemName nvarchar(100) NOT NULL,
	SupplierID int NOT NULL FOREIGN KEY REFERENCES Purchasing.Suppliers(SupplierID),
	ColorID int NULL FOREIGN KEY REFERENCES Warehouse.Colors(ColorID),
	UnitPackageID int NOT NULL FOREIGN KEY REFERENCES Warehouse.PackageTypes(PackageTypeID),
	OuterPackageID int NOT NULL FOREIGN KEY REFERENCES Warehouse.PackageTypes(PackageTypeID),
	Brand nvarchar(50) NULL,
	Size nvarchar(20) NULL,
	LeadTimeDays int NOT NULL,
	QuantityPerOuter int NOT NULL,
	IsChillerStock bit NOT NULL,
	Barcode nvarchar(50) NULL,
	TaxRate decimal(18, 3) NOT NULL,
	UnitPrice decimal(18, 2) NOT NULL,
	RecommendedRetailPrice decimal(18, 2) NULL,
	TypicalWeightPerUnit decimal(18, 3) NOT NULL,
	MarketingComments nvarchar(max) NULL,
	InternalComments nvarchar(max) NULL,
	Photo varbinary(max) NULL,
	CustomFields nvarchar(max) NULL,
	Tags AS (json_query(CustomFields, N'$.Tags')),
	SearchDetails AS (concat(StockItemName, N' ', MarketingComments)),
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO

CREATE TABLE Warehouse.StockGroups (
    StockGroupID INT NOT NULL PRIMARY KEY,
    StockGroupName NVARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
    ValidFrom DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo DATETIME2(7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO

CREATE TABLE Warehouse.StockItemsStockGroups(
    StockItemStockGroupID INT NOT NULL PRIMARY KEY,
    StockItemID INT NOT NULL FOREIGN KEY REFERENCES Warehouse.StockItems(StockItemID),
    StockGroupID INT NOT NULL FOREIGN KEY REFERENCES Warehouse.StockGroups(StockGroupID),
    LastEditedBy INT NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
    LastEditedWhen DATETIME2(7) NOT NULL
)
GO

CREATE TABLE Warehouse.StockItemHoldings (
    StockItemID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Warehouse.StockItems(StockItemID),
    QuantityOnHand INT NOT NULL,
    BinLocation NVARCHAR(20) NOT NULL,
    LastStocktakeQuantity INT NOT NULL,
    LastCostPrice DECIMAL(18, 2) NOT NULL,
    ReorderLevel INT NOT NULL,
    TargetStockLevel INT NOT NULL,
    LastEditedBy INT NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
    LastEditedWhen DATETIME2(7) NOT NULL
)


CREATE TABLE Users(
	IDUser int IDENTITY PRIMARY KEY NOT NULL,
    Username NVARCHAR(50) NOT NULL ,
    HashedPassword VARBINARY(64) NULL,   
    FullName NVARCHAR(100) NOT NULL,
    Active BIT NOT NULL DEFAULT 1,
    Rol NVARCHAR(30) NOT NULL,
    Email NVARCHAR(100) NULL,
    HireDate DATE NOT NULL DEFAULT GETDATE()
)
GO



USE LimSucursal
GO
CREATE SCHEMA Application
go
CREATE SCHEMA Purchasing
go
CREATE SCHEMA Sales
go
CREATE SCHEMA Warehouse
go

CREATE TABLE Application.People(
	PersonID int NOT NULL PRIMARY KEY IDENTITY,
	FullName nvarchar(50) NOT NULL,
	PreferredName nvarchar(50) NOT NULL,
	SearchName AS (concat(PreferredName, N' ', FullName)) PERSISTED NOT NULL,
	IsPermittedToLogon bit NOT NULL,
	LogonName nvarchar(50) NULL,
	IsExternalLogonProvider bit NOT NULL,
	HashedPassword varbinary(max) NULL,
	IsSystemUser bit NOT NULL,
	IsEmployee bit NOT NULL,
	IsSalesperson bit NOT NULL,
	UserPreferences nvarchar(max) NULL,
	PhoneNumber nvarchar(20) NULL,
	FaxNumber nvarchar(20) NULL,
	EmailAddress nvarchar(256) NULL,
	Photo varbinary(max) NULL,
	CustomFields nvarchar(max) NULL,
	OtherLanguages AS (json_query(CustomFields, N'$.OtherLanguages')),
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO
CREATE TABLE Sales.BuyingGroups(
	BuyingGroupID int NOT NULL PRIMARY KEY,
	BuyingGroupName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO
CREATE TABLE Sales.CustomerCategories(
	CustomerCategoryID int IDENTITY PRIMARY KEY NOT NULL,
	CustomerCategoryName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
CREATE TABLE Application.Countries (
	CountryID int NOT NULL PRIMARY KEY,
	CountryName nvarchar(60) NOT NULL,
	FormalName nvarchar(60) NOT NULL,
	IsoAlpha3Code nvarchar(3) NULL,
	IsoNumericCode int NULL,
	CountryType nvarchar(20) NULL,
	LatestRecordedPopulation bigint NULL,
	Continent nvarchar(30) NOT NULL,
	Region nvarchar(30) NOT NULL,
	Subregion nvarchar(30) NOT NULL,
	Border geography NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Application.StateProvinces(
	StateProvinceID int NOT NULL PRIMARY KEY,
	StateProvinceCode nvarchar(5) NOT NULL,
	StateProvinceName nvarchar(50) NOT NULL,
	CountryID int NOT NULL FOREIGN KEY REFERENCES Application.Countries(CountryID),
	SalesTerritory nvarchar(50) NOT NULL,
	Border geography NULL,
	LatestRecordedPopulation bigint NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Application.Cities (
	CityID int NOT NULL PRIMARY KEY,
	CityName nvarchar(50) NOT NULL,
	StateProvinceID int NOT NULL FOREIGN KEY REFERENCES Application.StateProvinces(StateProvinceID),
	Location geography NULL,
	LatestRecordedPopulation bigint NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Application.DeliveryMethods(
	DeliveryMethodID int NOT NULL PRIMARY KEY,
	DeliveryMethodName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

--Solo datos que no sean sensibles
CREATE TABLE Sales.Customers (
	CustomerID int IDENTITY PRIMARY KEY NOT NULL, 
	CustomerCategoryID int NOT NULL FOREIGN KEY REFERENCES Sales.CustomerCategories(CustomerCategoryID),
	BuyingGroupID int NULL FOREIGN KEY REFERENCES Sales.BuyingGroups(BuyingGroupID),
	DeliveryMethodID int NOT NULL FOREIGN KEY REFERENCES Application.DeliveryMethods(DeliveryMethodID), 
	AccountOpenedDate date NOT NULL,
	StandardDiscountPercentage decimal(18, 3) NOT NULL,
	IsStatementSent bit NOT NULL,
	PaymentDays int NOT NULL,
	DeliveryRun nvarchar(5) NULL,
	RunPosition nvarchar(5) NULL, 
	WebsiteURL nvarchar(256) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
GO

CREATE TABLE Purchasing.SupplierCategories(
	SupplierCategoryID int NOT NULL PRIMARY KEY,
	SupplierCategoryName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Purchasing.Suppliers(
	SupplierID int NOT NULL PRIMARY KEY,
	SupplierName nvarchar(100) NOT NULL,
	SupplierCategoryID int NOT NULL FOREIGN KEY REFERENCES Purchasing.SupplierCategories(SupplierCategoryID),
	PrimaryContactPersonID int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	AlternateContactPersonID int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	DeliveryMethodID int NULL FOREIGN KEY REFERENCES Application.DeliveryMethods(DeliveryMethodID),
	DeliveryCityID int NOT NULL FOREIGN KEY REFERENCES Application.Cities(CityID),
	PostalCityID int NOT NULL FOREIGN KEY REFERENCES Application.Cities(CityID),
	SupplierReference nvarchar(20) NULL,
	BankAccountName nvarchar(50) MASKED WITH (FUNCTION = 'default()') NULL,
	BankAccountBranch nvarchar(50) MASKED WITH (FUNCTION = 'default()') NULL,
	BankAccountCode nvarchar(20) MASKED WITH (FUNCTION = 'default()') NULL,
	BankAccountNumber nvarchar(20) MASKED WITH (FUNCTION = 'default()') NULL,
	BankInternationalCode nvarchar(20) MASKED WITH (FUNCTION = 'default()') NULL,
	PaymentDays int NOT NULL,
	InternalComments nvarchar(max) NULL,
	PhoneNumber nvarchar(20) NOT NULL,
	FaxNumber nvarchar(20) NOT NULL,
	WebsiteURL nvarchar(256) NOT NULL,
	DeliveryAddressLine1 nvarchar(60) NOT NULL,
	DeliveryAddressLine2 nvarchar(60) NULL,
	DeliveryPostalCode nvarchar(10) NOT NULL,
	DeliveryLocation geography NULL,
	PostalAddressLine1 nvarchar(60) NOT NULL,
	PostalAddressLine2 nvarchar(60) NULL,
	PostalPostalCode nvarchar(10) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Warehouse.Colors(
	ColorID int NOT NULL PRIMARY KEY,
	ColorName nvarchar(20) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Warehouse.PackageTypes(
	PackageTypeID int NOT NULL PRIMARY KEY,
	PackageTypeName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Warehouse.StockItems (
	StockItemID int NOT NULL PRIMARY KEY,
	StockItemName nvarchar(100) NOT NULL,
	SupplierID int NOT NULL FOREIGN KEY REFERENCES Purchasing.Suppliers(SupplierID),
	ColorID int NULL FOREIGN KEY REFERENCES Warehouse.Colors(ColorID),
	UnitPackageID int NOT NULL FOREIGN KEY REFERENCES Warehouse.PackageTypes(PackageTypeID),
	OuterPackageID int NOT NULL FOREIGN KEY REFERENCES Warehouse.PackageTypes(PackageTypeID),
	Brand nvarchar(50) NULL,
	Size nvarchar(20) NULL,
	LeadTimeDays int NOT NULL,
	QuantityPerOuter int NOT NULL,
	IsChillerStock bit NOT NULL,
	Barcode nvarchar(50) NULL,
	TaxRate decimal(18, 3) NOT NULL,
	UnitPrice decimal(18, 2) NOT NULL,
	RecommendedRetailPrice decimal(18, 2) NULL,
	TypicalWeightPerUnit decimal(18, 3) NOT NULL,
	MarketingComments nvarchar(max) NULL,
	InternalComments nvarchar(max) NULL,
	Photo varbinary(max) NULL,
	CustomFields nvarchar(max) NULL,
	Tags AS (json_query(CustomFields, N'$.Tags')),
	SearchDetails AS (concat(StockItemName, N' ', MarketingComments)),
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO

CREATE TABLE Warehouse.StockGroups (
    StockGroupID INT NOT NULL PRIMARY KEY,
    StockGroupName NVARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
    ValidFrom DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo DATETIME2(7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO

CREATE TABLE Warehouse.StockGroupsProducto(
    StockItemStockGroupID INT NOT NULL PRIMARY KEY,
    StockItemID INT NOT NULL FOREIGN KEY REFERENCES Warehouse.StockItems(StockItemID),
    StockGroupID INT NOT NULL FOREIGN KEY REFERENCES Warehouse.StockGroups(StockGroupID),
    LastEditedBy INT NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
    LastEditedWhen DATETIME2(7) NOT NULL
)
GO

CREATE TABLE Warehouse.StockItemHoldings (
    StockItemID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Warehouse.StockItems(StockItemID),
    QuantityOnHand INT NOT NULL,
    BinLocation NVARCHAR(20) NOT NULL,
    LastStocktakeQuantity INT NOT NULL,
    LastCostPrice DECIMAL(18, 2) NOT NULL,
    ReorderLevel INT NOT NULL,
    TargetStockLevel INT NOT NULL,
    LastEditedBy INT NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
    LastEditedWhen DATETIME2(7) NOT NULL
)


CREATE TABLE Users(
	IDUser int IDENTITY PRIMARY KEY NOT NULL,
    Username NVARCHAR(50) NOT NULL ,
    HashedPassword VARBINARY(64) NULL,   
    FullName NVARCHAR(100) NOT NULL,
    Active BIT NOT NULL DEFAULT 1,
    Rol NVARCHAR(30) NOT NULL,
    Email NVARCHAR(100) NULL,
    HireDate DATE NOT NULL DEFAULT GETDATE()
)
GO



USE Corporativo
GO


CREATE SCHEMA Application
go
CREATE SCHEMA Purchasing
go
CREATE SCHEMA Sales
go
CREATE SCHEMA Warehouse


CREATE TABLE Application.People(
	PersonID int NOT NULL PRIMARY KEY IDENTITY,
	FullName nvarchar(50) NOT NULL,
	PreferredName nvarchar(50) NOT NULL,
	SearchName AS (concat(PreferredName, N' ', FullName)) PERSISTED NOT NULL,
	IsPermittedToLogon bit NOT NULL,
	LogonName nvarchar(50) NULL,
	IsExternalLogonProvider bit NOT NULL,
	HashedPassword varbinary(max) NULL,
	IsSystemUser bit NOT NULL,
	IsEmployee bit NOT NULL,
	IsSalesperson bit NOT NULL,
	UserPreferences nvarchar(max) NULL,
	PhoneNumber nvarchar(20) NULL,
	FaxNumber nvarchar(20) NULL,
	EmailAddress nvarchar(256) NULL,
	Photo varbinary(max) NULL,
	CustomFields nvarchar(max) NULL,
	OtherLanguages AS (json_query(CustomFields, N'$.OtherLanguages')),
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO
CREATE TABLE Sales.BuyingGroups(
	BuyingGroupID int NOT NULL PRIMARY KEY,
	BuyingGroupName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO
CREATE TABLE Sales.CustomerCategories(
	CustomerCategoryID int IDENTITY PRIMARY KEY NOT NULL,
	CustomerCategoryName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
CREATE TABLE Application.Countries (
	CountryID int NOT NULL PRIMARY KEY,
	CountryName nvarchar(60) NOT NULL,
	FormalName nvarchar(60) NOT NULL,
	IsoAlpha3Code nvarchar(3) NULL,
	IsoNumericCode int NULL,
	CountryType nvarchar(20) NULL,
	LatestRecordedPopulation bigint NULL,
	Continent nvarchar(30) NOT NULL,
	Region nvarchar(30) NOT NULL,
	Subregion nvarchar(30) NOT NULL,
	Border geography NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Application.StateProvinces(
	StateProvinceID int NOT NULL PRIMARY KEY,
	StateProvinceCode nvarchar(5) NOT NULL,
	StateProvinceName nvarchar(50) NOT NULL,
	CountryID int NOT NULL FOREIGN KEY REFERENCES Application.Countries(CountryID),
	SalesTerritory nvarchar(50) NOT NULL,
	Border geography NULL,
	LatestRecordedPopulation bigint NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Application.Cities (
	CityID int NOT NULL PRIMARY KEY,
	CityName nvarchar(50) NOT NULL,
	StateProvinceID int NOT NULL FOREIGN KEY REFERENCES Application.StateProvinces(StateProvinceID),
	Location geography NULL,
	LatestRecordedPopulation bigint NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Application.DeliveryMethods(
	DeliveryMethodID int NOT NULL PRIMARY KEY,
	DeliveryMethodName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

-- los datos sensibles van aqui
CREATE TABLE Sales.Customers (
	CustomerID int IDENTITY PRIMARY KEY NOT NULL, 
	CustomerName nvarchar(100) NOT NULL , -- 
	BillToCustomerID int NOT NULL FOREIGN KEY REFERENCES Sales.Customers(CustomerID), --
	PrimaryContactPersonID int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID), --
	AlternateContactPersonID int NULL FOREIGN KEY REFERENCES Application.People(PersonID), --
	DeliveryCityID int NOT NULL, --
	PostalCityID int NOT NULL, --
	CreditLimit decimal(18, 2) NULL, --
	IsOnCreditHold bit NOT NULL, --
	PhoneNumber nvarchar(20) NOT NULL, --
	FaxNumber nvarchar(20) NOT NULL, --
	DeliveryAddressLine1 nvarchar(60) NOT NULL, --
	DeliveryAddressLine2 nvarchar(60) NULL, --
	DeliveryPostalCode nvarchar(10) NOT NULL, --
	DeliveryLocation geography NULL, --
	PostalAddressLine1 nvarchar(60) NOT NULL, --
	PostalAddressLine2 nvarchar(60) NULL, --
	PostalPostalCode nvarchar(10) NOT NULL, --<
)
GO

CREATE TABLE Purchasing.SupplierCategories(
	SupplierCategoryID int NOT NULL PRIMARY KEY,
	SupplierCategoryName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Purchasing.Suppliers(
	SupplierID int NOT NULL PRIMARY KEY,
	SupplierName nvarchar(100) NOT NULL,
	SupplierCategoryID int NOT NULL FOREIGN KEY REFERENCES Purchasing.SupplierCategories(SupplierCategoryID),
	PrimaryContactPersonID int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	AlternateContactPersonID int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	DeliveryMethodID int NULL FOREIGN KEY REFERENCES Application.DeliveryMethods(DeliveryMethodID),
	DeliveryCityID int NOT NULL FOREIGN KEY REFERENCES Application.Cities(CityID),
	PostalCityID int NOT NULL FOREIGN KEY REFERENCES Application.Cities(CityID),
	SupplierReference nvarchar(20) NULL,
	BankAccountName nvarchar(50) MASKED WITH (FUNCTION = 'default()') NULL,
	BankAccountBranch nvarchar(50) MASKED WITH (FUNCTION = 'default()') NULL,
	BankAccountCode nvarchar(20) MASKED WITH (FUNCTION = 'default()') NULL,
	BankAccountNumber nvarchar(20) MASKED WITH (FUNCTION = 'default()') NULL,
	BankInternationalCode nvarchar(20) MASKED WITH (FUNCTION = 'default()') NULL,
	PaymentDays int NOT NULL,
	InternalComments nvarchar(max) NULL,
	PhoneNumber nvarchar(20) NOT NULL,
	FaxNumber nvarchar(20) NOT NULL,
	WebsiteURL nvarchar(256) NOT NULL,
	DeliveryAddressLine1 nvarchar(60) NOT NULL,
	DeliveryAddressLine2 nvarchar(60) NULL,
	DeliveryPostalCode nvarchar(10) NOT NULL,
	DeliveryLocation geography NULL,
	PostalAddressLine1 nvarchar(60) NOT NULL,
	PostalAddressLine2 nvarchar(60) NULL,
	PostalPostalCode nvarchar(10) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Warehouse.Colors(
	ColorID int NOT NULL PRIMARY KEY,
	ColorName nvarchar(20) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Warehouse.PackageTypes(
	PackageTypeID int NOT NULL PRIMARY KEY,
	PackageTypeName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Warehouse.StockItems (
	StockItemID int NOT NULL PRIMARY KEY,
	StockItemName nvarchar(100) NOT NULL,
	SupplierID int NOT NULL FOREIGN KEY REFERENCES Purchasing.Suppliers(SupplierID),
	ColorID int NULL FOREIGN KEY REFERENCES Warehouse.Colors(ColorID),
	UnitPackageID int NOT NULL FOREIGN KEY REFERENCES Warehouse.PackageTypes(PackageTypeID),
	OuterPackageID int NOT NULL FOREIGN KEY REFERENCES Warehouse.PackageTypes(PackageTypeID),
	Brand nvarchar(50) NULL,
	Size nvarchar(20) NULL,
	LeadTimeDays int NOT NULL,
	QuantityPerOuter int NOT NULL,
	IsChillerStock bit NOT NULL,
	Barcode nvarchar(50) NULL,
	TaxRate decimal(18, 3) NOT NULL,
	UnitPrice decimal(18, 2) NOT NULL,
	RecommendedRetailPrice decimal(18, 2) NULL,
	TypicalWeightPerUnit decimal(18, 3) NOT NULL,
	MarketingComments nvarchar(max) NULL,
	InternalComments nvarchar(max) NULL,
	Photo varbinary(max) NULL,
	CustomFields nvarchar(max) NULL,
	Tags AS (json_query(CustomFields, N'$.Tags')),
	SearchDetails AS (concat(StockItemName, N' ', MarketingComments)),
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO

CREATE TABLE Warehouse.StockGroups (
    StockGroupID INT NOT NULL PRIMARY KEY,
    StockGroupName NVARCHAR(50) NOT NULL,
    LastEditedBy INT NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
    ValidFrom DATETIME2(7) GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo DATETIME2(7) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO

CREATE TABLE Warehouse.StockGroupsProducto(
    StockItemStockGroupID INT NOT NULL PRIMARY KEY,
    StockItemID INT NOT NULL FOREIGN KEY REFERENCES Warehouse.StockItems(StockItemID),
    StockGroupID INT NOT NULL FOREIGN KEY REFERENCES Warehouse.StockGroups(StockGroupID),
    LastEditedBy INT NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
    LastEditedWhen DATETIME2(7) NOT NULL
)
GO

CREATE TABLE Warehouse.StockItemHoldings (
    StockItemID INT NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Warehouse.StockItems(StockItemID),
    QuantityOnHand INT NOT NULL,
    BinLocation NVARCHAR(20) NOT NULL,
    LastStocktakeQuantity INT NOT NULL,
    LastCostPrice DECIMAL(18, 2) NOT NULL,
    ReorderLevel INT NOT NULL,
    TargetStockLevel INT NOT NULL,
    LastEditedBy INT NOT NULL FOREIGN KEY REFERENCES Application.People(PersonID),
    LastEditedWhen DATETIME2(7) NOT NULL
)


CREATE TABLE Users(
	IdUser int IDENTITY PRIMARY KEY NOT NULL,
    Username NVARCHAR(50) NOT NULL ,
    HashedPassword VARBINARY(64) NULL,   
    FullName NVARCHAR(100) NOT NULL,
    Active BIT NOT NULL DEFAULT 1,
    Rol NVARCHAR(30) NOT NULL,
    Email NVARCHAR(100) NULL,
    HireDate DATE NOT NULL DEFAULT GETDATE()
)


-- POR SI ACASO
USE master
DROP DATABASE SJSucursal
DROP DATABASE LimSucursal
DROP DATABASE Corporativo