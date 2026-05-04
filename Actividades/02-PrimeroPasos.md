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

> **Captura:** salida completa del comando `hello-world` mostrando el mensaje de Docker

### 1.2 Descargar una imagen

Podemos descargar imágenes sin ejecutarlas con `docker image pull`:

```bash
docker image pull alpine
```

> **Captura:** salida del pull mostrando las capas descargadas de alpine

### 1.3 Ejecutar comandos dentro de un contenedor

Se pueden pasar comandos directamente al contenedor como argumentos:

```bash
docker container run alpine ls -l
```

```bash
docker container run alpine echo "hello from alpine"
```

> **Captura:** salida de ambos comandos ejecutados en el contenedor alpine

### 1.4 Aislamiento de contenedores

Cada ejecución de `docker container run` crea un contenedor nuevo e independiente. Los cambios en uno no afectan a los demás:

```bash
docker container run alpine /bin/sh
```

> **Captura:** muestra que el contenedor se inicia y termina sin interacción (sin flag `-it`)

### 1.5 Listar contenedores

Contenedores en ejecución:

```bash
docker container ls
```

Todos los contenedores, incluidos los detenidos:

```bash
docker container ls -a
```

> **Captura:** salida de `docker container ls -a` mostrando los contenedores creados en los pasos anteriores con estado `Exited`

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

> **Captura:** sesión interactiva dentro del contenedor alpine mostrando los comandos ejecutados

---

## 2. Imágenes Docker

> Tutorial: https://training.play-with-docker.com/ops-s1-images/

### 2.1 Inspeccionar una imagen

El comando `docker image inspect` devuelve los metadatos completos de una imagen en formato JSON:

```bash
docker image inspect alpine
```

> **Captura:** fragmento de la salida JSON con campos como `Architecture`, `Os` y `RootFS`

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

> **Captura:** salida de `figlet "hello docker"` dentro del contenedor Ubuntu

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

> **Captura:** salida de `docker image ls` mostrando la imagen `ourfiglet` creada

Ejecutamos un contenedor con la nueva imagen:

```bash
docker container run ourfiglet figlet hello
```

> **Captura:** salida del comando `figlet hello` usando la imagen personalizada `ourfiglet`

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

> **Captura:** contenido del directorio con `ls -l` mostrando `index.js` y `Dockerfile`

Construimos la imagen:

```bash
docker image build -t hello:v0.1 .
```

> **Captura:** salida completa del build mostrando cada paso (`Step 1/5`, `Step 2/5`, etc.)

Ejecutamos un contenedor con la imagen creada:

```bash
docker container run hello:v0.1
```

> **Captura:** salida mostrando `hello from <container_id>`

### 2.4 Capas de una imagen

Cada instrucción del Dockerfile genera una capa. Podemos inspeccionar el historial de capas:

```bash
docker image history hello:v0.1
```

> **Captura:** tabla con las capas, sus tamaños y los comandos que las generaron

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

> **Captura:** salida del build de `v0.2` mostrando que las capas sin cambios se reutilizan desde caché (`Using cache`)

Ejecutamos la nueva versión:

```bash
docker container run hello:v0.2
```

> **Captura:** salida mostrando `hello from <id>` y `this is v0.2`

Comprobamos que ambas versiones coexisten:

```bash
docker image ls
```

> **Captura:** listado con `hello:v0.1` y `hello:v0.2` y sus IMAGE IDs
