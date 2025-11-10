function GruposCheckbox({ gruposProducto, producto, setProducto }) {
  const handleCheckboxChange = (e) => {
    const id = parseInt(e.target.value);
    const checked = e.target.checked;

    const nuevosGrupos = checked
      ? [...producto.GruposProductoIDs, id]
      : producto.GruposProductoIDs.filter(gid => gid !== id);

    setProducto({ ...producto, GruposProductoIDs: nuevosGrupos });
  };

  return (
    <div>
      <div style={{ border: '1px solid #ccc', padding: '10px', maxHeight: '150px', overflowY: 'auto' }}>
        {gruposProducto.map(g => (
          <label key={g.ID} style={{ display: 'block' }}>
            <input
              type="checkbox"
              value={g.ID}
              checked={producto.GruposProductoIDs.includes(g.ID)}
              onChange={handleCheckboxChange}
            />
            {g.Nombre}
          </label>
        ))}
      </div>
    </div>
  );
}

export default GruposCheckbox;