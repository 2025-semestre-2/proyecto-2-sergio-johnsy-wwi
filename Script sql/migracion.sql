-- Migrar datos de WideWorldImporters a Corporativo
USE master;
GO

-- Application.People
SET IDENTITY_INSERT Corporativo.Application.People ON;
INSERT INTO Corporativo.Application.People (
    PersonID, FullName, PreferredName, IsPermittedToLogon, LogonName, 
    IsExternalLogonProvider, HashedPassword, IsSystemUser, IsEmployee, 
    IsSalesperson, UserPreferences, PhoneNumber, FaxNumber, EmailAddress, 
    Photo, CustomFields, LastEditedBy, ValidFrom, ValidTo
)
SELECT 
    PersonID, FullName, PreferredName, IsPermittedToLogon, LogonName,
    IsExternalLogonProvider, HashedPassword, IsSystemUser, IsEmployee,
    IsSalesperson, UserPreferences, PhoneNumber, FaxNumber, EmailAddress,
    Photo, CustomFields, LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Application.People;
SET IDENTITY_INSERT Corporativo.Application.People OFF;
GO


-- Sales.BuyingGroups
SET IDENTITY_INSERT Corporativo.Sales.BuyingGroups ON;
INSERT INTO Corporativo.Sales.BuyingGroups (
    BuyingGroupID, BuyingGroupName, LastEditedBy, ValidFrom, ValidTo
)
SELECT 
    BuyingGroupID, BuyingGroupName, LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Sales.BuyingGroups;
SET IDENTITY_INSERT Corporativo.Sales.BuyingGroups OFF;
GO


-- Sales.CustomerCategories
SET IDENTITY_INSERT Corporativo.Sales.CustomerCategories ON;
INSERT INTO Corporativo.Sales.CustomerCategories (
    CustomerCategoryID, CustomerCategoryName, LastEditedBy, ValidFrom, ValidTo
)
SELECT 
    CustomerCategoryID, CustomerCategoryName, LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Sales.CustomerCategories;
SET IDENTITY_INSERT Corporativo.Sales.CustomerCategories OFF;
GO


-- Application.Countries
SET IDENTITY_INSERT Corporativo.Application.Countries ON;
INSERT INTO Corporativo.Application.Countries (
    CountryID, CountryName, FormalName, IsoAlpha3Code, IsoNumericCode,
    CountryType, LatestRecordedPopulation, Continent, Region, Subregion,
    Border, LastEditedBy, ValidFrom, ValidTo
)
SELECT
    CountryID, CountryName, FormalName, IsoAlpha3Code, IsoNumericCode,
    CountryType, LatestRecordedPopulation, Continent, Region, Subregion,
    Border, LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Application.Countries;
SET IDENTITY_INSERT Corporativo.Application.Countries OFF;
GO


-- Application.StateProvinces
SET IDENTITY_INSERT Corporativo.Application.StateProvinces ON;
INSERT INTO Corporativo.Application.StateProvinces (
    StateProvinceID, StateProvinceCode, StateProvinceName, CountryID, 
    SalesTerritory, Border, LatestRecordedPopulation, LastEditedBy, 
    ValidFrom, ValidTo
)
SELECT 
    StateProvinceID, StateProvinceCode, StateProvinceName, CountryID, 
    SalesTerritory, Border, LatestRecordedPopulation, LastEditedBy, 
    ValidFrom, ValidTo
FROM WideWorldImporters.Application.StateProvinces;
SET IDENTITY_INSERT Corporativo.Application.StateProvinces OFF;
GO


-- Application.Cities
SET IDENTITY_INSERT Corporativo.Application.Cities ON;
INSERT INTO Corporativo.Application.Cities (
    CityID, CityName, StateProvinceID, [Location],
    LatestRecordedPopulation, LastEditedBy, ValidFrom, ValidTo
)
SELECT
    CityID, CityName, StateProvinceID, [Location],
    LatestRecordedPopulation, LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Application.Cities;
SET IDENTITY_INSERT Corporativo.Application.Cities OFF;
GO


-- Application.DeliveryMethods
SET IDENTITY_INSERT Corporativo.Application.DeliveryMethods ON;
INSERT INTO Corporativo.Application.DeliveryMethods (
    DeliveryMethodID, DeliveryMethodName, LastEditedBy, ValidFrom, ValidTo
)
SELECT
    DeliveryMethodID, DeliveryMethodName, LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Application.DeliveryMethods;
SET IDENTITY_INSERT Corporativo.Application.DeliveryMethods OFF;
GO


