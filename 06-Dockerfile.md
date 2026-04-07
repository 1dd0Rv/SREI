## Dockerfile del contenedor web

El Dockerfile construye el contenedor principal `marisma-web` que ejecuta todos los servicios: Apache2, PHP, BIND9, ProFTPD y SSH.

```Bash
nano ~/marisma/web/Dockerfile
```

### Imagen base

Partimos de Debian 12 slim como base ligera:

```Dockerfile
FROM debian:12-slim
ENV DEBIAN_FRONTEND=noninteractive
```

### Instalación de paquetes

Se instalan todos los servicios necesarios en un solo RUN para optimizar las capas de Docker:

```Dockerfile
RUN apt-get update && apt-get install -y \
    # Apache + PHP
    apache2 php php-mysql php-curl php-gd php-mbstring php-xml php-zip libapache2-mod-php \
    # Python WSGI
    python3 python3-pip libapache2-mod-wsgi-py3 \
    # Cliente MariaDB (para scripts)
    mariadb-client \
    # phpMyAdmin
    phpmyadmin \
    # DNS
    bind9 bind9utils bind9-doc dnsutils \
    # FTP con TLS
    proftpd-basic proftpd-mod-crypto \
    # SSH / SFTP
    openssh-server \
    # Utilidades
    openssl curl wget nano net-tools iproute2 supervisor passwd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
```

### Configuración de SSH

Habilitamos login con contraseña y SFTP. Importante: descomentamos el Subsystem sftp existente en vez de añadir una línea nueva para evitar duplicados:

```Dockerfile
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#Subsystem\s*sftp.*/Subsystem sftp \/usr\/lib\/openssh\/sftp-server/' /etc/ssh/sshd_config
RUN ssh-keygen -A
```

> **Nota:** `ssh-keygen -A` genera las claves del host (RSA, ECDSA, ED25519). Sin esto, sshd no arranca.

### Certificado TLS autofirmado

Se genera un certificado para las conexiones FTP cifradas:

```Dockerfile
RUN openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/ssl/private/proftpd.key \
    -out /etc/ssl/certs/proftpd.crt \
    -subj "/C=ES/ST=Huelva/L=Huelva/O=Marisma/OU=ASIR/CN=marisma.local"
```

### COPY de configuraciones

Se copian todos los archivos de configuración que hemos creado:

```Dockerfile
# ProFTPD
COPY config/proftpd.conf /etc/proftpd/proftpd.conf

# BIND9
COPY config/named.conf.options /etc/bind/named.conf.options
COPY config/named.conf.local   /etc/bind/named.conf.local
COPY config/db.marisma.local   /etc/bind/db.marisma.local
COPY config/db.172.20          /etc/bind/db.172.20

# phpMyAdmin
COPY config/phpmyadmin.conf /etc/apache2/sites-available/phpmyadmin.conf

# Supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Scripts
COPY scripts/ /usr/local/bin/marisma/
RUN chmod +x /usr/local/bin/marisma/*.sh
```

### Módulos Apache

Se habilitan los módulos necesarios para PHP, WSGI (Python), SSL y VirtualHosts:

```Dockerfile
RUN a2enmod rewrite ssl wsgi php8.2 vhost_alias
```

### Comando de arranque

Supervisor es el proceso principal que mantiene vivo el contenedor:

```Dockerfile
EXPOSE 22 53/udp 53/tcp 80 8080 21 990 40000-40100
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
```

### Puesta en marcha

Una vez tenemos el Dockerfile y todas las configuraciones:

```Bash
cd ~/marisma
docker compose up -d --build
```

Verificamos que todo arranca correctamente:

```Bash
docker ps
docker logs marisma-web
```

Debemos ver los 4 servicios en estado RUNNING:

```
INFO success: apache2 entered RUNNING state
INFO success: bind9 entered RUNNING state
INFO success: proftpd entered RUNNING state
INFO success: sshd entered RUNNING state
```

<!-- CAPTURA: docker logs mostrando los 4 servicios RUNNING -->
