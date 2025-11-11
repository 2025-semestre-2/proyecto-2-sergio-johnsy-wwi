const express = require('express');
const { Connection, Request, TYPES } = require('tedious');
const app = express();
const cors = require("cors");
const { config } = require('dotenv');
const jwt = require('jsonwebtoken');
const port = 3000;

app.use(express.json());
app.use(cors());

//Para Linux
const configCorp = {
    server: '172.22.193.85',
    authentication: {
        type: 'default',
        options: {
            userName: 'sa',
            password: 'Admin2323*'
        }
    },
    options: {
        database: 'Corporativo',
        encrypt: false,
        trustServerCertificate: true
    }
};

const configSucursal = {
    server: '172.22.193.85',
    authentication: {
        type: 'default',
        options: {
            userName: 'sa',
            password: 'Admin2323*'
        }
    },
    options: {
        database: 'WideWorldImporters',
        encrypt: false,
        trustServerCertificate: true
    }
};

function ejecutarSP(nombreSP, parametros, req, res, devolver = false, sede = null) {
  return new Promise((resolve, reject) => {
    const resultados = [];
    const sedeFinal = sede || (req.user ? req.user.sede : null);
    let connection = new Connection(configCorp);
    if (sedeFinal && sedeFinal !== 'CORP') {
      let configSede = { ...configSucursal };
      configSede.options.database = "Sucursal_" + sedeFinal;
      connection = new Connection(configSede);
    }

    console.log(`Ejecutando SP: ${nombreSP} en sede: ${sedeFinal || 'Corporativo'}`);

    let responded = false;

    connection.on("connect", (err) => {
      if (err) {
        console.error("Error de conexión:", err);
        if (devolver) return reject(err);
        if (!responded) {
          responded = true;
          res.status(500).json({ error: err.message });
        }
        return;
      }

      const request = new Request(nombreSP, (err) => {
        if (err) {
          console.error("Error al ejecutar el procedimiento almacenado:", err);
          connection.close();
          if (devolver) reject(err);
          else if (!responded) {
            responded = true;
            res.status(400).json({ error: err.message });
          }
        }
      });

      request.on("row", (columns) => {
        const fila = {};
        columns.forEach((col) => (fila[col.metadata.colName] = col.value));
        resultados.push(fila);
      });

      request.on("requestCompleted", () => {
        connection.close();
        if (devolver) resolve(resultados);
        else if (!responded) {
          responded = true;
          res.json(resultados);
        }
      });

      parametros.forEach((p) => request.addParameter(p[0], p[1], p[2]));
      connection.callProcedure(request);
    });

    connection.connect();
  });
}

function verificarToken(req, res, next) {
  const header = req.headers['authorization'];
  if (!header) return res.status(401).json({ mensaje: "No autorizado" });

  const token = header.split(' ')[1];
  try {
    req.user = jwt.verify(token, "clave"); // reemplazar "clave" por process.env.JWT_SECRET 
    next();
  } catch {
    res.status(403).json({ mensaje: "Token inválido" });
  }
}

app.get('/api/getClientesSimple', verificarToken, (req, res) => {
  const { FiltrarNombre, FiltrarCategoria, FiltrarMetodoEntrega } = req.query;
  const parametros = [];
  if (FiltrarNombre) parametros.push(["FiltrarNombre", TYPES.NVarChar, FiltrarNombre]);
  if (FiltrarCategoria) parametros.push(["FiltrarCategoria", TYPES.Int, Number(FiltrarCategoria)]);
  if (FiltrarMetodoEntrega) parametros.push(["FiltrarMetodoEntrega", TYPES.Int, Number(FiltrarMetodoEntrega)]);
  ejecutarSP("getClientesSimple", parametros, req, res);
});

app.get('/api/getCliente/:id', verificarToken, (req, res) => {
  const { id } = req.params;
  ejecutarSP("getClientePorID", [["CustomerID", TYPES.Int, parseInt(id)]], req, res);
});

app.get("/api/getCategoriasDeClientes", verificarToken, (req, res) => {
  ejecutarSP("getCategoriasClientes", [], req, res);
});

app.get("/api/getMetodosDeEntrega", verificarToken, (req, res) => {
  ejecutarSP("getMetodosEntrega", [], req, res);
});


// Proveedores