-- Customers (SE FRAGMENTA CON DATOS SENSIBLES)
-- Sales.Customers
SET IDENTITY_INSERT Corporativo.Sales.Customers ON;
INSERT INTO Corporativo.Sales.Customers (
    CustomerID, CustomerCategoryID, BuyingGroupID, DeliveryMethodID,
    AccountOpenedDate, StandardDiscountPercentage, IsStatementSent,
    PaymentDays, DeliveryRun, RunPosition, WebsiteURL,
    LastEditedBy, ValidFrom, ValidTo
)
SELECT
    CustomerID, CustomerCategoryID, BuyingGroupID, DeliveryMethodID,
    AccountOpenedDate, StandardDiscountPercentage, IsStatementSent,
    PaymentDays, DeliveryRun, RunPosition, WebsiteURL,
    LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Sales.Customers;
SET IDENTITY_INSERT Corporativo.Sales.Customers OFF;
GO



-- Purchasing.SupplierCategories
SET IDENTITY_INSERT Corporativo.Purchasing.SupplierCategories ON;
INSERT INTO Corporativo.Purchasing.SupplierCategories (
    SupplierCategoryID, SupplierCategoryName, LastEditedBy, ValidFrom, ValidTo
)
SELECT
    SupplierCategoryID, SupplierCategoryName, LastEditedBy, ValidFrom, ValidTo
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
    LastEditedBy, ValidFrom, ValidTo
)
SELECT
    SupplierID, SupplierName, SupplierCategoryID, PrimaryContactPersonID, AlternateContactPersonID,
    DeliveryMethodID, DeliveryCityID, PostalCityID, SupplierReference,
    BankAccountName, BankAccountBranch, BankAccountCode, BankAccountNumber, BankInternationalCode,
    PaymentDays, InternalComments, PhoneNumber, FaxNumber, WebsiteURL,
    DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation,
    PostalAddressLine1, PostalAddressLine2, PostalPostalCode,
    LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Purchasing.Suppliers;
SET IDENTITY_INSERT Corporativo.Purchasing.Suppliers OFF;
GO


-- Warehouse.Colors
SET IDENTITY_INSERT Corporativo.Warehouse.Colors ON;
INSERT INTO Corporativo.Warehouse.Colors (
    ColorID, ColorName, LastEditedBy, ValidFrom, ValidTo
)
SELECT
    ColorID, ColorName, LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Warehouse.Colors;
SET IDENTITY_INSERT Corporativo.Warehouse.Colors OFF;
GO


-- Warehouse.PackageTypes
SET IDENTITY_INSERT Corporativo.Warehouse.PackageTypes ON;
INSERT INTO Corporativo.Warehouse.PackageTypes (
    PackageTypeID, PackageTypeName, LastEditedBy, ValidFrom, ValidTo
)
SELECT
    PackageTypeID, PackageTypeName, LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Warehouse.PackageTypes;
SET IDENTITY_INSERT Corporativo.Warehouse.PackageTypes OFF;
GO


-- Warehouse.StockItems
SET IDENTITY_INSERT Corporativo.Warehouse.StockItems ON;
INSERT INTO Corporativo.Warehouse.StockItems (
    StockItemID, StockItemName, SupplierID, ColorID, UnitPackageID, OuterPackageID,
    Brand, Size, LeadTimeDays, QuantityPerOuter, IsChillerStock, Barcode,
    TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit,
    MarketingComments, InternalComments, Photo, CustomFields,
    LastEditedBy, ValidFrom, ValidTo
)
SELECT
    StockItemID, StockItemName, SupplierID, ColorID, UnitPackageID, OuterPackageID,
    Brand, Size, LeadTimeDays, QuantityPerOuter, IsChillerStock, Barcode,
    TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit,
    MarketingComments, InternalComments, Photo, CustomFields,
    LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Warehouse.StockItems;
SET IDENTITY_INSERT Corporativo.Warehouse.StockItems OFF;
GO


-- Warehouse.StockGroups
SET IDENTITY_INSERT Corporativo.Warehouse.StockGroups ON;
INSERT INTO Corporativo.Warehouse.StockGroups (
    StockGroupID, StockGroupName, LastEditedBy, ValidFrom, ValidTo
)
SELECT
    StockGroupID, StockGroupName, LastEditedBy, ValidFrom, ValidTo
FROM WideWorldImporters.Warehouse.StockGroups;
SET IDENTITY_INSERT Corporativo.Warehouse.StockGroups OFF;
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
    LastEditedBy, LastEditedWhen, N'SJ'
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
    LastEditedBy, LastEditedWhen, N'SJ'
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