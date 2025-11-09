import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import "../../css/DetalleCliente.css";

export default function EditarProducto() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [producto, setProducto] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [guardando, setGuardando] = useState(false);

  const [proveedores, setProveedores] = useState([]);
  const [colores, setColores] = useState([]);
  const [unidadesEmpaquetamiento, setUnidadesEmpaquetamiento] = useState([]);
  const [gruposProducto, setGruposProducto] = useState([]);

  const token = localStorage.getItem("token");

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: "smooth" });

    fetch(`http://localhost:3000/api/getProductoID/${id}`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then((res) => {
        if (!res.ok) throw new Error("No se pudo cargar la información del producto");
        return res.json();
      })
      .then((data) => {
        const prod = data[0];
        if (typeof prod.GruposProductoIDs === "string") {
            try {
                prod.GruposProductoIDs = JSON.parse(prod.GruposProductoIDs);
            } catch {
                prod.GruposProductoIDs = prod.GruposProductoIDs.split(",").map(x => parseInt(x.trim()));
            }
        }
        setProducto(prod);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });

    fetch(`http://localhost:3000/api/getTodosProveedores`)
      .then(res => res.json())
      .then(setProveedores)
      .catch(err => setError(err.message));

    fetch(`http://localhost:3000/api/getTodosColores`)
      .then(res => res.json())
      .then(setColores)
      .catch(err => setError(err.message));

    fetch(`http://localhost:3000/api/getTodasUnidadesEmpaquetamiento`)
      .then(res => res.json())
      .then(setUnidadesEmpaquetamiento)
      .catch(err => setError(err.message));

    fetch(`http://localhost:3000/api/getTodosGruposProducto`)
      .then(res => res.json())
      .then(setGruposProducto)
      .catch(err => setError(err.message));
  }, [id]);

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

  const handleGuardar = () => {
    console.log("Guardando producto:", producto);
    setGuardando(true);
    fetch(`http://localhost:3000/api/editarProducto/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(producto),
    })
      .then((res) => {
        if (!res.ok) throw new Error("Error al guardar el producto");
        return res.json();
      })
      .then(() => {
        setGuardando(false);
        navigate(`/inventarios/${id}`);
      })
      .catch((err) => {
        setError(err.message);
        setGuardando(false);
      });
  };

  if (loading) return <p>Cargando producto...</p>;
  if (error) return <p>Error: {error}</p>;
  if (!producto) return <p>No se encontró el producto.</p>;

  return !loading ? (
    <div className="cliente-detalle-container">
      <div className="cliente-detalle-header">
        <button className="btn-volver" onClick={() => navigate(-1)}>Volver</button>
        <h2>Editar Producto</h2>
      </div>

      <div className="cliente-detalle-grid">
        <div className="cliente-derecha">
          <div className="seccion">
            <h3>Información General</h3>
            <p><strong>ID:</strong> {producto.ProductoID}</p>
            <p>
              <strong>Nombre:</strong>
              <input className="inputEditarProducto" type="text" name="NombreProducto" value={producto.NombreProducto} onChange={handleChange} />
            </p>
            <p>
              <strong>Marca:</strong>
              <input className="inputEditarProducto" type="text" name="Marca" value={producto.Marca ?? ""} onChange={handleChange} />
            </p>
            <p>
              <strong>Tamaño:</strong>
              <input className="inputEditarProducto" type="text" name="Tamano" value={producto.Tamano ?? ""} onChange={handleChange} />
            </p>
            <p>
              <strong>Color:</strong>
              <select className="inputEditarProducto" name="ColorID" value={producto.ColorID ?? ""} onChange={handleChange}>
                <option value="">- Seleccione color -</option>
                {colores.map(c => (
                  <option key={c.ID} value={c.ID}>{c.Nombre}</option>
                ))}
              </select>
            </p>
            <p>
            <strong>Grupos:</strong>
            <select
                className="inputEditarProducto"
                name="GruposProductoIDs"
                multiple
                value={producto.GruposProductoIDs || []}
                onChange={handleChangeMultiple}
                size={5}
            >
                {gruposProducto.map(g => (
                <option key={g.ID} value={g.ID}>{g.Nombre}</option>
                ))}
            </select>
            </p>
            <p>
                <strong>Palabras Clave:</strong>
                <input
                    className="inputEditarProducto"
                    type="text"
                    name="PalabrasClave"
                    value={producto.PalabrasClave || ""}
                    disabled
                />
            </p>
          </div>

          <div className="seccion">
            <h3>Precios e Impuestos</h3>
            <p>
              <strong>Precio unitario:</strong>
              <input className="inputEditarProducto" type="number" step="0.01" name="PrecioUnitario" value={producto.PrecioUnitario} onChange={handleChange} />
            </p>
            <p>
              <strong>Precio venta recomendado:</strong>
              <input className="inputEditarProducto" type="number" step="0.01" name="PrecioVentaRecomendado" value={producto.PrecioVentaRecomendado ?? 0} onChange={handleChange} />
            </p>
            <p>
              <strong>Tasa de impuesto (%):</strong>
              <input className="inputEditarProducto" type="number" step="0.01" name="TasaImpuesto" value={producto.TasaImpuesto} onChange={handleChange} />
            </p>
            <p>
              <strong>Peso unitario (kg):</strong>
              <input className="inputEditarProducto" type="number" step="0.01" name="PesoUnitario" value={producto.PesoUnitario ?? 0} onChange={handleChange} />
            </p>
          </div>
        </div>

        <div className="cliente-derecha">
          <div className="seccion">
            <h3>Inventario</h3>
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
              <select className="inputEditarProducto" name="UnidadEmpaquetamientoID" value={producto.UnidadEmpaquetamientoID ?? ""} onChange={handleChange}>
                <option value="">- Seleccione unidad -</option>
                {unidadesEmpaquetamiento.map(u => (
                  <option key={u.ID} value={u.ID}>{u.Nombre}</option>
                ))}
              </select>
            </p>
            <p>
              <strong>Empaque externo:</strong>
              <select className="inputEditarProducto" name="EmpaquetamientoID" value={producto.EmpaquetamientoID ?? ""} onChange={handleChange}>
                <option value="">- Seleccione empaque -</option>
                {unidadesEmpaquetamiento.map(u => (
                  <option key={u.ID} value={u.ID}>{u.Nombre}</option>
                ))}
              </select>
            </p>
            <p>
              <strong>Ubicación en bodega:</strong>
              <input className="inputEditarProducto" type="text" name="UbicacionBodega" value={producto.UbicacionBodega ?? ""} onChange={handleChange} />
            </p>
          </div>

          <div className="seccion">
            <h3>Proveedor</h3>
            <p>
              <strong>Proveedor:</strong>
              <select className="inputEditarProducto" name="IDProveedor" value={producto.IDProveedor ?? ""} onChange={handleChange}>
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
        <button className="btn-editar" onClick={handleGuardar} disabled={guardando}>
          Guardar Cambios
        </button>
        <button className="btn-borrar" onClick={() => navigate(-1)}>Cancelar</button>
      </div>
    </div>
  ) : (<p>Cargando datos...</p>);
}
