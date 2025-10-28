import React, { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { FaSearch, FaFilter, FaTruck, FaBroom } from "react-icons/fa";
import "../css/Clientes.css";

export default function Ventas() {
  const [ventas, setVentas] = useState([]);
  const [metodosEntrega, setMetodosEntrega] = useState([]);

  const [loading, setLoading] = useState(true);
  const [pagina, setPagina] = useState(1);
  const [totalPaginas, setTotalPaginas] = useState(1);
  const ventasPorPagina = 25;

  // Búsqueda y filtros
  const [busqueda, setBusqueda] = useState("");
  const [fechaDesde, setFechaDesde] = useState("");
  const [fechaHasta, setFechaHasta] = useState("");
  const [filtroMetodo, setFiltroMetodo] = useState(0);
  const [montoMinimo, setMontoMinimo] = useState("");
  const [montoMaximo, setMontoMaximo] = useState("");
  const [paginaInput, setNumPaginaInput] = useState(pagina);

  useEffect(() => {

    setLoading(true);

    //Métodos de entrega
    fetch("http://localhost:3000/api/getMetodosDeEntrega")
      .then((res) => res.json())
      .then((data) => {
        setMetodosEntrega(data);
        console.log("Métodos de entrega cargados:", data);
      })
      .catch((err) => {
        console.error("Error cargando métodos de entrega:", err);
      });

    cargarVentas();
  }, []);

  const cargarVentas = () => {
    const params = new URLSearchParams();
    console.log("Cargando ventas con filtros:", { busqueda, fechaDesde, fechaHasta, filtroMetodo, montoMinimo, montoMaximo });
    if (busqueda) params.append("FiltrarNombre", busqueda);
    if (fechaDesde && !isNaN(new Date(fechaDesde))) params.append("FiltrarFechaDesde", fechaDesde);
    if (fechaHasta && !isNaN(new Date(fechaHasta))) params.append("FiltrarFechaHasta", fechaHasta);
    if (filtroMetodo) params.append("FiltrarMetodoEntrega", filtroMetodo);
    if (montoMinimo) params.append("FiltrarMontoMinimo", montoMinimo);
    if (montoMaximo) params.append("FiltrarMontoMaximo", montoMaximo);
    params.append("Pagina", pagina);
    params.append("FilasPorPagina", ventasPorPagina);

    fetch(`http://localhost:3000/api/getVentas?${params.toString()}`)
      .then((res) => res.json())
      .then((data) => {
        if (data.error) setVentas([]);
        setVentas(data);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Error cargando ventas:", err);
        setVentas([]);
      });
  };

  useEffect(() => {
    cargarVentas();
  }, [busqueda, fechaDesde, fechaHasta, filtroMetodo, montoMinimo, montoMaximo, pagina]);

  const setNumPagina = (num) => {
    setNumPaginaInput(num);
    setPagina(num);
  }

  const manejarCambioInput = (e) => {
    const val = e.target.value;
    setNumPaginaInput(val);

    if (Number(val) > 0 && Number(val) <= totalPaginas) {
      setNumPagina(Number(val));
    }
  };

  const actualizarPagina = () => {
    let num = Number(paginaInput);
    const totalPaginas = Math.max(1, Math.ceil(ventas?.length / ventasPorPagina));

    if (isNaN(num) || num < 1) num = 1;
    if (num > totalPaginas) num = totalPaginas;

    setNumPagina(num);
    setNumPaginaInput(num);
  };

  const moverArriba = () => {
    window.scrollTo({ top: 100, behavior: 'smooth' });
  }

  const cambiarOrden = () => {
    ventas.reverse();
    setVentas([...ventas]);
  }

  useEffect(() => {
    if (ventas?.length > 0) {
      const totalFilas = ventas[0]?.TotalFilas ?? 0;
      const total = Math.max(1, Math.ceil(totalFilas / ventasPorPagina));
      setTotalPaginas(total);
    }
  }, [ventas]);

  return (
    <div className="estilos-page">
      <h2>Módulo de Ventas</h2>
      <div className="estilos-filtros">
        {/* Buscador */}
        <div className="busqueda-wrap">
          <FaSearch className="icono-busqueda" />
          <input
            className="busqueda-input"
            type="text"
            placeholder="Buscar por nombre de cliente..."
            value={busqueda}
            onChange={(e) => { setBusqueda(e.target.value); setNumPagina(1); }}
            aria-label="Buscar ventas"
          />
        </div>

        {!loading && (
          <div className="filtros-selects">
            <div className="filtro-wrap">
              <FaTruck className="icono-filtro" />
              <select
                value={filtroMetodo}
                onChange={(e) => { setFiltroMetodo(Number(e.target.value)); setNumPagina(1); }}
                className="filtro-select"
              >
                <option value={0}>Todos los métodos</option>
                {metodosEntrega.map((m) => (
                  <option value={m.MetodoID} key={m.MetodoID}>
                    {m.NombreMetodo}
                  </option>
                ))}
              </select>
            </div>

            <div className="filtro-wrap">
              <label>Desde:</label>
              <input
                type="date"
                value={fechaDesde}
                onChange={(e) => setFechaDesde(e.target.value)}
                onBlur={() => { setNumPagina(1); cargarVentas(); }}
              />
            </div>

            <div className="filtro-wrap">
              <label>Hasta:</label>
              <input
                type="date"
                value={fechaHasta}
                onChange={(e) => setFechaHasta(e.target.value)}
                onBlur={() => { setNumPagina(1); cargarVentas(); }}
              />
            </div>

            <div className="filtro-wrap">
              <label>Monto mínimo:</label>
              <input
                type="number"
                placeholder="₡0"
                value={montoMinimo}
                onChange={(e) => { setMontoMinimo(e.target.value); setNumPagina(1); }}
              />
            </div>

            <div className="filtro-wrap">
              <label>Monto máximo:</label>
              <input
                type="number"
                placeholder="₡0"
                value={montoMaximo}
                onChange={(e) => { setMontoMaximo(e.target.value); setNumPagina(1); }}
              />
            </div>

            <button
              type="button"
              className="btn-limpiar"
              onClick={() => {
                setBusqueda("");
                setFiltroMetodo(0);
                setFechaDesde("");
                setFechaHasta("");
                setMontoMinimo("");
                setMontoMaximo("");
                setNumPagina(1);
              }}
            >
              <FaBroom className="icono-limpiar" /> Limpiar
            </button>
          </div>
        )}
      </div>

      {!loading && (
        <>
          <div className="info-filtro">
            Mostrando <strong>{ventas.length}</strong> de <strong>{ventas[0]?.TotalFilas ?? 0}</strong> ventas
          </div>

          <div className="table-container">
            {ventas.length === 0 ? (
              <p>No hay ventas que coincidan con los criterios.</p>
            ) : (
              <table className="estilos-table">
                <thead>
                  <tr>
                    <th>Factura</th>
                    <th>Fecha</th>
                    <th onClick={cambiarOrden} style={{ cursor: "pointer" }}>Nombre del Cliente</th>
                    <th>Método de Entrega</th>
                    <th>Monto Total</th>
                  </tr>
                </thead>
                <tbody>
                  { ventas?.map((v) => (
                    <tr key={v.NumeroFactura ?? v.numeroFactura ?? v.id}>
                      <td>
                        <Link to={`/ventas/${v.NumeroFactura ?? v.numeroFactura ?? v.id}`} className="cliente-link">
                          {v["NumeroFactura"] ?? v.NumeroFactura ?? "-"}
                        </Link>
                      </td>
                      <td>{new Date(v.FechaVenta).toLocaleDateString(undefined, { year: 'numeric', month: '2-digit', day: '2-digit' })}</td>
                      <td>
                        <Link to={`/clientes/${v.ClienteID ?? v.clienteID ?? v.id}`} className="cliente-link">
                          {v["NombreCliente"] ?? v.NombreCliente ?? "-"}
                        </Link>
                      </td>
                      <td>{v["MetodoEntrega"] ?? v["MétodoEntrega"] ?? v.MetodoEntrega ?? "-"}</td>
                      <td>{v["MontoTotal"] ?? v["MontoTotal"] ?? v.MontoTotal ?? "-"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>

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
                onKeyDown={(e) => {
                  if (e.key === "Enter") actualizarPagina();
                }}
                min={1}
                max={totalPaginas}/> de {totalPaginas}
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
  );
}
