import { useParams, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import { FaArrowLeft } from "react-icons/fa";
import "../../css/DetalleCliente.css";
import "../../css/DetalleProveedor.css";

export default function DetalleProveedor() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [proveedor, setProveedor] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    setLoading(true);
    window.scrollTo({ top: 0, behavior: "smooth" });
    fetch(`http://localhost:3000/api/getProveedor/${id}`)
      .then((res) => {
        if (!res.ok) throw new Error("No se pudo cargar el proveedor");
        return res.json();
      })
      .then((data) => {
        setProveedor(data[0]);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Error cargando proveedor:", err);
        setError(err.message);
        setLoading(false);
      });
  }, [id]);

  if (loading) return <p>Cargando datos del proveedor...</p>;
  if (error) return <p>Error: {error}</p>;
  if (!proveedor) return <p>No se encontró el proveedor.</p>;

  return (
    <div className="cliente-detalle-container">
      <div className="cliente-detalle-header">
        <button className="btn-volver" onClick={() => navigate(-1)}>
          <FaArrowLeft /> Volver
        </button>
        <h2>Detalle del Proveedor</h2>
      </div>

      <div className="cliente-detalle-grid">
        {/* Izquierda */}
        <div className="cliente-info">
          <div className="seccion">
            <h3>Información General</h3>
            <p><strong>ID:</strong> {proveedor.IDProveedor ?? "-"}</p>
            <p><strong>Código:</strong> {proveedor.CodigoProveedor ?? "-"}</p>
            <p><strong>Nombre:</strong> {proveedor.NombreProveedor ?? "-"}</p>
            <p><strong>Categoría:</strong> {proveedor.Categoria ?? "-"}</p>
          </div>

          <div className="seccion">
            <h3>Contacto Principal</h3>
            <p><strong>Teléfono:</strong> {proveedor.Telefono ?? "-"}</p>
            <p><strong>Persona encargada:</strong> {proveedor.ContactoPrimario ?? "-"}</p>
            <p><strong>Fax:</strong> {proveedor.Fax ?? "-"}</p>
            <p><strong>Días para Pagar:</strong> {proveedor.DiasParaPagar ?? "-"}</p>
            <p><strong>Sitio Web:</strong> {proveedor.SitioWeb ? <a href={proveedor.SitioWeb} target="_blank" rel="noopener noreferrer">{proveedor.SitioWeb}</a> : "-"}</p>
          </div>

          <div className="seccion">
            <h3>Contacto Alternativo</h3>
            <p><strong>Nombre:</strong> {proveedor.ContactoAlternativo ?? "-"}</p>
            <p><strong>Teléfono:</strong> {proveedor.ContactoAlternativoTelefono ?? "-"}</p>
            <p><strong>Correo:</strong> {proveedor.ContactoAlternativoCorreo ?? "-"}</p>
          </div>

          <div className="seccion">
            <h3>Datos Bancarios</h3>
            <p><strong>Nombre del Banco:</strong> {proveedor.NombreBanco ?? "-"}</p>
            <p><strong>Número de Cuenta Corriente:</strong> {proveedor.NumeroCuentaCorriente ?? "-"}</p>
          </div>

          
        </div>

        <div className="cliente-derecha">
          {proveedor.Latitud && proveedor.Longitud && (
            <div className="proveedor-mapa">
              <iframe
                title="Mapa del Proveedor"
                src={`https://www.google.com/maps?q=${proveedor.Latitud},${proveedor.Longitud}&output=embed`}
                width="100%"
                height="100%"
                style={{ border: 0, borderRadius: "12px" }}
                allowFullScreen
                loading="lazy"
              ></iframe>
            </div>
          )}

          <div className="seccion direccion">
            <h3>Dirección y Entrega</h3>
            <p><strong>Método de Entrega:</strong> {proveedor.MetodoEntrega ?? "-"}</p>
            <p><strong>Dirección de Entrega:</strong> {proveedor.DireccionEntrega ?? "-"}</p>
            <p><strong>Dirección Postal:</strong> {proveedor.DireccionPostal ?? "-"}</p>
            <p><strong>Ciudad:</strong> {proveedor.CiudadEntrega ?? "-"}</p>
            <p><strong>Provincia:</strong> {proveedor.Provincia ?? "-"}</p>
            <p><strong>País:</strong> {proveedor.Pais ?? "-"}</p>
            <p><strong>Código Postal:</strong> {proveedor.CodigoPostal ?? "-"}</p>
          </div>
        </div>
      </div>
    </div>
  );
}
