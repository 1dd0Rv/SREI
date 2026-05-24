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

> **Captura:** salida de `docker images` mostrando la nueva imagen `ubuntu-apache2`

Verificamos que la imagen funciona:

```bash
docker run -d -p 8080:80 --name test-apache ubuntu-apache2 apachectl -D FOREGROUND
curl http://localhost:8080
```

> **Captura:** respuesta HTML del servidor Apache dentro del contenedor

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

> **Captura:** salida de `docker build` con los pasos de construcción

> **Captura:** navegador o curl mostrando "Mi web en Docker"

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

> **Captura:** salida de `docker build` mostrando las capas creadas

> **Captura:** respuesta de `curl http://localhost:5000` con el mensaje Flask

Inspeccionamos las capas de la imagen:

```bash
docker image history flask-app:v1
```

> **Captura:** historial de capas de la imagen

---

## 4. Subir una imagen a Docker Hub

Etiquetamos la imagen con nuestro usuario de Docker Hub:

```bash
docker tag flask-app:v1 <usuario_dockerhub>/flask-app:v1
docker push <usuario_dockerhub>/flask-app:v1
```

> **Captura:** salida de `docker push` confirmando la subida de las capas
