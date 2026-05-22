# Módulo 2: Imágenes Docker

> **Referencia:** [modulo2 — curso_docker_ies](https://github.com/josedom24/curso_docker_ies#2-im%C3%A1genes-docker)

---

## 1. Registros de imágenes: Docker Hub

Explorar Docker Hub en [https://hub.docker.com](https://hub.docker.com) y buscar la imagen oficial de `nginx`.

> 📸 **Captura:** Página de la imagen `nginx` en Docker Hub mostrando etiquetas disponibles

Buscar imágenes desde la terminal:

```bash
docker search nginx
```

> 📸 **Captura:** Resultado de `docker search nginx` con el listado de imágenes

---

## 2. Gestión de imágenes

Descargar una imagen sin crear contenedor:

```bash
docker pull nginx
```

> 📸 **Captura:** Proceso de descarga de capas de `nginx`

Listar imágenes locales:

```bash
docker images
```

> 📸 **Captura:** Listado de imágenes con columnas `REPOSITORY`, `TAG`, `IMAGE ID`, `SIZE`

Inspeccionar una imagen:

```bash
docker inspect nginx
```

> 📸 **Captura:** Fragmento del JSON con arquitectura, OS y capas (`RootFS.Layers`)

Eliminar una imagen:

```bash
docker rmi nginx
```

> 📸 **Captura:** Confirmación del borrado y `docker images` sin la imagen `nginx`

---

## 3. Cómo se organizan las imágenes (capas)

Descargar dos versiones distintas de Ubuntu y observar las capas compartidas:

```bash
docker pull ubuntu:22.04
docker pull ubuntu:20.04
docker images
```

> 📸 **Captura:** `docker images` con ambas versiones de Ubuntu y sus tamaños

---

## 4. Creación de contenedores desde imágenes con etiquetas

Ejecutar un contenedor especificando etiqueta concreta:

```bash
docker run -d -p 8080:80 --name web_nginx nginx:1.24
docker ps
```

> 📸 **Captura:** `docker ps` con el contenedor corriendo y acceso al navegador en `http://localhost:8080`

---

## 5. Ejemplo: Desplegando distintas versiones de Mediawiki

Instalar la última versión de Mediawiki:

```bash
docker run -d -p 8080:80 --name mediawiki1 mediawiki
```

> 📸 **Captura:** Navegador en `http://localhost:8080` mostrando la versión instalada de Mediawiki

Instalar una versión anterior en otro puerto:

```bash
docker run -d -p 8081:80 --name mediawiki2 mediawiki:1.40.2
```

> 📸 **Captura:** Navegador en `http://localhost:8081` mostrando la versión `1.40.2`

Instalar una tercera versión:

```bash
docker run -d -p 8082:80 --name mediawiki3 mediawiki:1.39.6
```

> 📸 **Captura:** Navegador en `http://localhost:8082` mostrando la versión `1.39.6`

Comparar las tres versiones activas:

```bash
docker ps
docker images | grep mediawiki
```

> 📸 **Captura:** `docker ps` con los tres contenedores en ejecución y `docker images` con las tres etiquetas de mediawiki

Limpiar:

```bash
docker rm -f mediawiki1 mediawiki2 mediawiki3
```
