// TopClientes.jsx
import React, { useEffect, useState } from "react";
import { FaSearch } from "react-icons/fa";
import "../../css/Estadisticas.css";

export default function TopClientes() {
  const [datos, setDatos] = useState([]);
  const [loading, setLoading] = useState(false);
  const [anio, setAnio] = useState(null);
  const [sede, setSede] = useState("");

  const token = localStorage.getItem("token");
  const sesion = localStorage.getItem("sesion");

  useEffect(() => {
    setLoading(true);
    let url = "http://localhost:3000/api/getRankingClientes";
    if (anio) url += `?FiltrarAnio=${anio}`;
    if (sede) url += anio ? `&FiltrarSede=${sede}` : `?FiltrarSede=${sede}`;

    fetch(url, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then((res) => res.json())
      .then((data) => {
        setDatos(data);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Error cargando top clientes:", err);
        setLoading(false);
      });
  }, [anio, sede]);

  return (
    <div className="stats-main">
      <div className="stats-filtros">
        <div className="filtro-especial" style={{ marginBottom: "10px" }}>
          <FaSearch className="icono-busqueda" />
          <input
            type="number"
            placeholder="Filtrar por año"
            value={anio || ""}
            onChange={(e) => setAnio(e.target.value ? Number(e.target.value) : null)}
          />
          
          { sesion && JSON.parse(sesion).sede === "CORP" && (
            <select
              className="filtro-sede"
              name=""
              id=""
              value={sede}
              onChange={(e) => setSede(e.target.value)}
            >
              <option value="">Todos</option>
              <option value="SJ">San José</option>
              <option value="LI">Limón</option>
            </select>
          )}
        </div>
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
                <th>ID Cliente</th>
                <th>Nombre Cliente</th>
                <th>Ganancia Total</th>
              </tr>
            </thead>
            <tbody>
              {(() => {
                // Agrupar por año
                const grouped = datos.reduce((acc, row) => {
                  const anio = row.Anio ?? "Sin Año";
                  if (!acc[anio]) acc[anio] = [];
                  acc[anio].push(row);
                  return acc;
                }, {});

                const filas = [];
                Object.keys(grouped).forEach((anio) => {
                  grouped[anio].forEach((row, idx) => {
                    filas.push(
                      <tr key={`${anio}-${idx}`}>
                        {idx === 0 && (
                          <td rowSpan={grouped[anio].length}>{anio}</td>
                        )}
                        <td>{row.Ranking}</td>
                        <td>{row.ClienteID}</td>
                        <td>{row.NombreCliente}</td>
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
