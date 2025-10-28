import React, { useEffect, useState } from "react";
import "../../css/Estadisticas.css";

export default function EstadisticasProveedores() {
  const [datos, setDatos] = useState([]);
  const [loading, setLoading] = useState(false);
  const [filtroTexto, setFiltroTexto] = useState("");

  const fetchDatos = (filtro = "") => {
    setLoading(true);
    fetch(`http://localhost:3000/api/getEstadisticasDeProveedores?FiltrarTexto=${encodeURIComponent(filtro)}`)
      .then(res => res.json())
      .then(data => {
        setDatos(data);
        setLoading(false);
      })
      .catch(err => {
        console.error("Error cargando estadísticas proveedores:", err);
        setLoading(false);
      });
  };

  useEffect(() => {
    fetchDatos(filtroTexto);
  }, [filtroTexto]);

  return (
    <div className="stats-main">
      <div className="stats-table-container">
        {loading ? <p>Cargando...</p> : (
          <>
            <div className="filtro-texto" style={{ marginBottom: "10px" }}>
              <input
                type="text"
                placeholder="Filtrar por proveedor o categoría..."
                value={filtroTexto}
                onChange={(e) => setFiltroTexto(e.target.value)}
              />
            </div>

            <table className="stats-table">
              <thead>
                <tr>
                  <th>Proveedor</th>
                  <th>Categoría</th>
                  <th>Monto Máximo</th>
                  <th>Monto Mínimo</th>
                  <th>Promedio Compra</th>
                </tr>
              </thead>
              <tbody>
                {datos.map((row, idx) => (
                  <tr key={idx}>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorProveedor ? "subtotal-tabla" : ""}>{row.NombreProveedor}</td>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorProveedor ? "subtotal-tabla" : ""}>{row.Categoria}</td>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorProveedor ? "subtotal-tabla" : ""}>{row.MontoMaximo}</td>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorProveedor ? "subtotal-tabla" : ""}>{row.MontoMinimo}</td>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorProveedor ? "subtotal-tabla" : ""}>{row.PromedioCompra}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </>
        )}
      </div>
    </div>
  );
}
