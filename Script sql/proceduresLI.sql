use Sucursal_LI;
GO

CREATE PROCEDURE getClientePorID
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        customer.CustomerID,
        customer.CustomerName AS NombreCliente,
        category.CustomerCategoryName AS Categoria,
        buyingGroup.BuyingGroupName AS GrupoCompra,
        p1.FullName AS ContactoPrimario,
        p2.FullName AS ContactoAlternativo,

        customer.BillToCustomerID AS ClienteFacturarID,
        customerBillTo.CustomerName AS NombreClienteFacturar,
        deliveryMethod.DeliveryMethodName AS MetodoEntrega,

        city.CityName AS CiudadEntrega,
        provinces.StateProvinceName AS Provincia,
        countries.CountryName AS Pais,

        customer.DeliveryPostalCode AS CodigoPostal,
        customer.PhoneNumber AS Telefono,
        customer.FaxNumber AS Fax,
        sucCustomer.PaymentDays AS DiasParaPagar,
        sucCustomer.WebsiteURL AS SitioWeb,

        CONCAT(customer.DeliveryAddressLine1, ', ', ISNULL(customer.DeliveryAddressLine2, '')) AS DireccionEntrega,
        CONCAT(customer.PostalAddressLine1, ', ', ISNULL(customer.PostalAddressLine2, '')) AS DireccionPostal,
        customer.DeliveryLocation.Lat AS Latitud,
        customer.DeliveryLocation.Long AS Longitud

    FROM Corporativo.Sales.Customers AS customer
		INNER JOIN Sucursal_LI.Sales.Customers AS sucCustomer
			ON customer.CustomerID = sucCustomer.CustomerID
        INNER JOIN Sales.CustomerCategories AS category
            ON sucCustomer.CustomerCategoryID = category.CustomerCategoryID
        LEFT JOIN Sales.BuyingGroups AS buyingGroup
            ON sucCustomer.BuyingGroupID = buyingGroup.BuyingGroupID
        LEFT JOIN Application.DeliveryMethods AS deliveryMethod
            ON sucCustomer.DeliveryMethodID = deliveryMethod.DeliveryMethodID
        LEFT JOIN Application.Cities AS city
            ON customer.DeliveryCityID = city.CityID
        LEFT JOIN Application.StateProvinces AS provinces
            ON city.StateProvinceID = provinces.StateProvinceID
        LEFT JOIN Application.Countries AS countries
            ON provinces.CountryID = countries.CountryID
        LEFT JOIN Corporativo.Sales.Customers AS customerBillTo
            ON customer.BillToCustomerID = customerBillTo.CustomerID
        LEFT JOIN Application.People AS p1
            ON customer.PrimaryContactPersonID = p1.PersonID
        LEFT JOIN Application.People AS p2
            ON customer.AlternateContactPersonID = p2.PersonID
    WHERE customer.CustomerID = @CustomerID; 
END;
GO

CREATE PROCEDURE getClientesSimple
    @FiltrarNombre NVARCHAR(100) = NULL,
    @FiltrarCategoria INT = NULL,
    @FiltrarMetodoEntrega INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        customer.CustomerID,
        customer.CustomerName AS NombreCliente,
        cc.CustomerCategoryName AS Categoría,
        dm.DeliveryMethodName AS MetodoEntrega
        
    FROM Corporativo.Sales.Customers AS customer
		INNER JOIN Sucursal_LI.Sales.Customers AS sucCustomer
			ON customer.CustomerID = sucCustomer.CustomerID
        INNER JOIN Sales.CustomerCategories AS cc
            ON sucCustomer.CustomerCategoryID = cc.CustomerCategoryID
        LEFT JOIN Application.DeliveryMethods AS dm
            ON sucCustomer.DeliveryMethodID = dm.DeliveryMethodID
    WHERE
        ((@FiltrarNombre IS NULL OR customer.CustomerName LIKE '%' + @FiltrarNombre + '%')
        OR (@FiltrarNombre IS NULL OR cc.CustomerCategoryName LIKE '%' + @FiltrarNombre + '%'))
        AND (@FiltrarCategoria IS NULL OR cc.CustomerCategoryID = @FiltrarCategoria)
        AND (@FiltrarMetodoEntrega IS NULL OR dm.DeliveryMethodID = @FiltrarMetodoEntrega)
    ORDER BY NombreCliente ASC;
END;
GO

CREATE PROCEDURE getMetodosEntrega
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        DeliveryMethodID AS MetodoID,
        DeliveryMethodName AS NombreMetodo
    FROM Application.DeliveryMethods;
