# Módulo 5: Creación de imágenes en Docker

> **Referencia:** [modulo5 — curso_docker_ies](https://github.com/josedom24/curso_docker_ies#5-creaci%C3%B3n-de-im%C3%A1genes-en-docker)

---

## 1. Crear imagen desde un contenedor (docker commit)

Crear un contenedor, modificarlo e instalar software:

```bash
docker run -it --name contenedor_base debian bash
# Dentro:
apt update && apt install -y apache2
exit
```

> 📸 **Captura:** Instalación de Apache dentro del contenedor

Generar una imagen a partir del contenedor modificado:

```bash
docker commit contenedor_base mi_apache:v1
docker images | grep mi_apache
```

> 📸 **Captura:** `docker images` mostrando la imagen `mi_apache:v1` recién creada

Arrancar un contenedor a partir de la imagen creada:

```bash
docker run -d -p 8080:80 --name web_custom mi_apache:v1 apache2ctl -D FOREGROUND
```

> 📸 **Captura:** `docker ps` y navegador en `http://localhost:8080`

---

## 2. Creación de imágenes con Dockerfile

### Estructura básica

Crear el contexto (directorio de trabajo):

```bash
mkdir ~/build && cd ~/build
echo "<h1>Curso Docker</h1>" > index.html
```

Crear el fichero `Dockerfile`:

```dockerfile
# syntax=docker/dockerfile:1
FROM debian:stable-slim
RUN apt-get update && apt-get install -y apache2
WORKDIR /var/www/html
COPY index.html .
CMD apache2ctl -D FOREGROUND
```

> 📸 **Captura:** Contenido del `Dockerfile` y del `index.html` en el directorio de contexto

Construir la imagen:

```bash
docker build -t mi_apache2:v2 .
```

> 📸 **Captura:** Proceso de `docker build` mostrando cada paso (Step 1/5, Step 2/5...)

Verificar la imagen generada:

```bash
docker images | grep mi_apache2
```

> 📸 **Captura:** `docker images` con `mi_apache2:v2` y su tamaño

Arrancar el contenedor:

```bash
docker run -d -p 8080:80 --name servidor_web mi_apache2:v2
```

> 📸 **Captura:** Navegador en `http://localhost:8080` mostrando `Curso Docker`

---

## 3. Ejemplo 1: Imagen con página estática

### Versión 1 — Desde imagen base Debian

Estructura del contexto:

```
build/
├── Dockerfile
└── public_html/
    └── index.html
```

```dockerfile
# syntax=docker/dockerfile:1
FROM debian:stable-slim
RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /var/www/html/
COPY public_html .
EXPOSE 80
CMD apache2ctl -D FOREGROUND
```

```bash
docker build -t mi_imagen:v1 .
docker run -d -p 80:80 --name web1 mi_imagen:v1
```

> 📸 **Captura:** Navegador mostrando la página estática servida por Apache

### Versión 2 — Desde imagen `httpd:2.4`

```dockerfile
# syntax=docker/dockerfile:1
FROM httpd:2.4
COPY public_html /usr/local/apache2/htdocs/
EXPOSE 80
```

```bash
docker build -t mi_imagen:v2 .
docker run -d -p 8080:80 --name web2 mi_imagen:v2
```

> 📸 **Captura:** Navegador en `:8080` mostrando la misma página desde la imagen `httpd`

### Versión 3 — Desde imagen `nginx`

```dockerfile
# syntax=docker/dockerfile:1
FROM nginx:1.24
COPY public_html /usr/share/nginx/html
EXPOSE 80
```

```bash
docker build -t mi_imagen:v3 .
docker run -d -p 8081:80 --name web3 mi_imagen:v3
```

> 📸 **Captura:** Navegador en `:8081` mostrando la página desde Nginx

Comparar las tres imágenes y sus tamaños:

```bash
docker images | grep mi_imagen
```

> 📸 **Captura:** Las tres versiones (`v1`, `v2`, `v3`) con sus distintos tamaños

---

## 4. Distribución de imágenes

Etiquetar la imagen con tu usuario de Docker Hub:

```bash
docker tag mi_imagen:v1 <tu_usuario_dockerhub>/mi_imagen:v1
```

Iniciar sesión y subir la imagen:

```bash
docker login
docker push <tu_usuario_dockerhub>/mi_imagen:v1
```

> 📸 **Captura:** Proceso de `docker push` subiendo las capas al registro

> 📸 **Captura:** Página de la imagen en Docker Hub (`hub.docker.com`) tras el push

Descargar la imagen desde otro equipo (o eliminarla y volver a bajarla):

```bash
docker rmi <tu_usuario_dockerhub>/mi_imagen:v1
docker pull <tu_usuario_dockerhub>/mi_imagen:v1
```

> 📸 **Captura:** `docker pull` descargando la imagen desde Docker Hub
