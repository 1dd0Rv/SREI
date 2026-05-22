# Módulo 4: Escenarios multicontenedor con Docker Compose

> **Referencia:** [modulo4 — curso_docker_ies](https://github.com/josedom24/curso_docker_ies#4-creando-escenarios-multicontenedor-con-docker-compose)

---

## 1. Instalación y verificación

Verificar que Docker Compose está disponible:

```bash
docker compose version
```

> 📸 **Captura:** Versión de Docker Compose instalada

---

## 2. El fichero docker-compose.yaml

Crear un directorio de prueba con un `docker-compose.yaml` para Let's Chat:

```bash
mkdir letschat && cd letschat
```

Contenido del fichero `docker-compose.yaml`:

```yaml
version: '3.1'
services:
  app:
    container_name: letschat
    image: sdelements/lets-chat
    restart: always
    environment:
      LCB_DATABASE_URI: mongodb://mongo/letschat
    ports:
      - 80:8080
    depends_on:
      - db
  db:
    container_name: mongo
    image: mongo:4
    restart: always
    volumes:
      - mongo:/data/db
volumes:
  mongo:
```

> 📸 **Captura:** Contenido del fichero `docker-compose.yaml` en el editor o con `cat`

---

## 3. Comandos básicos de Docker Compose

Levantar el escenario en segundo plano:

```bash
docker compose up -d
```

> 📸 **Captura:** Salida de `docker compose up -d` con los contenedores creados/iniciados

Listar los contenedores del escenario:

```bash
docker compose ps
```

> 📸 **Captura:** `docker compose ps` con `letschat` y `mongo` en estado `Up`

Ver los logs:

```bash
docker compose logs
```

> 📸 **Captura:** Fragmento de logs del escenario

Parar los contenedores sin eliminarlos:

```bash
docker compose stop
docker compose ps
```

> 📸 **Captura:** `docker compose ps` con los contenedores en estado `Exited`

Eliminar el escenario completo (contenedores + red, conservando volúmenes):

```bash
docker compose down
```

> 📸 **Captura:** Salida de `docker compose down`

---

## 4. Ejemplo: WordPress + MariaDB con Docker Compose

Crear un directorio y el fichero `docker-compose.yaml`:

```bash
mkdir wordpress && cd wordpress
```

Contenido con **volúmenes Docker**:

```yaml
version: '3.1'
services:
  wordpress:
    container_name: servidor_wp
    image: wordpress
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: user_wp
      WORDPRESS_DB_PASSWORD: asdasd
      WORDPRESS_DB_NAME: bd_wp
    ports:
      - 80:80
    volumes:
      - wordpress_data:/var/www/html/wp-content
  db:
    container_name: servidor_mysql
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: bd_wp
      MYSQL_USER: user_wp
      MYSQL_PASSWORD: asdasd
      MYSQL_ROOT_PASSWORD: asdasd
    volumes:
      - mariadb_data:/var/lib/mysql
volumes:
    wordpress_data:
    mariadb_data:
```

Lanzar el escenario:

```bash
docker compose up -d
docker compose ps
```

> 📸 **Captura:** `docker compose ps` con `servidor_wp` y `servidor_mysql` en estado `Up`

> 📸 **Captura:** Instalador de WordPress en `http://localhost`

Verificar la persistencia: parar, eliminar y volver a levantar — WordPress debe recordar la configuración:

```bash
docker compose down
docker compose up -d
```

> 📸 **Captura:** WordPress funcionando tras el ciclo down/up (sin reiniciar instalación)

Eliminar el escenario incluyendo volúmenes:

```bash
docker compose down -v
```

> 📸 **Captura:** Salida de `docker compose down -v` confirmando el borrado de volúmenes

---

## 5. Almacenamiento con Docker Compose (bind mount)

Modificar el `docker-compose.yaml` anterior para usar **bind mount** en lugar de volúmenes:

```yaml
    volumes:
      - ./wordpress:/var/www/html/wp-content
  db:
    ...
    volumes:
      - ./mysql:/var/lib/mysql
```

```bash
docker compose up -d
ls -la
```

> 📸 **Captura:** Directorios `wordpress/` y `mysql/` creados en el host por el bind mount
