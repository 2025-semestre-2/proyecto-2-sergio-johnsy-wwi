import React, { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { FaSearch, FaFilter, FaTruck, FaBroom } from "react-icons/fa";
import "../css/Clientes.css";

export default function Cliente() {
  const [clientes, setClientes] = useState([]);
  const [categoriasClientes, setCategoriasClientes] = useState([]);
  const [metodosEntrega, setMetodosEntrega] = useState([]);

  const [loading, setLoading] = useState(true);
  const [pagina, setPagina] = useState(1);
  const clientesPorPagina = 25;

  const [busqueda, setBusqueda] = useState("");
  const [filtroCategoria, setFiltroCategoria] = useState(0);
  const [filtroMetodo, setFiltroMetodo] = useState(0);
  const [paginaInput, setNumPaginaInput] = useState(pagina);

  useEffect(() => {

    setLoading(true);
    fetch("http://localhost:3000/api/getCategoriasDeClientes")
      .then((res) => res.json())
      .then((data) => {
        setCategoriasClientes(data);
      })
      .catch((err) => {
        console.error("Error cargando categorías de clientes:", err);
      });

    fetch("http://localhost:3000/api/getMetodosDeEntrega")
      .then((res) => res.json())
      .then((data) => {
        setMetodosEntrega(data);
        console.log("Métodos de entrega cargados:", data);
      })
      .catch((err) => {
        console.error("Error cargando métodos de entrega:", err);
      });

    cargarClientes();
  }, []);

  const cargarClientes = () => {
    const params = new URLSearchParams();
    console.log("Cargando clientes con filtros:", { busqueda, filtroCategoria, filtroMetodo });
    if (busqueda) params.append("FiltrarNombre", busqueda);
    if (filtroCategoria) params.append("FiltrarCategoria", filtroCategoria);
    if (filtroMetodo) params.append("FiltrarMetodoEntrega", filtroMetodo);

    fetch(`http://localhost:3000/api/getClientesSimple?${params.toString()}`)
      .then((res) => res.json())
      .then((data) => {
        setClientes(data);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Error cargando clientes:", err);
      });
  };

  useEffect(() => {
    cargarClientes();
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
    const totalPaginas = Math.max(1, Math.ceil(clientes.length / clientesPorPagina));

    if (isNaN(num) || num < 1) num = 1;
    if (num > totalPaginas) num = totalPaginas;

    setNumPagina(num);
    setNumPaginaInput(num);
  };

  const moverArriba = () => {
    window.scrollTo({ top: 100, behavior: 'smooth' });
  }

  const cambiarOrden = () => {
    clientes.reverse();
    setClientes([...clientes]);
  }

  const totalPaginas = Math.max(1, Math.ceil(clientes.length / clientesPorPagina));
  const indiceUltimo = pagina * clientesPorPagina;
  const indicePrimero = indiceUltimo - clientesPorPagina;
  const clientesActuales = clientes.slice(indicePrimero, indiceUltimo);

  return (
    <div className="estilos-page">
      <h2>Módulo de Clientes</h2>
      <div className="estilos-filtros">
        <div className="busqueda-wrap">
          <FaSearch className="icono-busqueda" />
          <input
            className="busqueda-input"
            type="text"
            placeholder="Buscar por nombre o categoría..."
            value={busqueda}
            onChange={(e) => { setBusqueda(e.target.value); setNumPagina(1); }}
            aria-label="Buscar clientes"
          />
        </div>

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
                {categoriasClientes.map((cat) => (
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
            Mostrando <strong>{Math.min(clientesPorPagina, clientes.length)}</strong> de <strong>{clientes.length}</strong> clientes
          </div>

          <div className="table-container">
            {clientes.length === 0 ? (
              <p>No hay clientes que coincidan con los criterios.</p>
            ) : (
              <table className="estilos-table">
                <thead>
                  <tr>
                    <th>ID del Cliente</th>
                    <th onClick={cambiarOrden} style={{ cursor: "pointer" }}>Nombre del Cliente</th>
                    <th>Categoría</th>
                    <th>Método de Entrega</th>
                  </tr>
                </thead>
                <tbody>
                  {clientesActuales.map((c) => (
                    <tr key={c.CustomerID ?? c.customerID ?? c.id}>
                      <td>{c.CustomerID ?? c.customerID ?? c.id}</td>
                      <td>
                        <Link to={`/clientes/${c.CustomerID ?? c.customerID ?? c.id}`} className="cliente-link">
                          {c["NombreCliente"] ?? c.NombreCliente ?? "-"}
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
