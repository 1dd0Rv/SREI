## Docker Compose - Definición de la infraestructura

El archivo `docker-compose.yml` define los dos contenedores, la red interna y los volúmenes del proyecto.

```Bash
nano ~/marisma/docker-compose.yml
```

### Red interna

Creamos una red bridge con la subred `172.20.0.0/24` para que los contenedores se comuniquen entre sí con IPs fijas:

```YAML
networks:
  marisma-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24
```

### Volúmenes

Usamos bind mounts para que los datos persistan aunque se destruyan los contenedores:

```YAML
volumes:
  www-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ./volumes/www    # Webs de los clientes
  db-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ./volumes/db     # Datos de MariaDB
```

### Contenedor web (`marisma-web`)

Contenedor principal con IP `172.20.0.10` que ejecuta todos los servicios:

| Puerto host | Puerto contenedor | Servicio |
|---|---|---|
| 80 | 80 | Apache HTTP |
| 2222 | 22 | SSH / SFTP |
| 53 | 53 | DNS (UDP + TCP) |
| 21 | 21 | FTP control |
| 990 | 990 | FTPS implícito |
| 8080 | 8080 | phpMyAdmin |
| 40000-40100 | 40000-40100 | FTP pasivo |

> **Nota:** El puerto SSH se mapea al 2222 en el host para no chocar con el SSH del propio LXC.

Variables de entorno que usa el contenedor:

```YAML
environment:
  - MYSQL_HOST=172.20.0.20        # IP del contenedor MariaDB
  - MYSQL_ROOT_PASSWORD=rootpass123
  - DOMAIN=marisma.local
  - SERVER_IP=172.20.0.10
```

### Contenedor de base de datos (`marisma-db`)

Contenedor con MariaDB 10.11 en la IP `172.20.0.20`:

```YAML
db:
  image: mariadb:10.11
  container_name: marisma-db
  hostname: db.marisma.local
  networks:
    marisma-net:
      ipv4_address: 172.20.0.20
  volumes:
    - db-data:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=rootpass123
  restart: unless-stopped
```

### Arquitectura de red

```
┌─────────────────────────────────────────────────┐
│                Red marisma-net                  │
│              172.20.0.0/24                      │
│                                                 │
│  ┌──────────────────┐  ┌──────────────────┐     │
│  │   marisma-web    │  │   marisma-db     │     │
│  │   172.20.0.10    │  │   172.20.0.20    │     │
│  │                  │  │                  │     │
│  │  Apache + PHP    │  │  MariaDB 10.11   │     │
│  │  BIND9 (DNS)     │  │                  │     │
│  │  ProFTPD (TLS)   │  │                  │     │
│  │  SSH / SFTP      │  │                  │     │
│  │  Python WSGI     │  │                  │     │
│  └──────────────────┘  └──────────────────┘     │
└─────────────────────────────────────────────────┘
```

### Comandos útiles

```Bash
# Levantar los contenedores
docker compose up -d --build

# Ver estado
docker ps

# Ver logs del contenedor web
docker logs marisma-web

# Ver estado de los servicios internos
docker exec marisma-web supervisorctl status

# Parar todo
docker compose down

# Reconstruir sin caché
docker compose build --no-cache
docker compose up -d
```
