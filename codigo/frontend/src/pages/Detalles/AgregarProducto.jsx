import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import GruposCheckbox from "../../components/GruposCheckbox.jsx";
import "../../css/DetalleCliente.css";

export default function CrearProducto() {
  const navigate = useNavigate();
  const [producto, setProducto] = useState({
    NombreProducto: "",
    Marca: "",
    Tamano: "",
    ColorID: "",
    GruposProductoIDs: [],
    PrecioUnitario: 0,
    PrecioVentaRecomendado: 0,
    TasaImpuesto: 0,
    PesoUnitario: 0,
    CantidadDisponible: 0,
    CantidadPorEmpaquetamiento: 0,
    UnidadEmpaquetamientoID: "",
    EmpaquetamientoID: "",
    BinLocation: "",
    IDProveedor: "",
    CodigoBarras: "",
    ComentariosMarketing: "",
    ComentariosInternos: "",
    Foto: null,
    LastStocktakeQuantity: 0,
    LastCostPrice: 0,
    ReorderLevel: 0,
    TargetStockLevel: 0
  });
  const [guardando, setGuardando] = useState(false);
  const [error, setError] = useState(null);

  const [proveedores, setProveedores] = useState([]);
  const [colores, setColores] = useState([]);
  const [unidadesEmpaquetamiento, setUnidadesEmpaquetamiento] = useState([]);
  const [gruposProducto, setGruposProducto] = useState([]);



  const token = localStorage.getItem("token");

  const sesion = localStorage.getItem("sesion");
  let userData = { nombre: "Invitado", sede: "Sin sede" };

  if (sesion) {
    const datos = JSON.parse(sesion);
    const nombre = datos.usuario || "Invitado";
    let sede = datos.sede || "Sin sede";
    if (sede === "CORP") sede = "Corporativa";
    else if (sede === "SJ") sede = "San José";
    else if (sede === "LI") sede = "Limón";
    userData = { nombre, sede };
  }

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: "smooth" });

    // Cargar listas
    fetch(`http://localhost:3000/api/getTodosProveedores`, {
        headers: {
          Authorization: `Bearer ${localStorage.getItem("token")}`
        }
      })
      .then(res => res.json())
      .then(setProveedores)
      .catch(err => setError(err.message));

    fetch(`http://localhost:3000/api/getTodosColores`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then(res => res.json())
      .then(setColores)
      .catch(err => setError(err.message));

    fetch(`http://localhost:3000/api/getTodasUnidadesEmpaquetamiento`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then(res => res.json())
      .then(setUnidadesEmpaquetamiento)
      .catch(err => setError(err.message));

    fetch(`http://localhost:3000/api/getTodosGruposProducto`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then(res => res.json())
      .then(setGruposProducto)
      .catch(err => setError(err.message));
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setProducto(prev => ({ ...prev, [name]: value }));
  };

  const handleChangeMultiple = (e) => {
    const { options, name } = e.target;
    const selected = Array.from(options)
        .filter(o => o.selected)
        .map(o => parseInt(o.value));
    setProducto(prev => ({ ...prev, [name]: selected }));
  };

  const handleGuardar = (e) => {
    e.preventDefault();
    console.log("Creando producto:", producto);
    setGuardando(true);

    fetch(`http://localhost:3000/api/insertarProducto`, {
      method: "POST",
      headers: { 
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify(producto),
    })
      .then(res => {
        if (!res.ok) throw new Error("Error al crear el producto");
        return res.json();
      })
      .then(() => {
        setGuardando(false);
        navigate("/inventarios");
      })
      .catch(err => {
        setError(err.message);
        setGuardando(false);
      });
  };

  return (
    <div className="cliente-detalle-container">
      <div className="cliente-detalle-header">
        <button className="btn-volver" onClick={() => navigate(-1)}>Volver</button>
        <h2>Crear Producto</h2>
      </div>

      {error && <p style={{ color: "red" }}>Error: {error}</p>}

      <form onSubmit={handleGuardar}>
        <div className="cliente-detalle-grid">
          <div className="cliente-derecha">
            <div className="seccion">
              <h3>Información General</h3>
              <p>
                <strong>Nombre:</strong>
                <input className="inputEditarProducto" type="text" required name="NombreProducto" value={producto.NombreProducto} onChange={handleChange} />
              </p>
              <p>
                <strong>Marca:</strong>
                <input className="inputEditarProducto" type="text" required name="Marca" value={producto.Marca} onChange={handleChange} />
              </p>
              <p>
                <strong>Tamaño:</strong>
                <input className="inputEditarProducto" type="text" required name="Tamano" value={producto.Tamano} onChange={handleChange} />
              </p>
              <p>
                <strong>Peso por unidad:</strong>
                <input className="inputEditarProducto" type="text" required name="PesoUnitario" value={producto.PesoUnitario} onChange={handleChange} />
              </p>
              <p>
                <strong>Color:</strong>
                <select className="inputEditarProducto" name="ColorID" value={producto.ColorID} onChange={handleChange}>
                  <option value="">- Seleccione color -</option>
                  {colores.map(c => (
                    <option key={c.ID} value={c.ID}>{c.Nombre}</option>
                  ))}
                </select>
              </p>
              
                <strong>Grupos:</strong>
                <GruposCheckbox
                  gruposProducto={gruposProducto}
                  producto={producto}
                  setProducto={setProducto}
                />

              
            </div>

            <div className="seccion">
              <h3>Precios e Impuestos</h3>
              <p>
                <strong>Precio unitario:</strong>
                <input className="inputEditarProducto" type="number" step="0.01" name="PrecioUnitario" value={producto.PrecioUnitario} onChange={handleChange} />
              </p>
              <p>
                <strong>Precio venta recomendado:</strong>
                <input className="inputEditarProducto" type="number" step="0.01" name="PrecioVentaRecomendado" value={producto.PrecioVentaRecomendado} onChange={handleChange} />
              </p>
              <p>
                <strong>Tasa de impuesto (%):</strong>
                <input className="inputEditarProducto" type="number" step="0.01" name="TasaImpuesto" value={producto.TasaImpuesto} onChange={handleChange} />
              </p>
            </div>
          </div>

          <div className="cliente-derecha">
            <div className="seccion">
              <h3>Inventario (Sucursal {userData.sede})</h3>
              <p>
                <strong>Cantidad disponible:</strong>
                <input className="inputEditarProducto" type="number" name="CantidadDisponible" value={producto.CantidadDisponible} onChange={handleChange} />
              </p>
              <p>
                <strong>Cantidad por empaque:</strong>
                <input className="inputEditarProducto" type="number" name="CantidadPorEmpaquetamiento" value={producto.CantidadPorEmpaquetamiento} onChange={handleChange} />
              </p>
              <p>
                <strong>Unidad de empaquetamiento:</strong>
                <select className="inputEditarProducto" name="UnidadEmpaquetamientoID" value={producto.UnidadEmpaquetamientoID} onChange={handleChange}>
                  <option value="">- Seleccione unidad -</option>
                  {unidadesEmpaquetamiento.map(u => (
                    <option key={u.ID} value={u.ID}>{u.Nombre}</option>
                  ))}
                </select>
              </p>
              <p>
                <strong>Empaque externo:</strong>
                <select className="inputEditarProducto" name="EmpaquetamientoID" value={producto.EmpaquetamientoID} onChange={handleChange}>
                  <option value="">- Seleccione empaque -</option>
                  {unidadesEmpaquetamiento.map(u => (
                    <option key={u.ID} value={u.ID}>{u.Nombre}</option>
                  ))}
                </select>
              </p>
              <p>
                <strong>Ubicación en bodega:</strong>
                <input className="inputEditarProducto" type="text" required name="BinLocation" value={producto.BinLocation} onChange={handleChange} />
              </p>
            </div>

            <div className="seccion">
              <h3>Proveedor</h3>
              <p>
                <strong>Proveedor:</strong>
                <select className="inputEditarProducto" name="IDProveedor" value={producto.IDProveedor} onChange={handleChange}>
                  <option value="">- Seleccione proveedor -</option>
                  {proveedores.map(p => (
                    <option key={p.ID} value={p.ID}>{p.Nombre}</option>
                  ))}
                </select>
              </p>
            </div>
          </div>
        </div>

        <div style={{ display: "flex", justifyContent: "center", gap: "20px", marginTop: "25px" }}>
          <button type="submit" className="btn-editar" disabled={guardando}>
            Crear Producto
          </button>
          <button className="btn-borrar" onClick={() => navigate(-1)}>Cancelar</button>
        </div>
      </form>
    </div>
  );
}
