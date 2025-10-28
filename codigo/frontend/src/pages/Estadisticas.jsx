import React, { useState } from "react";
import { FaChartBar, FaUsers, FaDollarSign, FaList, FaTruck } from "react-icons/fa";
import "../css/Estadisticas.css";
import EstadisticasProveedores from "./Estadisticas/EstadisticasProveedores";
import EstadisticasClientes from "./Estadisticas/EstadisticasClientes";
import TopProductos from "./Estadisticas/TopProductos";
import TopClientes from "./Estadisticas/TopClientes";
import TopProveedores from "./Estadisticas/TopProveedores";

export default function DashboardStats() {
  const [statSeleccionada, setStatSeleccionada] = useState("proveedores");

  const statsList = [
    { id: "proveedores", label: "Compras por Proveedor/Categoría", icon: <FaChartBar /> },
    { id: "clientes", label: "Compras por Cliente/Categoría", icon: <FaUsers /> },
    { id: "productos", label: "Top 5 Productos por Año", icon: <FaDollarSign /> },
    { id: "topClientes", label: "Top 5 Clientes por Facturas", icon: <FaList /> },
    { id: "topProveedores", label: "Top 5 Proveedores por Órdenes", icon: <FaTruck /> },
  ];

  return (
    <div className="stats-dashboard">
      <aside className="stats-sidebar">
        <h3>Estadísticas</h3>
        {statsList.map((s) => (
          <div
            key={s.id}
            className={`stats-item ${statSeleccionada === s.id ? "activo" : ""}`}
            onClick={() => setStatSeleccionada(s.id)}
          >
            {s.icon} <span>{s.label}</span>
          </div>
        ))}
      </aside>

      <main className="stats-main">
        {statSeleccionada === "proveedores" && <EstadisticasProveedores />}
        {statSeleccionada === "clientes" && <EstadisticasClientes />}
        {statSeleccionada === "productos" && <TopProductos />}
        {statSeleccionada === "topClientes" && <TopClientes />}
        {statSeleccionada === "topProveedores" && <TopProveedores />}
      </main>
    </div>
  );
}
