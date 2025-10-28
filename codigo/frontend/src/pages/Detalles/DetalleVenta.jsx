import { useParams, useNavigate, Link } from "react-router-dom";
import { useEffect, useState } from "react";
import { FaArrowLeft } from "react-icons/fa";
import "../../css/Ventas.css";

export default function DetalleVentas() {
  const { id } = useParams();
  const navigate = useNavigate();

  const [encabezado, setEncabezado] = useState(null);
  const [detalles, setDetalles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    setLoading(true);
    window.scrollTo({ top: 0, behavior: "smooth" });

    fetch(`http://localhost:3000/api/getEncabezadoVentaID/${id}`)
      .then((res) => {
        if (!res.ok) throw new Error("No se pudo cargar el encabezado");
        return res.json();
      })
      .then((encabezadoData) => {
        setEncabezado(encabezadoData[0]);

        return fetch(`http://localhost:3000/api/getDetallesVentaID/${id}`);
      })
      .then((res) => {
        if (!res.ok) throw new Error("No se pudo cargar los detalles");
        return res.json();
      })
      .then((detallesData) => {
        setDetalles(detallesData);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Error cargando factura:", err);
        setError(err.message);
        setLoading(false);
      });
  }, [id]);

  if (loading) return <p>Cargando factura...</p>;
  if (error) return <p>Error: {error}</p>;
  if (!encabezado) return <p>No se encontró la factura.</p>;

  const total = detalles.reduce((acc, d) => acc + d.PrecioTotal, 0);

  return (
    <div className="estilos-page">
        <div className="factura-container">
            <div className="factura-header">
                <div className="factura-empresa">
                    <h1>Factura N°{id}</h1>
                </div>
                <div className="factura-logo">
                    <img src="/src/assets/logo.png" alt="Logo" />
                </div>
            </div>

            <div className="factura-secciones">
                <div className="cliente-info subseccion-factura-info">
                    <h3>Cliente</h3>
                    <p><strong>ID:</strong> {encabezado.ClienteID}</p>
                    <p><strong>Nombre:</strong> <Link to={`/clientes/${encabezado.ClienteID}`}>{encabezado.NombreCliente}</Link></p>
                </div>

                <div className="vendedor-info subseccion-factura-info">
                    <h3>Vendedor</h3>
                    <p><strong>Nombre:</strong> {encabezado.VendedorNombre}</p>
                    <p><strong>Email:</strong> {encabezado.VendedorCorreo}</p>
                </div>
            </div>

            <div className="factura-secciones">
                <div className="metodo-entrega subseccion-factura-info">
                    <h3>Entrega</h3>
                    <p><strong>Método:</strong> {encabezado.MetodoEntrega}</p>
                    <p><strong>Instrucciones:</strong> {encabezado.InstruccionesEntrega}</p>
                </div>

                <div className="contacto-info subseccion-factura-info">
                <h3>Contacto Cliente</h3>
                    <p><strong>Nombre:</strong> {encabezado.PersonaContactoNombre}</p>
                    <p><strong>Email:</strong> {encabezado.PersonaContactoCorreo}</p>
                    <p><strong>Teléfono:</strong> {encabezado.PersonaContactoTelefono}</p>
                </div>
            </div>

            <table className="factura-table">
                <thead>
                <tr>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Precio Unitario</th>
                    <th>Impuesto</th>
                    <th>Total</th>
                </tr>
                </thead>
                <tbody>
                {detalles.map((d) => (
                    <tr key={d.ProductoID}>
                    <td><Link to={`/inventarios/${d.ProductoID}`}>{d.NombreProducto}</Link></td>
                    <td>{d.Cantidad}</td>
                    <td>{d.PrecioUnitario.toFixed(2)}</td>
                    <td>{d.Impuesto.toFixed(2)}</td>
                    <td>{d.PrecioTotal.toFixed(2)}</td>
                    </tr>
                ))}
                </tbody>
            </table>


            <div className="factura-totales">
                <button className="btn-descargar" onClick={() => window.print()}>
                    Descargar PDF
                </button>
                <div className="totales-detalle">
                    <p><span>Subtotal:</span> <span>{(encabezado.MontoTotal - encabezado.TotalImpuestos).toFixed(2)}</span></p>
                    <p><span>Total Impuestos:</span> <span>{encabezado.TotalImpuestos.toFixed(2)}</span></p>
                    <p className="factura-total"><strong>Total:</strong> <strong>{encabezado.MontoTotal.toFixed(2)}</strong></p>
                </div>
            </div>
        </div>
    </div>
  );
}
