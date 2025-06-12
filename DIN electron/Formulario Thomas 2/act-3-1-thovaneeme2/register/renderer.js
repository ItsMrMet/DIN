// Obtener el formulario y el mensaje de éxito
const registerForm = document.getElementById('registerForm');
const registrationMessage = document.getElementById('registration-message');
const togglePassword = document.getElementById('togglePassword');
const passwordInput = document.getElementById('passwordRegister');
const termsCheckbox = document.getElementById('terms');

// Mostrar u ocultar la contraseña
togglePassword.addEventListener('change', () => {
  if (togglePassword.checked) {
    passwordInput.type = 'text';
  } else {
    passwordInput.type = 'password';
  }
});

// Validación y envío del formulario
registerForm.addEventListener('submit', (event) => {
  event.preventDefault(); 

  const username = document.getElementById('usernameRegister').value;
  const email = document.getElementById('emailRegister').value;
  const confirmEmail = document.getElementById('confirmEmailRegister').value;
  const password = passwordInput.value;

  if (email !== confirmEmail) {
    alert('Los correos electrónicos no coinciden.');
    return;
  }

  if (!termsCheckbox.checked) {
    alert('Debe aceptar los términos y condiciones.');
    return;
  }

  window.electronAPI.registerUser(username);

  registrationMessage.style.display = 'block';

  registerForm.reset();
  setTimeout(() => {
    registrationMessage.style.display = 'none';
  }, 3000);
});
