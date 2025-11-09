-- Migrar datos de WideWorldImporters a Corporativo
USE master;
GO

-- Crear campos faltantes para la migración
ALTER TABLE [WideWorldImporters].[Sales].[Invoices]
ADD [Branch] NVARCHAR(10) NOT NULL DEFAULT 'SJ';
GO

ALTER TABLE [WideWorldImporters].[Warehouse].[StockItemHoldings]
ADD [Branch] NVARCHAR(10) NOT NULL DEFAULT 'SJ';
GO

-- Establecer algunas facturas en Limón
UPDATE [WideWorldImporters].[Sales].[Invoices]
SET Branch = 'LI'
WHERE CustomerID BETWEEN 1 AND 808;
GO

-- Establecer algunos inventarios en Limón
UPDATE [WideWorldImporters].[Warehouse].[StockItemHoldings]
SET Branch = 'LI'
WHERE StockItemID BETWEEN 1 AND 100;
GO


-- Application.People
SET IDENTITY_INSERT Corporativo.Application.People ON;
INSERT INTO Corporativo.Application.People (
    PersonID, FullName, PreferredName, IsPermittedToLogon, LogonName, 
    IsExternalLogonProvider, HashedPassword, IsSystemUser, IsEmployee, 
    IsSalesperson, UserPreferences, PhoneNumber, FaxNumber, EmailAddress, 
    Photo, CustomFields, LastEditedBy
)
SELECT 
    PersonID, FullName, PreferredName, IsPermittedToLogon, LogonName,
    IsExternalLogonProvider, HashedPassword, IsSystemUser, IsEmployee,
    IsSalesperson, UserPreferences, PhoneNumber, FaxNumber, EmailAddress,
    Photo, CustomFields, LastEditedBy
FROM WideWorldImporters.Application.People;
SET IDENTITY_INSERT Corporativo.Application.People OFF;
GO


-- Application.Countries
SET IDENTITY_INSERT Corporativo.Application.Countries ON;
INSERT INTO Corporativo.Application.Countries (
    CountryID, CountryName, FormalName, IsoAlpha3Code, IsoNumericCode,
    CountryType, LatestRecordedPopulation, Continent, Region, Subregion,
    Border, LastEditedBy
)
SELECT
    CountryID, CountryName, FormalName, IsoAlpha3Code, IsoNumericCode,
    CountryType, LatestRecordedPopulation, Continent, Region, Subregion,
    Border, LastEditedBy
FROM WideWorldImporters.Application.Countries;
SET IDENTITY_INSERT Corporativo.Application.Countries OFF;
GO


-- Application.StateProvinces
SET IDENTITY_INSERT Corporativo.Application.StateProvinces ON;
INSERT INTO Corporativo.Application.StateProvinces (
    StateProvinceID, StateProvinceCode, StateProvinceName, CountryID, 
    SalesTerritory, Border, LatestRecordedPopulation, LastEditedBy
)
SELECT 
    StateProvinceID, StateProvinceCode, StateProvinceName, CountryID, 
    SalesTerritory, Border, LatestRecordedPopulation, LastEditedBy
FROM WideWorldImporters.Application.StateProvinces;
SET IDENTITY_INSERT Corporativo.Application.StateProvinces OFF;
GO


-- Application.Cities
SET IDENTITY_INSERT Corporativo.Application.Cities ON;
INSERT INTO Corporativo.Application.Cities (
    CityID, CityName, StateProvinceID, [Location],
    LatestRecordedPopulation, LastEditedBy
)
SELECT
    CityID, CityName, StateProvinceID, [Location],
    LatestRecordedPopulation, LastEditedBy
FROM WideWorldImporters.Application.Cities;
SET IDENTITY_INSERT Corporativo.Application.Cities OFF;
GO


-- Application.DeliveryMethods
SET IDENTITY_INSERT Corporativo.Application.DeliveryMethods ON;
INSERT INTO Corporativo.Application.DeliveryMethods (
    DeliveryMethodID, DeliveryMethodName, LastEditedBy
)
SELECT
    DeliveryMethodID, DeliveryMethodName, LastEditedBy
