const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  openRegisterWindow: () => ipcRenderer.send('open-register-window'),

  on: (channel, callback) => {
    ipcRenderer.on(channel, callback);
  }
});
