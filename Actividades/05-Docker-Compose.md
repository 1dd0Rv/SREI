## Práctica 5 — Docker Compose

Actividad basada en el módulo 4 del curso [josedom24/curso_docker_ies](https://github.com/josedom24/curso_docker_ies).

---

## 1. Introducción a Docker Compose

Docker Compose permite definir y gestionar aplicaciones multi-contenedor mediante un fichero `docker-compose.yml`.

Verificamos la instalación:

```bash
docker compose version
```

<img width="472" height="141" alt="image" src="https://github.com/user-attachments/assets/a9a7d16d-ca7f-4d31-8aed-05742e6d8cfc" />

---

## 2. Ejemplo 1 — Despliegue de la aplicación Guestbook

`docker-compose.yml`:

```yaml
version: '3.1'
services:
  app:
    container_name: guestbook
    image: iesgn/guestbook
    restart: always
    ports:
      - 80:5000
  db:
    container_name: redis
    image: redis
    restart: always
    command: redis-server --appendonly yes
    volumes:
      - redis:/data
volumes:
  redis:
```

```bash
docker compose up -d
docker compose ps
```

<img width="1867" height="441" alt="image" src="https://github.com/user-attachments/assets/6c6d044e-7248-41a5-b782-c8d2a49df6da" />

<img width="1647" height="738" alt="image" src="https://github.com/user-attachments/assets/5a493a6c-d8fe-4c4e-9337-42f9fe77dbc5" />

```bash
docker compose down
```

<img width="1875" height="306" alt="image" src="https://github.com/user-attachments/assets/8adb24c4-f15d-410e-b403-9b79aa1b6e5e" />

---

## 3. Ejemplo 2 — Despliegue de la aplicación Temperaturas

`docker-compose.yml`:

```yaml
version: '3.1'
services:
  frontend:
    container_name: temperaturas-frontend
    image: iesgn/temperaturas_frontend
    restart: always
    ports:
      - 80:3000
    depends_on:
      - backend
  backend:
    container_name: temperaturas-backend
    image: iesgn/temperaturas_backend
    restart: always
```

```bash
docker compose up -d
docker compose ps
```

<img width="1914" height="478" alt="image" src="https://github.com/user-attachments/assets/e6bcdeb1-42eb-41de-8708-37242dd14aeb" />

<img width="1765" height="820" alt="image" src="https://github.com/user-attachments/assets/e8a9e55b-e815-4a6b-b213-0e5be61fcf50" />

```bash
docker compose down
```

---

## 4. Ejemplo 3 — WordPress con MariaDB

`docker-compose.yml`:

```yaml
version: '3.1'
services:
  wordpress:
    container_name: servidor_wp
    image: wordpress
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: user_wp
      WORDPRESS_DB_PASSWORD: asdasd
      WORDPRESS_DB_NAME: bd_wp
    ports:
      - 80:80
    volumes:
      - wordpress_data:/var/www/html/wp-content
  db:
    container_name: servidor_mysql
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: bd_wp
      MYSQL_USER: user_wp
      MYSQL_PASSWORD: asdasd
      MYSQL_ROOT_PASSWORD: asdasd
    volumes:
      - mariadb_data:/var/lib/mysql
volumes:
  wordpress_data:
  mariadb_data:
```

```bash
docker compose up -d
docker compose ps
```

<img width="1764" height="234" alt="image" src="https://github.com/user-attachments/assets/cb60514c-2bc5-4353-991b-1cbef6969f67" />

<img width="1486" height="961" alt="image" src="https://github.com/user-attachments/assets/79cc3de4-a7bf-4c71-a91f-2ac9980154de" />

```bash
docker compose down -v   # elimina también los volúmenes
```

<img width="1896" height="336" alt="image" src="https://github.com/user-attachments/assets/72ca8fbc-6f57-48e6-83e2-77c0bc0716d3" />
 comando
