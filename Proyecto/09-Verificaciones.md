## Verificaciones y pruebas

Una vez levantado el proyecto y creado un cliente de prueba, verificamos que todos los servicios funcionan correctamente.

### 1. Estado de los contenedores

```Bash
docker ps
```

Debemos ver los dos contenedores corriendo:
- `marisma-web` → Contenedor principal con todos los servicios
- `marisma-db` → MariaDB

<img width="1433" height="195" alt="image" src="https://github.com/user-attachments/assets/043ceb79-d985-417c-b77d-fd3a303f5855" />


### 2. Estado de los servicios internos

```Bash
docker logs marisma-web
```

Los 4 servicios deben estar en RUNNING:
- apache2
- bind9
- proftpd
- sshd

<img width="1009" height="194" alt="image" src="https://github.com/user-attachments/assets/10b8e259-03c8-4db3-b27d-d95cb4f5ab13" />


### 3. Creación de cliente de prueba

```Bash
docker exec marisma-web /usr/local/bin/marisma/crear_cliente.sh -u Juan -i 172.20.0.10 -p Test1234
```

<img width="1019" height="586" alt="image" src="https://github.com/user-attachments/assets/3ca0645c-ead5-4387-b417-489445d8417a" />


### 4. Verificación DNS

Comprobamos que el subdominio resuelve correctamente:

```Bash
docker exec marisma-web dig juan.marisma.local @127.0.0.1
```

Resultado esperado: `juan.marisma.local.  86400  IN  A  172.20.0.10`

<img width="763" height="388" alt="image" src="https://github.com/user-attachments/assets/3ca85f53-8818-4125-9cd7-defcd103c4bc" />


### 5. Verificación Web (Apache + PHP)

Comprobamos que Apache sirve la página del cliente:

```Bash
docker exec marisma-web curl -s -H "Host: juan.marisma.local" http://127.0.0.1 | head -5
```

Debe mostrar el HTML de la página de bienvenida.

<img width="985" height="164" alt="image" src="https://github.com/user-attachments/assets/6090855f-1e30-4415-bae0-a4e347d240b4" />


### 6. Verificación Base de Datos

Comprobamos que la base de datos y el usuario fueron creados:

```Bash
docker exec marisma-db mariadb -u root -prootpass123 -e "SHOW DATABASES;" | grep pepito
```

Debe mostrar `juan_db`.

<img width="929" height="90" alt="image" src="https://github.com/user-attachments/assets/2af1269f-fbb6-48d0-9f79-bfd87b55a6c2" />


### 7. Verificación SSH

Desde una máquina cliente nos conectamos por SSH:

```Bash
ssh juan@192.168.206.172 -p 2222
```

<img width="878" height="327" alt="image" src="https://github.com/user-attachments/assets/2f640ceb-ba2d-436a-a90a-e54f5e92ebfb" />


### 8. Verificación SFTP

```Bash
sftp -P 2222 juan@192.168.206.172
```

Una vez dentro podemos listar archivos con `ls`:

```
sftp> ls
app.py     index.html   info.php
```

<img width="563" height="224" alt="image" src="https://github.com/user-attachments/assets/a89449b6-af09-4794-b0c9-ee0494afdd00" />


### 9. Verificación FTP con TLS

Desde un cliente con `lftp`:

```Bash
lftp
set ftp:ssl-allow true
set ssl:verify-certificate no
open -u juan,Test1234 ftp://192.168.206.172
ls
```

También se puede verificar que el servidor ofrece TLS con `openssl`:

```Bash
openssl s_client -connect 192.168.206.172:21 -starttls ftp
```

<img width="965" height="317" alt="image" src="https://github.com/user-attachments/assets/85718876-220a-4011-9f7e-c5c51d89d02d" />


### 10. Verificación phpMyAdmin

Accedemos desde el navegador a:

```
http://192.168.206.172:8080
```

Iniciamos sesión con el usuario `juan_usr` y la contraseña del cliente para acceder a la base de datos `pepito_db`.

<img width="1067" height="765" alt="image" src="https://github.com/user-attachments/assets/9b2933d9-0e38-4996-a1bd-307d33afa869" />

