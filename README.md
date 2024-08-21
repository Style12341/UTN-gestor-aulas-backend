# Instalacion
### General
Intente los instaladores para windows y no me resulto muy bien asi que vamos con la opcion mas comun para correr rails en windows.
Se utiliza WSL (Windows subsystem for linux, te abre un bash de linux y corres todo en windows). Para usar esto escriban en el buscador "turn windows features on or off" o su equivalente en español y activen la opcion que diga lo de WSL. Ahi seguramente les pida reinicio.
Tambien hay que instalar desde la windows store Ubuntu, se busca y se instala.
Luego ya podemos acceder en un entorno buscando bash en el buscador (no git bash , solo bash)

Ahora se puede correr con docker asi no hay que hacer tanto desastre, de todas maneras hay que tener instalado el wsl.
### Instalacion Docker Desktop
Con este link instalan docker desktop, que tiene el docker engine y compose.Se siguen los pasos nomas no hay que hacer nada raro
https://docs.docker.com/desktop/install/windows-install/

Luego desde powershell (supongo que cmd tambien), clonan el proyecto en algun lado.
**Hay que crear un archivo .env adentro del proyecto y copiar las variables de entorno que estan en el docs de convenciones backend y frontend esto mejor si lo hacen desde VSCODE, y cambian abajo donde dice CRLF a LF seleccionando todo lo del archivo**.
Eso ultimo es porque windows utiliza otro \n que linux :P.

Si por alguna razon tienen postgres corriendo en su maquina, o otra db escuchando en el puerto 5432, se debe frenar antes de correr cualquier comando del docker, porque viene con una imagen con postgres escuchando en ese puerto.
### Instalacion proyecto
Clonar repositorio:
```
git clone https://github.com/Alexander-Werlen/UTN-gestor-aulas-frontend.git
```
Luego se ejecuta dentro del repositorio:
```bash
docker-compose up --build -d
```
Esto va a correr las dos imagenes, la de rails y la de postgres en el background, para ver los logs del servidor se puede usar directamente la app de docker desktop.
Para cerrar las imagenes:
```bash
docker-compose down
```
### Ante cualquier cambio (git pull)
Hay que correr lo siguiente desde la carpeta del proyecto:
```bash
docker-compose down
docker-compose up --build -d
```

