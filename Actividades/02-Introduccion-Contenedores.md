## Práctica 2 — Introducción a los contenedores Docker

Actividad basada en el módulo 3 del curso [josedom24/curso_docker_ies](https://github.com/josedom24/curso_docker_ies).

---

## 1. El "Hola Mundo" de Docker

```bash
docker run ubuntu /bin/echo 'Hello world'
```

> **Captura:** salida del comando mostrando "Hello world"

Cuando ejecutamos `docker run`, Docker busca la imagen localmente. Si no existe la descarga del registro. Cada `docker run` crea un contenedor nuevo.

---

## 2. Ejecutar un contenedor interactivo

```bash
docker run -it --name contenedor1 ubuntu bash
```

Dentro del contenedor:

```bash
root@<id>:/# ls
root@<id>:/# cat /etc/os-release
root@<id>:/# exit
```

> **Captura:** terminal dentro del contenedor mostrando el prompt `root@<id>:/#` y la salida de `cat /etc/os-release`

---

## 3. Ciclo de vida de un contenedor

### 3.1 Listar contenedores

```bash
docker ps         # contenedores en ejecución
docker ps -a      # todos, incluidos los detenidos
```

> **Captura:** salida de `docker ps -a` mostrando `contenedor1` en estado `Exited`

### 3.2 Iniciar y parar

```bash
docker start contenedor1
docker stop contenedor1
```

> **Captura:** salida de `docker start contenedor1` y `docker ps`

### 3.3 Conectarse a un contenedor en ejecución

```bash
docker start contenedor1
docker attach contenedor1
```

> **Captura:** terminal reconectada al contenedor en ejecución

### 3.4 Ejecutar un proceso en un contenedor activo

```bash
docker start contenedor1
docker exec contenedor1 ls /etc
```

> **Captura:** listado de `/etc` devuelto por `exec` sin entrar en modo interactivo

---

## 4. Contenedores en segundo plano (modo detached)

```bash
docker run -d --name contenedor2 ubuntu bash -c "while true; do echo hello world; sleep 1; done"
```

> **Captura:** `docker ps` mostrando `contenedor2` en estado `Up`

Ver los logs del contenedor:

```bash
docker logs contenedor2
docker logs -f contenedor2   # en tiempo real
```

> **Captura:** salida de `docker logs contenedor2` con las líneas "hello world"

---

## 5. Eliminar contenedores

```bash
docker stop contenedor2
docker rm contenedor1
docker rm contenedor2
docker ps -a
```

> **Captura:** `docker ps -a` vacío tras eliminar ambos contenedores

Eliminar todos los contenedores parados de una vez:

```bash
docker container prune
```

---

## 6. Información de un contenedor

```bash
docker run -d --name webserver nginx -p 8080:80
docker inspect webserver
```

> **Captura:** fragmento de la salida de `docker inspect` mostrando la IP y el estado del contenedor
