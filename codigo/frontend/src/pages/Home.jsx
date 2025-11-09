import { useNavigate } from "react-router-dom";
import { FaUsers, FaTruck, FaBoxes, FaChartLine, FaFileAlt } from "react-icons/fa";
import Estadisticas from "./Estadisticas";
import "../css/Home.css";

export default function Home() {
  const navigate = useNavigate();

  const sesion = localStorage.getItem("sesion");
  let userData = { nombre: "Invitado", sede: "Sin sede" };

  if (sesion) {
    const datos = JSON.parse(sesion);
    const nombre = datos.usuario || "Invitado";
    let sede = datos.sede || "Sin sede";
    if (sede === "CORP") sede = "Corporativa";
    else if (sede === "SJ") sede = "San José";
    else if (sede === "LI") sede = "Limón";
    userData = { nombre, sede };
  }

  if (userData.sede === "Corporativa") {
    return <Estadisticas />;
  }

  const sections = [
    { title: "Clientes", desc: "Gestiona tus clientes, agrega, edita o elimina información importante.", link: "/clientes", icon: <FaUsers /> },
    { title: "Proveedores", desc: "Administra tus proveedores y mantén el control de tus pedidos.", link: "/proveedores", icon: <FaTruck /> },
    { title: "Inventarios", desc: "Consulta y actualiza tus inventarios de productos fácilmente.", link: "/inventarios", icon: <FaBoxes /> },
    { title: "Ventas", desc: "Registra y analiza todas tus ventas de forma rápida.", link: "/ventas", icon: <FaChartLine /> },
    { title: "Estadísticas", desc: "Visualiza estadísticas y reportes para tomar mejores decisiones.", link: "/estadisticas", icon: <FaFileAlt /> },
  ];

  return (
    <div className="home-page">
      <h1 className="bienvenida">Bienvenido a la Gestión de Wide World Importers</h1>
      <div className="sections-container">
        {sections.map((s, idx) => (
          <div
            key={idx}
            className={`section-block ${idx === sections.length - 1 ? "center-last" : ""}`}
            onClick={() => navigate(s.link)}
          >
            <div className="section-details">
              <div className="section-icon">{s.icon}</div>
              <div className="section-content">
                <h2>{s.title}</h2>
                <p>{s.desc}</p>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
