import { useEffect, useState } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { FaArrowLeft, FaEdit, FaTrash } from "react-icons/fa";
import "../../css/DetalleCliente.css";

export default function DetalleInventario() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [producto, setProducto] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [mostrarModal, setMostrarModal] = useState(false);
  const [borrando, setBorrando] = useState(false);

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: "smooth" });
    fetch(`http://localhost:3000/api/getProductoID/${id}`)
      .then((res) => {
        if (!res.ok) throw new Error("No se pudo cargar la información del producto");
        return res.json();
      })
      .then((data) => {
        setProducto(data[0]);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });
  }, [id]);

  const handleEliminar = async (productoID) => {
    setBorrando(true);
    try {
      const res = await fetch(`http://localhost:3000/api/eliminarProducto/${productoID}`, {
        method: "DELETE",
      });
      const data = await res.json();

      if (!res.ok) {
        throw new Error(data?.error || "Error al eliminar el producto");
      }
      alert(data?.Mensaje || "Producto eliminado correctamente ✅");
      navigate("/inventarios");
    } catch (err) {
      alert(err.message);
    } finally {
      setBorrando(false);
      setMostrarModal(false);
    }
  };

  if (loading) return <p>Cargando producto...</p>;
  if (error) return <p>Error: {error}</p>;
  if (!producto) return <p>No se encontró el producto.</p>;

  return (
    <div className="cliente-detalle-container">
      {/* Header */}
      <div className="cliente-detalle-header">
        <Link to="/inventarios" className="btn-volver">
          <FaArrowLeft /> Volver
        </Link>
        <h2>{producto.NombreProducto}</h2>
      </div>

      <div className="cliente-detalle-grid">
        <div className="cliente-derecha">
          <div className="seccion">
            <h3>Información General</h3>
            <p><strong>ID:</strong> {producto.ProductoID}</p>
            <p><strong>Marca:</strong> {producto.Marca ?? "-"}</p>
            <p><strong>Tamaño:</strong> {producto.Tamano ?? "-"}</p>
            <p className="textoColor">
              <strong>Color:</strong> {producto?.Color ?? "-"}{" "}
              {producto?.Color && (
                <span
                  className="circuloColor"
                  style={{ backgroundColor: producto?.Color?.toLowerCase() }}
                ></span>
              )}
            </p>
            <p><strong>Grupos:</strong> {producto.GruposProducto ?? "-"}</p>
            <p><strong>Palabras Clave:</strong> {producto.PalabrasClave ?? "-"}</p>
          </div>

          <div className="seccion">
            <h3>Precios e Impuestos</h3>
            <p><strong>Precio unitario:</strong> ₡{producto.PrecioUnitario.toFixed(2)}</p>
            <p><strong>Precio venta recomendado:</strong> ₡{producto.PrecioVentaRecomendado?.toFixed(2)}</p>
            <p><strong>Tasa de impuesto:</strong> {producto.TasaImpuesto}%</p>
            <p><strong>Peso unitario:</strong> {producto.PesoUnitario ?? "-"} kg</p>
          </div>
        </div>

        <div className="cliente-derecha">
          <div className="seccion">
            <h3>Inventario</h3>
            <p><strong>Cantidad disponible:</strong> {producto.CantidadDisponible}</p>
            <p><strong>Cantidad por empaque:</strong> {producto.CantidadPorEmpaquetamiento}</p>
            <p><strong>Unidad de empaquetamiento:</strong> {producto.UnidadEmpaquetamiento ?? "-"}</p>
            <p><strong>Empaque externo:</strong> {producto.Empaquetamiento ?? "-"}</p>
            <p><strong>Ubicación en bodega:</strong> {producto.UbicacionBodega ?? "-"}</p>
          </div>

          <div className="seccion">
            <h3>Proveedor</h3>
            <p><strong>ID del Proveedor:</strong> {producto.IDProveedor}</p>
            <p>
              <strong>Nombre:</strong>{" "}
              <Link to={`/proveedores/${producto.IDProveedor}`} className="cliente-link">
                {producto.NombreProveedor}
              </Link>
            </p>
          </div>

          <div className="seccion-botones">
            <Link to={`/inventarios/editar/${producto.ProductoID}`} className="btn-editar">
              <FaEdit style={{ marginRight: "6px" }} /> Editar
            </Link>
            <button className="btn-borrar" onClick={() => setMostrarModal(true)}>
              <FaTrash style={{ marginRight: "6px" }} /> Borrar
            </button>
          </div>
        </div>
      </div>

      {/* 🧩 Modal de confirmación */}
      {mostrarModal && (
        <div className="modal-fondo">
          <div className="modal-contenido">
            <h3>¿Seguro que quieres eliminar este producto?</h3>
            <p>Esta acción no se puede deshacer.</p>
            <div className="modal-botones">
              <button
                className="btn-cancelar"
                onClick={() => setMostrarModal(false)}
                disabled={borrando}
              >
                Cancelar
              </button>
              <button
                className="btn-borrar"
                onClick={() => handleEliminar(producto.ProductoID)}
                disabled={borrando}
              >
                {borrando ? "Eliminando..." : "Sí, eliminar"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