END;
GO

CREATE PROCEDURE getCategoriasClientes
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CustomerCategoryID AS CategoriaID,
        CustomerCategoryName AS NombreCategoria
    FROM Sales.CustomerCategories;
END;
GO

CREATE PROCEDURE getProveedoresSimple
    @FiltrarNombre NVARCHAR(100) = NULL,
    @FiltrarCategoria INT = NULL,
    @FiltrarMetodoEntrega INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        supplier.SupplierID as IDProveedor,
        supplier.SupplierName AS NombreProveedor,
        sc.SupplierCategoryName AS Categoría,
        dm.DeliveryMethodName AS MetodoEntrega
        
    FROM Purchasing.Suppliers AS supplier
        INNER JOIN Purchasing.SupplierCategories AS sc
            ON supplier.SupplierCategoryID = sc.SupplierCategoryID
        LEFT JOIN Application.DeliveryMethods AS dm
            ON supplier.DeliveryMethodID = dm.DeliveryMethodID
    WHERE
        ((@FiltrarNombre IS NULL OR supplier.SupplierName LIKE '%' + @FiltrarNombre + '%')
        OR (@FiltrarNombre IS NULL OR sc.SupplierCategoryName LIKE '%' + @FiltrarNombre + '%'))
        AND (@FiltrarCategoria IS NULL OR sc.SupplierCategoryID = @FiltrarCategoria)
        AND (@FiltrarMetodoEntrega IS NULL OR dm.DeliveryMethodID = @FiltrarMetodoEntrega)
    ORDER BY NombreProveedor ASC;
END;
GO

CREATE PROCEDURE getCategoriasProveedores
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        SupplierCategoryID AS CategoriaID,
        SupplierCategoryName AS NombreCategoria
    FROM Purchasing.SupplierCategories;
END;
GO


CREATE PROCEDURE getProveedorPorID
    @SupplierID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        supplier.SupplierID AS IDProveedor,
        supplier.SupplierReference AS CodigoProveedor,
        supplier.SupplierName AS NombreProveedor,
        category.SupplierCategoryName AS Categoria,

        p1.FullName AS ContactoPrimario,
        p1.PhoneNumber AS ContactoPrimarioTelefono,
        p1.EmailAddress AS ContactoAlternativoCorreo,

        p2.FullName AS ContactoAlternativo,
        p2.PhoneNumber AS ContactoAlternativoTelefono,
        p2.EmailAddress AS ContactoAlternativoCorreo,

        deliveryMethod.DeliveryMethodName AS MetodoEntrega,

        city.CityName AS CiudadEntrega,
        provinces.StateProvinceName AS Provincia,
        countries.CountryName AS Pais,

        supplier.DeliveryPostalCode AS CodigoPostal,
        supplier.PhoneNumber AS Telefono,
        supplier.FaxNumber AS Fax,
        supplier.WebsiteURL AS SitioWeb,
        supplier.PaymentDays AS DiasParaPagar,

        CONCAT(supplier.DeliveryAddressLine1, ', ', ISNULL(supplier.DeliveryAddressLine2, '')) AS DireccionEntrega,
        CONCAT(supplier.PostalAddressLine1, ', ', ISNULL(supplier.PostalAddressLine2, '')) AS DireccionPostal,

        supplier.DeliveryLocation.Lat AS Latitud,
        supplier.DeliveryLocation.Long AS Longitud,

        supplier.BankAccountBranch AS NombreBanco,
        supplier.BankAccountNumber AS NumeroCuentaCorriente

    FROM Purchasing.Suppliers AS supplier
        INNER JOIN Purchasing.SupplierCategories AS category
            ON supplier.SupplierCategoryID = category.SupplierCategoryID
        LEFT JOIN Application.DeliveryMethods AS deliveryMethod
            ON supplier.DeliveryMethodID = deliveryMethod.DeliveryMethodID
        LEFT JOIN Application.Cities AS city
            ON supplier.DeliveryCityID = city.CityID
        LEFT JOIN Application.StateProvinces AS provinces
            ON city.StateProvinceID = provinces.StateProvinceID
        LEFT JOIN Application.Countries AS countries
            ON provinces.CountryID = countries.CountryID
        LEFT JOIN Application.People AS p1
            ON supplier.PrimaryContactPersonID = p1.PersonID
        LEFT JOIN Application.People AS p2
            ON supplier.AlternateContactPersonID = p2.PersonID
    WHERE supplier.SupplierID = @SupplierID;
