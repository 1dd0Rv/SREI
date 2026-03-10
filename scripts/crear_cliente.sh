#!/bin/bash

# EJEMPLOS:
#   sudo ./crear_cliente.sh -u juan -i 192.168.1.50 -p MiPass123
#   sudo ./crear_cliente.sh -u ana  -i 192.168.1.51 -p OtraPass  -d miempresa.local
#   sudo ./crear_cliente.sh -u luis -i 192.168.1.52 -p Pass456   -s
# =============================================================================

# ─── COLORES ──────────────────────────────────────────────────────────────────
RED='\033[0;31m' 
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_ok()   { echo -e "${GREEN}[OK]${NC}    $1"; }
log_info() { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_err()  { echo -e "${RED}[ERROR]${NC} $1"; }

# ─── CONFIGURACIÓN POR DEFECTO ────────────────────────────────────────────────
DOMINIO="marisma.local"
WWW_ROOT="/var/www/html"
ZONE_INVERSA="/etc/bind/db.192.168.206"    
MYSQL_ROOT_PASS="passwd"   
SOLO_SSH=false

# ─── FUNCIÓN AYUDA ────────────────────────────────────────────────────────────
mostrar_ayuda() {
    echo ""
    echo -e "${BLUE}Uso:${NC} sudo $0 -u <usuario> -i <ip> -p <password> [opciones]"
    echo ""
    echo -e "${BLUE}Opciones obligatorias:${NC}"
    echo "  -u  Nombre de usuario del cliente"
    echo "  -i  Dirección IP del subdominio"
    echo "  -p  Contraseña del usuario"
    echo ""
    echo -e "${BLUE}Opciones adicionales:${NC}"
    echo "  -d  Dominio base (por defecto: marisma.local)"
    echo "  -s  Deshabilitar FTP, solo SSH/SFTP"
    echo "  -h  Mostrar esta ayuda"
    echo ""
    echo -e "${BLUE}Ejemplos:${NC}"
    echo "  sudo $0 -u juan -i 192.168.1.50 -p MiPass123"
    echo "  sudo $0 -u ana  -i 192.168.1.51 -p OtraPass  -d miempresa.local"
    echo "  sudo $0 -u luis -i 192.168.1.52 -p Pass456   -s"
    echo ""
}

# ─── PARSEO CON GETOPTS ───────────────────────────────────────────────────────
# Formato: ":u:i:p:d:sh"
#   'u:', 'i:', 'p:', 'd:' requieren argumento
#   's' y 'h' son flags sin argumento
while getopts ":u:i:p:d:sh" opt; do
    case $opt in
        u) USER="$OPTARG"    ;;
        i) IP="$OPTARG"      ;;
        p) PASS="$OPTARG"    ;;
        d) DOMINIO="$OPTARG" ;;
        s) SOLO_SSH=true     ;;
        h) mostrar_ayuda; exit 0 ;;
        :)  log_err "La opción -${OPTARG} requiere un argumento."
            mostrar_ayuda; exit 1 ;;
        \?) log_err "Opción desconocida: -${OPTARG}"
            mostrar_ayuda; exit 1 ;;
    esac
done

# ─── VALIDACIONES ─────────────────────────────────────────────────────────────
if [ "$EUID" -ne 0 ]; then
    log_err "Este script debe ejecutarse como root (usa sudo)"; exit 1
fi

# Verificar parámetros obligatorios
ERRORES=0
[ -z "$USER" ] && { log_err "Falta -u (usuario)";     ERRORES=1; }
[ -z "$IP"   ] && { log_err "Falta -i (ip)";           ERRORES=1; }
[ -z "$PASS" ] && { log_err "Falta -p (contraseña)";   ERRORES=1; }
[ $ERRORES -ne 0 ] && { mostrar_ayuda; exit 1; }

# Validar nombre de usuario
if ! [[ "$USER" =~ ^[a-z][a-z0-9_-]{2,15}$ ]]; then
    log_err "Usuario no válido. Solo minúsculas/números/guiones, entre 3 y 16 chars."
    exit 1
fi

