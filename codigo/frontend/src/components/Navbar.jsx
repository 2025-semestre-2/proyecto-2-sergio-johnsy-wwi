import { useEffect, useRef, useState } from "react";
import { Link } from "react-router-dom";
import logo from "../assets/logo.png";
import "../css/Navbar.css";

function Navbar() {
  const [hidden, setHidden] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const lastScroll = useRef(0);

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

  const handleCloseMenu = () => {
    setMenuOpen(false);
  };

  const handleSetMenuOpen = (state) => {
    setMenuOpen(state);
    if (state) setHidden(false);
  };

  return (
    <>
      <nav className={`navbar ${hidden && !menuOpen ? "hide" : ""}`}>
        <a className="logo-container" href="/">
          <img src={logo} alt="Wide World Importers" className="logo" />
          <h1 className="title">Panel de Control</h1>
        </a>

        <div className={`links ${menuOpen ? "show" : ""}`}>
          <Link to="/" className="link" onClick={handleCloseMenu}>Inicio</Link>
          <Link to="/clientes" className="link" onClick={handleCloseMenu}>Clientes</Link>
          <Link to="/proveedores" className="link" onClick={handleCloseMenu}>Proveedores</Link>
          <Link to="/inventarios" className="link" onClick={handleCloseMenu}>Inventarios</Link>
          <Link to="/ventas" className="link" onClick={handleCloseMenu}>Ventas</Link>
          <Link to="/estadisticas" className="link" onClick={handleCloseMenu}>Estadísticas</Link>
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
