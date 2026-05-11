## Primeros pasos en Docker

Actividad basada en los tutoriales online de [Play with Docker](https://training.play-with-docker.com/ops-stage1/).

---

## 1. Hello World en Docker

> Tutorial: https://training.play-with-docker.com/ops-s1-hello/

### 1.1 Ejecutar el primer contenedor

El comando `docker container run` descarga la imagen si no existe localmente y lanza el contenedor:

```bash
docker container run hello-world
```

<img width="1093" height="714" alt="image" src="https://github.com/user-attachments/assets/dff5429f-b062-4ac8-9623-f986ce588abd" />


### 1.2 Descargar una imagen

Podemos descargar imágenes sin ejecutarlas con `docker image pull`:

```bash
docker image pull alpine
```

<img width="1122" height="397" alt="image" src="https://github.com/user-attachments/assets/32e4aeb0-f352-4a4b-8388-ed8fe4ae32a8" />

### 1.3 Ejecutar comandos dentro de un contenedor

Se pueden pasar comandos directamente al contenedor como argumentos:

```bash
docker container run alpine ls -l
```

```bash
docker container run alpine echo "hello from alpine"
```

<img width="1212" height="736" alt="image" src="https://github.com/user-attachments/assets/b1d14d9e-0831-4494-9358-a7ab66bab978" />

### 1.4 Aislamiento de contenedores

Cada ejecución de `docker container run` crea un contenedor nuevo e independiente. Los cambios en uno no afectan a los demás:

```bash
docker container run alpine /bin/sh
```

<img width="1129" height="436" alt="image" src="https://github.com/user-attachments/assets/db90a28e-1d05-4504-bda7-828902615609" />

### 1.5 Listar contenedores

Contenedores en ejecución:

```bash
docker container ls
```

Todos los contenedores, incluidos los detenidos:

```bash
docker container ls -a
```

<img width="1918" height="444" alt="image" src="https://github.com/user-attachments/assets/6d75f9b6-0391-4b51-80ce-644397f7e935" />

### 1.6 Modo interactivo

Con las flags `-i` (stdin) y `-t` (pseudo-TTY) se obtiene una shell interactiva dentro del contenedor:

```bash
docker container run -it alpine /bin/sh
```

Dentro del contenedor:

```sh
ls
uname -a
exit
```

<img width="1479" height="352" alt="image" src="https://github.com/user-attachments/assets/06fb35bb-75a1-4de7-b79b-0c1996cec874" />

---

## 2. Imágenes Docker

> Tutorial: https://training.play-with-docker.com/ops-s1-images/

### 2.1 Inspeccionar una imagen

El comando `docker image inspect` devuelve los metadatos completos de una imagen en formato JSON:

```bash
docker image inspect alpine
```

<img width="1315" height="973" alt="image" src="https://github.com/user-attachments/assets/9b296a37-c318-4e81-9b8d-3050e322f77f" />

### 2.2 Crear una imagen desde un contenedor

Se puede instalar software dentro de un contenedor y luego hacer un `commit` para guardar el estado como nueva imagen.

Primero arrancamos un contenedor Ubuntu en modo interactivo:

```bash
docker container run -ti ubuntu bash
```

Dentro del contenedor instalamos `figlet`:

```bash
apt-get update && apt-get install -y figlet
figlet "hello docker"
exit
```

<img width="1098" height="363" alt="image" src="https://github.com/user-attachments/assets/ea03436a-c6bf-4ec6-b592-f9e35b4d2b2d" />

<img width="730" height="321" alt="image" src="https://github.com/user-attachments/assets/d1419845-da24-43c5-8cd1-dd10d3da2821" />


Obtenemos el ID del contenedor que acabamos de usar:

```bash
docker container ls -a
```

Hacemos commit del contenedor para crear una nueva imagen:

```bash
docker container commit <CONTAINER_ID>
```

Etiquetamos la imagen resultante:

```bash
docker image tag <IMAGE_ID> ourfiglet
```

Verificamos que la imagen aparece en el listado:

```bash
docker image ls
```

<img width="1582" height="819" alt="image" src="https://github.com/user-attachments/assets/efd44ee4-b44d-4bd9-bb7a-5dd1afaa54f8" />

Ejecutamos un contenedor con la nueva imagen:

```bash
docker container run ourfiglet figlet hello
```

<img width="816" height="339" alt="image" src="https://github.com/user-attachments/assets/847d6154-5c6a-458a-b130-758861b52dc0" />

### 2.3 Crear una imagen con Dockerfile

El método recomendado es usar un `Dockerfile`. Creamos el directorio de trabajo:

```bash
mkdir myimage && cd myimage
```

Creamos el archivo de la aplicación `index.js`:

```bash
cat > index.js <<EOF
var os = require("os");
var hostname = os.hostname();
console.log("hello from " + hostname);
EOF
```

Creamos el `Dockerfile`:

```bash
cat > Dockerfile <<EOF
FROM alpine
RUN apk update && apk add nodejs
COPY . /app
WORKDIR /app
CMD ["node","index.js"]
EOF
```

<img width="736" height="645" alt="image" src="https://github.com/user-attachments/assets/7ac6c9b7-8d47-4b95-bbdf-7a61dd837ec5" />

Construimos la imagen:

```bash
docker image build -t hello:v0.1 .
```

<img width="871" height="954" alt="image" src="https://github.com/user-attachments/assets/56c21fb1-53b3-431d-93ed-0e9464f77a4d" />

Ejecutamos un contenedor con la imagen creada:

```bash
docker container run hello:v0.1
```

<img width="670" height="199" alt="image" src="https://github.com/user-attachments/assets/23aabb9d-d26f-4b31-ac15-563ca7b49787" />

### 2.4 Capas de una imagen

Cada instrucción del Dockerfile genera una capa. Podemos inspeccionar el historial de capas:

```bash
docker image history hello:v0.1
```

<img width="1437" height="346" alt="image" src="https://github.com/user-attachments/assets/690f5d37-0b17-4886-b844-67f65208612e" />

Añadimos una segunda versión de la imagen modificando `index.js`:

```bash
cat >> index.js <<EOF
console.log("this is v0.2");
EOF
```

Construimos la nueva versión:

```bash
docker image build -t hello:v0.2 .
```

<img width="1266" height="712" alt="image" src="https://github.com/user-attachments/assets/546ca70b-95ee-45af-9e65-fbbc5d441720" />

Ejecutamos la nueva versión:

```bash
docker container run hello:v0.2
```

<img width="687" height="235" alt="image" src="https://github.com/user-attachments/assets/1f2a7782-3756-499b-bfbc-43bbcc7f39d3" />

Comprobamos que ambas versiones coexisten:

```bash
docker image ls
```

<img width="1264" height="573" alt="image" src="https://github.com/user-attachments/assets/4d1401a6-bd11-4ff5-9270-69a6685eeb0a" />
