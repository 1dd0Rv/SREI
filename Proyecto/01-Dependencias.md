## Configuración e instalación de dependecias en LXC

1- Ponemos una ip statica a nuestro server para poder actualizar el servidor.

<img width="934" height="187" alt="image" src="https://github.com/user-attachments/assets/77614532-7114-43fd-ad0d-845853de5cee" />

2- Una vez tenemos internet en nuestro server procedemos a hacer:
```Bash
sudo apt update && sudo apt upgrade -y -> Actualizar el servidor
apt install -y ca-certificates curl gnupg lsb-release -> Instalar dependencias
``` 
3- Añadimos el repositorio oficial de docker.

<img width="948" height="74" alt="image" src="https://github.com/user-attachments/assets/75dc3408-8c27-4a3e-a621-22273fb9d05c" />

<img width="850" height="92" alt="image" src="https://github.com/user-attachments/assets/4ae87665-46c4-41b6-9bdf-470d8ba06c90" />

```Bash
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
```
4- Instalamos docker

<img width="1375" height="283" alt="image" src="https://github.com/user-attachments/assets/b3012efc-c9ba-4f66-b630-a2d8668e2553" />
