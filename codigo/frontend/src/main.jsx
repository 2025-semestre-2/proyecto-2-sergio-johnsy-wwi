import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'
import { BrowserRouter } from 'react-router-dom'
import "./components/AutoError.jsx";

createRoot(document.getElementById('root')).render(
  <BrowserRouter>
    <ErrorProvider>
      <App />
    </ErrorProvider>
  </BrowserRouter>
)
