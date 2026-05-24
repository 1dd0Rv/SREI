## Práctica 6 — Creación de imágenes Docker

Actividad basada en el módulo 5 del curso [josedom24/curso_docker_ies](https://github.com/josedom24/curso_docker_ies).

---

## 1. Creación de imágenes con `docker commit`

Levantamos un contenedor Ubuntu interactivo e instalamos software:

```bash
docker run -it --name contenedor_base ubuntu bash
```

Dentro del contenedor:

```bash
apt update && apt install -y apache2
exit
```

Creamos la imagen a partir del contenedor modificado:

```bash
docker commit contenedor_base ubuntu-apache2
docker images
```

<img width="990" height="268" alt="image" src="https://github.com/user-attachments/assets/a2bf9669-8558-4846-9d7c-ff4c6ba7653a" />

Verificamos que la imagen funciona:

```bash
docker run -d -p 8080:80 --name test-apache ubuntu-apache2 apachectl -D FOREGROUND
curl http://localhost:8080
```

<img width="1261" height="967" alt="image" src="https://github.com/user-attachments/assets/8b5bdde5-624f-4705-9d58-a59628cd22e1" />

---

## 2. Creación de imágenes con Dockerfile — aplicación web estática con nginx

Estructura del proyecto:

```
mi-web/
├── Dockerfile
└── index.html
```

`index.html`:

```html
<!DOCTYPE html>
<html>
  <body><h1>Mi web en Docker</h1></body>
</html>
```

`Dockerfile`:

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

Construimos y ejecutamos:

```bash
docker build -t mi-web:v1 .
docker run -d -p 8080:80 --name miweb mi-web:v1
curl http://localhost:8080
```

<img width="1117" height="960" alt="image" src="https://github.com/user-attachments/assets/ee3ed875-ad27-463b-8707-ea63e07ae622" />

<img width="676" height="274" alt="image" src="https://github.com/user-attachments/assets/976eb14d-9e39-4f9b-bd69-11a6a2024a51" />

---

## 3. Creación de imágenes con Dockerfile — aplicación Python con Flask

Estructura del proyecto:

```
flask-app/
├── Dockerfile
├── requirements.txt
└── app.py
```

`app.py`:

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return '<h1>Hola desde Flask en Docker</h1>'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

`requirements.txt`:

```
flask
```

`Dockerfile`:

```dockerfile
FROM python:3.12-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

Construimos y ejecutamos:

```bash
docker build -t flask-app:v1 .
docker run -d -p 5000:5000 --name flask-test flask-app:v1
curl http://localhost:5000
```

<img width="993" height="700" alt="image" src="https://github.com/user-attachments/assets/a23044ba-0d9b-46c3-b72b-c85f580584f4" />

<img width="666" height="187" alt="image" src="https://github.com/user-attachments/assets/056d4c85-a610-4880-9821-b4a1d6bb4dd8" />

Inspeccionamos las capas de la imagen:

```bash
docker image history flask-app:v1
```

<img width="1456" height="544" alt="image" src="https://github.com/user-attachments/assets/841f0fa6-3e58-405f-8e0f-0cbd8b850810" />

---

## 4. Subir una imagen a Docker Hub

Etiquetamos la imagen con nuestro usuario de Docker Hub:

```bash
docker tag flask-app:v1 <usuario_dockerhub>/flask-app:v1
docker push <usuario_dockerhub>/flask-app:v1
```

<img width="1201" height="399" alt="image" src="https://github.com/user-attachments/assets/509d2856-f4b6-4c76-882f-4669ccab5124" />
