// Manejo del clic en el botón de "Registrarse"
document.getElementById('register-btn').addEventListener('click', () => {
  window.electronAPI.openRegisterWindow();
});


// Al recibir los datos desde el registro, verifica los campos
window.electronAPI.on('set-username', (event, username) => {
  document.getElementById('usernameLogin').value = username;
  
  const passwordField = document.getElementById('passwordLogin');
  if (passwordField.readOnly) {
    passwordField.readOnly = false;
  }

  if (passwordField.disabled) {
    passwordField.disabled = false;
  }

  alert(`Bienvenido, ${username}`);
});

// Manejo del formulario de inicio de sesión
document.getElementById('loginForm').addEventListener('submit', (event) => {
  event.preventDefault();
  const username = document.getElementById('usernameLogin').value;
  const password = document.getElementById('passwordLogin').value;

  if (username && password) {
    console.log(`Iniciar sesión con: ${username}, ${password}`);
  } else {
    alert('Por favor, completa todos los campos');
  }
});
