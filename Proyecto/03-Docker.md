## Contenedotes y Dockerfile.

**docker-compose.yml**
```YAMAL
version: "3.9"

networks:
  marisma-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24

volumes:
  www-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ./volumes/www
  db-data:

services:

  # ============================================================
  # CONTENEDOR 1: DNS (BIND9) + Apache2 + PHP + ProFTPD + SSH
  # ============================================================
  web:
    build:
      context: ./web
      dockerfile: Dockerfile
    container_name: marisma-web
    hostname: www.marisma.local
    networks:
      marisma-net:
        ipv4_address: 172.20.0.10
    ports:
      - "80:80"       # Apache HTTP
      - "21:21"       # FTP control
      - "22:22"       # SSH / SFTP
      - "53:53/udp"   # DNS UDP
      - "53:53/tcp"   # DNS TCP
      - "990:990"     # FTPS (TLS implícito)
      - "8080:8080"   # phpMyAdmin
      - "40000-40100:40000-40100"  # FTP pasivo
    volumes:
      - www-data:/var/www/html
      - ./dns:/etc/bind/zones   # archivos de zona accesibles desde el host
    environment:
      - MYSQL_HOST=172.20.0.20
      - MYSQL_ROOT_PASSWORD=rootpass123
      - DOMAIN=marisma.local
      - SERVER_IP=172.20.0.10
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
    depends_on:
      - db

  # ============================================================
  # CONTENEDOR 2: MariaDB
  # ============================================================
  db:
    image: mariadb:10.11
    container_name: marisma-db
    hostname: db.marisma.local
    networks:
      marisma-net:
        ipv4_address: 172.20.0.20
    volumes:
      - db-data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=rootpass123
      - MYSQL_DATABASE=phpmyadmin_tmp
    restart: unless-stopped
```

**Dockerfile**

```Dockerfile
FROM debian:12

LABEL maintainer="marisma.local"

ENV DEBIAN_FRONTEND=noninteractive

# ── Instalación de todos los servicios ──────────────────────────────────────
RUN apt-get update && apt-get install -y \
    # Apache + PHP
    apache2 \
    php \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    libapache2-mod-php \
    # Python WSGI
    python3 \
    python3-pip \
    libapache2-mod-wsgi-py3 \
    # MariaDB client (para ejecutar queries desde scripts)
    mariadb-client \
    # phpMyAdmin
    phpmyadmin \
    # DNS
    bind9 \
    bind9utils \
    bind9-doc \
    dnsutils \
    # FTP con TLS
    proftpd \
    proftpd-mod-tls \
    # SSH / SFTP
    openssh-server \
    # Utilidades
    openssl \
    curl \
    wget \
    nano \
    net-tools \
    iproute2 \
    supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ── Módulos Apache ───────────────────────────────────────────────────────────
RUN a2enmod rewrite ssl wsgi php8.2

# ── Configuración SSH ────────────────────────────────────────────────────────
RUN mkdir /var/run/sshd
# Permitir login root con contraseña (para pruebas; en producción usar claves)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
# Subsistema SFTP
RUN echo "Subsystem sftp /usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config

# ── Certificado TLS autofirmado para FTP ─────────────────────────────────────
RUN openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/ssl/private/proftpd.key \
    -out /etc/ssl/certs/proftpd.crt \
    -subj "/C=ES/ST=Huelva/L=Huelva/O=Marisma/OU=ASIR/CN=marisma.local"

# ── Configuración ProFTPD con TLS ─────────────────────────────────────────────
COPY config/proftpd.conf /etc/proftpd/proftpd.conf

# ── Configuración BIND9 ───────────────────────────────────────────────────────
COPY config/named.conf.options /etc/bind/named.conf.options
COPY config/named.conf.local   /etc/bind/named.conf.local
COPY config/db.marisma.local   /etc/bind/db.marisma.local
COPY config/db.172.20          /etc/bind/db.172.20
RUN chown -R bind:bind /etc/bind

# ── phpMyAdmin en Apache (puerto 8080) ───────────────────────────────────────
RUN echo "Listen 8080" >> /etc/apache2/ports.conf
COPY config/phpmyadmin.conf /etc/apache2/conf-available/phpmyadmin.conf
RUN a2enconf phpmyadmin
# Enlace simbólico por si no lo creó el instalador
RUN ln -sf /usr/share/phpmyadmin /var/www/html/phpmyadmin || true

# ── Scripts de administración ────────────────────────────────────────────────
COPY scripts/ /usr/local/bin/marisma/
RUN chmod +x /usr/local/bin/marisma/*.sh

# ── Supervisor: arranca todos los servicios ──────────────────────────────────
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ── Directorio raíz web ──────────────────────────────────────────────────────
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

EXPOSE 22 53/udp 53/tcp 80 8080 21 990 40000-40100

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
```
