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
	[BuyingGroupID] [int] NOT NULL PRIMARY KEY,
	[BuyingGroupName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL FOREIGN KEY REFERENCES Personas(PersonID),
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
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

CREATE TABLE Clientes (
	CustomerID int IDENTITY PRIMARY KEY NOT NULL,
	CustomerName nvarchar(100) NOT NULL,
	BillToCustomerID int NOT NULL FOREIGN KEY REFERENCES Clientes(CustomerID),
	CustomerCategoryID int NOT NULL FOREIGN KEY REFERENCES CategoriaClientes(CustomerCategoryID),
	BuyingGroupID int NULL ,
	PrimaryContactPersonID int NOT NULL,
	AlternateContactPersonID int NULL,
	DeliveryMethodID int NOT NULL,
	DeliveryCityID int NOT NULL,
	PostalCityID int NOT NULL,
	CreditLimit decimal(18, 2) NULL,
	AccountOpenedDate date NOT NULL,
	StandardDiscountPercentage decimal(18, 3) NOT NULL,
	IsStatementSent bit NOT NULL,
	IsOnCreditHold bit NOT NULL,
	PaymentDays int NOT NULL,
	PhoneNumber nvarchar(20) NOT NULL,
	FaxNumber nvarchar(20) NOT NULL,
	DeliveryRun nvarchar(5) NULL,
	RunPosition nvarchar(5) NULL,
	WebsiteURL nvarchar(256) NOT NULL,
	DeliveryAddressLine1 nvarchar(60) NOT NULL,
	DeliveryAddressLine2 nvarchar(60) NULL,
	DeliveryPostalCode nvarchar(10) NOT NULL,
	DeliveryLocation geography NULL,
	PostalAddressLine1 nvarchar(60) NOT NULL,
	PostalAddressLine2 nvarchar(60) NULL,
	PostalPostalCode nvarchar(10) NOT NULL,
	LastEditedBy int NOT NULL,
	ValidFrom datetime2(7) GENERATED ALWAYS AS ROW START NOT NULL,
	ValidTo datetime2(7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])

)
GO




-- POR SI ACASO
USE master
DROP DATABASE SJSucursal
DROP DATABASE LimSucursal
DROP DATABASE Corporativo