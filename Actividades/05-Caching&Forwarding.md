## Instalacion Bind

- Empezaremos instalando bind  sus utilidades en el servidor.
  <img width="705" height="90" alt="image" src="https://github.com/user-attachments/assets/854945bf-330a-4fb6-8df6-775ff872e883" />

### Configurar como servidor de DNS de almacenamiento en caché

- Primero, cubriremos cómo configurar Bind para que actúe como un servidor DNS de almacenamiento en caché. Esta configuración obligará al servidor a buscar respuestas
  recursivamente de otros servidores DNS cuando un cliente emita una consulta. Nos moveremos al directorio /etc/bind que es donde se guardan las configuraciones y dentro de el
  con nano abriremos el archivo de configuración "named.conf.options".

  <img width="1349" height="108" alt="image" src="https://github.com/user-attachments/assets/02f10299-7843-45aa-b035-26065eead247" />

- Y dejaremos el archivo tal que asi.

  <img width="585" height="145" alt="image" src="https://github.com/user-attachments/assets/d13d3015-1cb2-4e03-8153-699652bfd9ae" />

- Justo arriba de "option" crearemos unas reglas **ACL** para evitar que utilicen nuestro servidor DNS en una red de servidores que se usan para hacer **DNS amplification attack**. Aqui pondremos
  la ip de nuestro cliente que opera en nuestra misma subred **192.168.206** y el **localhost y localnets**. En la parte de options pondremos estos dos apartados "recursion yes; allow-query { goodclients; };"

  <img width="624" height="274" alt="image" src="https://github.com/user-attachments/assets/bbbc2c9f-7683-4d83-8ea8-5dd43bfc0cf8" />

### Configurar servidor DNS como reenviador (Forward)

- En el apartado de "options" activaremos los reenviadores hacia los servidores de google y activamos el modulo de **forward only**

  <img width="732" height="357" alt="image" src="https://github.com/user-attachments/assets/8c6e5a87-0cc4-4b83-b57d-e497c30190d0" />

- Revisamos que este todo bien escrito con "named-checkconf" y reiniciamos el demoio de "bind".

  <img width="531" height="73" alt="image" src="https://github.com/user-attachments/assets/126fa0bc-6e0c-4494-91a2-2b7ae9fa2992" />

- Despues de estos pasos el firewall UFW estará habilitado en el servidor. Necesitamos permitir el tráfico DNS a nuestro servidor para poder responder a las solicitudes de los clientes.

  <img width="486" height="92" alt="image" src="https://github.com/user-attachments/assets/bf1580db-3f81-41f6-a08e-273caabbee23" />

- Dejamos este comando en el servidor y vamos a nuestro cliente para configurarlo.

  <img width="486" height="92" alt="image" src="https://github.com/user-attachments/assets/ca05689c-5992-4957-a54b-9d09a1c5a452" />

### Configuración máquina cliente.

- Iremos al archivo resolv.conf ocn permisos sudo y pondremos la ip de nuestro server.

  <img width="552" height="99" alt="image" src="https://github.com/user-attachments/assets/52bbd1e7-9633-40bc-968d-bd9f6e174f65" />

  <img width="542" height="407" alt="image" src="https://github.com/user-attachments/assets/64a6b3d1-fc28-4169-94c2-26ae2d2c7d8d" />

- Y como podemos ver nuestra máquina cliente puede conectarse con google.com.

  <img width="526" height="275" alt="image" src="https://github.com/user-attachments/assets/4d2ca727-0cef-4037-90dd-691fee2aff92" />


  


  


  


  
