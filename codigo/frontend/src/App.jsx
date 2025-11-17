import { useState, useEffect } from 'react'
import { BrowserRouter, Routes, Route, useLocation, useNavigate } from "react-router-dom";
import Navbar from './components/Navbar';

import Home from "./pages/Home.jsx";
import Login from "./pages/login.jsx";
import Clientes from "./pages/Clientes.jsx";
import Proveedores from "./pages/Proveedores.jsx";
import Inventarios from "./pages/Inventarios.jsx";
import Ventas from "./pages/Ventas.jsx";
import Estadisticas from "./pages/Estadisticas.jsx";

import DetalleCliente from './pages/Detalles/DetalleCliente.jsx';
import DetalleProveedor from './pages/Detalles/DetalleProveedor.jsx';
import DetalleInventario from './pages/Detalles/DetalleInventario.jsx';
import DetalleVentas from './pages/Detalles/DetalleVenta.jsx';

import EditarProducto from './pages/Detalles/EditarProducto.jsx';
import AgregarProducto from './pages/Detalles/AgregarProducto.jsx';

import Error from './pages/Error.jsx';
import { useGlobalFetchInterceptor } from "./components/AutoError.jsx";
import './App.css'

function App() {
  const location = useLocation();
  const hideNavbar = location.pathname === "/login" || location.pathname === "/error";
  const navigate = useNavigate();
  useGlobalFetchInterceptor();

  useEffect(() => {
    const sesion = localStorage.getItem("sesion");
    if (!sesion && (location.pathname !== "/login" && location.pathname !== "/error")) {
      navigate("/login");
    }
    let sede = "Sin sede";
    if (sesion) {
      const datos = JSON.parse(sesion);
      sede = datos.sede || "Sin sede";
    }
    if (sede === "CORP" && (location.pathname != "/login" && location.pathname != "/")) {
      navigate("/");
    }
  }, [location, navigate]);


  return (
    <>
        {!hideNavbar && <Navbar />}
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
          <Route path="/clientes" element={<Clientes />} />
          <Route path="/proveedores" element={<Proveedores />} />
          <Route path="/inventarios" element={<Inventarios />} />
          <Route path="/ventas" element={<Ventas />} />
          <Route path="/estadisticas" element={<Estadisticas />} />

          <Route path="/clientes/:id" element={<DetalleCliente />} />
          <Route path="/proveedores/:id" element={<DetalleProveedor />} />
          <Route path="/inventarios/:id" element={<DetalleInventario />} />
          <Route path="/ventas/:id" element={<DetalleVentas />} />

          <Route path="/inventarios/editar/:id" element={<EditarProducto />} />
          <Route path="/inventarios/nuevo" element={<AgregarProducto />} />

          <Route path="*" element={<Error />} />
          <Route path="/error" element={<Error />} />
        </Routes>
    </>
  );
}

export default App