END;
GO

CREATE PROCEDURE getInventarioSimple
    @FiltrarNombre NVARCHAR(100) = NULL,
    @FiltrarGrupo INT = NULL,
    @FiltrarCantidadMinima INT = NULL,
    @FiltrarCantidadMaxima INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        product.StockItemID AS IDProducto,
        product.StockItemName AS NombreProducto,
        STRING_AGG(productGroup.StockGroupName, ', ') AS GruposProducto,
        holdings.QuantityOnHand AS CantidadDisponible
    FROM Warehouse.StockItems product
    LEFT JOIN Warehouse.StockItemStockGroups sisg
        ON product.StockItemID = sisg.StockItemID
    LEFT JOIN Warehouse.StockGroups productGroup
        ON sisg.StockGroupID = productGroup.StockGroupID
    LEFT JOIN Warehouse.StockItemHoldings holdings 
        ON product.StockItemID = holdings.StockItemID
    WHERE
        ((@FiltrarNombre IS NULL OR product.StockItemName LIKE '%' + @FiltrarNombre + '%')
        OR (@FiltrarNombre IS NULL OR productGroup.StockGroupName LIKE '%' + @FiltrarNombre + '%'))
        AND (@FiltrarGrupo IS NULL OR productGroup.StockGroupID = @FiltrarGrupo)
        AND (@FiltrarCantidadMinima IS NULL OR holdings.QuantityOnHand >= @FiltrarCantidadMinima)
        AND (@FiltrarCantidadMaxima IS NULL OR holdings.QuantityOnHand <= @FiltrarCantidadMaxima)
    GROUP BY product.StockItemID, product.StockItemName, holdings.QuantityOnHand
    ORDER BY product.StockItemName ASC;
END;
GO

CREATE PROCEDURE getGruposProductos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        StockGroupID AS GrupoID,
        StockGroupName AS NombreGrupo
    FROM Warehouse.StockGroups;
END;
GO

-- NUEVO INVENTARIO

CREATE PROCEDURE getProductoPorID
    @ProductoID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        product.StockItemID AS ProductoID,
        product.StockItemName AS NombreProducto,

        supplier.SupplierID AS IDProveedor,
        supplier.SupplierName AS NombreProveedor,

        STRING_AGG(productGroup.StockGroupName, ', ') AS GruposProducto,

        color.ColorID AS ColorID,
        color.ColorName AS Color,
        
        unit.PackageTypeID AS UnidadEmpaquetamientoID,
        unit.PackageTypeName AS UnidadEmpaquetamiento,

        outerP.PackageTypeID AS EmpaquetamientoID,
        outerP.PackageTypeName AS Empaquetamiento,

        product.QuantityPerOuter AS CantidadPorEmpaquetamiento,
        product.Brand AS Marca,
        product.Size AS Tamano,
        product.TaxRate AS TasaImpuesto,
        product.UnitPrice AS PrecioUnitario,

        product.RecommendedRetailPrice AS PrecioVentaRecomendado,
        product.TypicalWeightPerUnit AS PesoUnitario,

        holdings.QuantityOnHand AS CantidadDisponible,

        product.SearchDetails AS PalabrasClave,
        holdings.BinLocation AS UbicacionBodega

    FROM Warehouse.StockItems AS product
    LEFT JOIN Warehouse.StockItemStockGroups sisg
        ON product.StockItemID = sisg.StockItemID
    LEFT JOIN Warehouse.StockGroups productGroup
        ON sisg.StockGroupID = productGroup.StockGroupID
    LEFT JOIN Warehouse.StockItemHoldings holdings
        ON product.StockItemID = holdings.StockItemID
    LEFT JOIN Purchasing.Suppliers AS supplier
        ON product.SupplierID = supplier.SupplierID
    LEFT JOIN Warehouse.Colors AS color
        ON product.ColorID = color.ColorID
    LEFT JOIN Warehouse.PackageTypes AS unit
        ON product.UnitPackageID = unit.PackageTypeID
    LEFT JOIN Warehouse.PackageTypes AS outerP
        ON product.OuterPackageID = outerP.PackageTypeID
    WHERE product.StockItemID = @ProductoID
    GROUP BY 
        product.StockItemID, product.StockItemName, supplier.SupplierID,
        supplier.SupplierName,holdings.QuantityOnHand,color.ColorName, unit.PackageTypeName, outerP.PackageTypeName, product.QuantityPerOuter,
        product.Brand, product.Size, product.TaxRate, product.UnitPrice, product.RecommendedRetailPrice, product.TypicalWeightPerUnit, 
        holdings.BinLocation, product.SearchDetails, color.ColorID, unit.PackageTypeID, outerP.PackageTypeID;