FROM WideWorldImporters.Application.DeliveryMethods;
SET IDENTITY_INSERT Corporativo.Application.DeliveryMethods OFF;
GO


-- Sales.CustomerCategories
SET IDENTITY_INSERT Corporativo.Sales.CustomerCategories ON;
INSERT INTO Corporativo.Sales.CustomerCategories (
    CustomerCategoryID, CustomerCategoryName, LastEditedBy
)
SELECT 
    CustomerCategoryID, CustomerCategoryName, LastEditedBy
FROM WideWorldImporters.Sales.CustomerCategories;
SET IDENTITY_INSERT Corporativo.Sales.CustomerCategories OFF;
GO


-- Sales.BuyingGroups
SET IDENTITY_INSERT Corporativo.Sales.BuyingGroups ON;
INSERT INTO Corporativo.Sales.BuyingGroups (
    BuyingGroupID, BuyingGroupName, LastEditedBy
)
SELECT 
    BuyingGroupID, BuyingGroupName, LastEditedBy
FROM WideWorldImporters.Sales.BuyingGroups;
SET IDENTITY_INSERT Corporativo.Sales.BuyingGroups OFF;
GO


-- Customers (SE FRAGMENTA CON DATOS SENSIBLES)
-- Sales.Customers
SET IDENTITY_INSERT Corporativo.Sales.Customers ON;
INSERT INTO Corporativo.Sales.Customers (
    CustomerID, CustomerName, BillToCustomerID, PrimaryContactPersonID, 
    AlternateContactPersonID, DeliveryCityID, PostalCityID, 
    CreditLimit, IsOnCreditHold, PhoneNumber, FaxNumber, 
    DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, 
    DeliveryLocation, PostalAddressLine1, PostalAddressLine2, PostalPostalCode
)
SELECT
    CustomerID, CustomerName, BillToCustomerID, PrimaryContactPersonID, 
    AlternateContactPersonID, DeliveryCityID, PostalCityID, 
    CreditLimit, IsOnCreditHold, PhoneNumber, FaxNumber, 
    DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, 
    DeliveryLocation, PostalAddressLine1, PostalAddressLine2, PostalPostalCode
FROM WideWorldImporters.Sales.Customers;
SET IDENTITY_INSERT Corporativo.Sales.Customers OFF;
GO


-- Purchasing.SupplierCategories
SET IDENTITY_INSERT Corporativo.Purchasing.SupplierCategories ON;
INSERT INTO Corporativo.Purchasing.SupplierCategories (
    SupplierCategoryID, SupplierCategoryName, LastEditedBy
)
SELECT
    SupplierCategoryID, SupplierCategoryName, LastEditedBy
FROM WideWorldImporters.Purchasing.SupplierCategories;
SET IDENTITY_INSERT Corporativo.Purchasing.SupplierCategories OFF;
GO


-- Purchasing.Suppliers
SET IDENTITY_INSERT Corporativo.Purchasing.Suppliers ON;
INSERT INTO Corporativo.Purchasing.Suppliers (
    SupplierID, SupplierName, SupplierCategoryID, PrimaryContactPersonID, AlternateContactPersonID,
    DeliveryMethodID, DeliveryCityID, PostalCityID, SupplierReference,
    BankAccountName, BankAccountBranch, BankAccountCode, BankAccountNumber, BankInternationalCode,
    PaymentDays, InternalComments, PhoneNumber, FaxNumber, WebsiteURL,
    DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation,
    PostalAddressLine1, PostalAddressLine2, PostalPostalCode,
    LastEditedBy
)
SELECT
    SupplierID, SupplierName, SupplierCategoryID, PrimaryContactPersonID, AlternateContactPersonID,
    DeliveryMethodID, DeliveryCityID, PostalCityID, SupplierReference,
    BankAccountName, BankAccountBranch, BankAccountCode, BankAccountNumber, BankInternationalCode,
    PaymentDays, InternalComments, PhoneNumber, FaxNumber, WebsiteURL,
    DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation,
    PostalAddressLine1, PostalAddressLine2, PostalPostalCode,
    LastEditedBy
