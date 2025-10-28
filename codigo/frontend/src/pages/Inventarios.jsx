import React, { useEffect, useState } from "react";
import { FaSearch, FaFilter, FaBroom } from "react-icons/fa";
import { Link } from "react-router-dom";
import "../css/Inventarios.css";

export default function Inventarios() {
  const [productos, setProductos] = useState([]);
  const [grupos, setGrupos] = useState([]);

  const [loading, setLoading] = useState(true);
  const [pagina, setPagina] = useState(1);
  const productosPorPagina = 25;

  // Filtros
  const [busqueda, setBusqueda] = useState("");
  const [filtroGrupo, setFiltroGrupo] = useState(0);
  const [cantidadMinima, setCantidadMinima] = useState(null);
  const [cantidadMaxima, setCantidadMaxima] = useState(null);
  // Control de input de página
  const [paginaInput, setPaginaInput] = useState(pagina);

  useEffect(() => {
    setLoading(true);

    fetch("http://localhost:3000/api/getGruposDeProductos")
      .then((res) => res.json())
      .then((data) => {
        setGrupos(data);
      })
      .catch((err) => console.error("Error cargando grupos de productos:", err));

    cargarProductos();
  }, []);

  const cargarProductos = () => {
    const params = new URLSearchParams();
    if (busqueda) params.append("FiltrarNombre", busqueda);
    if (filtroGrupo) params.append("FiltrarGrupo", filtroGrupo);
    if (cantidadMinima) params.append("FiltrarCantidadMinima", cantidadMinima);
    if (cantidadMaxima) params.append("FiltrarCantidadMaxima", cantidadMaxima);

    fetch(`http://localhost:3000/api/getProductosInventario?${params.toString()}`)
      .then((res) => res.json())
      .then((data) => {
        setProductos(data);
        setLoading(false);
      })
      .catch((err) => console.error("Error cargando productos:", err));
  };

  useEffect(() => {
    cargarProductos();
  }, [busqueda, filtroGrupo, cantidadMinima, cantidadMaxima]);

  const setNumPagina = (num) => {
    setPaginaInput(num);
    setPagina(num);
  };

  const manejarCambioInput = (e) => {
    const val = e.target.value;
    setPaginaInput(val);

    if (Number(val) > 0 && Number(val) <= totalPaginas) {
      setNumPagina(Number(val));
    }
  };

  const actualizarPagina = () => {
    let num = Number(paginaInput);
    const totalPaginas = Math.max(1, Math.ceil(productos.length / productosPorPagina));

    if (isNaN(num) || num < 1) num = 1;
    if (num > totalPaginas) num = totalPaginas;

    setNumPagina(num);
    setPaginaInput(num);
  };

  const moverArriba = () => {
    window.scrollTo({ top: 100, behavior: "smooth" });
  };

  const totalPaginas = Math.max(1, Math.ceil(productos.length / productosPorPagina));
  const indiceUltimo = pagina * productosPorPagina;
  const indicePrimero = indiceUltimo - productosPorPagina;
  const productosActuales = productos.slice(indicePrimero, indiceUltimo);

  return (
    <div className="estilos-page">
      <h2>Inventarios</h2>

      <div className="estilos-filtros">
        <div className="busqueda-wrap">
          <FaSearch className="icono-busqueda" />
          <input
            className="busqueda-input"
            type="text"
            placeholder="Buscar por nombre o grupo..."
            value={busqueda}
            onChange={(e) => { setBusqueda(e.target.value); setNumPagina(1); }}
            aria-label="Buscar productos"
          />
        </div>

        {/* Filtros */}
        {!loading && (
          <div className="filtros-selects">
            <div className="filtro-wrap">
              <FaFilter className="icono-filtro" />
              <select
                value={filtroGrupo}
                onChange={(e) => { setFiltroGrupo(Number(e.target.value)); setNumPagina(1); }}
                className="filtro-select"
              >
                <option value={0}>Todos los grupos</option>
                {grupos.map((g) => (
                  <option value={g.GrupoID} key={g.GrupoID}>{g.NombreGrupo}</option>
                ))}
              </select>
            </div>

            <div className="filtro-wrap">
              <label>Cantidad mínima:</label>
              <input
                type="number"
                placeholder="0"
                value={cantidadMinima ?? ""}
                onChange={(e) => { setCantidadMinima(e.target.value ? Number(e.target.value) : null); setNumPagina(1); }}
              />
            </div>

            <div className="filtro-wrap">
              <label>Cantidad máxima:</label>
              <input
                type="number"
                placeholder="0"
                value={cantidadMaxima ?? ""}
                onChange={(e) => { setCantidadMaxima(e.target.value ? Number(e.target.value) : null); setNumPagina(1); }}
              />
            </div>

            <button
              type="button"
              className="btn-limpiar"
              onClick={() => {
                setBusqueda("");
                setFiltroGrupo(0);
                setCantidadMinima(null);
                setCantidadMaxima(null);
                setNumPagina(1);
              }}
            >
              <FaBroom className="icono-limpiar" /> Restaurar filtros
            </button>
          </div>
        )}
      </div>

      {!loading && (
        <>
          <div className="info-filtro">
            Mostrando <strong>{Math.min(productosPorPagina, productos.length)}</strong> de <strong>{productos.length}</strong> productos
          </div>

          <div className="table-container">
            {productos.length === 0 ? (
              <p>No hay productos que coincidan con los criterios.</p>
            ) : (
              <table className="estilos-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Nombre del Producto</th>
                    <th>Grupos</th>
                    <th>Cantidad Disponible</th>
                  </tr>
                </thead>
                <tbody>
                  {productosActuales.map((p) => (
                    <tr key={p.IDProducto ?? p.id}>
                      <td>{p.IDProducto ?? p.id}</td>
                      <td>
                        <Link to={`/inventarios/${p.IDProducto ?? p.id}`} className="proveedor-link">
                          {p["NombreProducto"] ?? p.NombreProducto ?? "-"}
                        </Link>
                        </td>
                      <td>{p.GruposProducto ?? "-"}</td>
                      <td>{p.CantidadDisponible ?? 0}</td>
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
  );
}
