import React from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import "../css/Error.css";

export default function Error() {
  const navigate = useNavigate();
  const [params] = useSearchParams();
  const msg = params.get("msg") || "Error desconocido";

  return (
    <div className="error-page">
      <div className="error-content">
        <h1>404</h1>
        <h2>¡Ups! Ocurrió un error</h2>
        <p>{msg}</p>
        <button className="btn-volver-err" onClick={() => navigate("/")}>
          Volver al inicio
        </button>
      </div>
    </div>
  );
}