END;
GO




-- VENTAS



CREATE VIEW vw_VentasResumen AS
SELECT
    venta.InvoiceID AS NumeroFactura,
    venta.InvoiceDate AS FechaVenta,
    customer.CustomerID AS ClienteID,
    customer.CustomerName AS NombreCliente,
    dm.DeliveryMethodID AS MetodoEntregaID,
    dm.DeliveryMethodName AS MetodoEntrega,
    SUM(lineas.ExtendedPrice) AS MontoTotal
FROM Sales.Invoices venta
INNER JOIN Sales.InvoiceLines lineas ON venta.InvoiceID = lineas.InvoiceID
LEFT JOIN Corporativo.Sales.Customers customer ON venta.CustomerID = customer.CustomerID
LEFT JOIN Application.DeliveryMethods dm ON venta.DeliveryMethodID = dm.DeliveryMethodID
GROUP BY 
    venta.InvoiceID, 
    venta.InvoiceDate, 
    customer.CustomerID, 
    customer.CustomerName,
    dm.DeliveryMethodID,
    dm.DeliveryMethodName;
GO

CREATE PROCEDURE getVentasSimple
    @FiltrarCliente NVARCHAR(100) = NULL,
    @FiltrarFechaDesde DATE = NULL,
    @FiltrarFechaHasta DATE = NULL,
    @FiltrarMontoMinimo DECIMAL(18,2) = NULL,
    @FiltrarMontoMaximo DECIMAL(18,2) = NULL,
    @FiltrarMetodoEntrega INT = NULL,
    @Pagina INT = 1,
    @FilasPorPagina INT = 25
AS
BEGIN
    SET NOCOUNT ON;

    SELECT NumeroFactura, FechaVenta, ClienteID, NombreCliente, MetodoEntregaID, MetodoEntrega, MontoTotal, COUNT(*) OVER() AS TotalFilas
    FROM vw_VentasResumen
    WHERE
        (@FiltrarCliente IS NULL OR NombreCliente LIKE '%' + @FiltrarCliente + '%')
        AND (@FiltrarFechaDesde IS NULL OR FechaVenta >= @FiltrarFechaDesde)
        AND (@FiltrarFechaHasta IS NULL OR FechaVenta <= @FiltrarFechaHasta)
        AND (@FiltrarMetodoEntrega IS NULL OR MetodoEntregaID = @FiltrarMetodoEntrega)
        AND (@FiltrarMontoMinimo IS NULL OR MontoTotal >= @FiltrarMontoMinimo)
        AND (@FiltrarMontoMaximo IS NULL OR MontoTotal <= @FiltrarMontoMaximo)
    ORDER BY NombreCliente
    OFFSET (@Pagina - 1) * @FilasPorPagina ROWS
    FETCH NEXT @FilasPorPagina ROWS ONLY;
END;
GO

CREATE PROCEDURE getEncabezadoVentaPorID
    @NumeroFactura INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        venta.InvoiceID AS NumeroFactura,
        customer.CustomerName AS NombreCliente,
        customer.CustomerID AS ClienteID,

        dm.DeliveryMethodName AS MetodoEntrega,
        venta.CustomerPurchaseOrderNumber AS NumeroOrden,
        
        p1.FullName AS PersonaContactoNombre,
        p1.EmailAddress AS PersonaContactoCorreo,
        p1.PhoneNumber AS PersonaContactoTelefono,

        vendedor.FullName AS VendedorNombre,
        vendedor.EmailAddress AS VendedorCorreo,
        venta.InvoiceDate AS FechaVenta,
        venta.DeliveryInstructions AS InstruccionesEntrega,

        SUM(lineas.TaxAmount) AS TotalImpuestos,
        SUM(lineas.ExtendedPrice) AS MontoTotal

    FROM Sales.Invoices venta
    LEFT JOIN Corporativo.Sales.Customers customer
        ON venta.CustomerID = customer.CustomerID
    LEFT JOIN Application.DeliveryMethods dm
        ON venta.DeliveryMethodID = dm.DeliveryMethodID
    LEFT JOIN Application.People p1
        ON venta.ContactPersonID = p1.PersonID
    LEFT JOIN Application.People vendedor
        ON venta.SalespersonPersonID = vendedor.PersonID
    LEFT JOIN Sales.InvoiceLines lineas
        ON venta.InvoiceID = lineas.InvoiceID
    WHERE venta.InvoiceID = @NumeroFactura
    GROUP BY 
        venta.InvoiceID,
        customer.CustomerName,
        customer.CustomerID,
        dm.DeliveryMethodName,
        venta.CustomerPurchaseOrderNumber,
        p1.FullName,
        p1.EmailAddress,
        p1.PhoneNumber,
        vendedor.FullName,
        vendedor.EmailAddress,
        venta.InvoiceDate,
        venta.DeliveryInstructions;
