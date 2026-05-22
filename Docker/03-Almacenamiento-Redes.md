# Módulo 3: Almacenamiento y Redes en Docker

> **Referencia:** [modulo3 — curso_docker_ies](https://github.com/josedom24/curso_docker_ies#3-almacenamiento-y-redes-en-docker)

---

## 1. Volúmenes Docker

### Gestión de volúmenes

Crear, listar e inspeccionar un volumen:

```bash
docker volume create mivol
docker volume ls
docker volume inspect mivol
```

> 📸 **Captura:** `docker volume ls` y `docker volume inspect mivol` con la ruta en `/var/lib/docker/volumes/`

### Asociar un volumen a un contenedor

Crear un contenedor MariaDB con un volumen para persistencia:

```bash
docker run -d --name mariadb1 \
  -v mivol:/var/lib/mysql \
  -e MARIADB_ROOT_PASSWORD=root \
  mariadb
```

> 📸 **Captura:** `docker ps` con el contenedor `mariadb1` en estado `Up`

Crear una base de datos dentro del contenedor:

```bash
docker exec -it mariadb1 mariadb -u root -proot -e "CREATE DATABASE prueba;"
docker exec -it mariadb1 mariadb -u root -proot -e "SHOW DATABASES;"
```

> 📸 **Captura:** `SHOW DATABASES` mostrando la base de datos `prueba`

Eliminar el contenedor y crear uno nuevo con el mismo volumen — los datos deben persistir:

```bash
docker rm -f mariadb1
docker run -d --name mariadb2 \
  -v mivol:/var/lib/mysql \
  -e MARIADB_ROOT_PASSWORD=root \
  mariadb
docker exec -it mariadb2 mariadb -u root -proot -e "SHOW DATABASES;"
```

> 📸 **Captura:** `SHOW DATABASES` en `mariadb2` mostrando que la base `prueba` sigue existiendo

---

## 2. Bind Mount

Montar un directorio local dentro del contenedor Apache:

```bash
mkdir -p ~/public_html
echo "<h1>Hola desde bind mount</h1>" > ~/public_html/index.html

docker run -d --name apache_bind \
  -p 8080:80 \
  -v ~/public_html:/usr/local/apache2/htdocs/ \
  httpd:2.4
```

> 📸 **Captura:** Navegador en `http://localhost:8080` mostrando `Hola desde bind mount`

Modificar el fichero en el host y comprobar el cambio en vivo:

```bash
echo "<h1>Contenido actualizado</h1>" > ~/public_html/index.html
```

> 📸 **Captura:** Navegador tras refrescar mostrando `Contenido actualizado`

---

## 3. Redes en Docker

### Redes predefinidas

Listar las redes disponibles:

```bash
docker network ls
```

> 📸 **Captura:** `docker network ls` mostrando `bridge`, `host` y `none`

### Red bridge (por defecto)

Crear un contenedor y obtener su IP en la red bridge:

```bash
docker run -it --name contenedor1 --rm debian bash
```

En otra terminal:

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' contenedor1
```

> 📸 **Captura:** IP del contenedor en el rango `172.17.0.0/16`

### Red host

Ejecutar un contenedor en la red del host:

```bash
docker run -d --name web_host --network host josedom24/aplicacionweb:v1
docker ps
```

> 📸 **Captura:** `docker ps` sin mapeo de puertos y acceso directo al puerto 80 del host

---

## 4. Redes definidas por el usuario

Crear una red personalizada:

```bash
docker network create red_propia
docker network ls
```

> 📸 **Captura:** `docker network ls` mostrando `red_propia` de tipo `bridge`

Conectar dos contenedores a la misma red y verificar resolución DNS:

```bash
docker run -d --name serv1 --network red_propia nginx
docker run -it --name cliente --network red_propia debian bash
# Dentro: apt update && apt install -y curl && curl http://serv1
```

> 📸 **Captura:** Respuesta HTML de nginx desde el contenedor `cliente` resolviendo por nombre `serv1`

---

## 5. Ejemplo: Despliegue de WordPress + MariaDB

Crear la red y los dos contenedores con persistencia:

```bash
docker network create red_wp

docker run -d --name servidor_mysql \
  --network red_wp \
  -v /opt/mysql_wp:/var/lib/mysql \
  -e MYSQL_DATABASE=bd_wp \
  -e MYSQL_USER=user_wp \
  -e MYSQL_PASSWORD=asdasd \
  -e MYSQL_ROOT_PASSWORD=asdasd \
  mariadb

docker run -d --name servidor_wp \
  --network red_wp \
  -v /opt/wordpress:/var/www/html/wp-content \
  -e WORDPRESS_DB_HOST=servidor_mysql \
  -e WORDPRESS_DB_USER=user_wp \
  -e WORDPRESS_DB_PASSWORD=asdasd \
  -e WORDPRESS_DB_NAME=bd_wp \
  -p 80:80 \
  wordpress

docker ps
```

> 📸 **Captura:** `docker ps` con ambos contenedores (`servidor_mysql` y `servidor_wp`) en estado `Up`

Acceder al instalador de WordPress:

> 📸 **Captura:** Navegador en `http://localhost` mostrando el instalador de WordPress

Completar la instalación y acceder al panel de administración:

> 📸 **Captura:** Panel de administración de WordPress (`/wp-admin`)

Limpiar:

```bash
docker rm -f servidor_wp servidor_mysql
docker network rm red_wp
```
