## Práctica 3 — Imágenes y contenedores

---

## Tareas realizadas

### 1. Descargar la imagen de Ubuntu

```bash
docker pull ubuntu
```

<img width="662" height="166" alt="image" src="https://github.com/user-attachments/assets/526ca441-0490-4b51-9a2a-1dab5b67c76e" />


---

### 2. Descargar la imagen de hello-world

```bash
docker pull hello-world
```
<img width="657" height="168" alt="image" src="https://github.com/user-attachments/assets/d2e47197-847a-4e10-acd0-c8e5deb39dda" />


---

### 3. Descargar la imagen de nginx

```bash
docker pull nginx
```

<img width="666" height="172" alt="image" src="https://github.com/user-attachments/assets/57d833da-c83d-40eb-a4d8-c08499e0ad50" />


---

### 4. Listado de todas las imágenes

```bash
docker images
```

<img width="726" height="354" alt="image" src="https://github.com/user-attachments/assets/e465e4b1-d616-446c-81b6-a8b0d88a4fbe" />


---

### 5. Ejecutar contenedor hello-world con nombre "myhello1"

```bash
docker run --name myhello1 hello-world
```

<img width="662" height="404" alt="image" src="https://github.com/user-attachments/assets/0f7fc72a-9a0e-4b90-8ce0-49a23339972b" />


---

### 6. Ejecutar contenedor hello-world con nombre "myhello2"

```bash
docker run --name myhello2 hello-world
```

<img width="662" height="423" alt="image" src="https://github.com/user-attachments/assets/23ed86f9-73b5-4e01-b279-b7b57c60a893" />


---

### 7. Ejecutar contenedor hello-world con nombre "myhello3"

```bash
docker run --name myhello3 hello-world
```

<img width="665" height="407" alt="image" src="https://github.com/user-attachments/assets/cd964b9d-70bf-470a-a679-52475855e050" />


---

### 8. Mostrar los contenedores en ejecución

```bash
docker ps -a
```

<img width="1085" height="192" alt="image" src="https://github.com/user-attachments/assets/e9a26c4d-968f-4957-b645-b7de268e3df1" />


---

### 9. Parar el contenedor "myhello1"

```bash
docker stop myhello1
```
<img width="299" height="93" alt="image" src="https://github.com/user-attachments/assets/4a7b2739-b800-407c-91e2-dee054566ee0" />


---

### 10. Parar el contenedor "myhello2"

```bash
docker stop myhello2
```

<img width="358" height="116" alt="image" src="https://github.com/user-attachments/assets/c41b4975-6b84-400b-8c18-e228bfc84c10" />



---

### 11. Borrar el contenedor "myhello1"

```bash
docker rm myhello1
```

<img width="301" height="150" alt="image" src="https://github.com/user-attachments/assets/b295a951-2cf0-4726-a373-faef050dac19" />

---

### 12. Mostrar los contenedores en ejecución

```bash
docker ps -a
```

<img width="1127" height="181" alt="image" src="https://github.com/user-attachments/assets/39a8d28a-96f4-4544-a2ab-75c3af54e5d2" />

---

### 13. Borrar todos los contenedores

```bash
docker rm myhello2 myhello3
docker ps -a
```

<img width="1131" height="248" alt="image" src="https://github.com/user-attachments/assets/cc8e541b-5422-472b-95d4-b49899d0e4db" />
