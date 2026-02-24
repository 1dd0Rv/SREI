## Configuracion DNS y SFTP

Instalaremos lo necesario para configurar DNS y servicio FTP seguro

<img width="853" height="70" alt="image" src="https://github.com/user-attachments/assets/c1bd36d4-11ef-4321-898c-a728ea21474a" />

### Declarar zona Bind9

Abriremos el archivo *named.ocnf.local* y configuraremos la zona "marisma.local" y la zona inversa

<img width="599" height="200" alt="image" src="https://github.com/user-attachments/assets/e70387d9-71af-492c-a812-32a0dd254bfa" />


Configuramos el archivo db.marisma.local

<img width="633" height="200" alt="image" src="https://github.com/user-attachments/assets/33c6e844-4d16-4200-b42a-b44be406392f" />

Configuramos la zona inversa.

<img width="744" height="204" alt="image" src="https://github.com/user-attachments/assets/8c5b777c-de93-4a2b-8f67-3e2804f8a97e" />


### FTP con TLS

Vamos a generar el certificado SSL/TLS autofirmado. Lo crearemos para que tenga validez de un año. Creamos un dirctorio para tener todas las configuraciones organizadas

<img width="562" height="67" alt="image" src="https://github.com/user-attachments/assets/1981d9ad-0fca-46ad-a615-120506f5f6cd" />

Con este comando generamos el certificado.

<img width="945" height="70" alt="image" src="https://github.com/user-attachments/assets/6c91d13d-c19a-4cb6-978a-74733a431b30" />

Ahora en el archivo "/etc/proftp/proftpd.conf" y quitamos la almohadilla.

<img width="779" height="259" alt="image" src="https://github.com/user-attachments/assets/aff4c632-0e38-4af6-982b-6f3d1f5b29dd" />

Vamos a configurar unas reglas para el TLS.

<img width="763" height="218" alt="image" src="https://github.com/user-attachments/assets/56204416-9183-4a48-818f-dd348240e82c" />

 Y ya tendremos FTP con us certifcado SSL/TLS con proftpd y nuestro servidor DNS con bind9 configurado

 <img width="909" height="469" alt="image" src="https://github.com/user-attachments/assets/3567da1e-0dd5-4b30-9a95-0d41cb772ca0" />
 




