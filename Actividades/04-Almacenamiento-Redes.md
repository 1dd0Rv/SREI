## Introducción a los contenedores Docker

Actividad basada en el módulo 3 del curso [josedom24/curso_docker_ies](https://github.com/josedom24/curso_docker_ies).

---

## 1. Volúmenes Docker y Bind Mount

Los contenedores son **efímeros**: si se destruye el contenedor, sus datos desaparecen. Docker ofrece dos mecanismos para persistir datos:

| Mecanismo | Descripción |
|---|---|
| **Volumen Docker** | Gestionado por Docker, almacenado en `/var/lib/docker/volumes` |
| **Bind mount** | Monta un directorio del host directamente en el contenedor |

### 1.1 Gestión de volúmenes

```bash
docker volume create miweb
docker volume ls
docker volume inspect miweb
docker volume rm miweb
docker volume prune
```

<img width="898" height="699" alt="image" src="https://github.com/user-attachments/assets/8ccb3775-5ae8-4bf7-89b3-de269ab83ad3" />

### 1.2 Asociar un volumen Docker a un contenedor

Creamos el volumen y lo asociamos a un contenedor Apache con `-v`:

```bash
docker volume create miweb

docker run -d --name my-apache-app -v miweb:/usr/local/apache2/htdocs -p 8080:80 httpd:2.4

docker exec my-apache-app bash -c 'echo "<h1>Hola</h1>" > /usr/local/apache2/htdocs/index.html'

curl http://localhost:8080
```

<img width="1303" height="618" alt="image" src="https://github.com/user-attachments/assets/beffdd0e-4108-4f96-9197-d60ae878f023" />

Destruimos el contenedor y comprobamos que los datos persisten al crear uno nuevo con el mismo volumen:

```bash
docker rm -f my-apache-app

docker run -d --name my-apache-app -v miweb:/usr/local/apache2/htdocs -p 8080:80 httpd:2.4

curl http://localhost:8080
```

<img width="1278" height="331" alt="image" src="https://github.com/user-attachments/assets/e4e0b428-416d-4e9b-abe3-9ce417a4024e" />

### 1.3 Bind mount

Creamos un directorio en el host y lo montamos en el contenedor:

```bash
mkdir web
echo "<h1>Hola</h1>" > web/index.html

docker run -d --name my-apache-app -v /home/usuario/web:/usr/local/apache2/htdocs -p 8080:80 httpd:2.4

curl http://localhost:8080
```

<img width="1156" height="316" alt="image" src="https://github.com/user-attachments/assets/0c404af1-2c27-4bdc-87a6-98e01ba5c5e7" />

Modificamos el fichero desde el host sin tocar el contenedor y verificamos el cambio en directo:

```bash
echo "<h1>Adios</h1>" > web/index.html

curl http://localhost:8080
```

<img width="1206" height="469" alt="image" src="https://github.com/user-attachments/assets/908f6d6d-966a-4788-9708-1a330555f0e7" />

---

## 2. Redes en Docker

Al instalar Docker se crean tres redes predefinidas:

```bash
docker network ls
```

<img width="640" height="226" alt="image" src="https://github.com/user-attachments/assets/5dbd600e-34f6-4c1b-a086-3642bcdde42f" />

### 2.1 Red bridge (por defecto)

Los contenedores se conectan a la red `bridge` (172.17.0.0/16) por defecto. Creamos un contenedor y consultamos su IP:

```bash
docker run -it --name contenedor1 --rm debian bash
```

En otra terminal:

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' contenedor1
```

<img width="1899" height="235" alt="image" src="https://github.com/user-attachments/assets/b47be8bc-3b0f-4b8c-b0db-cc28df174d15" />

Verificamos el bridge `docker0` en el host:

```bash
ip a
```

<img width="1441" height="208" alt="image" src="https://github.com/user-attachments/assets/28d1751b-1fbe-43c6-91fb-71265a79078e" />

### 2.2 Red host

Con la red `host` el contenedor comparte directamente la interfaz de red del anfitrión:

```bash
docker run -d --name mi_servidor --network host josedom24/aplicacionweb:v1

docker ps
```

<img width="1890" height="565" alt="image" src="https://github.com/user-attachments/assets/b0a547b2-7d7c-4f4a-b502-5f06fdfdff9e" />

Acceder al puerto 80 del servidor directamente desde el navegador para verificar la página web.

<img width="1755" height="426" alt="image" src="https://github.com/user-attachments/assets/f1f61774-0e51-4d88-bfb6-61db8ea177e6" />

### 2.3 Redes definidas por el usuario

Las redes bridge personalizadas proporcionan **resolución DNS entre contenedores**, lo cual es imprescindible en entornos de producción.

Creamos una red:

```bash
docker network create red1
docker network inspect red1
```

<img width="1005" height="984" alt="image" src="https://github.com/user-attachments/assets/855cc053-1e0c-409b-bc97-37e7c074b871" />

Lanzamos dos contenedores en esa red:

```bash
docker run -d --name my-apache-app --network red1 -p 8080:80 httpd:2.4

docker run -it --name contenedor1 --network red1 debian bash
```

Dentro de `contenedor1` instalamos `dnsutils` y probamos la resolución DNS:

```bash
apt update && apt install dnsutils -y

dig my-apache-app
cat /etc/resolv.conf
dig contenedor1
```

<img width="864" height="553" alt="image" src="https://github.com/user-attachments/assets/517ccb0f-4257-4df7-844a-021699515370" />

Conectar un contenedor en caliente a una red y opciones adicionales:

```bash
docker network connect red1 <contenedor>
docker network disconnect red1 <contenedor>
```

> **Captura:** resultado de `docker network inspect red1` tras conectar un contenedor en caliente, mostrando el nuevo contenedor en la sección `Containers`

---

## 3. Ejemplo 1: Despliegue de Guestbook

Aplicación Python (puerto 5000) con base de datos Redis (puerto 6379). Ambos contenedores deben estar en la misma red para que el frontend resuelva el nombre `redis` por DNS.

```bash
docker network create red_guestbook

docker run -d --name redis \
    --network red_guestbook \
    -v /opt/redis:/data \
    redis redis-server --appendonly yes

docker run -d -p 80:5000 \
    --name guestbook \
    --network red_guestbook \
    iesgn/guestbook
```

> **Captura:** salida de `docker ps` mostrando los dos contenedores `redis` y `guestbook` en estado `Up`

> **Captura:** navegador accediendo a `http://localhost` con la aplicación Guestbook funcionando

Verificamos la persistencia: eliminamos y recreamos el contenedor Redis:

```bash
docker rm -f redis

docker run -d --name redis \
    --network red_guestbook \
    -v /opt/redis:/data \
    redis redis-server --appendonly yes
```

> **Captura:** aplicación Guestbook en el navegador mostrando los datos anteriores tras recrear Redis

### 3.1 Configuración con variable de entorno

Si el contenedor Redis tiene un nombre distinto, se usa la variable `REDIS_SERVER`:

```bash
docker run -d --name contenedor_redis \
    --network red_guestbook \
    -v /opt/redis:/data \
    redis redis-server --appendonly yes

docker run -d -p 80:5000 \
    --name guestbook \
    -e REDIS_SERVER=contenedor_redis \
    --network red_guestbook \
    iesgn/guestbook
```

> **Captura:** salida de `docker ps` confirmando que ambos contenedores están activos con el nombre personalizado

---

## 4. Ejemplo 2: Despliegue de la aplicación Temperaturas

Aplicación de dos microservicios: `frontend` (puerto 3000) y `backend` API REST (puerto 5000). El frontend busca el backend por el nombre DNS `temperaturas-backend`.

```bash
docker network create red_temperaturas

docker run -d --name temperaturas-backend \
    --network red_temperaturas \
    iesgn/temperaturas_backend

docker run -d -p 80:3000 \
    --name temperaturas-frontend \
    --network red_temperaturas \
    iesgn/temperaturas_frontend
```

> **Captura:** salida de `docker ps` con los dos contenedores activos

> **Captura:** navegador mostrando la aplicación Temperaturas con una búsqueda de municipio realizada

### 4.1 Configuración con variable de entorno

Si el backend tiene otro nombre se usa la variable `TEMP_SERVER`:

```bash
docker run -d --name temperaturas-api \
    --network red_temperaturas \
    iesgn/temperaturas_backend

docker run -d -p 80:3000 \
    --name temperaturas-frontend \
    -e TEMP_SERVER=temperaturas-api:5000 \
    --network red_temperaturas \
    iesgn/temperaturas_frontend
```

> **Captura:** salida de `docker ps` mostrando el backend con nombre `temperaturas-api` y el frontend funcionando

---

## 5. Ejemplo 3: Despliegue de WordPress + MariaDB

WordPress requiere dos contenedores: base de datos MariaDB y servidor web WordPress. Se comunican a través de una red definida por el usuario usando variables de entorno para la configuración.

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

> **Captura:** salida de `docker ps` mostrando `servidor_mysql` (puerto 3306 sin mapear) y `servidor_wp` (0.0.0.0:80->80)

> **Captura:** navegador accediendo a `http://localhost` mostrando el asistente de instalación de WordPress (o el sitio ya instalado)

---

## 6. Ejemplo 4: Despliegue de Tomcat + Nginx (proxy inverso)

Tomcat sirve una aplicación Java (`.war`) en el puerto 8080 internamente. Nginx actúa como proxy inverso en el puerto 80, reenviando las peticiones a Tomcat usando resolución DNS por nombre de contenedor.

Descargamos los ficheros necesarios del repositorio del curso:

```bash
mkdir tomcat && cd tomcat
# Descargar sample.war y default.conf desde:
# https://github.com/josedom24/curso_docker_ies/tree/main/ejemplos/modulo3/ejemplo4
ls
```

> **Captura:** salida de `ls` mostrando `sample.war` y `default.conf` en el directorio

Creamos la red y desplegamos Tomcat:

```bash
docker network create red_tomcat

docker run -d --name aplicacionjava \
    --network red_tomcat \
    -v /home/usuario/tomcat/sample.war:/usr/local/tomcat/webapps/sample.war:ro \
    tomcat:9.0
```

> **Captura:** salida de `docker ps` mostrando el contenedor `aplicacionjava` activo (sin puerto mapeado al exterior)

Fichero `default.conf` de Nginx para el proxy inverso:

```nginx
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        proxy_pass http://aplicacionjava:8080/sample/;
    }
}
```

Desplegamos Nginx:

```bash
docker run -d --name proxy \
    -p 80:80 \
    --network red_tomcat \
    -v /home/usuario/tomcat/default.conf:/etc/nginx/conf.d/default.conf:ro \
    nginx
```

> **Captura:** salida de `docker ps` mostrando `proxy` (0.0.0.0:80->80) y `aplicacionjava` en la misma red

> **Captura:** navegador accediendo a `http://localhost` mostrando la aplicación Java de ejemplo servida a través del proxy Nginx
