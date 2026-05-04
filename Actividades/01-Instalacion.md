## Instalacion de docker en Ubuntu.

Siguiendo la documentacion oficial de Docker primero debemos desintalar paquetes conflictivos para una instalacion limpia:
``` Bash
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
```
<img width="1351" height="261" alt="image" src="https://github.com/user-attachments/assets/6f800721-03d9-460b-840e-e51f7964a595" />

El metodo recomendado es añadir el paquete apt de docker 

#### Dependencias y certificados
```Bash
sudo apt update && apt upgrade (**Ya que es un sistema nuevo debemos hacer upgrade tambien.**)
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```
<img width="1359" height="259" alt="image" src="https://github.com/user-attachments/assets/eb061ece-f6cd-4b5d-bd07-919c41587e77" />

#### Añadir el repositorio

```Bash
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
```

<img width="1143" height="508" alt="image" src="https://github.com/user-attachments/assets/5aafcf61-dea8-4c93-878e-411e06f56e84" />

#### Instalacion.

```Bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### Prueba

```Bash
docker run hello-world
```

<img width="1182" height="477" alt="image" src="https://github.com/user-attachments/assets/9bbd2cd4-cc65-467b-8ac8-64b703c2d865" />






