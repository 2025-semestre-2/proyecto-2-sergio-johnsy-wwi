import { createBrowserHistory } from "history";

const history = createBrowserHistory();
const originalFetch = window.fetch;

window.fetch = async (...args) => {
  try {
    const response = await originalFetch(...args);

    if (!response.ok) {
      // Leemos el error del backend
      const text = await response.text();

      // Redirigir a /error con el mensaje
      history.push(`/error?msg=${encodeURIComponent(text)}`);
    }

    return response;
  } catch (err) {
    history.push(`/error?msg=${encodeURIComponent(err.message)}`);
  }
};
