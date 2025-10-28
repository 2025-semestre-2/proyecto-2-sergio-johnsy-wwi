import { useParams, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import { FaArrowLeft } from "react-icons/fa";
import "../../css/DetalleCliente.css";

export default function DetalleCliente() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [cliente, setCliente] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    setLoading(true);
    window.scrollTo({ top: 0, behavior: "smooth" });
    fetch(`http://localhost:3000/api/getCliente/${id}`)
      .then((res) => {
        if (!res.ok) throw new Error("No se pudo cargar el cliente");
        return res.json();
      })
      .then((data) => {
        setCliente(data[0]);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Error cargando cliente:", err);
        setError(err.message);
        setLoading(false);
      });
  }, [id]);

  if (loading) return <p>Cargando datos del cliente...</p>;
  if (error) return <p>Error: {error}</p>;
  if (!cliente) return <p>No se encontró el cliente.</p>;

  return (
    <div className="cliente-detalle-container">
      <div className="cliente-detalle-header"> 
        <button className="btn-volver" onClick={() => navigate(-1)}>
          <FaArrowLeft /> Volver
        </button>

        <h2>Detalle del Cliente</h2>
      </div>

      <div className="cliente-detalle-grid">
        {/* Izquierda: info */}
        <div className="cliente-info">
          <div className="seccion">
            <h3>Información General</h3>
            <p><strong>ID:</strong> {cliente.CustomerID ?? "-"}</p>
            <p><strong>Nombre:</strong> {cliente.NombreCliente ?? "-"}</p>
            <p><strong>Categoría:</strong> {cliente.Categoria ?? "-"}</p>
            <p><strong>Grupo de Compra:</strong> {cliente.GrupoCompra ?? "-"}</p>
          </div>

          <div className="seccion">
            <h3>Contactos</h3>
            <p><strong>Contacto Primario:</strong> {cliente.ContactoPrimario ?? "-"}</p>
            <p><strong>Contacto Alternativo:</strong> {cliente.ContactoAlternativo ?? "-"}</p>
            <p><strong>Cliente a facturar:</strong> {cliente.NombreClienteFacturar ?? "-"}</p>
          </div>

          

          <div className="seccion">
            <h3>Contacto Adicional</h3>
            <p><strong>Teléfono:</strong> {cliente.Telefono ?? "-"}</p>
            <p><strong>Fax:</strong> {cliente.Fax ?? "-"}</p>
            <p><strong>Días para Pagar:</strong> {cliente.DiasParaPagar ?? "-"}</p>
            <p><strong>Sitio Web:</strong> {cliente.SitioWeb ? <a href={cliente.SitioWeb} target="_blank" rel="noopener noreferrer">{cliente.SitioWeb}</a> : "-"}</p>
          </div>
        </div>

        <div className="cliente-derecha">
            {cliente.Latitud && cliente.Longitud && (
                <div className="cliente-mapa">
                    <iframe
                    title="Mapa del Cliente"
                    src={`https://www.google.com/maps?q=${cliente.Latitud},${cliente.Longitud}&output=embed`}
                    width="100%"
                    height="100%"
                    style={{ border: 0, borderRadius: '12px' }}
                    allowFullScreen
                    loading="lazy"
                    ></iframe>
                </div>
            )}

            <div className="seccion direccion">
                <h3>Dirección y Entrega</h3>
                <p><strong>Método de Entrega:</strong> {cliente.MetodoEntrega}</p>
                <p><strong>Dirección de Entrega:</strong> {cliente.DireccionEntrega}</p>
                <p><strong>Dirección Postal:</strong> {cliente.DireccionPostal}</p>
                <p><strong>Ciudad:</strong> {cliente.CiudadEntrega}</p>
                <p><strong>Provincia:</strong> {cliente.Provincia}</p>
                <p><strong>País:</strong> {cliente.Pais}</p>
                <p><strong>Código Postal:</strong> {cliente.CodigoPostal}</p>
            </div>
        </div>
      </div>
    </div>
  );
}
