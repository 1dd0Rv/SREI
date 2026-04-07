## Configuraciones de servicios

Antes de levantar los contenedores, necesitamos crear los archivos de configuración que el Dockerfile copiará dentro del contenedor. Todos van en `~/marisma/web/config/`.

### 1. ProFTPD con TLS (`proftpd.conf`)

Configuramos ProFTPD en modo standalone con TLS obligatorio para que las transferencias FTP vayan cifradas.

```Bash
nano ~/marisma/web/config/proftpd.conf
```

```
ServerName                  "FTP Marisma"
ServerType                  standalone
DefaultServer               on
Port                        21
UseIPv6                     off
Umask                       022

User                        nobody
Group                       nogroup

# Cada usuario entra enjaulado en su home
DefaultRoot                 ~

MaxInstances                30
MaxClientsPerHost           5

TimeoutIdle                 600
TimeoutNoTransfer           300

# Permitir login a usuarios sin shell válida
RequireValidShell           off

# Modo pasivo (puertos expuestos en docker-compose)
PassivePorts                40000 40100
MasqueradeAddress           172.20.0.10

# Logs
TransferLog                 /var/log/proftpd/xferlog
SystemLog                   /var/log/proftpd/proftpd.log

# TLS - Cifrado obligatorio
<IfModule mod_tls.c>
    TLSEngine               on
    TLSLog                  /var/log/proftpd/tls.log
    TLSRSACertificateFile   /etc/ssl/certs/proftpd.crt
    TLSRSACertificateKeyFile /etc/ssl/private/proftpd.key
    TLSProtocol             TLSv1.2 TLSv1.3
    TLSRequired             on
    TLSVerifyClient         off
    TLSRenegotiate          required off
</IfModule>

<Global>
    CreateHome              on 755
</Global>
```

**Puntos clave:**
- `DefaultRoot ~` → Cada usuario solo ve su propio directorio (jail)
- `TLSRequired on` → Obliga a usar TLS, no permite conexiones sin cifrar
- `PassivePorts 40000 40100` → Rango de puertos para modo pasivo, mapeados en docker-compose
- El certificado TLS se genera automáticamente en el Dockerfile con `openssl`

---

### 2. phpMyAdmin (`phpmyadmin.conf`)

VirtualHost de Apache para servir phpMyAdmin en el puerto 8080.

```Bash
nano ~/marisma/web/config/phpmyadmin.conf
```

```Apache
<VirtualHost *:8080>
    ServerAdmin admin@marisma.local
    ServerName  db.marisma.local

    DocumentRoot /usr/share/phpmyadmin

    <Directory /usr/share/phpmyadmin>
        Options FollowSymLinks
        DirectoryIndex index.php
        AllowOverride All
        Require all granted
    </Directory>

    <Directory /usr/share/phpmyadmin/templates>
        Require all denied
    </Directory>

    <Directory /usr/share/phpmyadmin/libraries>
        Require all denied
    </Directory>

    ErrorLog  /var/log/apache2/phpmyadmin_error.log
    CustomLog /var/log/apache2/phpmyadmin_access.log combined

    php_admin_value upload_max_filesize 64M
    php_admin_value post_max_size 64M
</VirtualHost>
```

**Puntos clave:**
- Escucha en el puerto 8080 para no interferir con el puerto 80 (webs de clientes)
- Se bloquea el acceso a los directorios sensibles (`templates`, `libraries`)
- Se conecta al contenedor MariaDB (172.20.0.20) mediante la configuración PHP

---

### 3. Supervisor (`supervisord.conf`)

Supervisor es el proceso principal del contenedor (CMD del Dockerfile). Se encarga de arrancar y mantener los 4 servicios.

```Bash
nano ~/marisma/web/config/supervisord.conf
```

```ini
[supervisord]
nodaemon=true
user=root
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid
childlogdir=/var/log/supervisor

[program:apache2]
command=/usr/sbin/apache2ctl -D FOREGROUND
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/apache2_stdout.log
stderr_logfile=/var/log/supervisor/apache2_stderr.log

[program:bind9]
command=/usr/sbin/named -g -u bind
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/bind9_stdout.log
stderr_logfile=/var/log/supervisor/bind9_stderr.log

[program:proftpd]
command=/usr/sbin/proftpd --nodaemon
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/proftpd_stdout.log
stderr_logfile=/var/log/supervisor/proftpd_stderr.log

[program:sshd]
command=/usr/sbin/sshd -D
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/sshd_stdout.log
stderr_logfile=/var/log/supervisor/sshd_stderr.log
```

**Puntos clave:**
- `nodaemon=true` → Supervisor corre en primer plano (necesario para Docker)
- Cada servicio se arranca con su flag de "no daemon" (`-D`, `-g`, `--nodaemon`)
- `autorestart=true` → Si un servicio cae, Supervisor lo reinicia automáticamente




  
