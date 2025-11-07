const express = require('express');
const { Connection, Request, TYPES } = require('tedious');
const app = express();
const cors = require("cors");
const port = 3000;

app.use(express.json());
app.use(cors());

//Para Linux
const config = {
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
  
function ejecutarSP(nombreSP, parametros, res) {
  const resultados = [];
  const connection = new Connection(config);
  let responded = false; // <-- evita doble envío

  connection.on('connect', (err) => {
    if (err) {
      console.error("Error de conexión:", err);
      if (!responded) {
        responded = true;
        console.error("Error de conexión:", err);
        return res.status(500).json({ error: err.message });
      }
    }

    const request = new Request(nombreSP, (err) => {
      if (err && !responded) {
        responded = true;
        console.error("Error al ejecutar el procedimiento almacenado:", err);
        connection.close();
        return res.status(400).json({ error: err.message });
      }
    });

    request.on('row', (columns) => {
      const fila = {};
      columns.forEach((col) => {
        fila[col.metadata.colName] = col.value;
      });
      resultados.push(fila);
    });

    request.on('requestCompleted', () => {
      if (!responded) {
        responded = true;
        connection.close();
        res.json(resultados);
      }
    });

    parametros.forEach(param => {
      request.addParameter(param[0], param[1], param[2]);
    });

    connection.callProcedure(request);
  });

  connection.connect();
}


app.get('/api/getClientesSimple', (req, res) => {
  const { FiltrarNombre, FiltrarCategoria, FiltrarMetodoEntrega } = req.query;
  const parametros = [];
  if (FiltrarNombre) parametros.push(["FiltrarNombre", TYPES.NVarChar, FiltrarNombre]);
  if (FiltrarCategoria) parametros.push(["FiltrarCategoria", TYPES.Int, Number(FiltrarCategoria)]);
  if (FiltrarMetodoEntrega) parametros.push(["FiltrarMetodoEntrega", TYPES.Int, Number(FiltrarMetodoEntrega)]);
  ejecutarSP("getClientesSimple", parametros, res);
});

app.get('/api/getCliente/:id', (req, res) => {
  const { id } = req.params;
  ejecutarSP("getClientePorID", [["CustomerID", TYPES.Int, parseInt(id)]], res);
});

app.get("/api/getCategoriasDeClientes", (req, res) => {
  ejecutarSP("getCategoriasClientes", [], res);
});

app.get("/api/getMetodosDeEntrega", (req, res) => {
  ejecutarSP("getMetodosEntrega", [], res);
});


// Proveedores

app.get('/api/getProveedoresSimple', (req, res) => {
  const { FiltrarNombre, FiltrarCategoria, FiltrarMetodoEntrega } = req.query;
  const parametros = [];
  if (FiltrarNombre) parametros.push(["FiltrarNombre", TYPES.NVarChar, FiltrarNombre]);
  if (FiltrarCategoria) parametros.push(["FiltrarCategoria", TYPES.Int, Number(FiltrarCategoria)]);
  if (FiltrarMetodoEntrega) parametros.push(["FiltrarMetodoEntrega", TYPES.Int, Number(FiltrarMetodoEntrega)]);
  ejecutarSP("getProveedoresSimple", parametros, res);
});

app.get('/api/getProveedor/:id', (req, res) => {
  const { id } = req.params;
  ejecutarSP("getProveedorPorID", [["SupplierID", TYPES.Int, parseInt(id)]], res);
});

app.get("/api/getCategoriasDeProveedores", (req, res) => {
  ejecutarSP("getCategoriasProveedores", [], res);
});


// Inventarios
app.get('/api/getProductosInventario', (req, res) => {
  const { FiltrarNombre, FiltrarGrupo, FiltrarCantidadMinima, FiltrarCantidadMaxima } = req.query;
  const parametros = [];
  if (FiltrarNombre) parametros.push(["FiltrarNombre", TYPES.NVarChar, FiltrarNombre]);
  if (FiltrarGrupo) parametros.push(["FiltrarGrupo", TYPES.Int, Number(FiltrarGrupo)]);
  if (FiltrarCantidadMinima) parametros.push(["FiltrarCantidadMinima", TYPES.Int, Number(FiltrarCantidadMinima)]);
  if (FiltrarCantidadMaxima) parametros.push(["FiltrarCantidadMaxima", TYPES.Int, Number(FiltrarCantidadMaxima)]);
  ejecutarSP("getInventarioSimple", parametros, res);
});

app.get("/api/getGruposDeProductos", (req, res) => {
  ejecutarSP("getGruposProductos", [], res);
});

app.get('/api/getProductoID/:id', (req, res) => {
  const { id } = req.params;
  ejecutarSP("getProductoPorID", [["ProductoID", TYPES.Int, parseInt(id)]], res);
});


// Ventas

app.get('/api/getEncabezadoVentaID/:id', (req, res) => {
  const { id } = req.params;
  ejecutarSP("getEncabezadoVentaPorID", [["NumeroFactura", TYPES.Int, parseInt(id)]], res);
});

app.get('/api/getDetallesVentaID/:id', (req, res) => {
  const { id } = req.params;
  ejecutarSP("getDetallesVentaPorID", [["NumeroFactura", TYPES.Int, parseInt(id)]], res);
});

app.get('/api/getVentas', (req, res) => {
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
  ejecutarSP("getVentasSimple", parametros, res);
});


// Estadísticas

app.get('/api/getEstadisticasDeProveedores', (req, res) => {
  const { FiltrarTexto } = req.query;
  ejecutarSP("EstadisticasProveedores", [["FiltrarTexto", TYPES.NVarChar, FiltrarTexto || null]], res);
});

app.get('/api/getEstadisticasDeClientes', (req, res) => {
  const { FiltrarTexto } = req.query;
  ejecutarSP("EstadisticasClientes", [["FiltrarTexto", TYPES.NVarChar, FiltrarTexto || null]], res);
});

app.get('/api/getRankingProductos', (req, res) => {
  const { FiltrarAnio } = req.query;
  const parametros = [];
  if (FiltrarAnio) parametros.push(["FiltrarAnio", TYPES.Int, Number(FiltrarAnio)]);
  ejecutarSP("getTopProductosAnuales", parametros, res);
});

app.get('/api/getRankingClientes', (req, res) => {
  const { FiltrarAnio } = req.query;
  const parametros = [];
  if (FiltrarAnio) parametros.push(["FiltrarAnio", TYPES.Int, Number(FiltrarAnio)]);
  ejecutarSP("getTopClientesFacturasAnuales", parametros, res);
});

app.get('/api/getRankingProveedores', (req, res) => {
  const { FiltrarAnio } = req.query;
  const parametros = [];
  if (FiltrarAnio) parametros.push(["FiltrarAnio", TYPES.Int, Number(FiltrarAnio)]);
  ejecutarSP("getTopProveedoresOrdenesAnuales", parametros, res);
});

app.get('/api/getTodosProveedores', (req, res) => {
  ejecutarSP("getProveedores", [], res);
});

app.get('/api/getTodosColores', (req, res) => {
  ejecutarSP("getColores", [], res);
});

app.get('/api/getTodasUnidadesEmpaquetamiento', (req, res) => {
  ejecutarSP("getUnidadesEmpaquetamiento", [], res);
});

app.get('/api/getTodosGruposProducto', (req, res) => {
  ejecutarSP("getGruposProducto", [], res);
});



app.put('/api/editarProducto/:id', (req, res) => {
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
  ejecutarSP("editarStockItem", parametros, res);
});


app.delete('/api/eliminarProducto/:id', (req, res) => {
  const { id } = req.params;
  ejecutarSP("eliminarStockItem", [["ProductoID", TYPES.Int, parseInt(id)]], res);
});


app.post('/api/insertarProducto', (req, res) => {
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
    console.log("Faltan campos obligatorios o están vacíos");
    return res.status(400).json({ error: 'Faltan campos obligatorios o están vacíos' });
  }
  const gruposProductoStr = Array.isArray(GruposProductoIDs) ? JSON.stringify({ grupos: GruposProductoIDs }) : null;

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
    ["TypicalWeightPerUnit", TYPES.Float, 0], // si no lo tienes, default 0
    ["CustomFields", TYPES.NVarChar, gruposProductoStr]
  ];

  ejecutarSP("crearStockItem", parametros, res);
});


app.listen(port, () => {
  console.log(`Servidor iniciado en http://localhost:${port}`);
});