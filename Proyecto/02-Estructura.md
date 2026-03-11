## Estructura de directorios del proyecto

Vamos a crear la estructura del proyecto en nuestro server, nos cambiamos al usuario personal y ejecutamos este comand.
```Bash
mkdir -p ~/marisma/{dns,web,scripts,volumes/{bind,www,ftp-certs,logs}}
```
La idea es que todo el proyecto viva en ~/marisma y los datos en volumes/

<img width="859" height="333" alt="image" src="https://github.com/user-attachments/assets/1a68a104-3651-4dcb-ad89-53246e6520e9" />
```
~/marisma/
├── docker-compose.yml
├── dns/
│   ├── Dockerfile
│   ├── named.conf.local
│   ├── named.conf.options
│   ├── db.marisma.local          (zona directa)
│   └── db.172.20               (zona inversa)
├── web/
│   ├── Dockerfile
│   └── scripts/
│       └── crear_cliente.sh     (script principal)
└── volumes/
    └── www/                     (webs de clientes)
```
