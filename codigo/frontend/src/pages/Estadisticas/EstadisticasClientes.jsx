// EstadisticasClientes.jsx
import React, { useEffect, useState } from "react";
import { FaSearch } from "react-icons/fa";
import "../../css/Estadisticas.css";

export default function EstadisticasClientes() {
  const [datos, setDatos] = useState([]);
  const [loading, setLoading] = useState(false);
  const [pagina, setPagina] = useState(1);
  const [paginaInput, setNumPaginaInput] = useState(1);
  const [filtroTexto, setFiltroTexto] = useState("");
  const porPagina = 25;

  const token = localStorage.getItem("token");

  // Función para obtener datos de la API con filtro
  const fetchDatos = (filtro = "") => {
    setLoading(true);
    fetch(`http://localhost:3000/api/getEstadisticasDeClientes?filtro=${encodeURIComponent(filtro)}`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then(res => res.json())
      .then(data => {
        setDatos(data);
        setLoading(false);
        setPagina(1);
        setNumPaginaInput(1);
      })
      .catch(err => {
        console.error("Error cargando clientes:", err);
        setLoading(false);
      });
  };

  useEffect(() => {
    fetchDatos(filtroTexto);
  }, [filtroTexto]);

  const setNumPagina = (num) => {
    setNumPaginaInput(num);
    setPagina(num);
  }

  const manejarCambioInput = (e) => {
    const val = e.target.value;
    setNumPaginaInput(val);

    const num = Number(val);
    if (num > 0 && num <= totalPaginas) {
      setPagina(num);
    }
  };

  const actualizarPagina = () => {
    let num = Number(paginaInput);
    if (isNaN(num) || num < 1) num = 1;

    if (num > totalPaginas) num = totalPaginas;

    setNumPagina(num);
    setNumPaginaInput(num);
  };

  const moverArriba = () => {
    window.scrollTo({ top: 100, behavior: 'smooth' });
  }

  const totalPaginas = Math.max(1, Math.ceil(datos.length / porPagina));
  const inicio = (pagina - 1) * porPagina;
  const visible = datos.slice(inicio, inicio + porPagina);

  return (
    <div className="stats-main">
      <div className="stats-table-container">
        <div className="filtro-texto" style={{ marginBottom: "10px" }}>
          <FaSearch className="icono-busqueda" />
          <input
            type="text"
            placeholder="Filtrar por cliente o categoría..."
            value={filtroTexto}
            onChange={(e) => setFiltroTexto(e.target.value)}
          />
        </div>
        {loading ? <p>Cargando...</p> : (
          <>
            <table className="stats-table">
              <thead>
                <tr>
                  <th>Cliente</th>
                  <th>Categoría</th>
                  <th>Monto Máximo</th>
                  <th>Monto Mínimo</th>
                  <th>Promedio Compra</th>
                </tr>
              </thead>
              <tbody>
                {visible.map((row, idx) => (
                  <tr key={row.IDCliente + "-" + row.Categoria + "-" + idx}>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorCliente ? "subtotal-tabla" : ""}>{row.NombreCliente}</td>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorCliente ? "subtotal-tabla" : ""}>{row.Categoria}</td>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorCliente ? "subtotal-tabla" : ""}>{row.MontoMaximo}</td>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorCliente ? "subtotal-tabla" : ""}>{row.MontoMinimo}</td>
                    <td className={row.EsTotalGeneral ? "total-general-tabla" : row.EsSubtotalPorCliente ? "subtotal-tabla" : ""}>{row.PromedioCompra}</td>
                  </tr>
                ))}
              </tbody>
            </table>

            <div className="paginado">
              <button
                onClick={() => setNumPagina((p) => Math.max(1, p - 1))}
                disabled={pagina === 1}
              >
                Anterior
              </button>

              <span>
                Página <input
                  id="pagina-input"
                  type="number"
                  value={paginaInput}
                  onChange={manejarCambioInput}
                  onBlur={actualizarPagina}
                  onKeyDown={(e) => { if (e.key === "Enter") actualizarPagina(); }}
                  min={1}
                  max={totalPaginas}
                /> de {totalPaginas}
              </span>

              <button
                onClick={() => { setNumPagina((p) => Math.min(totalPaginas, p + 1)); moverArriba(); }}
                disabled={pagina === totalPaginas}
              >
                Siguiente
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
