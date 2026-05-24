## Práctica 2 — Introducción a los contenedores Docker

Actividad basada en el módulo 3 del curso [josedom24/curso_docker_ies](https://github.com/josedom24/curso_docker_ies).

---

## 1. El "Hola Mundo" de Docker

```bash
docker run ubuntu /bin/echo 'Hello world'
```

<img width="438" height="105" alt="image" src="https://github.com/user-attachments/assets/20e01cea-a900-4924-9b9e-b12d5e444891" />


Cuando ejecutamos `docker run`, Docker busca la imagen localmente. Si no existe la descarga del registro. Cada `docker run` crea un contenedor nuevo.

---

## 2. Ejecutar un contenedor interactivo

```bash
docker run -it --name contenedor1 ubuntu bash
```

<img width="692" height="310" alt="image" src="https://github.com/user-attachments/assets/5f6ad628-0da6-4402-9ba4-8190bf5c7222" />


---

## 3. Ciclo de vida de un contenedor

### 3.1 Listar contenedores

```bash
docker ps         # contenedores en ejecución
docker ps -a      # todos, incluidos los detenidos
```

<img width="1169" height="178" alt="image" src="https://github.com/user-attachments/assets/5edad0f7-f101-479f-8fac-c7e1292a30c7" />


### 3.2 Iniciar y parar

```bash
docker start contenedor1
docker stop contenedor1
```

<img width="758" height="155" alt="image" src="https://github.com/user-attachments/assets/0e43e07d-f4e3-4be3-8aed-03d08a43fd94" />
`

### 3.3 Conectarse a un contenedor en ejecución

```bash
docker start contenedor1
docker attach contenedor1
```

<img width="853" height="355" alt="image" src="https://github.com/user-attachments/assets/2447d4cb-114c-4caa-8269-0403af929212" />


### 3.4 Ejecutar un proceso en un contenedor activo

```bash
docker start contenedor1
docker exec contenedor1 ls /etc
```

<img width="379" height="299" alt="image" src="https://github.com/user-attachments/assets/0d1766f1-d976-414b-97d9-ff719860780c" />


---

## 4. Contenedores en segundo plano (modo detached)

```bash
docker run -d --name contenedor2 ubuntu bash -c "while true; do echo hello world; sleep 1; done"
```

<img width="908" height="203" alt="image" src="https://github.com/user-attachments/assets/a40cde88-0383-438a-9e38-5d8d3d5738e8" />


Ver los logs del contenedor:

```bash
docker logs contenedor2
docker logs -f contenedor2   # en tiempo real
```
<img width="436" height="751" alt="image" src="https://github.com/user-attachments/assets/74965900-3c02-40f2-997c-fdc4586d98a0" />


---

## 5. Eliminar contenedores

```bash
docker stop contenedor2
docker rm contenedor1
docker rm contenedor2
docker ps -a
```

<img width="1121" height="214" alt="image" src="https://github.com/user-attachments/assets/707d0876-fc34-40e5-9fe1-12a016204f16" />


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

<img width="1544" height="740" alt="image" src="https://github.com/user-attachments/assets/9dd93b50-7eb2-4e0f-b72b-154d28b582a5" />

