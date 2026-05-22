# Práctica 2 — Módulo 1: Introducción a los contenedores Docker

> **Referencia:** [modulo1 — curso_docker_ies](https://github.com/josedom24/curso_docker_ies#1-introducci%C3%B3n-a-los-contenedores-docker)

---

## 1. Instalación de Docker

Verificar que Docker está instalado correctamente:

```bash
docker --version
docker info
```

> 📸 **Captura:** Salida de `docker --version` y `docker info`

---

## 2. El "Hola Mundo" de Docker

Crear el primer contenedor desde la imagen `hello-world`:

```bash
docker run hello-world
```

> 📸 **Captura:** Salida completa del `docker run hello-world` con el mensaje de bienvenida

Listar contenedores en ejecución y parados:

```bash
docker ps
docker ps -a
```

> 📸 **Captura:** Resultado de `docker ps -a` mostrando el contenedor `hello-world` en estado `Exited`

Eliminar el contenedor:

```bash
docker rm <ID_o_NOMBRE>
```

> 📸 **Captura:** Confirmación del borrado y `docker ps -a` vacío

---

## 3. Ejecución simple de contenedores

Ejecutar un comando dentro de un contenedor Ubuntu:

```bash
docker run ubuntu echo 'Hello world'
```

> 📸 **Captura:** Descarga de la imagen Ubuntu y ejecución del echo

Verificar el contenedor parado y las imágenes descargadas:

```bash
docker ps -a
docker images
```

> 📸 **Captura:** `docker images` mostrando `ubuntu` y `hello-world`

---

## 4. Contenedor interactivo

Crear un contenedor con sesión interactiva:

```bash
docker run -it --name contenedor1 ubuntu bash
```

Dentro del contenedor, ejecutar algunos comandos (ej: `ls`, `cat /etc/os-release`) y salir con `exit`.

> 📸 **Captura:** Sesión dentro del contenedor Ubuntu con prompt `root@<id>`

Volver a conectarse al contenedor parado:

```bash
docker start contenedor1
docker attach contenedor1
```

> 📸 **Captura:** Reconexión al contenedor con `docker start` + `docker attach`

Ejecutar un comando sin entrar al contenedor:

```bash
docker start contenedor1
docker exec contenedor1 ls -al
```

> 📸 **Captura:** Salida de `docker exec contenedor1 ls -al`

Inspeccionar el contenedor:

```bash
docker inspect contenedor1
```

> 📸 **Captura:** Fragmento del JSON de `docker inspect` (al menos el bloque `State` y `NetworkSettings`)

---

## 5. Contenedor demonio

Crear un contenedor en segundo plano con un proceso en bucle:

```bash
docker run -d --name contenedor2 ubuntu bash -c "while true; do echo hello world; sleep 1; done"
```

> 📸 **Captura:** `docker ps` mostrando `contenedor2` en estado `Up`

Ver los logs del contenedor:

```bash
docker logs contenedor2
docker logs -f contenedor2
```

> 📸 **Captura:** Salida de `docker logs contenedor2` con las líneas `hello world`

Parar y eliminar el contenedor:

```bash
docker stop contenedor2
docker rm contenedor2
```

> 📸 **Captura:** `docker ps -a` confirmando que el contenedor ya no existe

---

## 6. Contenedor con servidor web (Apache)

Lanzar un servidor Apache mapeando el puerto 8080 del host al 80 del contenedor:

```bash
docker run -d --name my-apache-app -p 8080:80 httpd:2.4
```

> 📸 **Captura:** `docker ps` con el contenedor `my-apache-app` y el mapeo de puertos `0.0.0.0:8080->80/tcp`

Acceder desde el navegador a `http://localhost:8080`:

> 📸 **Captura:** Página por defecto de Apache en el navegador

Modificar el `index.html` dentro del contenedor:

```bash
docker exec my-apache-app bash -c 'echo "<h1>Curso Docker</h1>" > /usr/local/apache2/htdocs/index.html'
```

> 📸 **Captura:** Navegador mostrando `Curso Docker` tras la modificación

Ver los logs del servidor web:

```bash
docker logs my-apache-app
```

> 📸 **Captura:** Logs de acceso HTTP de Apache

---

## 7. Variables de entorno

Crear un contenedor con una variable de entorno personalizada:

```bash
docker run -it --name prueba -e USUARIO=prueba ubuntu bash
# Dentro: echo $USUARIO
```

> 📸 **Captura:** Salida de `echo $USUARIO` dentro del contenedor mostrando `prueba`

Desplegar MariaDB con variables de entorno obligatorias:

```bash
docker run -d --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb
docker ps
```

> 📸 **Captura:** `docker ps` con el contenedor `some-mariadb` en estado `Up`

Verificar la variable de entorno dentro del contenedor:

```bash
docker exec -it some-mariadb env
```

> 📸 **Captura:** Salida de `env` mostrando `MARIADB_ROOT_PASSWORD`

Acceder a la base de datos:

```bash
docker exec -it some-mariadb mariadb -u root -p
```

> 📸 **Captura:** Prompt `MariaDB [(none)]>` tras iniciar sesión

Eliminar y recrear el contenedor mapeando el puerto 3306:

```bash
docker rm -f some-mariadb
docker run -d -p 3306:3306 --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb
docker ps
```

> 📸 **Captura:** `docker ps` con el mapeo `0.0.0.0:3306->3306/tcp`

Conectarse desde el host (si tienes cliente mysql/mariadb instalado):

```bash
mysql -u root -p -h 127.0.0.1
```

> 📸 **Captura:** Conexión exitosa al servidor MariaDB desde el host