END;
GO

CREATE PROCEDURE getDetallesVentaPorID
    @NumeroFactura INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        lineas.StockItemID AS ProductoID,
        p.StockItemName AS NombreProducto,
        lineas.Quantity AS Cantidad,
        lineas.UnitPrice AS PrecioUnitario,
        lineas.TaxRate AS TasaImpuesto,
        lineas.TaxAmount AS Impuesto,
        lineas.ExtendedPrice AS PrecioTotal
    FROM Sales.InvoiceLines lineas
    LEFT JOIN Warehouse.StockItems p 
        ON lineas.StockItemID = p.StockItemID
    WHERE lineas.InvoiceID = @NumeroFactura;
END;
GO











-- ESTADÍSTICAS

-- #1 Estadísticas de Proveedores

CREATE VIEW vw_OrdenProveedorTotal AS
SELECT
    po.PurchaseOrderID,
    proveedor.SupplierID,
    proveedor.SupplierName,
    categorias.SupplierCategoryName,
    SUM((lineas.ExpectedUnitPricePerOuter * lineas.OrderedOuters)) AS Total
FROM Purchasing.PurchaseOrders AS po
LEFT JOIN Purchasing.PurchaseOrderLines AS lineas
    ON po.PurchaseOrderID = lineas.PurchaseOrderID
LEFT JOIN Warehouse.StockItems AS productos
    ON lineas.StockItemID = productos.StockItemID
LEFT JOIN Purchasing.Suppliers AS proveedor
    ON po.SupplierID = proveedor.SupplierID
LEFT JOIN Purchasing.SupplierCategories AS categorias
    ON proveedor.SupplierCategoryID = categorias.SupplierCategoryID
GROUP BY
    po.PurchaseOrderID,
    proveedor.SupplierID,
    proveedor.SupplierName,
    categorias.SupplierCategoryName;
GO


CREATE PROCEDURE EstadisticasProveedores
    @FiltrarTexto NVARCHAR(100) = NULL
AS
BEGIN

    SET NOCOUNT ON;

    SELECT 
        CASE
            WHEN GROUPING(orden.SupplierName) = 1 THEN 'Total General'
            ELSE orden.SupplierName
        END AS NombreProveedor,
    
        CASE
            WHEN GROUPING(orden.SupplierName) = 1 THEN ''
            WHEN GROUPING(orden.SupplierCategoryName) = 1 THEN 'Subtotal por ' + orden.SupplierName
            ELSE orden.SupplierCategoryName
        END AS Categoria,

        MAX(orden.Total) AS MontoMaximo,
        MIN(orden.Total) AS MontoMinimo,
        CAST(AVG(orden.Total) AS DECIMAL(18,2)) AS PromedioCompra,
        GROUPING(orden.SupplierName) AS EsTotalGeneral,
        GROUPING(orden.SupplierCategoryName) AS EsSubtotalPorProveedor

    FROM vw_OrdenProveedorTotal AS orden
    WHERE (@FiltrarTexto IS NULL OR orden.SupplierName LIKE '%' + @FiltrarTexto + '%'
        OR @FiltrarTexto IS NULL OR orden.SupplierCategoryName LIKE '%' + @FiltrarTexto + '%')
    GROUP BY ROLLUP (orden.SupplierName, orden.SupplierCategoryName)
    ORDER BY 
        GROUPING(orden.SupplierName);
END;
GO





-- #2 Estadísticas de Clientes



CREATE VIEW vw_OrdenClientesTotal AS
SELECT
    venta.InvoiceID,
    cliente.CustomerID,
    cliente.CustomerName,
    categorias.CustomerCategoryName,
    SUM((lineas.ExtendedPrice)) AS Total
FROM Sales.Invoices AS venta
LEFT JOIN Sales.InvoiceLines AS lineas
    ON venta.InvoiceID = lineas.InvoiceID
LEFT JOIN Corporativo.Sales.Customers AS cliente
    ON venta.CustomerID = cliente.CustomerID
