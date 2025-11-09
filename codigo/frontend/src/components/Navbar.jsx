import { useEffect, useRef, useState } from "react";
import { Link } from "react-router-dom";
import logo from "../assets/logo.png";
import "../css/Navbar.css";
import { FaUserCircle } from "react-icons/fa";

function Navbar() {
  const [hidden, setHidden] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const [userData, setUserData] = useState({ nombre: "", sede: "" });
  const lastScroll = useRef(0);

  useEffect(() => {
    const sesion = localStorage.getItem("sesion");
    if (sesion) {
      const datos = JSON.parse(sesion);
      const nombre = datos.usuario || "Invitado";
      let sede = datos.sede || "Sin sede";
      if (sede === "CORP") {
        sede = "Corporativa";
      } else if (sede === "SJ") {
        sede = "San José";
      } else if (sede === "LI") {
        sede = "Limón";
      }
      setUserData({ nombre, sede });
    } else {
      setUserData({ nombre: "Invitado", sede: "Sin sede" });
    }
  }, []);

  useEffect(() => {
    const handleScroll = () => {
      const currentScroll = window.scrollY;
      if (currentScroll <= 80) {
        setHidden(false);
        setMenuOpen(false);
      }
      if (currentScroll > lastScroll.current && currentScroll > 80) {
        setHidden(true);
      }
      lastScroll.current = currentScroll;
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, [menuOpen]);

  const handleCloseMenu = () => setMenuOpen(false);
  const handleSetMenuOpen = (state) => {
    setMenuOpen(state);
    if (state) setHidden(false);
  };

  const toggleUserMenu = () => setUserMenuOpen(!userMenuOpen);

  return (
    <>
      <nav className={`navbar ${hidden && !menuOpen ? "hide" : ""}`}>
        <a className="logo-container" href="/">
          <img src={logo} alt="Wide World Importers" className="logo" />
          <h1 className="title">Panel de Control</h1>
        </a>

        <div className="info-links">
          {userData.sede != "Corporativa" && (
            <div className={`links ${menuOpen ? "show" : ""}`}>
              <Link to="/" className="link" onClick={handleCloseMenu}>Inicio</Link>
              <Link to="/clientes" className="link" onClick={handleCloseMenu}>Clientes</Link>
              <Link to="/proveedores" className="link" onClick={handleCloseMenu}>Proveedores</Link>
              <Link to="/inventarios" className="link" onClick={handleCloseMenu}>Inventarios</Link>
              <Link to="/ventas" className="link" onClick={handleCloseMenu}>Ventas</Link>
              <Link to="/estadisticas" className="link" onClick={handleCloseMenu}>Estadísticas</Link>
            </div>
          )}

          {userData.sede === "Corporativa" && (
            <div className={`links ${menuOpen ? "show" : ""}`}>
              <p>Corporativa</p>
            </div>
          )}

          <div className="user-info" onClick={toggleUserMenu}>
            <FaUserCircle className="user-icon" />
            {userMenuOpen && (
              <div className="user-menu">
                <div className="user-header">
                  <p className="user-name">{userData.nombre}</p>
                  <p className="user-sede">{userData.sede}</p>
                </div>
                <button className="user-option">Cambiar sede</button>
                <button
                  className="user-option logout"
                  onClick={() => {
                    sessionStorage.clear();
                    window.location.reload();
                  }}
                >
                  Cerrar sesión
                </button>
              </div>
            )}
          </div>
        </div>
      </nav>

      {hidden && !menuOpen && (
        <button
          className="floating-btn"
          onClick={() => handleSetMenuOpen(true)}
          aria-label="Mostrar menú"
        >
          ☰
        </button>
      )}
    </>
  );
}

export default Navbar;
