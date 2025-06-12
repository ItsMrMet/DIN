const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');

app.setPath('userData', path.join(app.getPath('home'), 'MyElectronApp'));

let mainWindow;
let registerWindow;

function createMainWindow() {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'login/preload.js'),
    },
  });
  mainWindow.loadFile('login/index.html');
}

function createRegisterWindow() {
  registerWindow = new BrowserWindow({
    width: 800,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'register/preload.js'),
    },
  });
  registerWindow.loadFile('register/index.html');
}

app.whenReady().then(() => {
  createMainWindow();

  ipcMain.on('open-register-window', () => {
    createRegisterWindow();
  });

  ipcMain.on('register-user', (event, username) => {
    mainWindow.webContents.send('set-username', username);

    registerWindow.close();
  });

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createMainWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
