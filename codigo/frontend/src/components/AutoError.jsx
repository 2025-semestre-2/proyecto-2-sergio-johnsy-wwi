import { useNavigate } from "react-router-dom";
import { useEffect } from "react";

export function useGlobalFetchInterceptor() {
  const navigate = useNavigate();

  useEffect(() => {
    const originalFetch = window.fetch;

    window.fetch = async (...args) => {
      try {
        const response = await originalFetch(...args);

        if (!response.ok) {
          let errorMessage = `Error ${response.status} (${response.statusText})`;

          try {
            // Intentar leer JSON
            const data = await response.clone().json();
            if (data?.message) errorMessage = data.message;
            else if (typeof data === "string") errorMessage = data;
          } catch {
            // Si no es JSON, intentar texto
            try {
              const text = await response.clone().text();
              if (text.trim()) errorMessage = text;
            } catch {}
          }

          navigate(`/error?msg=${encodeURIComponent(errorMessage)}`);
        }

        return response;
      } catch (err) {
        navigate(`/error?msg=${encodeURIComponent(err.message || "Error de conexión")}`);
      }
    };

    return () => {
      window.fetch = originalFetch;
    };
  }, [navigate]);
}