FROM WideWorldImporters.Purchasing.Suppliers;
SET IDENTITY_INSERT Corporativo.Purchasing.Suppliers OFF;
GO


-- Warehouse.Colors
SET IDENTITY_INSERT Corporativo.Warehouse.Colors ON;
INSERT INTO Corporativo.Warehouse.Colors (
    ColorID, ColorName, LastEditedBy
)
SELECT
    ColorID, ColorName, LastEditedBy
FROM WideWorldImporters.Warehouse.Colors;
SET IDENTITY_INSERT Corporativo.Warehouse.Colors OFF;
GO


-- Warehouse.PackageTypes
SET IDENTITY_INSERT Corporativo.Warehouse.PackageTypes ON;
INSERT INTO Corporativo.Warehouse.PackageTypes (
    PackageTypeID, PackageTypeName, LastEditedBy
)
SELECT
    PackageTypeID, PackageTypeName, LastEditedBy
FROM WideWorldImporters.Warehouse.PackageTypes;
SET IDENTITY_INSERT Corporativo.Warehouse.PackageTypes OFF;
GO


-- Warehouse.StockGroups
SET IDENTITY_INSERT Corporativo.Warehouse.StockGroups ON;
INSERT INTO Corporativo.Warehouse.StockGroups (
    StockGroupID, StockGroupName, LastEditedBy
)
SELECT
    StockGroupID, StockGroupName, LastEditedBy
FROM WideWorldImporters.Warehouse.StockGroups;
SET IDENTITY_INSERT Corporativo.Warehouse.StockGroups OFF;
GO


-- Warehouse.StockItems
SET IDENTITY_INSERT Corporativo.Warehouse.StockItems ON;
INSERT INTO Corporativo.Warehouse.StockItems (
    StockItemID, StockItemName, SupplierID, ColorID, UnitPackageID, OuterPackageID,
    Brand, Size, LeadTimeDays, QuantityPerOuter, IsChillerStock, Barcode,
    TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit,
    MarketingComments, InternalComments, Photo, CustomFields,
    LastEditedBy
)
SELECT
    StockItemID, StockItemName, SupplierID, ColorID, UnitPackageID, OuterPackageID,
    Brand, Size, LeadTimeDays, QuantityPerOuter, IsChillerStock, Barcode,
    TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit,
    MarketingComments, InternalComments, Photo, CustomFields,
    LastEditedBy
FROM WideWorldImporters.Warehouse.StockItems;
SET IDENTITY_INSERT Corporativo.Warehouse.StockItems OFF;
GO


-- Warehouse.StockItemStockGroups
SET IDENTITY_INSERT Corporativo.Warehouse.StockItemStockGroups ON;
INSERT INTO Corporativo.Warehouse.StockItemStockGroups (
    StockItemStockGroupID, StockItemID, StockGroupID, LastEditedBy, LastEditedWhen
)
SELECT
    StockItemStockGroupID, StockItemID, StockGroupID, LastEditedBy, LastEditedWhen
FROM WideWorldImporters.Warehouse.StockItemStockGroups;
SET IDENTITY_INSERT Corporativo.Warehouse.StockItemStockGroups OFF;
GO


-- Warehouse.StockItemHoldings
INSERT INTO Corporativo.Warehouse.StockItemHoldings (
    StockItemID, QuantityOnHand, BinLocation, LastStocktakeQuantity, 
    LastCostPrice, ReorderLevel, TargetStockLevel, 
    LastEditedBy, LastEditedWhen, Branch
)
SELECT
    StockItemID, QuantityOnHand, BinLocation, LastStocktakeQuantity, 
    LastCostPrice, ReorderLevel, TargetStockLevel, 
    LastEditedBy, LastEditedWhen, Branch
