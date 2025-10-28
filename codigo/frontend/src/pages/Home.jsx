import { useNavigate } from "react-router-dom";
import { FaUsers, FaTruck, FaBoxes, FaChartLine, FaFileAlt } from "react-icons/fa";
import "../css/Home.css";

export default function Home() {
  const navigate = useNavigate();

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
