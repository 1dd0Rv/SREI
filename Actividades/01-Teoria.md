### 1. ¿Qué es TLD? ¿Cómo se clasifican los dominios de nivel superior?, Pon algunos ejemplos.

**Top-Level-Domain** o **TLD** es uno de los dominios mas alto en la jerarquia. Es el elemento final del dominio, lo siguiente al punto, por ejemplo en el dominio google.com el **TLD** serìa **.com**.
IANA(Internet Assigned Numbers Authority) clasifica los dominios de nivel superior de la siguiente manera:

- gTLD(Generic TLD) $\rightarrow$ Son dominios genéricos que teoricamente indican el tipo de organización aunque hoy en dia están más abiertos
  - .com $\rightarrow$ Comercial
  - .org $\rightarrow$ Organización
  - .net $\rightarrow$ Red

- ccTLD(Country Code TLD) $\rightarrow$ Dominios geograficos reservados para paises o terrritorios.
  - .es $\rightarrow$ España
  - .mx $\rightarrow$ México
  - .ar $\rightarrow$ Argentina

- sTLD(sponsored TLD) $\rightarrow$ Dominios patrocinados por comunidades privadas u organizaciones que establecen reglas estrictas para su uso.
  - .gov $\rightarrow$ Gobiernos de EEUU
  - .edu $\rightarrow$ Instituciones educativas acreditadas
  - .mil $\rightarrow$ Militar de EEUU
 
- Infraestructura TLD $\rightarrow$ Reservado unicamente para estructuras de internet
  - .arpa $\rightarrow$ Usado para resoluciones inversas de DNS, como in-addr.arpa

---

### 2. ¿Qué es FQDN?, Pon algún ejemplo de FQDN

**FQDN** significa **Fully Qualified Domain Name** (Nombre de Dominio Completamente Calificado). Es la dirección completa e inambigua de un host en internet. 
A diferencia de un nombre relativo (como www), un FQDN especifica la ruta completa desde el host hasta la raíz del DNS. Por ejemplo:

Si el servidor se llama server1 y está en el dominio google.com:

- Nombre de Host: server1
- Dominio: google.com
- FQDN: server1.google.com. (Punto final despues de com).

---

### 3. ¿Qué son los root servers? , ¿Cuántos root servers hay?, ¿Cuántos servidores raíz físicos existen y dónde se encuentran?, ¿Qué es anycast?

  **¿Qué son?** Son los servidores autoritativos para la zona raíz del DNS. Son el primer paso en la resolución de cualquier dominio cuando no está en caché.
  Responden dónde encontrar los servidores de los TLDs (.com, .es, etc.).

  **¿Cuántos hay?** (Lógicos y Físicos)
  - Lógicos: Existen 13 servidores raíz lógicos, nombrados de la letra A a la M (ej. a.root-servers.net, m.root-servers.net). Esto se debe históricamente a limitaciones 
  en el tamaño del paquete UDP original del DNS (512 bytes).

  - Físicos: En la realidad, existen más de 1900 instancias de servidores distribuidas globalmente (según datos actualizados a 2026)

  **¿Dónde se encuentran?** Están dispersos por todo el mundo para garantizar redundancia y baja latencia. Aunque la gestión recae en 12 organizaciones (como NASA, Verisign, ICANN, Universidades),
las máquinas físicas están en cientos de países.

  **¿Qué es anycast?** Anycast es una técnica de direccionamiento de red donde una misma dirección IP es anunciada desde múltiples ubicaciones físicas diferentes.
Esta tecnología que permite que esos 13 servidores lógicos se conviertan en miles físicos. Cuando tu computadora consulta al servidor raíz "L", la red enruta tu petición 
al servidor físico "L" que esté topológicamente más cerca de ti. Esto proporciona alta disponibilidad y resistencia a ataques DDoS.

  ---
  
### 4. ¿Qué es un archivo de zona (zone file)? Indica para qué sirven los registros de un archivo de zona. Pon un ejemplo de un archivo de zona e interpreta la información almacenada

  Un archivo de zona es un archivo de texto simple que describe una zona DNS completa. 
  Contiene las instrucciones (Resource Records) que le dicen al servidor cómo resolver los nombres dentro de        ese dominio.
  
  Para que sirven principalmente:

  | Registro | Nombre Completo | Función |
| :--- | :--- | :--- |
| **SOA** | Start of Authority | **Obligatorio**. Define parámetros globales de la zona (servidor primario, email, caché). |
| **NS** | Name Server | Indica qué servidores DNS tienen la autoridad sobre esta zona. |
| **A** | Address | Traduce un nombre de host a una dirección **IPv4**. |
| **AAAA** | Quad A | Traduce un nombre de host a una dirección **IPv6**. |
| **CNAME** | Canonical Name | Crea un alias de un nombre a otro (ej. `www` apunta al dominio raíz). |
| **MX** | Mail Exchange | Indica los servidores encargados de recibir el correo electrónico. |
| **TXT** | Text | Guarda texto arbitrario, usado para verificaciones de seguridad (SPF, DKIM). |

Ejemplo e interpretación:

    $ORIGIN example.com.
    $TTL 86400
    
    ; --- REGISTRO SOA (Inicio de Autoridad) ---
    @   IN  SOA     ns1.example.com. admin.example.com. (
                2026011901 ; Serial (Formato AAAAMMDDnn)
                3600       ; Refresh (1 hora)
                1800       ; Retry (30 min)
                604800     ; Expire (1 semana)
                86400 )    ; Minimum TTL (1 día)
    
    ; --- SERVIDORES DE NOMBRES (NS) ---
        IN  NS      ns1.example.com.
        IN  NS      ns2.example.com.
    
    ; --- REGISTROS DE DIRECCIÓN (A / AAAA) ---
    @   IN  A       192.0.2.10      ; La raíz (example.com) apunta a esta IP
    ns1 IN  A       192.0.2.10      ; El servidor de nombres ns1 es esta misma máquina
    www IN  CNAME   example.com.    ; www es un alias de la raíz
    
    ; --- CORREO (MX) ---
    @   IN  MX  10  mail.example.com. ; Servidor de correo con prioridad 10
    mail IN A       192.0.2.20        ; IP del servidor de correo
   
    
