## Práctica 5 — Docker Compose

Actividad basada en el módulo 4 del curso [josedom24/curso_docker_ies](https://github.com/josedom24/curso_docker_ies).

---

## 1. Introducción a Docker Compose

Docker Compose permite definir y gestionar aplicaciones multi-contenedor mediante un fichero `docker-compose.yml`.

Verificamos la instalación:

```bash
docker compose version
```

> **Captura:**

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

> **Captura:** salida de `docker compose ps` con los dos servicios en estado `running`

> **Captura:** navegador accediendo a `http://localhost` con la aplicación Guestbook

```bash
docker compose down
```

> **Captura:** salida de `docker compose down`

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

> **Captura:** `docker compose ps` con frontend y backend activos

> **Captura:** navegador mostrando la aplicación Temperaturas con una búsqueda realizada

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

> **Captura:** `docker compose ps` con `servidor_wp` y `servidor_mysql` activos

> **Captura:** navegador accediendo a `http://localhost` mostrando el instalador de WordPress

```bash
docker compose down -v   # elimina también los volúmenes
```

> **Captura:** salida del comando