LEFT JOIN Sucursal_LI.Sales.Customers AS cliente2
    ON venta.CustomerID = cliente.CustomerID
LEFT JOIN Sales.CustomerCategories AS categorias
    ON cliente2.CustomerCategoryID = categorias.CustomerCategoryID
GROUP BY
    venta.InvoiceID,
    cliente.CustomerID,
    cliente.CustomerName,
    categorias.CustomerCategoryName;
GO


CREATE PROCEDURE EstadisticasClientes
    @FiltrarTexto NVARCHAR(100) = NULL
AS
BEGIN

    SET NOCOUNT ON;

    SELECT 
        CASE
            WHEN GROUPING(orden.CustomerName) = 1 THEN 'Total General'
            ELSE orden.CustomerName
        END AS NombreCliente,

        CASE
            WHEN GROUPING(orden.CustomerName) = 1 THEN ''
            WHEN GROUPING(orden.CustomerCategoryName) = 1 THEN 'Subtotal por ' + orden.CustomerName
            ELSE orden.CustomerCategoryName
        END AS Categoria,

        MAX(orden.Total) AS MontoMaximo,
        MIN(orden.Total) AS MontoMinimo,
        CAST(AVG(orden.Total) AS DECIMAL(18,2)) AS PromedioCompra,
        GROUPING(orden.CustomerName) AS EsTotalGeneral,
        GROUPING(orden.CustomerCategoryName) AS EsSubtotalPorCliente

    FROM vw_OrdenClientesTotal AS orden
    WHERE (@FiltrarTexto IS NULL OR orden.CustomerName LIKE '%' + @FiltrarTexto + '%'
        OR @FiltrarTexto IS NULL OR orden.CustomerCategoryName LIKE '%' + @FiltrarTexto + '%')
    GROUP BY ROLLUP (orden.CustomerName, orden.CustomerCategoryName)
    ORDER BY
        GROUPING(orden.CustomerName);
END;
GO





-- #3 Estadísticas de Productos

-- LISTO
CREATE VIEW vw_RankingAnualProducts AS
SELECT 
    YEAR(venta.InvoiceDate) AS Anio,
    producto.StockItemID as ProductoID,
    producto.StockItemName as NombreProducto,
    SUM(lineas.ExtendedPrice) AS GananciaTotal,
    DENSE_RANK() OVER (
        PARTITION BY YEAR(venta.InvoiceDate)
        ORDER BY SUM(lineas.ExtendedPrice) DESC
    ) AS Ranking
FROM Sales.Invoices AS venta
INNER JOIN Sales.InvoiceLines AS lineas
    ON venta.InvoiceID = lineas.InvoiceID
INNER JOIN Warehouse.StockItems AS producto
    ON lineas.StockItemID = producto.StockItemID
GROUP BY 
    YEAR(venta.InvoiceDate),
    producto.StockItemID,
    producto.StockItemName
GO


-- LISTO
CREATE PROCEDURE getTopProductosAnuales
    @FiltrarAnio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Anio, Ranking, ProductoID, NombreProducto, GananciaTotal
    FROM vw_RankingAnualProducts
    WHERE (
        Ranking <= 5
        AND (@FiltrarAnio IS NULL OR Anio = @FiltrarAnio))
    ORDER BY Anio, Ranking;
END;
GO




-- #4 Estadísticas de top 5 de clientes con mayor cantidad de facturas emitidas y mostrar monto total

CREATE VIEW vw_RankingAnualClientesFacturas AS
SELECT 
    YEAR(venta.InvoiceDate) AS Anio,
    cliente.CustomerID as ClienteID,
    cliente.CustomerName as NombreCliente,
    SUM(lineas.ExtendedPrice) AS GananciaTotal,
    DENSE_RANK() OVER (
        PARTITION BY YEAR(venta.InvoiceDate)
        ORDER BY SUM(lineas.ExtendedPrice) DESC
    ) AS Ranking
FROM Sales.Invoices AS venta
INNER JOIN Sales.InvoiceLines AS lineas
    ON venta.InvoiceID = lineas.InvoiceID
INNER JOIN Corporativo.Sales.Customers AS cliente
    ON venta.CustomerID = cliente.CustomerID
GROUP BY 
    YEAR(venta.InvoiceDate),
    cliente.CustomerID,
    cliente.CustomerName
GO


