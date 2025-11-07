use WideWorldImporters
GO

CREATE SYNONYM Clientes FOR Sales.Customers
CREATE SYNONYM Categoria FOR Sales.CustomerCategories
CREATE SYNONYM Proveedor FOR Purchasing.Suppliers
CREATE SYNONYM Inventario FOR Warehouse.StockItems
CREATE SYNONYM Factura FOR Sales.Invoices
CREATE SYNONYM DetallesFactura FOR Sales.InvoiceLines
CREATE SYNONYM OrdenCompra FOR Purchasing.PurchaseOrders
go


CREATE DATABASE SJSucursal
CREATE DATABASE LimSucursal
CREATE DATABASE Corporativo
GO

USE SJSucursal
GO
)

CREATE TABLE Personas(
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
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO
CREATE TABLE GrupoCompra(
	BuyingGroupID int NOT NULL PRIMARY KEY,
	BuyingGroupName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
GO
CREATE TABLE CategoriaClientes(
	CustomerCategoryID int IDENTITY PRIMARY KEY NOT NULL,
	CustomerCategoryName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
CREATE TABLE Paises (
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
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE ProvinciaEstado(
	StateProvinceID int NOT NULL PRIMARY KEY,
	StateProvinceCode nvarchar(5) NOT NULL,
	StateProvinceName nvarchar(50) NOT NULL,
	CountryID int NOT NULL FOREIGN KEY REFERENCES Paises(CountryID),
	SalesTerritory nvarchar(50) NOT NULL,
	Border geography NULL,
	LatestRecordedPopulation bigint NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Ciudades (
	CityID int NOT NULL PRIMARY KEY,
	CityName nvarchar(50) NOT NULL,
	StateProvinceID int NOT NULL FOREIGN KEY REFERENCES ProvinciaEstado(StateProvinceID),
	Location geography NULL,
	LatestRecordedPopulation bigint NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE MetodoEntrega(
	DeliveryMethodID int NOT NULL PRIMARY KEY,
	DeliveryMethodName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Clientes (
	CustomerID int IDENTITY PRIMARY KEY NOT NULL, 
	CustomerCategoryID int NOT NULL FOREIGN KEY REFERENCES CategoriaClientes(CustomerCategoryID),
	BuyingGroupID int NULL FOREIGN KEY REFERENCES GrupoCompra(BuyingGroupID),
	DeliveryMethodID int NOT NULL FOREIGN KEY REFERENCES MetodoEntrega(DeliveryMethodID), 
	AccountOpenedDate date NOT NULL,
	StandardDiscountPercentage decimal(18, 3) NOT NULL,
	IsStatementSent bit NOT NULL,
	PaymentDays int NOT NULL,
	DeliveryRun nvarchar(5) NULL,
	RunPosition nvarchar(5) NULL, 
	WebsiteURL nvarchar(256) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
GO

CREATE TABLE CategoriaProveedores(
	SupplierCategoryID int NOT NULL PRIMARY KEY,
	SupplierCategoryName nvarchar(50) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Proveedores(
	SupplierID int NOT NULL PRIMARY KEY,
	SupplierName nvarchar(100) NOT NULL,
	SupplierCategoryID int NOT NULL FOREIGN KEY REFERENCES CategoriaProveedores(SupplierCategoryID),
	PrimaryContactPersonID int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	AlternateContactPersonID int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	DeliveryMethodID int NULL FOREIGN KEY REFERENCES MetodoEntrega(DeliveryMethodID),
	DeliveryCityID int NOT NULL FOREIGN KEY REFERENCES Ciudades(CityID),
	PostalCityID int NOT NULL FOREIGN KEY REFERENCES Ciudades(CityID),
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
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)

CREATE TABLE Colores(
	ColorID int NOT NULL PRIMARY KEY,
	ColorName nvarchar(20) NOT NULL,
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)

)

CREATE TABLE Productos (
	StockItemID int NOT NULL,
	StockItemName nvarchar(100) NOT NULL,
	SupplierID int NOT NULL FOREIGN KEY REFERENCES Proveedores(SupplierID),
	ColorID int NULL ,
	UnitPackageID int NOT NULL,
	OuterPackageID int NOT NULL,
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
	LastEditedBy int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)








USE Corporativo
GO

CREATE TABLE Clientes (
	CustomerID int IDENTITY PRIMARY KEY NOT NULL, 
	CustomerName nvarchar(100) NOT NULL , -- 
	BillToCustomerID int NOT NULL FOREIGN KEY REFERENCES Clientes(CustomerID), --
	PrimaryContactPersonID int NOT NULL FOREIGN KEY REFERENCES Personas(PersonID), --
	AlternateContactPersonID int NULL FOREIGN KEY REFERENCES Personas(PersonID), --
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
	PostalPostalCode nvarchar(10) NOT NULL, --


)
GO

-- POR SI ACASO
USE master
DROP DATABASE SJSucursal
DROP DATABASE LimSucursal
DROP DATABASE Corporativo