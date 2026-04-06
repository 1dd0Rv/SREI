## Script para crear clientes.

El script que hemo hecho, **crear_cliente.sh** ha funcionado perfectamente y haremos las comprobaciones necesarias para ver si de verdad ha funcionado. Lo ejecuttaremos con este comando
```bash
docker exec marisma-web /usr/local/bin/marisma/crear_cliente.sh -u pepito -i 172.20.0.10 -p Test1234
``` 
<img width="1081" height="625" alt="image" src="https://github.com/user-attachments/assets/923d3f5f-95bd-458c-9332-88b9bccdc2b1" />

- Para comprobar que la parte del DNS esta funcionando con **docker exec** entramos al contenedor y ejecutaremos este comando
  ``` Bash
  docker exec marisma-web dig pepito.marisma.local @127.0.0.1
  ```
  <img width="751" height="370" alt="image" src="https://github.com/user-attachments/assets/a1ae66c7-a99a-44bc-af87-4e5402ecbe53" />

- Para saber si apache esta sirviendo la pagina web ejecutamos lo siguiente:
  ``` Bash
  docker exec marisma-web curl -s -H "Host: pepito.marisma.local" http://127.0.0.1 | head -10
  ```
  <img width="1045" height="218" alt="image" src="https://github.com/user-attachments/assets/34d69872-2a5e-4b8d-bff0-3acd702f99d9" />

  - Comprobacion de que la base de datos existe.
    ``` Bash
    docker exec marisma-db mariadb -u root -prootpass123 -e "SHOW DATABASES;" | grep pepito
    ```
    <img width="977" height="128" alt="image" src="https://github.com/user-attachments/assets/43a2b48f-b28e-484c-8e2e-84821457d235" />


  