CREATE PROCEDURE getTopClientesFacturasAnuales
    @FiltrarAnio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Anio, Ranking, ClienteID, NombreCliente, GananciaTotal
    FROM vw_RankingAnualClientesFacturas
    WHERE (
        Ranking <= 5
        AND (@FiltrarAnio IS NULL OR Anio = @FiltrarAnio))
    ORDER BY Anio, Ranking;
END;
GO




-- #5 Estadísticas de top 5 de proveedores con mayor cantidad de ordenes de compra emitidas y mostrar monto total por año

CREATE VIEW vw_RankingAnualProveedoresOrdenes AS
SELECT 
    YEAR(orden.OrderDate) AS Anio,
    proveedor.SupplierID as ProveedorID,
    proveedor.SupplierName as NombreProveedor,
    SUM(lineas.OrderedOuters*lineas.ExpectedUnitPricePerOuter) AS GananciaTotal,
    DENSE_RANK() OVER (
        PARTITION BY YEAR(orden.OrderDate)
        ORDER BY SUM(lineas.OrderedOuters*lineas.ExpectedUnitPricePerOuter) DESC
    ) AS Ranking
FROM Purchasing.Suppliers AS proveedor
INNER JOIN Purchasing.PurchaseOrders AS orden
    ON proveedor.SupplierID = orden.SupplierID
INNER JOIN Purchasing.PurchaseOrderLines AS lineas
    ON orden.PurchaseOrderID = lineas.PurchaseOrderID
GROUP BY 
    YEAR(orden.OrderDate),
    proveedor.SupplierID,
    proveedor.SupplierName
GO


CREATE PROCEDURE getTopProveedoresOrdenesAnuales
    @FiltrarAnio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Anio, Ranking, ProveedorID, NombreProveedor, GananciaTotal
    FROM vw_RankingAnualProveedoresOrdenes
    WHERE (
        Ranking <= 5
        AND (@FiltrarAnio IS NULL OR Anio = @FiltrarAnio))
    ORDER BY Anio, Ranking;
END;
GO






-- CRUD DE INVENTARIO

CREATE PROCEDURE getProveedores
AS
BEGIN
    SET NOCOUNT ON;

    SELECT SupplierID AS ID, SupplierName AS Nombre
    FROM Purchasing.Suppliers
    ORDER BY SupplierName;
END;
GO

CREATE PROCEDURE getColores
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ColorID AS ID, ColorName AS Nombre
    FROM Warehouse.Colors
    ORDER BY ColorName;
END;
GO

CREATE PROCEDURE getUnidadesEmpaquetamiento
AS
BEGIN
    SET NOCOUNT ON;

    SELECT PackageTypeID AS ID, PackageTypeName AS Nombre
    FROM Warehouse.PackageTypes
    ORDER BY PackageTypeName;
END;
GO

CREATE PROCEDURE getGruposProducto
AS
BEGIN
    SET NOCOUNT ON;

    SELECT StockGroupID AS ID, StockGroupName AS Nombre
    FROM Warehouse.StockGroups
    ORDER BY StockGroupName;
END;
GO



CREATE PROCEDURE editarStockItem
    @ProductoID INT,
    @NombreProducto NVARCHAR(255),
    @Marca NVARCHAR(255) = NULL,
    @Tamano NVARCHAR(50) = NULL,
    @ColorID INT = NULL,
    @UnidadEmpaquetamientoID INT = NULL,
    @EmpaquetamientoID INT = NULL,
    @CantidadPorEmpaquetamiento INT = NULL,
    @PrecioUnitario DECIMAL(18,2),
    @PrecioVentaRecomendado DECIMAL(18,2) = NULL,
    @TasaImpuesto FLOAT,
    @GruposProductoIDs NVARCHAR(MAX) = NULL,
    @ProveedorID INT = NULL,
    @CantidadDisponible INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Warehouse.StockItems
    SET 
        StockItemName = @NombreProducto,
        Brand = @Marca,
        Size = @Tamano,
        ColorID = @ColorID,
        UnitPackageID = @UnidadEmpaquetamientoID,
        OuterPackageID = @EmpaquetamientoID,
        QuantityPerOuter = @CantidadPorEmpaquetamiento,
        UnitPrice = @PrecioUnitario,
        RecommendedRetailPrice = @PrecioVentaRecomendado,
        TaxRate = @TasaImpuesto,
        SupplierID = @ProveedorID
    WHERE StockItemID = @ProductoID;

    IF @CantidadDisponible IS NOT NULL
    BEGIN
        UPDATE Warehouse.StockItemHoldings
        SET QuantityOnHand = @CantidadDisponible
        WHERE StockItemID = @ProductoID;
    END

    IF @GruposProductoIDs IS NOT NULL
    BEGIN
        DELETE FROM Warehouse.StockItemStockGroups 
        WHERE StockItemID = @ProductoID;

        DECLARE @Grupos TABLE (ID INT);
        INSERT INTO @Grupos (ID)
        SELECT TRY_CAST(value AS INT)
        FROM OPENJSON(@GruposProductoIDs);

        INSERT INTO Warehouse.StockItemStockGroups (StockItemID, StockGroupID)
        SELECT @ProductoID, ID FROM @Grupos;
    END

    SELECT 'Producto actualizado correctamente' AS Mensaje;
