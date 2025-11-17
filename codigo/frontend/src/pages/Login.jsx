import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import "../css/Login.css";
import logo from "../assets/logo.png";
import { FaUser, FaLock, FaMapMarkerAlt } from "react-icons/fa";

export default function Login() {
  const [sede, setSede] = useState("");
  const navigate = useNavigate();

  const [usuario, setUsuario] = useState("");
  const [contrasena, setContrasena] = useState("");

  const handleChange = (e) => {
    const { name, value } = e.target;
    if (name === "sede") {
      setSede(value);
    } else if (name === "usuario") {
      setUsuario(value);
    } else if (name === "contrasena") {
      setContrasena(value);
    }
  };

  const handleSubmit = async (e) => {
  e.preventDefault();

  if (!usuario || !contrasena || !sede) {
    alert("Por favor, completa todos los campos");
    return;
  }

  try {
    const res = await fetch("http://localhost:3000/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ usuario, password: contrasena, sede }),
    });

    const data = await res.json();
    if (!res.ok) {
      if (data.mensaje !== undefined) alert(data.mensaje);
    }

    if (!(!res.ok && !data.token)) {
      localStorage.setItem("sesion", JSON.stringify({ usuario, sede }));
      localStorage.setItem("token", data.token);
      navigate("/");
    }
  } catch (err) {
    alert(err.message);
  }
};


  useEffect(() => {
    document.body.classList.add("login-page");
    return () => document.body.classList.remove("login-page");
  }, []);

  return (
    <div className="login-page">

      <div className="login-background">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
          <path
            fill="rgba(25,118,210,0.15)"
            d="M0,192L48,186.7C96,181,192,171,288,181.3C384,192,480,224,576,224C672,224,768,192,864,176C960,160,1056,160,1152,176C1248,192,1344,224,1392,240L1440,256V320H0Z"
          ></path>
          <path
            fill="rgba(13,83,175,0.25)"
            d="M0,288L60,266.7C120,245,240,203,360,176C480,149,600,139,720,165.3C840,192,960,256,1080,261.3C1200,267,1320,213,1380,186.7L1440,160V320H0Z"
          ></path>
        </svg>
      </div>
      <form className="login-box" onSubmit={handleSubmit}>
        <img src={logo} alt="Logo" className="login-logo" />
        <h2>Inicio de sesión</h2>

        <div className="input-container">
          <FaUser className="input-icon" />
          <input type="text" value={usuario} onChange={handleChange} name="usuario" placeholder="Usuario" required />
        </div>

        <div className="input-container">
          <FaLock className="input-icon" />
          <input type="password" value={contrasena} onChange={handleChange} name="contrasena" placeholder="Contraseña" required />
        </div>

        <div className="input-container">
          <FaMapMarkerAlt className="input-icon" />
          <select value={sede} onChange={handleChange} name="sede" required>
            <option value="">-- Selecciona tu sede --</option>
            <option value="CORP">Corporativa</option>
            <option value="SJ">San José</option>
            <option value="LI">Limón</option>
          </select>
        </div>

        <button type="submit">Ingresar</button>
      </form>
    </div>
  );
}
