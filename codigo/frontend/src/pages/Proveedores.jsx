import React, { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { FaSearch, FaFilter, FaTruck, FaBroom } from "react-icons/fa";
import "../css/Proveedores.css";

export default function Proveedores() {
  const [proveedores, setProveedores] = useState([]);
  const [categoriasProveedores, setCategoriasProveedores] = useState([]);
  const [metodosEntrega, setMetodosEntrega] = useState([]);

  const [loading, setLoading] = useState(true);
  const [pagina, setPagina] = useState(1);
  const proveedoresPorPagina = 25;

  // Búsqueda y filtros
  const [busqueda, setBusqueda] = useState("");
  const [filtroCategoria, setFiltroCategoria] = useState(0);
  const [filtroMetodo, setFiltroMetodo] = useState(0);
  const [paginaInput, setNumPaginaInput] = useState(pagina);

  const token = localStorage.getItem("token");

  useEffect(() => {

    setLoading(true);
    //Categorías
    fetch("http://localhost:3000/api/getCategoriasDeProveedores", {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then((res) => res.json())
      .then((data) => {
        setCategoriasProveedores(data);
      })
      .catch((err) => {
        console.error("Error cargando categorías de proveedores:", err);
      });

    //Métodos de entrega
    fetch("http://localhost:3000/api/getMetodosDeEntrega", {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then((res) => res.json())
      .then((data) => {
        setMetodosEntrega(data);
        console.log("Métodos de entrega cargados:", data);
      })
      .catch((err) => {
        console.error("Error cargando métodos de entrega:", err);
      });

    cargarProveedores();
  }, []);

  const cargarProveedores = () => {
    const params = new URLSearchParams();
    if (busqueda) params.append("FiltrarNombre", busqueda);
    if (filtroCategoria) params.append("FiltrarCategoria", filtroCategoria);
    if (filtroMetodo) params.append("FiltrarMetodoEntrega", filtroMetodo);

    fetch(`http://localhost:3000/api/getProveedoresSimple?${params.toString()}`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      })
      .then((res) => res.json())
      .then((data) => {
        setProveedores(data);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Error cargando proveedores:", err);
      });
  };

  useEffect(() => {
    cargarProveedores();
  }, [busqueda, filtroCategoria, filtroMetodo]);

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
    const totalPaginas = Math.max(1, Math.ceil(proveedores.length / proveedoresPorPagina));

    if (isNaN(num) || num < 1) num = 1;
    if (num > totalPaginas) num = totalPaginas;

    setNumPagina(num);
    setNumPaginaInput(num);
  };

  const moverArriba = () => {
    window.scrollTo({ top: 100, behavior: 'smooth' });
  }

  const cambiarOrden = () => {
    proveedores.reverse();
    setProveedores([...proveedores]);
  }

  const totalPaginas = Math.max(1, Math.ceil(proveedores.length / proveedoresPorPagina));
  const indiceUltimo = pagina * proveedoresPorPagina;
  const indicePrimero = indiceUltimo - proveedoresPorPagina;
  const proveedoresActuales = proveedores.slice(indicePrimero, indiceUltimo);

  return (
    <div className="estilos-page">
      <h2>Módulo de Proveedores</h2>
      <div className="estilos-filtros">
        {/* Buscador */}
        <div className="busqueda-wrap">
          <FaSearch className="icono-busqueda" />
          <input
            className="busqueda-input"
            type="text"
            placeholder="Buscar por nombre o categoría..."
            value={busqueda}
            onChange={(e) => { setBusqueda(e.target.value); setNumPagina(1); }}
            aria-label="Buscar proveedores"
          />
        </div>

        {/* Filtros */}
        {!loading && (
          <div className="filtros-selects">
            <div className="filtro-wrap">
              <FaFilter className="icono-filtro" />
              <select
                value={filtroCategoria}
                onChange={(e) => { setFiltroCategoria(Number(e.target.value)); setNumPagina(1); }}
                className="filtro-select"
              >
                <option value={0}>Todas las categorías</option>
                {categoriasProveedores.map((cat) => (
                  <option value={cat.CategoriaID} key={cat.CategoriaID}>
                    {cat.NombreCategoria}
                  </option>
                ))}
              </select>
            </div>

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

            <button
              type="button"
              className="btn-limpiar"
              onClick={() => {
                setBusqueda("");
                setFiltroCategoria(0);
                setFiltroMetodo(0);
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
            Mostrando <strong>{Math.min(proveedoresPorPagina, proveedores.length)}</strong> de <strong>{proveedores.length}</strong> proveedores
          </div>

          <div className="table-container">
            {proveedores.length === 0 ? (
              <p>No hay proveedores que coincidan con los criterios.</p>
            ) : (
              <table className="estilos-table">
                <thead>
                  <tr>
                    <th>ID del Proveedor</th>
                    <th onClick={cambiarOrden} style={{ cursor: "pointer" }}>Nombre del Proveedor</th>
                    <th>Categoría</th>
                    <th>Método de Entrega</th>
                  </tr>
                </thead>
                <tbody>
                  {proveedoresActuales.map((c) => (
                    <tr key={c.IDProveedor ?? c.iDProveedor ?? c.id}>
                      <td>{c.IDProveedor ?? c.iDProveedor ?? c.id}</td>
                      <td>
                        <Link to={`/proveedores/${c.IDProveedor ?? c.iDProveedor ?? c.id}`} className="proveedor-link">
                          {c["NombreCliente"] ?? c.NombreProveedor ?? "-"}
                        </Link>
                      </td>
                      <td>{c["Categoría"] ?? c.Categoria ?? "-"}</td>
                      <td>{c["MetodoEntrega"] ?? c["MétodoEntrega"] ?? c.MetodoEntrega ?? "-"}</td>
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
