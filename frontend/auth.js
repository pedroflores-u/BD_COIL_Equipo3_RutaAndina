function verificarAcceso(rolPermitido) {
  const raw = localStorage.getItem('usuarioRutaAndina');
  if (!raw) {
    window.location.href = '/login.html';
    return null;
  }

  const usuario = JSON.parse(raw);
  if (usuario.rol !== rolPermitido) {
    window.location.href = '/login.html';
    return null;
  }

  return usuario;
}

function cerrarSesion() {
  localStorage.removeItem('usuarioRutaAndina');
  window.location.href = '/login.html';
}