app.get('/api/getProveedoresSimple', verificarToken, (req, res) => {
  const { FiltrarNombre, FiltrarCategoria, FiltrarMetodoEntrega } = req.query;
  const parametros = [];
  if (FiltrarNombre) parametros.push(["FiltrarNombre", TYPES.NVarChar, FiltrarNombre]);
  if (FiltrarCategoria) parametros.push(["FiltrarCategoria", TYPES.Int, Number(FiltrarCategoria)]);
  if (FiltrarMetodoEntrega) parametros.push(["FiltrarMetodoEntrega", TYPES.Int, Number(FiltrarMetodoEntrega)]);
  ejecutarSP("getProveedoresSimple", parametros, req, res);
});

app.get('/api/getProveedor/:id', verificarToken, (req, res) => {
  const { id } = req.params;
  ejecutarSP("getProveedorPorID", [["SupplierID", TYPES.Int, parseInt(id)]], req, res);
});

app.get("/api/getCategoriasDeProveedores", (req, res) => {
  ejecutarSP("getCategoriasProveedores", [], req, res);
});


// Inventarios
app.get('/api/getProductosInventario', verificarToken, (req, res) => {
  const { FiltrarNombre, FiltrarGrupo, FiltrarCantidadMinima, FiltrarCantidadMaxima } = req.query;
  const parametros = [];
  if (FiltrarNombre) parametros.push(["FiltrarNombre", TYPES.NVarChar, FiltrarNombre]);
  if (FiltrarGrupo) parametros.push(["FiltrarGrupo", TYPES.Int, Number(FiltrarGrupo)]);
  if (FiltrarCantidadMinima) parametros.push(["FiltrarCantidadMinima", TYPES.Int, Number(FiltrarCantidadMinima)]);
  if (FiltrarCantidadMaxima) parametros.push(["FiltrarCantidadMaxima", TYPES.Int, Number(FiltrarCantidadMaxima)]);
  ejecutarSP("getInventarioSimple", parametros, req, res);
});

app.get("/api/getGruposDeProductos", verificarToken, (req, res) => {
  ejecutarSP("getGruposProductos", [], req, res);
});

app.get('/api/getProductoID/:id', verificarToken, (req, res) => {
  const { id } = req.params;
  ejecutarSP("getProductoPorID", [["ProductoID", TYPES.Int, parseInt(id)]], req, res);
});


// Ventas

app.get('/api/getEncabezadoVentaID/:id', verificarToken, (req, res) => {
  const { id } = req.params;
  ejecutarSP("getEncabezadoVentaPorID", [["NumeroFactura", TYPES.Int, parseInt(id)]], req, res);
});

app.get('/api/getDetallesVentaID/:id', verificarToken, (req, res) => {
  const { id } = req.params;
  ejecutarSP("getDetallesVentaPorID", [["NumeroFactura", TYPES.Int, parseInt(id)]], req, res);
});

app.get('/api/getVentas', verificarToken, (req, res) => {
  const { FiltrarCliente, FiltrarFechaDesde, FiltrarFechaHasta, FiltrarMetodoEntrega, FiltrarMontoMinimo, FiltrarMontoMaximo, Pagina, FilasPorPagina } = req.query;
  const parametros = [];
  if (FiltrarCliente) parametros.push(["FiltrarCliente", TYPES.NVarChar, FiltrarCliente]);
  if (FiltrarFechaDesde) parametros.push(["FiltrarFechaDesde", TYPES.DateTime, new Date(FiltrarFechaDesde)]);
  if (FiltrarFechaHasta) parametros.push(["FiltrarFechaHasta", TYPES.DateTime, new Date(FiltrarFechaHasta)]);
  if (FiltrarMetodoEntrega) parametros.push(["FiltrarMetodoEntrega", TYPES.Int, Number(FiltrarMetodoEntrega)]);
  if (FiltrarMontoMinimo) parametros.push(["FiltrarMontoMinimo", TYPES.Money, Number(FiltrarMontoMinimo)]);
  if (FiltrarMontoMaximo) parametros.push(["FiltrarMontoMaximo", TYPES.Money, Number(FiltrarMontoMaximo)]);
  if (Pagina) parametros.push(["Pagina", TYPES.Int, Number(Pagina)]);
  if (FilasPorPagina) parametros.push(["FilasPorPagina", TYPES.Int, Number(FilasPorPagina)]);
  ejecutarSP("getVentasSimple", parametros, req, res);
});


// Estadísticas

app.get('/api/getEstadisticasDeProveedores', verificarToken, (req, res) => {
  const { FiltrarTexto } = req.query;
  ejecutarSP("EstadisticasProveedores", [["FiltrarTexto", TYPES.NVarChar, FiltrarTexto || null]], req, res);
});

