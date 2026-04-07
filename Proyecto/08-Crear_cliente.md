## Script de automatización: crear_cliente.sh

Este script automatiza todo el proceso de alta de un nuevo cliente en el servidor de alojamiento. Se ejecuta dentro del contenedor `marisma-web`.

### Uso

```Bash
docker exec marisma-web /usr/local/bin/marisma/crear_cliente.sh -u <usuario> -i <ip> -p <password> [opciones]
```

### Opciones

| Flag | Descripción | Obligatorio |
|---|---|---|
| `-u` | Nombre de usuario del cliente | Sí |
| `-i` | Dirección IP del subdominio | Sí |
| `-p` | Contraseña del usuario | Sí |
| `-d` | Dominio base (por defecto: marisma.local) | No |
| `-s` | Deshabilitar FTP, solo SSH/SFTP | No |
| `-h` | Mostrar ayuda | No |

### Ejemplo de ejecución

```Bash
docker exec marisma-web /usr/local/bin/marisma/crear_cliente.sh -u pepito -i 172.20.0.10 -p Test1234
```

<!-- CAPTURA: Salida del script con los 7 pasos en verde -->

### ¿Qué hace el script? (7 pasos)

#### Paso 1: Crear usuario del sistema

Crea un usuario Linux con su home en el DocumentRoot. Este usuario podrá conectarse por FTP, SSH y SFTP.

```Bash
useradd -m -s /bin/bash -d "/var/www/html/${USER}" "$USER"
echo "${USER}:${PASS}" | chpasswd
usermod -aG www-data "$USER"
```

#### Paso 2: Directorio web y páginas por defecto

Crea el directorio del cliente con tres páginas de ejemplo:
- `index.html` → Página de bienvenida con información del cliente
- `info.php` → Muestra `phpinfo()` para verificar que PHP funciona
- `app.py` → Aplicación Python WSGI de prueba

```Bash
mkdir -p "/var/www/html/${USER}"
chown -R "${USER}:www-data" "/var/www/html/${USER}"
chmod -R 755 "/var/www/html/${USER}"
```

#### Paso 3: VirtualHost en Apache

Crea y habilita un VirtualHost para el subdominio del cliente con soporte PHP y Python WSGI:

```Apache
<VirtualHost *:80>
    ServerName  pepito.marisma.local
    ServerAlias www.pepito.marisma.local
    DocumentRoot /var/www/html/pepito

    # Python WSGI
    WSGIScriptAlias /python /var/www/html/pepito/app.py
</VirtualHost>
```

```Bash
a2ensite pepito.marisma.local.conf
apache2ctl graceful
```

#### Paso 4: Subdominio DNS (zona directa + inversa)

Añade el registro A en la zona directa y el PTR en la zona inversa:

```
; Zona directa (db.marisma.local)
pepito     IN  A  172.20.0.10
www.pepito IN  A  172.20.0.10

; Zona inversa (db.172.20)
10    IN  PTR  pepito.marisma.local.
```

Se recarga BIND9 para aplicar los cambios:

```Bash
service bind9 reload
```

#### Paso 5: Base de datos MySQL

Crea una base de datos y un usuario con ALL PRIVILEGES:

```SQL
CREATE DATABASE IF NOT EXISTS `pepito_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'pepito_usr'@'%' IDENTIFIED BY 'Test1234';
GRANT ALL PRIVILEGES ON `pepito_db`.* TO 'pepito_usr'@'%';
FLUSH PRIVILEGES;
```

El cliente puede administrar su base de datos desde phpMyAdmin (`http://marisma.local:8080`).

#### Paso 6: FTP con TLS

ProFTPD ya está configurado globalmente. Al crear el usuario del sistema en el paso 1, automáticamente puede conectarse por FTP. Se recarga ProFTPD para asegurar que reconoce al nuevo usuario.

Si se usa el flag `-s`, se omite FTP y el cliente solo tendrá acceso por SSH/SFTP.

#### Paso 7: SSH y SFTP

Se prepara el directorio `.ssh` del usuario con los permisos correctos:

```Bash
mkdir -p "/home/${USER}/.ssh"
chmod 700 "/home/${USER}/.ssh"
touch "/home/${USER}/.ssh/authorized_keys"
chmod 600 "/home/${USER}/.ssh/authorized_keys"
```

### Verificación

Después de crear un cliente, podemos verificar que todo funciona:

```Bash
# DNS
docker exec marisma-web dig pepito.marisma.local @127.0.0.1

# Web
docker exec marisma-web curl -s -H "Host: pepito.marisma.local" http://127.0.0.1 | head -5

# Base de datos
docker exec marisma-db mariadb -u root -prootpass123 -e "SHOW DATABASES;" | grep pepito
```

<!-- CAPTURAS: Resultado de las 3 verificaciones -->

### Resumen de acceso del cliente

| Servicio | Acceso |
|---|---|
| Web | `http://pepito.marisma.local` |
| PHP | `http://pepito.marisma.local/info.php` |
| Python WSGI | `http://pepito.marisma.local/python` |
| phpMyAdmin | `http://marisma.local:8080` → BD: `pepito_db` |
| SSH/SFTP | `ssh pepito@<ip_servidor> -p 2222` |
| FTP/FTPS | `ftp pepito@<ip_servidor>` (puerto 21, TLS obligatorio) |