FROM WideWorldImporters.Warehouse.StockItemHoldings;
GO


-- Sales.Orders
SET IDENTITY_INSERT Corporativo.Sales.Orders ON;
INSERT INTO Corporativo.Sales.Orders (
    OrderID, CustomerID, SalespersonPersonID, PickedByPersonID, 
    ContactPersonID, BackorderOrderID, OrderDate, ExpectedDeliveryDate, 
    CustomerPurchaseOrderNumber, IsUndersupplyBackordered, Comments, 
    DeliveryInstructions, InternalComments, PickingCompletedWhen, 
    LastEditedBy, LastEditedWhen
)
SELECT
    OrderID, CustomerID, SalespersonPersonID, PickedByPersonID, 
    ContactPersonID, BackorderOrderID, OrderDate, ExpectedDeliveryDate, 
    CustomerPurchaseOrderNumber, IsUndersupplyBackordered, Comments, 
    DeliveryInstructions, InternalComments, PickingCompletedWhen, 
    LastEditedBy, LastEditedWhen
FROM WideWorldImporters.Sales.Orders;
SET IDENTITY_INSERT Corporativo.Sales.Orders OFF;
GO


-- Sales.OrderLines
SET IDENTITY_INSERT Corporativo.Sales.OrderLines ON;
INSERT INTO Corporativo.Sales.OrderLines (
    OrderLineID, OrderID, StockItemID, Description, PackageTypeID, 
    Quantity, UnitPrice, TaxRate, PickedQuantity, 
    PickingCompletedWhen, LastEditedBy, LastEditedWhen
)
SELECT
    OrderLineID, OrderID, StockItemID, Description, PackageTypeID, 
    Quantity, UnitPrice, TaxRate, PickedQuantity, 
    PickingCompletedWhen, LastEditedBy, LastEditedWhen
FROM WideWorldImporters.Sales.OrderLines;
SET IDENTITY_INSERT Corporativo.Sales.OrderLines OFF;
GO


-- Sales.Invoices
SET IDENTITY_INSERT Corporativo.Sales.Invoices ON;
INSERT INTO Corporativo.Sales.Invoices (
    InvoiceID, CustomerID, BillToCustomerID, OrderID, DeliveryMethodID,
    ContactPersonID, AccountsPersonID, SalespersonPersonID, PackedByPersonID,
    InvoiceDate, CustomerPurchaseOrderNumber, IsCreditNote, CreditNoteReason,
    Comments, DeliveryInstructions, InternalComments, TotalDryItems,
    TotalChillerItems, DeliveryRun, RunPosition, ReturnedDeliveryData,
    LastEditedBy, LastEditedWhen, Branch
)
SELECT
    InvoiceID, CustomerID, BillToCustomerID, OrderID, DeliveryMethodID,
    ContactPersonID, AccountsPersonID, SalespersonPersonID, PackedByPersonID,
    InvoiceDate, CustomerPurchaseOrderNumber, IsCreditNote, CreditNoteReason,
    Comments, DeliveryInstructions, InternalComments, TotalDryItems,
    TotalChillerItems, DeliveryRun, RunPosition, ReturnedDeliveryData,
    LastEditedBy, LastEditedWhen, Branch
FROM WideWorldImporters.Sales.Invoices;
SET IDENTITY_INSERT Corporativo.Sales.Invoices OFF;
GO


-- Sales.InvoiceLines
SET IDENTITY_INSERT Corporativo.Sales.InvoiceLines ON;
INSERT INTO Corporativo.Sales.InvoiceLines (
    InvoiceLineID, InvoiceID, StockItemID, Description, PackageTypeID,
    Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice,
    LastEditedBy, LastEditedWhen
)
SELECT
    InvoiceLineID, InvoiceID, StockItemID, Description, PackageTypeID,
    Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice,
    LastEditedBy, LastEditedWhen
FROM WideWorldImporters.Sales.InvoiceLines;
SET IDENTITY_INSERT Corporativo.Sales.InvoiceLines OFF;
GO


-- Users no se migra