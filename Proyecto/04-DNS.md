## Configuracion de DNS.

Para la configuracion del DNS tenemos que crear los archivos correspondientes con zona directa e inversa.

## Zona directa e inversa.

```Bash
// Zona directa
zone "marisma.local" {
    type master;
    file "/etc/bind/db.marisma.local";
    allow-update { none; };
};

// Zona inversa (red 172.20.0.x)
zone "0.20.172.in-addr.arpa" {
    type master;
    file "/etc/bind/db.172.20";
    allow-update { none; };
};
```
## fsd

```Bash
options {
    directory "/var/cache/bind";

    // Reenviar consultas externas a Google DNS
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    // Escuchar en todas las interfaces
    listen-on { any; };
    listen-on-v6 { any; };

    // Permitir consultas desde la red del contenedor y localhost
    allow-query {
        localhost;
        172.20.0.0/24;
        any;
    };

    allow-recursion {
        localhost;
        172.20.0.0/24;
    };
```
## Configuracion de servidores directa

``` Bash
; Zona directa: marisma.local
$TTL 86400
@   IN  SOA     ns1.marisma.local. admin.marisma.local. (
                    2024010101  ; Serial
                    3600        ; Refresh
                    1800        ; Retry
                    604800      ; Expire
                    86400 )     ; Negative TTL

; Servidores de nombres
@       IN  NS      ns1.marisma.local.

; Registros A principales
ns1     IN  A       172.20.0.10
www     IN  A       172.20.0.10
db      IN  A       172.20.0.20
@       IN  A       172.20.0.10

; Los subdominios de clientes se añaden dinámicamente con el script
```

## Configruacion servidores inversa

``` Bash
  GNU nano 8.7.1                                     db.172.20                                                  
; Zona inversa: 172.20.0.x
$TTL 86400
@   IN  SOA     ns1.marisma.local. admin.marisma.local. (
                    2024010101  ; Serial
                    3600        ; Refresh
                    1800        ; Retry
                    604800      ; Expire
                    86400 )     ; Negative TTL

@       IN  NS      ns1.marisma.local.

; PTR principales
10      IN  PTR     www.marisma.local.
20      IN  PTR     db.marisma.local.

; Los PTR de clientes se añaden dinámicamente con el script
```

