import React, { useEffect, useState } from "react";
import "../../css/Estadisticas.css";

export default function TopProductos() {
  const [datos, setDatos] = useState([]);
  const [loading, setLoading] = useState(false);
  const [anio, setAnio] = useState(null);

  useEffect(() => {
    setLoading(true);
    let url = "http://localhost:3000/api/getRankingProductos";
    if (anio) url += `?FiltrarAnio=${anio}`;
    fetch(url)
      .then(res => res.json())
      .then(data => {
        setDatos(data);
        setLoading(false);
      })
      .catch(err => {
        console.error("Error cargando top productos:", err);
        setLoading(false);
      });
  }, [anio]);

  return (
    <div className="stats-main">
      <div className="stats-filtros">
        <input
          type="number"
          placeholder="Filtrar por año"
          value={anio || ""}
          onChange={e => setAnio(e.target.value ? Number(e.target.value) : null)}
        />
      </div>

      <div className="stats-table-container">
        {loading ? (
          <p>Cargando...</p>
        ) : datos.length === 0 ? (
          <p>No hay datos que coincidan con los filtros.</p>
        ) : (
          <table className="stats-table">
            <thead>
              <tr>
                <th>Año</th>
                <th>Ranking</th>
                <th>ID Producto</th>
                <th>Nombre Producto</th>
                <th>Ganancia Total</th>
              </tr>
            </thead>
            <tbody>
              {(() => {
                const grouped = datos.reduce((acc, row) => {
                  const anio = row.Anio ?? "Sin Año";
                  if (!acc[anio]) acc[anio] = [];
                  acc[anio].push(row);
                  return acc;
                }, {});
                const filas = [];
                Object.keys(grouped).forEach(anio => {
                  grouped[anio].forEach((row, idx) => {
                    filas.push(
                      <tr key={`${anio}-${idx}`}>
                        {idx === 0 && (
                          <td rowSpan={grouped[anio].length}>{anio}</td>
                        )}
                        <td>{row.Ranking}</td>
                        <td>{row.ProductoID}</td>
                        <td>{row.NombreProducto}</td>
                        <td>{row.GananciaTotal}</td>
                      </tr>
                    );
                  });
                });
                return filas;
              })()}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
