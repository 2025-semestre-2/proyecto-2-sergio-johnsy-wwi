-- Migrar datos de WideWorldImporters a Sucursal_SJ
USE master;
GO


-- Application.People
SET IDENTITY_INSERT Sucursal_SJ.Application.People ON;
INSERT INTO Sucursal_SJ.Application.People (
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
FROM [sql_corp].Corporativo.Application.People;
SET IDENTITY_INSERT Sucursal_SJ.Application.People OFF;
GO


-- Application.Countries
SET IDENTITY_INSERT Sucursal_SJ.Application.Countries ON;
INSERT INTO Sucursal_SJ.Application.Countries (
    CountryID, CountryName, FormalName, IsoAlpha3Code, IsoNumericCode,
    CountryType, LatestRecordedPopulation, Continent, Region, Subregion,
    Border, LastEditedBy
)
SELECT
    CountryID, CountryName, FormalName, IsoAlpha3Code, IsoNumericCode,
    CountryType, LatestRecordedPopulation, Continent, Region, Subregion,
    Border, LastEditedBy
FROM Corporativo.Application.Countries;
SET IDENTITY_INSERT Sucursal_SJ.Application.Countries OFF;
GO


-- Application.StateProvinces
SET IDENTITY_INSERT Sucursal_SJ.Application.StateProvinces ON;
INSERT INTO Sucursal_SJ.Application.StateProvinces (
    StateProvinceID, StateProvinceCode, StateProvinceName, CountryID, 
    SalesTerritory, Border, LatestRecordedPopulation, LastEditedBy
)
SELECT 
    StateProvinceID, StateProvinceCode, StateProvinceName, CountryID, 
    SalesTerritory, Border, LatestRecordedPopulation, LastEditedBy
FROM Corporativo.Application.StateProvinces;
SET IDENTITY_INSERT Sucursal_SJ.Application.StateProvinces OFF;
GO


-- Application.Cities
SET IDENTITY_INSERT Sucursal_SJ.Application.Cities ON;
INSERT INTO Sucursal_SJ.Application.Cities (
    CityID, CityName, StateProvinceID, [Location],
    LatestRecordedPopulation, LastEditedBy
)
SELECT
    CityID, CityName, StateProvinceID, [Location],
    LatestRecordedPopulation, LastEditedBy
FROM Corporativo.Application.Cities;
SET IDENTITY_INSERT Sucursal_SJ.Application.Cities OFF;
GO


-- Application.DeliveryMethods
SET IDENTITY_INSERT Sucursal_SJ.Application.DeliveryMethods ON;
INSERT INTO Sucursal_SJ.Application.DeliveryMethods (
    DeliveryMethodID, DeliveryMethodName, LastEditedBy
)
SELECT
    DeliveryMethodID, DeliveryMethodName, LastEditedBy
FROM Corporativo.Application.DeliveryMethods;
SET IDENTITY_INSERT Sucursal_SJ.Application.DeliveryMethods OFF;
GO


-- Application.TransactionTypes
SET IDENTITY_INSERT Sucursal_SJ.Application.TransactionTypes ON;
INSERT INTO Sucursal_SJ.Application.TransactionTypes (
    TransactionTypeID, TransactionTypeName, LastEditedBy
)
SELECT
    TransactionTypeID, TransactionTypeName, LastEditedBy
FROM Corporativo.Application.TransactionTypes;
SET IDENTITY_INSERT Sucursal_SJ.Application.TransactionTypes OFF;
GO


-- Sales.CustomerCategories
SET IDENTITY_INSERT Sucursal_SJ.Sales.CustomerCategories ON;
INSERT INTO Sucursal_SJ.Sales.CustomerCategories (
    CustomerCategoryID, CustomerCategoryName, LastEditedBy
)
SELECT 
    CustomerCategoryID, CustomerCategoryName, LastEditedBy
FROM Corporativo.Sales.CustomerCategories;
SET IDENTITY_INSERT Sucursal_SJ.Sales.CustomerCategories OFF;
GO


-- Sales.BuyingGroups
SET IDENTITY_INSERT Sucursal_SJ.Sales.BuyingGroups ON;
INSERT INTO Sucursal_SJ.Sales.BuyingGroups (
    BuyingGroupID, BuyingGroupName, LastEditedBy
)
SELECT 
    BuyingGroupID, BuyingGroupName, LastEditedBy
FROM Corporativo.Sales.BuyingGroups;
SET IDENTITY_INSERT Sucursal_SJ.Sales.BuyingGroups OFF;
GO


-- Customers (SE FRAGMENTA CON DATOS SENSIBLES)
-- Sales.Customers
-- Migrar datos faltantes de clientes desde WWI a San José
SET IDENTITY_INSERT Sucursal_SJ.Sales.Customers ON;
INSERT INTO Sucursal_SJ.Sales.Customers (
    CustomerID, CustomerCategoryID, BuyingGroupID, DeliveryMethodID, 
    AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, 
    PaymentDays, DeliveryRun, RunPosition, WebsiteURL, LastEditedBy
)
SELECT
    CustomerID, CustomerCategoryID, BuyingGroupID, DeliveryMethodID, 
    AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, 
    PaymentDays, DeliveryRun, RunPosition, WebsiteURL, LastEditedBy
FROM WideWorldImporters.Sales.Customers;
SET IDENTITY_INSERT Sucursal_SJ.Sales.Customers OFF;
GO


-- Purchasing.SupplierCategories
SET IDENTITY_INSERT Sucursal_SJ.Purchasing.SupplierCategories ON;
INSERT INTO Sucursal_SJ.Purchasing.SupplierCategories (
    SupplierCategoryID, SupplierCategoryName, LastEditedBy
)
SELECT
    SupplierCategoryID, SupplierCategoryName, LastEditedBy
FROM Corporativo.Purchasing.SupplierCategories;
SET IDENTITY_INSERT Sucursal_SJ.Purchasing.SupplierCategories OFF;
GO


-- Purchasing.Suppliers
SET IDENTITY_INSERT Sucursal_SJ.Purchasing.Suppliers ON;
INSERT INTO Sucursal_SJ.Purchasing.Suppliers (
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
SET IDENTITY_INSERT Sucursal_SJ.Purchasing.Suppliers OFF;
GO


-- Purchasing.PurchaseOrders
SET IDENTITY_INSERT Sucursal_SJ.Purchasing.PurchaseOrders ON;
INSERT INTO Sucursal_SJ.Purchasing.PurchaseOrders (
    PurchaseOrderID, SupplierID, OrderDate, DeliveryMethodID, ContactPersonID,
    ExpectedDeliveryDate, SupplierReference, IsOrderFinalized, Comments,
    InternalComments, LastEditedBy, LastEditedWhen
)
SELECT
    PurchaseOrderID, SupplierID, OrderDate, DeliveryMethodID, ContactPersonID,
    ExpectedDeliveryDate, SupplierReference, IsOrderFinalized, Comments,
    InternalComments, LastEditedBy, LastEditedWhen
FROM Corporativo.Purchasing.PurchaseOrders;
SET IDENTITY_INSERT Sucursal_SJ.Purchasing.PurchaseOrders OFF;
GO


-- Warehouse.Colors
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.Colors ON;
INSERT INTO Sucursal_SJ.Warehouse.Colors (
    ColorID, ColorName, LastEditedBy
)
SELECT
    ColorID, ColorName, LastEditedBy
FROM Corporativo.Warehouse.Colors;
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.Colors OFF;
GO


-- Warehouse.PackageTypes
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.PackageTypes ON;
INSERT INTO Sucursal_SJ.Warehouse.PackageTypes (
    PackageTypeID, PackageTypeName, LastEditedBy
)
SELECT
    PackageTypeID, PackageTypeName, LastEditedBy
FROM Corporativo.Warehouse.PackageTypes;
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.PackageTypes OFF;
GO


-- Warehouse.StockGroups
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.StockGroups ON;
INSERT INTO Sucursal_SJ.Warehouse.StockGroups (
    StockGroupID, StockGroupName, LastEditedBy
)
SELECT
    StockGroupID, StockGroupName, LastEditedBy
FROM Corporativo.Warehouse.StockGroups;
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.StockGroups OFF;
GO


-- Warehouse.StockItems
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.StockItems ON;
INSERT INTO Sucursal_SJ.Warehouse.StockItems (
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
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.StockItems OFF;
GO


-- Warehouse.StockItemStockGroups
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.StockItemStockGroups ON;
INSERT INTO Sucursal_SJ.Warehouse.StockItemStockGroups (
    StockItemStockGroupID, StockItemID, StockGroupID, LastEditedBy, LastEditedWhen
)
SELECT
    StockItemStockGroupID, StockItemID, StockGroupID, LastEditedBy, LastEditedWhen
FROM Corporativo.Warehouse.StockItemStockGroups;
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.StockItemStockGroups OFF;
GO


-- Corporativo a SAN JOSE
INSERT INTO Sucursal_SJ.Warehouse.StockItemHoldings (
    StockItemID, QuantityOnHand, BinLocation, LastStocktakeQuantity, 
    LastCostPrice, ReorderLevel, TargetStockLevel, 
    LastEditedBy, LastEditedWhen, Branch
)
SELECT
    StockItemID, QuantityOnHand, BinLocation, LastStocktakeQuantity, 
    LastCostPrice, ReorderLevel, TargetStockLevel, 
    LastEditedBy, LastEditedWhen, Branch
FROM Corporativo.Warehouse.StockItemHoldings
WHERE Branch = 'SJ';
GO


-- Purchasing.PurchaseOrderLines
SET IDENTITY_INSERT Sucursal_SJ.Purchasing.PurchaseOrderLines ON;
INSERT INTO Sucursal_SJ.Purchasing.PurchaseOrderLines (
    PurchaseOrderLineID, PurchaseOrderID, StockItemID, OrderedOuters, Description,
    ReceivedOuters, PackageTypeID, ExpectedUnitPricePerOuter, LastReceiptDate,
    IsOrderLineFinalized, LastEditedBy, LastEditedWhen
)
SELECT
    PurchaseOrderLineID, PurchaseOrderID, StockItemID, OrderedOuters, Description,
    ReceivedOuters, PackageTypeID, ExpectedUnitPricePerOuter, LastReceiptDate,
    IsOrderLineFinalized, LastEditedBy, LastEditedWhen
FROM Corporativo.Purchasing.PurchaseOrderLines;
SET IDENTITY_INSERT Sucursal_SJ.Purchasing.PurchaseOrderLines OFF;
GO


-- Sales.Orders
SET IDENTITY_INSERT Sucursal_SJ.Sales.Orders ON;
INSERT INTO Sucursal_SJ.Sales.Orders (
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
SET IDENTITY_INSERT Sucursal_SJ.Sales.Orders OFF;
GO


-- Sales.OrderLines
SET IDENTITY_INSERT Sucursal_SJ.Sales.OrderLines ON;
INSERT INTO Sucursal_SJ.Sales.OrderLines (
    OrderLineID, OrderID, StockItemID, Description, PackageTypeID, 
    Quantity, UnitPrice, TaxRate, PickedQuantity, 
    PickingCompletedWhen, LastEditedBy, LastEditedWhen
)
SELECT
    OrderLineID, OrderID, StockItemID, Description, PackageTypeID, 
    Quantity, UnitPrice, TaxRate, PickedQuantity, 
    PickingCompletedWhen, LastEditedBy, LastEditedWhen
FROM Corporativo.Sales.OrderLines;
SET IDENTITY_INSERT Sucursal_SJ.Sales.OrderLines OFF;
GO


-- Sales.Invoices
-- Corporativo a SAN JOSE
SET IDENTITY_INSERT Sucursal_SJ.Sales.Invoices ON;
INSERT INTO Sucursal_SJ.Sales.Invoices (
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
WHERE Branch = 'SJ';
SET IDENTITY_INSERT Sucursal_SJ.Sales.Invoices OFF;
GO


-- Sales.InvoiceLines
SET IDENTITY_INSERT Sucursal_SJ.Sales.InvoiceLines ON;
INSERT INTO Sucursal_SJ.Sales.InvoiceLines (
    InvoiceLineID, InvoiceID, StockItemID, Description, PackageTypeID,
    Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice,
    LastEditedBy, LastEditedWhen
)
SELECT 
    il.InvoiceLineID, i.InvoiceID, il.StockItemID, il.Description, il.PackageTypeID,
    il.Quantity, il.UnitPrice, il.TaxRate, il.TaxAmount, il.LineProfit, il.ExtendedPrice,
    il.LastEditedBy, il.LastEditedWhen
FROM Corporativo.Sales.InvoiceLines AS il
INNER JOIN Sucursal_SJ.Sales.Invoices AS i
    ON il.InvoiceID = i.InvoiceID;
SET IDENTITY_INSERT Sucursal_SJ.Sales.InvoiceLines OFF;
GO


-- Warehouse.StockItemTransactions
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.StockItemTransactions ON;
INSERT INTO Sucursal_SJ.Warehouse.StockItemTransactions (
    StockItemTransactionID, StockItemID, TransactionTypeID, CustomerID, InvoiceID,
    SupplierID, PurchaseOrderID, TransactionOccurredWhen, Quantity,
    LastEditedBy, LastEditedWhen
)
SELECT 
    t.StockItemTransactionID, t.StockItemID, t.TransactionTypeID, t.CustomerID, t.InvoiceID,
    t.SupplierID, t.PurchaseOrderID, t.TransactionOccurredWhen, t.Quantity,
    t.LastEditedBy, t.LastEditedWhen
FROM Corporativo.Warehouse.StockItemTransactions AS t
INNER JOIN Sucursal_SJ.Sales.Invoices AS i
    ON t.InvoiceID = i.InvoiceID
WHERE t.InvoiceID IS NOT NULL;
SET IDENTITY_INSERT Sucursal_SJ.Warehouse.StockItemTransactions OFF;
GO



-- Users no se migra