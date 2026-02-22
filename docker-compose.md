## Crear docker compose para levantar el servicio DNS.

- El primer paso es instalar docker y asi tenemos nuestras configuraciones y todo corriendo sobre docker.
  Creaamos un directorio donde guardaremos nuestro docker compose 
<img width="600" height="74" alt="image" src="https://github.com/user-attachments/assets/a560d6eb-3b72-4b6e-9259-5967aafb0dad" />

- Dentro del directorio **alojamiento_docker** crearemos un docker compose que definira los contenedores, la red    interna y los volumenes.
``` YML
version: '3.8'

services:
  # 1. Contenedor DNS (Bind9)
  dns_server:
    image: internetsystemsconsortium/bind9:9.18
    container_name: dns_marisma
    ports:
      - "53:53/udp"
      - "53:53/tcp"
    volumes:
      - ./dns:/etc/bind # Volumen para la configuración del DNS
    networks:
      asir_network:
        ipv4_address: 172.20.0.10
    restart: always

  # 2. Contenedor Servidor Web (Apache + PHP)
  web_server:
    image: php:8.2-apache
    container_name: web_marisma
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./web:/var/www/html # Volumen para el alojamiento web
    networks:
      asir_network:
        ipv4_address: 172.20.0.20
    restart: always

  # 3. Contenedor Servidor MySQL (MariaDB)
  db_server:
    image: mariadb:10.11
    container_name: mysql_marisma
    environment:
      MYSQL_ROOT_PASSWORD: root_password_segura
    ports:
      - "3306:3306"
    volumes:
      - ./mysql:/var/lib/mysql # Volumen para las bases de datos
    networks:
      asir_network:
        ipv4_address: 172.20.0.30
    restart: always

# Configuración de la Red
networks:
  asir_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
``` 
<img width="826" height="187" alt="image" src="https://github.com/user-attachments/assets/dec4ab27-2f14-4ca4-b450-ad78e8f74a19" />

Creamos un script para la puesta en marcha de los contenedores:

```Bash
#!/bin/bash
# iniciar_docker.sh - Script para levantar la infraestructura Docker

echo "[+] Iniciando despliegue de contenedores (DNS, Web, MySQL)..."

# Comprobamos si docker-compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "[!] Error: docker-compose no está instalado. Instalando..."
    sudo apt-get update && sudo apt-get install -y docker-compose
fi

# Damos permisos a las carpetas de volúmenes por si acaso
chmod -R 755 /opt/alojamiento_docker/web

# Levantamos los contenedores en segundo plano (-d)
docker-compose up -d

echo "[+] ¡Contenedores desplegados correctamente!"
echo "[+] Estado actual:"
docker ps
```