app.get('/api/getEstadisticasDeClientes', verificarToken, (req, res) => {
  const { FiltrarTexto, FiltrarSede } = req.query;
  ejecutarSP("EstadisticasClientes", [["FiltrarTexto", TYPES.NVarChar, FiltrarTexto || null]], req, res, false, FiltrarSede);
});

app.get('/api/getRankingProductos', verificarToken, (req, res) => {
  const { FiltrarAnio, FiltrarSede } = req.query;
  const parametros = [];
  if (FiltrarAnio) parametros.push(["FiltrarAnio", TYPES.Int, Number(FiltrarAnio)]);
  ejecutarSP("getTopProductosAnuales", parametros, req, res, false, FiltrarSede);
});

app.get('/api/getRankingClientes', verificarToken, (req, res) => {
  const { FiltrarAnio, FiltrarSede } = req.query;

  const parametros = [];
  if (FiltrarAnio) parametros.push(["FiltrarAnio", TYPES.Int, Number(FiltrarAnio)]);
  ejecutarSP("getTopClientesFacturasAnuales", parametros, req, res, false, FiltrarSede);
});

app.get('/api/getRankingProveedores', verificarToken, (req, res) => {
  const { FiltrarAnio } = req.query;
  const parametros = [];
  if (FiltrarAnio) parametros.push(["FiltrarAnio", TYPES.Int, Number(FiltrarAnio)]);
  ejecutarSP("getTopProveedoresOrdenesAnuales", parametros, req, res);
});

app.get('/api/getTodosProveedores', verificarToken, (req, res) => {
  ejecutarSP("getProveedores", [], req, res);
});

app.get('/api/getTodosColores', verificarToken, (req, res) => {
  ejecutarSP("getColores", [], req, res);
});

app.get('/api/getTodasUnidadesEmpaquetamiento', verificarToken, (req, res) => {
  ejecutarSP("getUnidadesEmpaquetamiento", [], req, res);
});

app.get('/api/getTodosGruposProducto', verificarToken, (req, res) => {
  ejecutarSP("getGruposProducto", [], req, res);
});



app.put('/api/editarProducto/:id', verificarToken, (req, res) => {
  const { id } = req.params;
  const {
    NombreProducto,
    IDProveedor,
    Marca,
    Tamano,
    ColorID,
    UnidadEmpaquetamientoID,
    EmpaquetamientoID,
    CantidadPorEmpaquetamiento,
    PrecioUnitario,
    PrecioVentaRecomendado,
    TasaImpuesto,
    CantidadDisponible,
    GruposProductoIDs
  } = req.body;
  if ([NombreProducto, PrecioUnitario, TasaImpuesto].includes(undefined) || NombreProducto.trim() === "") {
    return res.status(400).json({ error: 'Faltan campos obligatorios o están vacíos' });
  }
  const gruposProductoStr = Array.isArray(GruposProductoIDs) ? JSON.stringify(GruposProductoIDs) : null;

  const parametros = [
    ["ProductoID", TYPES.Int, parseInt(id)],
    ["NombreProducto", TYPES.NVarChar, NombreProducto],
    ["ProveedorID", TYPES.Int, IDProveedor || null],
    ["Marca", TYPES.NVarChar, Marca || null],
    ["Tamano", TYPES.NVarChar, Tamano || null],
    ["ColorID", TYPES.Int, ColorID || null],
    ["UnidadEmpaquetamientoID", TYPES.Int, UnidadEmpaquetamientoID || null],
    ["EmpaquetamientoID", TYPES.Int, EmpaquetamientoID || null],
    ["CantidadPorEmpaquetamiento", TYPES.Int, CantidadPorEmpaquetamiento || null],
    ["PrecioUnitario", TYPES.Money, PrecioUnitario],
    ["PrecioVentaRecomendado", TYPES.Money, PrecioVentaRecomendado || null],
    ["TasaImpuesto", TYPES.Float, TasaImpuesto],
    ["CantidadDisponible", TYPES.Int, CantidadDisponible || null],
    ["GruposProductoIDs", TYPES.NVarChar, gruposProductoStr]
  ]; 
  ejecutarSP("editarStockItem", parametros, req, res);
});


app.delete('/api/eliminarProducto/:id', verificarToken, (req, res) => {
  const { id } = req.params;
  ejecutarSP("eliminarStockItem", [["ProductoID", TYPES.Int, parseInt(id)]], req, res);
});