# Validar formato IP
if ! [[ "$IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    log_err "Formato de IP no válido: $IP"; exit 1
fi

# Verificar que el usuario no exista ya
if id "$USER" &>/dev/null; then
    log_err "El usuario '$USER' ya existe en el sistema."; exit 1
fi

# ─── VARIABLES DERIVADAS (tras posible cambio de -d) ─────────────────────────
ZONE_FILE="/etc/bind/db.${DOMINIO}"
SUB_DOMAIN="${USER}.${DOMINIO}"
DOCUMENT_ROOT="${WWW_ROOT}/${USER}"
CONF_FILE="${USER}.${DOMINIO}.conf"
PATH_AVAILABLE="/etc/apache2/sites-available/${CONF_FILE}"
DB_NAME="${USER}_db"
DB_USER="${USER}_usr"
ULTIMO_OCTETO=$(echo "$IP" | cut -d'.' -f4)

# ─── RESUMEN PREVIO ───────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Creando cliente: ${USER} → ${SUB_DOMAIN}${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════${NC}"
echo -e "  Dominio:       ${SUB_DOMAIN}"
echo -e "  IP:            ${IP}"
echo -e "  DocumentRoot:  ${DOCUMENT_ROOT}"
echo -e "  Base de datos: ${DB_NAME}  /  usuario MySQL: ${DB_USER}"
echo -e "  FTP:           $([ "$SOLO_SSH" = true ] && echo 'Deshabilitado (-s)' || echo 'Habilitado')"
echo ""

# ─── 1. USUARIO DEL SISTEMA ───────────────────────────────────────────────────
log_info "1/7 Creando usuario del sistema..."

useradd -m -s /bin/bash -d "/home/${USER}" "$USER"
echo "${USER}:${PASS}" | chpasswd
usermod -aG www-data "$USER"

log_ok "Usuario '${USER}' creado y añadido a www-data"

# ─── 2. DIRECTORIO WEB Y PÁGINAS POR DEFECTO ─────────────────────────────────
log_info "2/7 Creando directorio web y páginas por defecto..."

mkdir -p "$DOCUMENT_ROOT"

# index.html de bienvenida
cat > "${DOCUMENT_ROOT}/index.html" <<HTML
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Bienvenido - ${SUB_DOMAIN}</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 80px; background: #f4f4f4; }
        .card { background: white; padding: 40px; display: inline-block;
                border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; }
        .badge { background: #27ae60; color: white; padding: 4px 12px;
                 border-radius: 20px; font-size: 13px; margin: 3px; display: inline-block; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🌐 ${SUB_DOMAIN}</h1>
        <p>Usuario: <strong>${USER}</strong></p>
        <span class="badge">PHP</span>
        <span class="badge">Python WSGI</span>
        <span class="badge">MySQL</span>
        <p><small>IES La Marisma · ASIR</small></p>
    </div>
</body>
</html>
HTML

# Página PHP de prueba
cat > "${DOCUMENT_ROOT}/info.php" <<'PHP'
<?php phpinfo(); ?>
PHP

# Aplicación Python WSGI de prueba
cat > "${DOCUMENT_ROOT}/app.py" <<PYTHON
def application(environ, start_response):
    status = '200 OK'
    output = b'<h1>Python WSGI OK - ${SUB_DOMAIN}</h1>'
    response_headers = [('Content-type', 'text/html'),
                        ('Content-Length', str(len(output)))]
    start_response(status, response_headers)
    return [output]
PYTHON

chown -R "${USER}:www-data" "$DOCUMENT_ROOT"
chmod -R 755 "$DOCUMENT_ROOT"

log_ok "Directorio web creado en ${DOCUMENT_ROOT}"

# ─── 3. VIRTUAL HOST APACHE ───────────────────────────────────────────────────
log_info "3/7 Creando VirtualHost en Apache..."

cat > "$PATH_AVAILABLE" <<VHOST
<VirtualHost *:80>
    ServerAdmin admin@${SUB_DOMAIN}
    ServerName ${SUB_DOMAIN}
    ServerAlias www.${SUB_DOMAIN}
    DocumentRoot ${DOCUMENT_ROOT}

    <Directory ${DOCUMENT_ROOT}>
        DirectoryIndex index.html index.php
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>

    # Python WSGI
    WSGIScriptAlias /python ${DOCUMENT_ROOT}/app.py
    <Files app.py>
        Require all granted
    </Files>

    ErrorLog  /var/log/apache2/${SUB_DOMAIN}.error.log
    CustomLog /var/log/apache2/${SUB_DOMAIN}.access.log combined
    LogLevel warn
</VirtualHost>
VHOST

a2ensite "$CONF_FILE" > /dev/null 2>&1
apache2ctl configtest > /dev/null 2>&1 && systemctl reload apache2

log_ok "VirtualHost ${SUB_DOMAIN} habilitado en Apache"

# ─── 4. DNS BIND9 (ZONA DIRECTA + INVERSA) ───────────────────────────────────
log_info "4/7 Añadiendo registros DNS en BIND9..."

if [ -f "$ZONE_FILE" ]; then
    cat >> "$ZONE_FILE" <<DNS

; Usuario ${USER} - creado el $(date +%Y-%m-%d)
${USER}     IN  A  ${IP}
www.${USER} IN  A  ${IP}
DNS
    log_ok "Registro A añadido en ${ZONE_FILE}"
else
    log_warn "Fichero de zona no encontrado: ${ZONE_FILE} — omitido"
fi

if [ -f "$ZONE_INVERSA" ]; then
    echo "${ULTIMO_OCTETO}    IN  PTR  ${SUB_DOMAIN}." >> "$ZONE_INVERSA"
    log_ok "Registro PTR añadido en zona inversa"
else
    log_warn "Zona inversa no encontrada: ${ZONE_INVERSA} — omitido"
fi

systemctl reload bind9 > /dev/null 2>&1
log_ok "BIND9 recargado"

# ─── 5. BASE DE DATOS MYSQL ───────────────────────────────────────────────────
log_info "5/7 Creando base de datos MySQL..."

mysql -u root -p"${MYSQL_ROOT_PASS}" <<SQL 2>/dev/null
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SQL

if [ $? -eq 0 ]; then
    log_ok "BD '${DB_NAME}' y usuario '${DB_USER}' con ALL PRIVILEGES creados"
else
    log_warn "Error MySQL — revisa la variable MYSQL_ROOT_PASS al inicio del script"
fi

# ─── 6. FTP CON TLS (ProFTPD) ─────────────────────────────────────────────────
log_info "6/7 Configurando FTP/TLS con ProFTPD..."

if [ "$SOLO_SSH" = true ]; then
    log_warn "Flag -s activo: FTP omitido para este usuario"
else
    if ! grep -q "mod_tls" /etc/proftpd/proftpd.conf 2>/dev/null; then
        log_warn "Verifica que mod_tls esté habilitado en /etc/proftpd/proftpd.conf"
    fi
    systemctl reload proftpd > /dev/null 2>&1
    log_ok "ProFTPD recargado — ${USER} puede conectar por FTP/FTPS"
fi

# ─── 7. SSH Y SFTP ────────────────────────────────────────────────────────────
log_info "7/7 Configurando SSH/SFTP..."

mkdir -p "/home/${USER}/.ssh"
chmod 700 "/home/${USER}/.ssh"
touch "/home/${USER}/.ssh/authorized_keys"
chmod 600 "/home/${USER}/.ssh/authorized_keys"
chown -R "${USER}:${USER}" "/home/${USER}/.ssh"

log_ok "Directorio .ssh preparado — ${USER} puede conectar por SSH y SFTP"

# ─── RESUMEN FINAL ────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}   ✅  Cliente '${USER}' creado correctamente${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  🌐 Web:        http://${SUB_DOMAIN}"
echo -e "  🐘 PHP:        http://${SUB_DOMAIN}/info.php"
echo -e "  🐍 Python:     http://${SUB_DOMAIN}/python"
echo -e "  🗄️  phpMyAdmin: http://<servidor>/phpmyadmin  →  BD: ${DB_NAME}"
echo -e "  🔐 SSH/SFTP:   ssh ${USER}@${IP}"
if [ "$SOLO_SSH" = false ]; then
    echo -e "  📁 FTP/FTPS:   ftp ${USER}@${IP}"
fi
echo -e "  📂 Directorio: ${DOCUMENT_ROOT}"
echo ""
