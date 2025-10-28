import React from "react";
import { useNavigate } from "react-router-dom";
import "../css/Error.css";

export default function Error() {
  const navigate = useNavigate();

  return (
    <div className="error-page">
      <div className="error-content">
        <h1>404</h1>
        <h2>¡Ups! Página no encontrada</h2>
        <p>⚠️ Lo sentimos, la página que buscas no existe. ⚠️</p>
        <button className="btn-volver-err" onClick={() => navigate("/")}>
          Volver al inicio
        </button>
      </div>
    </div>
  );
}
