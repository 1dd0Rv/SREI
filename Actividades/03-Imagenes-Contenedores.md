## Práctica 3 — Imágenes y contenedores

---

## Tareas realizadas

### 1. Descargar la imagen de Ubuntu

```bash
docker pull ubuntu
```

> **Captura:**

---

### 2. Descargar la imagen de hello-world

```bash
docker pull hello-world
```

> **Captura:**

---

### 3. Descargar la imagen de nginx

```bash
docker pull nginx
```

> **Captura:**

---

### 4. Listado de todas las imágenes

```bash
docker images
```

> **Captura:**

---

### 5. Ejecutar contenedor hello-world con nombre "myhello1"

```bash
docker run --name myhello1 hello-world
```

> **Captura:**

---

### 6. Ejecutar contenedor hello-world con nombre "myhello2"

```bash
docker run --name myhello2 hello-world
```

> **Captura:**

---

### 7. Ejecutar contenedor hello-world con nombre "myhello3"

```bash
docker run --name myhello3 hello-world
```

> **Captura:**

---

### 8. Mostrar los contenedores en ejecución

```bash
docker ps
```

> **Captura:**

---

### 9. Parar el contenedor "myhello1"

```bash
docker stop myhello1
```

> **Captura:**

---

### 10. Parar el contenedor "myhello2"

```bash
docker stop myhello2
```

> **Captura:**

---

### 11. Borrar el contenedor "myhello1"

```bash
docker rm myhello1
```

> **Captura:**

---

### 12. Mostrar los contenedores en ejecución

```bash
docker ps -a
```

> **Captura:** se observa que `myhello1` ya no aparece, y `myhello2` figura como detenido

---

### 13. Borrar todos los contenedores

```bash
docker rm myhello2 myhello3
docker ps -a
```

> **Captura:** `docker ps -a` vacío tras borrar todos los contenedores
