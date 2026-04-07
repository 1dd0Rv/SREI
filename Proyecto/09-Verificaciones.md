## Verificaciones y pruebas

Una vez levantado el proyecto y creado un cliente de prueba, verificamos que todos los servicios funcionan correctamente.

### 1. Estado de los contenedores

```Bash
docker ps
```

Debemos ver los dos contenedores corriendo:
- `marisma-web` → Contenedor principal con todos los servicios
- `marisma-db` → MariaDB

<!-- CAPTURA: docker ps -->

### 2. Estado de los servicios internos

```Bash
docker logs marisma-web
```

Los 4 servicios deben estar en RUNNING:
- apache2
- bind9
- proftpd
- sshd

<!-- CAPTURA: docker logs con los 4 servicios RUNNING -->

### 3. Creación de cliente de prueba

```Bash
docker exec marisma-web /usr/local/bin/marisma/crear_cliente.sh -u pepito -i 172.20.0.10 -p Test1234
```

<!-- CAPTURA: Salida del script con los 7 pasos -->

### 4. Verificación DNS

Comprobamos que el subdominio resuelve correctamente:

```Bash
docker exec marisma-web dig pepito.marisma.local @127.0.0.1
```

Resultado esperado: `pepito.marisma.local.  86400  IN  A  172.20.0.10`

<!-- CAPTURA: dig -->

### 5. Verificación Web (Apache + PHP)

Comprobamos que Apache sirve la página del cliente:

```Bash
docker exec marisma-web curl -s -H "Host: pepito.marisma.local" http://127.0.0.1 | head -5
```

Debe mostrar el HTML de la página de bienvenida.

<!-- CAPTURA: curl -->

### 6. Verificación Base de Datos

Comprobamos que la base de datos y el usuario fueron creados:

```Bash
docker exec marisma-db mariadb -u root -prootpass123 -e "SHOW DATABASES;" | grep pepito
```

Debe mostrar `pepito_db`.

<!-- CAPTURA: SHOW DATABASES -->

### 7. Verificación SSH

Desde una máquina cliente nos conectamos por SSH:

```Bash
ssh pepito@192.168.206.172 -p 2222
```

<!-- CAPTURA: conexión SSH exitosa -->

### 8. Verificación SFTP

```Bash
sftp -P 2222 pepito@192.168.206.172
```

Una vez dentro podemos listar archivos con `ls`:

```
sftp> ls
app.py     index.html   info.php
```

<!-- CAPTURA: conexión SFTP -->

### 9. Verificación FTP con TLS

Desde un cliente con `lftp`:

```Bash
lftp
set ftp:ssl-allow true
set ssl:verify-certificate no
open -u pepito,Test1234 ftp://192.168.206.172
ls
```

También se puede verificar que el servidor ofrece TLS con `openssl`:

```Bash
openssl s_client -connect 192.168.206.172:21 -starttls ftp
```

<!-- CAPTURA: openssl mostrando CONNECTED -->

### 10. Verificación phpMyAdmin

Accedemos desde el navegador a:

```
http://192.168.206.172:8080
```

Iniciamos sesión con el usuario `pepito_usr` y la contraseña del cliente para acceder a la base de datos `pepito_db`.

<!-- CAPTURA: phpMyAdmin en el navegador -->
