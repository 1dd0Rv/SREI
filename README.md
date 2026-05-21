# SREI — Servicios de Red e Internet

> Repositorio de actividades y proyectos del módulo **SREI** del ciclo formativo **ASIR** (Administración de Sistemas Informáticos en Red).

![Debian](https://img.shields.io/badge/OS-Debian-A81D33?logo=debian&logoColor=white)
![Apache](https://img.shields.io/badge/Server-Apache-D22128?logo=apache&logoColor=white)
![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?logo=mysql&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-8.2-777BB4?logo=php&logoColor=white)
![BIND9](https://img.shields.io/badge/DNS-BIND9-0078D4)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazonaws&logoColor=white)

---

## Índice de ramas

| Trimestre | Contenido | Rama | Estado |
|-----------|-----------|------|--------|
| 1º — Actividades | Apache: VHosts, SSL, mod_rewrite, autenticación | [`main`](https://github.com/1dd0Rv/SREI/tree/main/Apache) | ✅ Completado |
| 1º — Proyecto | Servidor Web corporativo con LXC + LAMP | [`server_web`](https://github.com/1dd0Rv/SREI/tree/server_web) | ✅ Completado |
| 2º — Actividades | DNS con BIND9: caching, forwarding, zonas, subdominios | [`dns`](https://github.com/1dd0Rv/SREI/tree/dns/Actividades) | ✅ Completado |
| 2º — Proyecto | Servidor de Alojamiento Web con Docker + DNS + FTP | [`dns`](https://github.com/1dd0Rv/SREI/tree/dns/Proyecto) | ✅ Completado |
| 2º — Proyecto | WordPress desplegado en AWS (VPC, EC2, RDS, EFS) | [`wdpss_aws`](https://github.com/1dd0Rv/SREI/tree/wdpss_aws) | ✅ Completado |
| 3º — Actividades | Docker: instalación, contenedores, primeros pasos | [`Docker`](https://github.com/1dd0Rv/SREI/tree/Docker/Actividades) | ✅ Completado |

---

## `main` — Actividades Apache (1º Trimestre)

Actividades progresivas sobre configuración y administración de **Apache HTTP Server** en Debian con stack LAMP. Cada fichero documenta una práctica con comandos, capturas y explicaciones.

| Fichero | Contenido |
|---------|-----------|
| [`01_Actividad1.md`](Apache/01_Actividad1.md) | Instalación de LAMP y primeros pasos con Apache |
| [`02_Configuración_apache.md`](Apache/02_Configuración_apache.md) | Estructura de ficheros de configuración y directivas globales |
| [`03_Directiva_directory.md`](Apache/03_Directiva_directory.md) | Control de acceso con `<Directory>`, `Options` y `AllowOverride` |
| [`05_regExpr.md`](Apache/05_regExpr.md) | Uso de expresiones regulares en la configuración de Apache |
| [`06_Reescreitura.md`](Apache/06_Reescreitura.md) | Módulo `mod_rewrite`: reglas de reescritura y redirección de URLs |
| [`07_VirtualHosts.md`](Apache/07_VirtualHosts.md) | Hosts virtuales basados en nombre y en puerto |
| [`08_Autenticacion.md`](Apache/08_Autenticacion.md) | Autenticación HTTP básica y digest con `mod_auth` |
| [`09_SSL.md`](Apache/09_SSL.md) | Certificados SSL/TLS y configuración de HTTPS con `mod_ssl` |

**Scripts de automatización** disponibles en [`scripts/`](scripts/):

| Script | Descripción |
|--------|-------------|
| [`apachePort.sh`](scripts/apachePort.sh) | Añade puertos adicionales a la configuración de Apache |
| [`createWeb.sh`](scripts/createWeb.sh) | Genera un `index.html` básico con estilos |
| [`addHost.sh`](scripts/addHost.sh) | Añade entradas al fichero `/etc/hosts` |

---

## `server_web` — Proyecto Servidor Web Corporativo (1º Trimestre)

Despliegue de una **intranet corporativa completa** usando contenedores **LXC** sobre Proxmox con Debian 12. Tres hosts virtuales con tecnologías distintas sobre el mismo servidor.

| Fichero | Contenido |
|---------|-----------|
| [`01_LXC con LAMP.md`](https://github.com/1dd0Rv/SREI/blob/server_web/Proyecto/01_LXC%20con%20LAMP.md) | Creación del contenedor LXC e instalación del stack LAMP |
| [`02_Pasos iniciales.md`](https://github.com/1dd0Rv/SREI/blob/server_web/Proyecto/02_Pasos%20iniciales.md) | Configuración de red, hostname y acceso al contenedor |
| [`03_Configuración de Wordpress.md`](https://github.com/1dd0Rv/SREI/blob/server_web/Proyecto/03_Configuraci%C3%B3n%20de%20Wordpress.md) | Instalación y configuración de WordPress en `centro.intranet` (puerto 80) |
| [`04_WSGI.md`](https://github.com/1dd0Rv/SREI/blob/server_web/Proyecto/04_WSGI.md) | Aplicación Python/Flask integrada con Apache via `mod_wsgi` en `departamentos.centro.intranet` con autenticación básica |
| [`05_awstat.md`](https://github.com/1dd0Rv/SREI/blob/server_web/Proyecto/05_awstat.md) | Monitorización de tráfico web con **AWStats** |
| [`06_nginx.md`](https://github.com/1dd0Rv/SREI/blob/server_web/Proyecto/06_nginx.md) | Servidor **Nginx** secundario en `servidor2.centro.intranet:8080` con phpMyAdmin |

---

## `dns` — Actividades DNS y Proyecto Servidor de Alojamiento (2º Trimestre)

### Actividades BIND9

Teoría y práctica sobre el **Sistema de Nombres de Dominio** implementado con **BIND9** en Debian.

| Fichero | Contenido |
|---------|-----------|
| [`01-Teoria.md`](https://github.com/1dd0Rv/SREI/blob/dns/Actividades/01-Teoria.md) | Fundamentos DNS: TLDs, FQDN, servidores raíz, registros de zona (SOA, NS, A, AAAA, CNAME, MX, TXT) |
| [`05-Caching&Forwarding.md`](https://github.com/1dd0Rv/SREI/blob/dns/Actividades/05-Caching%26Forwarding.md) | Configuración de BIND9 como servidor caché y reenviador (forwarder) |
| [`06-MasterDNS.md`](https://github.com/1dd0Rv/SREI/blob/dns/Actividades/06-MasterDNS.md) | Servidor DNS maestro: `named.conf`, zonas directas e inversas |
| [`08- Subdominios.md`](https://github.com/1dd0Rv/SREI/blob/dns/Actividades/08-%20Subdominios.md) | Delegación y creación de subdominios en BIND9 |

### Proyecto — Servidor de Alojamiento Web con Docker

Despliegue de un servidor de alojamiento web completo orquestado con **Docker Compose** (BIND9 + Apache/PHP + MariaDB + ProFTPD).

| Fichero | Contenido |
|---------|-----------|
| [`01-Dependencias.md`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/01-Dependencias.md) | Requisitos previos e instalación de dependencias |
| [`02-Estructura.md`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/02-Estructura.md) | Estructura de directorios y ficheros del proyecto |
| [`03-Docker.md`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/03-Docker.md) | Configuración general de los servicios Docker |
| [`04-DNS.md`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/04-DNS.md) | Configuración del servidor DNS BIND9 dentro de Docker |
| [`05-configuraciones.md`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/05-configuraciones.md) | Ajustes de Apache, MariaDB y ProFTPD |
| [`06-Dockerfile.md`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/06-Dockerfile.md) | Explicación del Dockerfile personalizado |
| [`07-Docker-compose.md`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/07-Docker-compose.md) | Fichero `docker-compose.yml` con todos los servicios |
| [`08-Crear_cliente.md`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/08-Crear_cliente.md) | Proceso de alta de un nuevo cliente (dominio, FTP, web) |
| [`09-Verificaciones.md`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/09-Verificaciones.md) | Pruebas de funcionamiento de DNS, HTTP y FTP |
| [`crear_cliente.sh`](https://github.com/1dd0Rv/SREI/blob/dns/Proyecto/crear_cliente.sh) | Script bash que automatiza el alta completa de un cliente |

---

## `wdpss_aws` — Proyecto WordPress en AWS (2º Trimestre)

Despliegue de **WordPress en producción** sobre Amazon Web Services con arquitectura de tres capas desacoplada (cómputo, base de datos y almacenamiento independientes).

| Fichero | Servicio AWS | Contenido |
|---------|-------------|-----------|
| [`01_VPC_EC2.md`](https://github.com/1dd0Rv/SREI/blob/wdpss_aws/Proyecto%20/01_VPC_EC2.md) | VPC + EC2 | Creación de red privada virtual con subredes públicas/privadas, Internet Gateway y lanzamiento de instancia EC2 Debian |
| [`02_LAMP.md`](https://github.com/1dd0Rv/SREI/blob/wdpss_aws/Proyecto%20/02_LAMP.md) | EC2 | Instalación del stack LAMP (Apache 2.4, PHP, cliente MySQL) sobre la instancia |
| [`03_Base_datos.md`](https://github.com/1dd0Rv/SREI/blob/wdpss_aws/Proyecto%20/03_Base_datos.md) | RDS | Aprovisionamiento de instancia **RDS MySQL 8.0** gestionada y conexión segura desde EC2 |
| [`04_EFS.md`](https://github.com/1dd0Rv/SREI/blob/wdpss_aws/Proyecto%20/04_EFS.md) | EFS | Montaje de **Elastic File System** (NFS) como almacenamiento compartido y persistente |
| [`05_Wordpress.md`](https://github.com/1dd0Rv/SREI/blob/wdpss_aws/Proyecto%20/05_Wordpress.md) | EC2 + RDS | Instalación de WordPress apuntando al endpoint de RDS |
| [`06_EFS_WP-content.md`](https://github.com/1dd0Rv/SREI/blob/wdpss_aws/Proyecto%20/06_EFS_WP-content.md) | EFS | Migración de `wp-content` a EFS para desacoplar contenido del servidor |

---

## `Docker` — Actividades Docker (3º Trimestre)

Prácticas introductorias sobre **Docker**: conceptos fundamentales, ciclo de vida de contenedores e imágenes, redes y volúmenes.

| Fichero | Contenido |
|---------|-----------|
| [`01-Instalacion.md`](https://github.com/1dd0Rv/SREI/blob/Docker/Actividades/01-Instalacion.md) | Instalación de Docker Engine en Debian y primeros comandos |
| [`02-PrimeroPasos.md`](https://github.com/1dd0Rv/SREI/blob/Docker/Actividades/02-PrimeroPasos.md) | Gestión de imágenes, ejecución de contenedores y comandos básicos |
| [`03-Contenedores.md`](https://github.com/1dd0Rv/SREI/blob/Docker/Actividades/03-Contenedores.md) | Ciclo de vida de contenedores, redes, volúmenes y Docker Hub |
