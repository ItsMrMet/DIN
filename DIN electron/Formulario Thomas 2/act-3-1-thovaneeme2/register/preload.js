const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  registerUser: (username) => ipcRenderer.send('register-user', username)
});
