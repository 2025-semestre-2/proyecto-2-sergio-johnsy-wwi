-- Migrar datos de WideWorldImporters a Sucursal_LI
USE master;
GO


-- Application.People
SET IDENTITY_INSERT Sucursal_LI.Application.People ON;
INSERT INTO Sucursal_LI.Application.People (
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
FROM Corporativo.Application.People;
SET IDENTITY_INSERT Sucursal_LI.Application.People OFF;
GO


-- Application.Countries
SET IDENTITY_INSERT Sucursal_LI.Application.Countries ON;
INSERT INTO Sucursal_LI.Application.Countries (
    CountryID, CountryName, FormalName, IsoAlpha3Code, IsoNumericCode,
    CountryType, LatestRecordedPopulation, Continent, Region, Subregion,
    Border, LastEditedBy
)
SELECT
    CountryID, CountryName, FormalName, IsoAlpha3Code, IsoNumericCode,
    CountryType, LatestRecordedPopulation, Continent, Region, Subregion,
    Border, LastEditedBy
FROM Corporativo.Application.Countries;
SET IDENTITY_INSERT Sucursal_LI.Application.Countries OFF;
GO


-- Application.StateProvinces
SET IDENTITY_INSERT Sucursal_LI.Application.StateProvinces ON;
INSERT INTO Sucursal_LI.Application.StateProvinces (
    StateProvinceID, StateProvinceCode, StateProvinceName, CountryID, 
    SalesTerritory, Border, LatestRecordedPopulation, LastEditedBy
)
SELECT 
    StateProvinceID, StateProvinceCode, StateProvinceName, CountryID, 
    SalesTerritory, Border, LatestRecordedPopulation, LastEditedBy
FROM Corporativo.Application.StateProvinces;
SET IDENTITY_INSERT Sucursal_LI.Application.StateProvinces OFF;
GO


-- Application.Cities
SET IDENTITY_INSERT Sucursal_LI.Application.Cities ON;
INSERT INTO Sucursal_LI.Application.Cities (
    CityID, CityName, StateProvinceID, [Location],
    LatestRecordedPopulation, LastEditedBy
)
SELECT
    CityID, CityName, StateProvinceID, [Location],
    LatestRecordedPopulation, LastEditedBy
FROM Corporativo.Application.Cities;
SET IDENTITY_INSERT Sucursal_LI.Application.Cities OFF;
GO


-- Application.DeliveryMethods
SET IDENTITY_INSERT Sucursal_LI.Application.DeliveryMethods ON;
INSERT INTO Sucursal_LI.Application.DeliveryMethods (
    DeliveryMethodID, DeliveryMethodName, LastEditedBy
)
SELECT
    DeliveryMethodID, DeliveryMethodName, LastEditedBy
FROM Corporativo.Application.DeliveryMethods;
SET IDENTITY_INSERT Sucursal_LI.Application.DeliveryMethods OFF;
GO


-- Application.TransactionTypes
SET IDENTITY_INSERT Sucursal_LI.Application.TransactionTypes ON;
INSERT INTO Sucursal_LI.Application.TransactionTypes (
    TransactionTypeID, TransactionTypeName, LastEditedBy
)
SELECT
    TransactionTypeID, TransactionTypeName, LastEditedBy
FROM Corporativo.Application.TransactionTypes;
SET IDENTITY_INSERT Sucursal_LI.Application.TransactionTypes OFF;
GO


-- Sales.CustomerCategories
SET IDENTITY_INSERT Sucursal_LI.Sales.CustomerCategories ON;
INSERT INTO Sucursal_LI.Sales.CustomerCategories (
    CustomerCategoryID, CustomerCategoryName, LastEditedBy
)
SELECT 
    CustomerCategoryID, CustomerCategoryName, LastEditedBy
FROM Corporativo.Sales.CustomerCategories;
SET IDENTITY_INSERT Sucursal_LI.Sales.CustomerCategories OFF;
GO


-- Sales.BuyingGroups
SET IDENTITY_INSERT Sucursal_LI.Sales.BuyingGroups ON;
INSERT INTO Sucursal_LI.Sales.BuyingGroups (
    BuyingGroupID, BuyingGroupName, LastEditedBy
)
SELECT 
    BuyingGroupID, BuyingGroupName, LastEditedBy
FROM Corporativo.Sales.BuyingGroups;
SET IDENTITY_INSERT Sucursal_LI.Sales.BuyingGroups OFF;
GO


-- Customers (SE FRAGMENTA CON DATOS SENSIBLES)
-- Sales.Customers
-- Migrar datos faltantes de clientes desde WWI a San José
SET IDENTITY_INSERT Sucursal_LI.Sales.Customers ON;
INSERT INTO Sucursal_LI.Sales.Customers (
    CustomerID, CustomerCategoryID, BuyingGroupID, DeliveryMethodID, 
    AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, 
    PaymentDays, DeliveryRun, RunPosition, WebsiteURL, LastEditedBy
)
SELECT
    CustomerID, CustomerCategoryID, BuyingGroupID, DeliveryMethodID, 
    AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, 
    PaymentDays, DeliveryRun, RunPosition, WebsiteURL, LastEditedBy
FROM WideWorldImporters.Sales.Customers;
SET IDENTITY_INSERT Sucursal_LI.Sales.Customers OFF;
GO


-- Purchasing.SupplierCategories
SET IDENTITY_INSERT Sucursal_LI.Purchasing.SupplierCategories ON;
INSERT INTO Sucursal_LI.Purchasing.SupplierCategories (
    SupplierCategoryID, SupplierCategoryName, LastEditedBy
)
SELECT
    SupplierCategoryID, SupplierCategoryName, LastEditedBy
FROM Corporativo.Purchasing.SupplierCategories;
SET IDENTITY_INSERT Sucursal_LI.Purchasing.SupplierCategories OFF;
GO


-- Purchasing.Suppliers
SET IDENTITY_INSERT Sucursal_LI.Purchasing.Suppliers ON;
INSERT INTO Sucursal_LI.Purchasing.Suppliers (
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
FROM Corporativo.Purchasing.Suppliers;
SET IDENTITY_INSERT Sucursal_LI.Purchasing.Suppliers OFF;
GO


-- Purchasing.PurchaseOrders
SET IDENTITY_INSERT Sucursal_LI.Purchasing.PurchaseOrders ON;
INSERT INTO Sucursal_LI.Purchasing.PurchaseOrders (
    PurchaseOrderID, SupplierID, OrderDate, DeliveryMethodID, ContactPersonID,
    ExpectedDeliveryDate, SupplierReference, IsOrderFinalized, Comments,
    InternalComments, LastEditedBy, LastEditedWhen
)
SELECT
    PurchaseOrderID, SupplierID, OrderDate, DeliveryMethodID, ContactPersonID,
    ExpectedDeliveryDate, SupplierReference, IsOrderFinalized, Comments,
    InternalComments, LastEditedBy, LastEditedWhen
FROM Corporativo.Purchasing.PurchaseOrders;
SET IDENTITY_INSERT Sucursal_LI.Purchasing.PurchaseOrders OFF;
GO


-- Warehouse.Colors
SET IDENTITY_INSERT Sucursal_LI.Warehouse.Colors ON;
INSERT INTO Sucursal_LI.Warehouse.Colors (
    ColorID, ColorName, LastEditedBy
)
SELECT
    ColorID, ColorName, LastEditedBy
FROM Corporativo.Warehouse.Colors;
SET IDENTITY_INSERT Sucursal_LI.Warehouse.Colors OFF;
GO


-- Warehouse.PackageTypes
SET IDENTITY_INSERT Sucursal_LI.Warehouse.PackageTypes ON;
INSERT INTO Sucursal_LI.Warehouse.PackageTypes (
    PackageTypeID, PackageTypeName, LastEditedBy
)
SELECT
    PackageTypeID, PackageTypeName, LastEditedBy
FROM Corporativo.Warehouse.PackageTypes;
SET IDENTITY_INSERT Sucursal_LI.Warehouse.PackageTypes OFF;
GO


-- Warehouse.StockGroups
SET IDENTITY_INSERT Sucursal_LI.Warehouse.StockGroups ON;
INSERT INTO Sucursal_LI.Warehouse.StockGroups (
    StockGroupID, StockGroupName, LastEditedBy
)
SELECT
    StockGroupID, StockGroupName, LastEditedBy
FROM Corporativo.Warehouse.StockGroups;
SET IDENTITY_INSERT Sucursal_LI.Warehouse.StockGroups OFF;
GO


-- Warehouse.StockItems
SET IDENTITY_INSERT Sucursal_LI.Warehouse.StockItems ON;
INSERT INTO Sucursal_LI.Warehouse.StockItems (
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
FROM Corporativo.Warehouse.StockItems;
SET IDENTITY_INSERT Sucursal_LI.Warehouse.StockItems OFF;
GO


-- Warehouse.StockItemStockGroups
SET IDENTITY_INSERT Sucursal_LI.Warehouse.StockItemStockGroups ON;
INSERT INTO Sucursal_LI.Warehouse.StockItemStockGroups (
    StockItemStockGroupID, StockItemID, StockGroupID, LastEditedBy, LastEditedWhen
)
SELECT
    StockItemStockGroupID, StockItemID, StockGroupID, LastEditedBy, LastEditedWhen
FROM Corporativo.Warehouse.StockItemStockGroups;
SET IDENTITY_INSERT Sucursal_LI.Warehouse.StockItemStockGroups OFF;
GO


-- Corporativo a SAN JOSE
INSERT INTO Sucursal_LI.Warehouse.StockItemHoldings (
    StockItemID, QuantityOnHand, BinLocation, LastStocktakeQuantity, 
    LastCostPrice, ReorderLevel, TargetStockLevel, 
    LastEditedBy, LastEditedWhen, Branch
)
SELECT
    StockItemID, QuantityOnHand, BinLocation, LastStocktakeQuantity, 
    LastCostPrice, ReorderLevel, TargetStockLevel, 
    LastEditedBy, LastEditedWhen, Branch
FROM Corporativo.Warehouse.StockItemHoldings
WHERE Branch = 'LI';
GO


-- Purchasing.PurchaseOrderLines
SET IDENTITY_INSERT Sucursal_LI.Purchasing.PurchaseOrderLines ON;
INSERT INTO Sucursal_LI.Purchasing.PurchaseOrderLines (
    PurchaseOrderLineID, PurchaseOrderID, StockItemID, OrderedOuters, Description,
    ReceivedOuters, PackageTypeID, ExpectedUnitPricePerOuter, LastReceiptDate,
    IsOrderLineFinalized, LastEditedBy, LastEditedWhen
)
SELECT
    PurchaseOrderLineID, PurchaseOrderID, StockItemID, OrderedOuters, Description,
    ReceivedOuters, PackageTypeID, ExpectedUnitPricePerOuter, LastReceiptDate,
    IsOrderLineFinalized, LastEditedBy, LastEditedWhen
FROM Corporativo.Purchasing.PurchaseOrderLines;
SET IDENTITY_INSERT Sucursal_LI.Purchasing.PurchaseOrderLines OFF;
GO


-- Sales.Orders
SET IDENTITY_INSERT Sucursal_LI.Sales.Orders ON;
INSERT INTO Sucursal_LI.Sales.Orders (
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
FROM Corporativo.Sales.Orders;
SET IDENTITY_INSERT Sucursal_LI.Sales.Orders OFF;
GO


-- Sales.OrderLines
SET IDENTITY_INSERT Sucursal_LI.Sales.OrderLines ON;
INSERT INTO Sucursal_LI.Sales.OrderLines (
    OrderLineID, OrderID, StockItemID, Description, PackageTypeID, 
    Quantity, UnitPrice, TaxRate, PickedQuantity, 
    PickingCompletedWhen, LastEditedBy, LastEditedWhen
)
SELECT
    OrderLineID, OrderID, StockItemID, Description, PackageTypeID, 
    Quantity, UnitPrice, TaxRate, PickedQuantity, 
    PickingCompletedWhen, LastEditedBy, LastEditedWhen
FROM Corporativo.Sales.OrderLines;
SET IDENTITY_INSERT Sucursal_LI.Sales.OrderLines OFF;
GO


-- Sales.Invoices
-- Corporativo a SAN JOSE
SET IDENTITY_INSERT Sucursal_LI.Sales.Invoices ON;
INSERT INTO Sucursal_LI.Sales.Invoices (
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
FROM Corporativo.Sales.Invoices
WHERE Branch = 'LI';
SET IDENTITY_INSERT Sucursal_LI.Sales.Invoices OFF;
GO


-- Sales.InvoiceLines
SET IDENTITY_INSERT Sucursal_LI.Sales.InvoiceLines ON;
INSERT INTO Sucursal_LI.Sales.InvoiceLines (
    InvoiceLineID, InvoiceID, StockItemID, Description, PackageTypeID,
    Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice,
    LastEditedBy, LastEditedWhen
)
SELECT 
    il.InvoiceLineID, i.InvoiceID, il.StockItemID, il.Description, il.PackageTypeID,
    il.Quantity, il.UnitPrice, il.TaxRate, il.TaxAmount, il.LineProfit, il.ExtendedPrice,
    il.LastEditedBy, il.LastEditedWhen
FROM Corporativo.Sales.InvoiceLines AS il
INNER JOIN Sucursal_LI.Sales.Invoices AS i
    ON il.InvoiceID = i.InvoiceID;
SET IDENTITY_INSERT Sucursal_LI.Sales.InvoiceLines OFF;
GO


-- Warehouse.StockItemTransactions
SET IDENTITY_INSERT Sucursal_LI.Warehouse.StockItemTransactions ON;
INSERT INTO Sucursal_LI.Warehouse.StockItemTransactions (
    StockItemTransactionID, StockItemID, TransactionTypeID, CustomerID, InvoiceID,
    SupplierID, PurchaseOrderID, TransactionOccurredWhen, Quantity,
    LastEditedBy, LastEditedWhen
)
SELECT 
    t.StockItemTransactionID, t.StockItemID, t.TransactionTypeID, t.CustomerID, t.InvoiceID,
    t.SupplierID, t.PurchaseOrderID, t.TransactionOccurredWhen, t.Quantity,
    t.LastEditedBy, t.LastEditedWhen
FROM Corporativo.Warehouse.StockItemTransactions AS t
INNER JOIN Sucursal_LI.Sales.Invoices AS i
    ON t.InvoiceID = i.InvoiceID
WHERE t.InvoiceID IS NOT NULL;
SET IDENTITY_INSERT Sucursal_LI.Warehouse.StockItemTransactions OFF;
GO



-- Users no se migra