app.post('/api/insertarProducto', verificarToken, async (req, res) => {
  const {
    NombreProducto,
    IDProveedor,
    Marca,
    Tamano,
    ColorID,
    UnidadEmpaquetamientoID,
    EmpaquetamientoID,
    CantidadPorEmpaquetamiento,
    PrecioUnitario,
    PrecioVentaRecomendado,
    TasaImpuesto,
    PesoUnitario,
    CantidadDisponible,
    GruposProductoIDs,
    CodigoBarras,
    ComentariosMarketing,
    ComentariosInternos,
    Foto,
    // Inventario:
    StockItemID,  
    BinLocation, 
    LastStocktakeQuantity, 
    LastCostPrice, 
    ReorderLevel, 
    TargetStockLevel
  } = req.body;

  if ([NombreProducto, PrecioUnitario, TasaImpuesto].includes(undefined) || NombreProducto.trim() === "") {
    console.log("Faltan campos obligatorios o están vacíos");
    return res.status(400).json({ error: 'Faltan campos obligatorios o están vacíos' });
  }

  let gruposProductoStr = null
  if (GruposProductoIDs != [] && GruposProductoIDs != null) {
    gruposProductoStr = GruposProductoIDs.join(",")
  }

  const parametros = [
    ["StockItemName", TYPES.NVarChar, NombreProducto],
    ["SupplierID", TYPES.Int, IDProveedor || null],
    ["Brand", TYPES.NVarChar, Marca || null],
    ["Size", TYPES.NVarChar, Tamano || null],
    ["ColorID", TYPES.Int, ColorID || null],
    ["UnitPackageID", TYPES.Int, UnidadEmpaquetamientoID || null],
    ["OuterPackageID", TYPES.Int, EmpaquetamientoID || null],
    ["UnitPrice", TYPES.Money, PrecioUnitario],
    ["RecommendedRetailPrice", TYPES.Money, PrecioVentaRecomendado || 0],
    ["TaxRate", TYPES.Float, TasaImpuesto || 0],
    ["TypicalWeightPerUnit", TYPES.Float, PesoUnitario || 0],
    ["CustomFields", TYPES.NVarChar, "{}"],
    ["QuantityPerOuter", TYPES.Int, CantidadPorEmpaquetamiento || null],
    ["Barcode", TYPES.NVarChar, CodigoBarras || null],
    ["MarketingComments", TYPES.NVarChar, ComentariosMarketing || null],
    ["InternalComments", TYPES.NVarChar, ComentariosInternos || null],
    ["Photo", TYPES.VarBinary, Foto || null],
    ["GruposID", TYPES.NVarChar, gruposProductoStr],
    ["LastEditedBy", TYPES.Int, 1 || null]
  ];

  const resultado1 = await ejecutarSP("crearStockItem", parametros, req, res, true);

  const parametrosInventario = [
    ["StockItemID", TYPES.Int, resultado1[0]?.StockItemID || StockItemID],
    ["QuantityOnHand", TYPES.Int, CantidadDisponible || 0],
    ["BinLocation", TYPES.NVarChar, BinLocation || null],
    ["LastStocktakeQuantity", TYPES.Int, LastStocktakeQuantity || 0],
    ["LastCostPrice", TYPES.Money, LastCostPrice || 0],
    ["ReorderLevel", TYPES.Int, ReorderLevel || 0],
    ["TargetStockLevel", TYPES.Int, TargetStockLevel || 0],
    ["LastEditedBy", TYPES.Int, 1 || null],
    ["Branch", TYPES.NVarChar, req.body.sede || "SJ"]
  ];
  
  const resultado2 = await ejecutarSP("crearInventarioProducto", parametrosInventario, req, res, true);

  res.json({ Mensaje: "Producto creado correctamente", ProductoID: resultado1[0]?.NewStockItemID, InventarioID: resultado2[0]?.NewInventoryID });

});


app.post('/api/login', async (req, res) => {
  const { usuario, password, sede } = req.body;

  try {
    const parametros = [
      ["Usuario", TYPES.NVarChar, usuario],
      ["Contrasena", TYPES.NVarChar, password]
    ];

    const resultado = await ejecutarSP("sp_login", parametros, req, res, true, sede);
    console.log("Resultado de login:", resultado);

    if (!resultado || resultado.length === 0 || resultado[0].Exito !== 1)
      return res.status(401).json({ mensaje: resultado[0].Mensaje || "Credenciales inválidas" });

    const token = jwt.sign({ usuario, sede }, "clave", { expiresIn: "8h" }); // reemplazar "clave" por process.env.JWT_SECRET
    res.json({ mensaje: "Autenticación exitosa", token });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error en el servidor" });
  }
});


app.listen(port, () => {
  console.log(`Servidor iniciado en http://localhost:${port}`);
});