END;
GO


CREATE PROCEDURE eliminarStockItem
    @ProductoID INT
AS
BEGIN
    SET NOCOUNT ON;


    IF EXISTS (SELECT 1 FROM Sales.OrderLines WHERE StockItemID = @ProductoID)
    BEGIN
        RAISERROR('No es posible eliminar el producto, tiene órdenes asociadas.', 16, 1);
        RETURN;
    END

    DELETE FROM Warehouse.StockItemStockGroups
    WHERE StockItemID = @ProductoID;

    DELETE FROM Warehouse.StockItemTransactions
    WHERE StockItemID = @ProductoID;

    DELETE FROM Warehouse.StockItemHoldings
    WHERE StockItemID = @ProductoID;

    DELETE FROM Warehouse.StockItems
    WHERE StockItemID = @ProductoID;

    SELECT 'Producto eliminado correctamente' AS Mensaje;
END;
GO


--CREATE PROCEDURE crearStockItem
--    @StockItemName NVARCHAR(255),
--    @SupplierID INT = NULL,
--    @Brand NVARCHAR(255) = NULL,
--    @Size NVARCHAR(50) = NULL,
--    @ColorID INT = NULL,
--    @UnitPackageID INT = NULL,
--    @OuterPackageID INT = NULL,
--    @UnitPrice DECIMAL(18,2) = 0,
--    @RecommendedRetailPrice DECIMAL(18,2) = 0,
--    @TaxRate DECIMAL(5,2) = 0,
--    @TypicalWeightPerUnit DECIMAL(10,2) = 0,
--    @CustomFields NVARCHAR(MAX) = NULL
--AS
--BEGIN
--    SET NOCOUNT ON;
--
--    INSERT INTO [Warehouse].[StockItems] (
--        StockItemName,
--        SupplierID,
--        Brand,
--        Size,
--        ColorID,
--        UnitPackageID,
--        OuterPackageID,
--        UnitPrice,
--        RecommendedRetailPrice,
--        TaxRate,
--        TypicalWeightPerUnit,
--        CustomFields,
--        LeadTimeDays,
--        QuantityPerOuter,
--        IsChillerStock,
--        LastEditedBy,
--        ValidFrom,
--        ValidTo
--    )
--    VALUES (
--        @StockItemName,
--        @SupplierID,
--        @Brand,
--        @Size,
--        @ColorID,
--        @UnitPackageID,
--        @OuterPackageID,
--        @UnitPrice,
--        @RecommendedRetailPrice,
--        @TaxRate,
--        @TypicalWeightPerUnit,
--        @CustomFields,
--        0, -- LeadTimeDays
--        DEFAULT, -- QuantityPerOuter
--        DEFAULT, -- IsChillerStock
--        DEFAULT, -- LastEditedBy
--        DEFAULT, -- ValidFrom
--        DEFAULT  -- ValidTo
--    );
--
--    SELECT SCOPE_IDENTITY() AS StockItemID;
--END;
--GO


CREATE PROCEDURE sp_login
  @Usuario NVARCHAR(50),
  @Contrasena NVARCHAR(100)
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @HashGuardado VARBINARY(64);

  SELECT @HashGuardado = HashedPassword
  FROM Application.Users
  WHERE Username = @Usuario AND Active = 1;

  IF @HashGuardado IS NULL
  BEGIN
    SELECT 'Usuario no encontrado o inactivo.' AS Mensaje, 0 AS Exito;
    RETURN;
  END;

  IF @HashGuardado = HASHBYTES('SHA2_256', @Contrasena)
  BEGIN
    SELECT 'Inicio de sesión exitoso.' AS Mensaje, 1 AS Exito;
  END
  ELSE
  BEGIN
    SELECT 'Contraseña incorrecta.' AS Mensaje, 0 AS Exito;
  END;
END;
