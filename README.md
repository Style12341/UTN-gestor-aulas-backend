# Instalacion
### General
Intente los instaladores para windows y no me resulto muy bien asi que vamos con la opcion mas comun para correr rails en windows.
Se utiliza WSL (Windows subsystem for linux, te abre un bash de linux y corres todo en windows). Para usar esto escriban en el buscador "turn windows features on or off" o su equivalente en español y activen la opcion que diga lo de WSL. Ahi seguramente les pida reinicio.
Tambien hay que instalar desde la windows store Ubuntu, se busca y se instala.
Luego ya podemos acceder en un entorno buscando bash en el buscador (no git bash , solo bash)

Adentro del bash van a correr estos comandos en orden (peguen con click derecho)
### Linux general
Comandos para tener el linux en orden.
```bash
sudo apt update
sudo apt upgrade
```
```bash
sudo apt install gcc make libssl-dev libreadline-dev zlib1g-dev libsqlite3-dev libyaml-dev
```
### Ruby
Comandos para instalar el gestor de versiones de ruby
```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
```
```bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exit
```
Aca se les va a cerrar el bash, abranlo de vuelta y sigan.
```bash
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
```
```bash
rbenv -v
```
Si salio todo bien les deberia tirar una version.

Comandos para instalar ruby ( tarda un toque )
```bash
rbenv install 3.3.0 --verbose
```
```bash
rbenv global 3.3.0
ruby -v
```
Si fue todo joya les tira la version de ruby actual.
Comando para instalar bundler (equivalente al pip de python)
```bash
gem install bundler
```




### Node
Ya todos tenemos node en nuestras maquinas seguramente, pero hay que instalarlo tambien desde el bash (creo).
Gestor de versiones de node
```bash
sudo apt install curl
```
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```
```bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```
```bash
command -v nvm
```
Si con ese ultimo comando les tiro error o algo, reinicien el bash
```bash
nvm install --lts
```
```bash
nvm use --lts
```
```bash
node -v
```
Si salio todo bien les tira la version de node instalada.
### Rails
Trivial
```bash
gem install rails
```
No deberiamos usarlo aca pero por si a caso
```bash
npm install --global yarn
```
### Postgres SQL
```bash
sudo apt install postgresql postgresql-contrib libpq-dev
```
Aca vamos a instalar postgres en windows directamente desde: https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
Yo tuve dramas para instalar casi todas las versiones me tiraba algo de permiso denegado, prueben si quieren.
A mi me funciono esta:
https://get.enterprisedb.com/postgresql/postgresql-11.2-1-windows-x64.exe
Pongale cuando pida una contraseña "postgres", asi arranca derecho el repositorio.
Cuando diga algo de arrancar con stack builder destilden y terminen.
Una vez instalado (podria variar con la version), verificamos que el servidor este inciado, abrimos pgadmin (buscando desde el buscador de windows), abrimos donde dice servers y si esta con una x, le damos a object y a connect server. La contraseña es postgres.
**Volvemos al bash**
Bueno listo, ahora hay que navegar a donde quieran clonar el repositorio.
Las carpetas de windows estan bajo /mnt/"disco" , por ejemplo para navegar al escritorio seria:
```bash
cd /mnt/c/Users/<suUsuarioDeWindows>/Desktop # Si tienen onedrive suele estar en usuario/Onedrive/...
```
Estando en la carpeta que quieran finalmente
```bash
git clone https://github.com/Style12341/UTN-gestor-aulas-backend.git
```
Con cualquier editor de codigo abran donde clonaron el repo y en config/database.yml peguen donde esta actualmente
```yml
default: &default
  adapter: postgresql
  encoding: unicode
  username: postgres
  password: postgres
  host: localhost
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```
Esto no esta en el repositorio porque lo tengo distinto en mi vm, y si tambien pusieron otro password o ya tenian postgres pueden poner ahi las credenciales.
### Inicializar servidor
Instalamos las gemas de ruby (librerias xd)
```bash
bundle install
```
Luego creamos la base de datos
```bash
rails db:create
```
Migramos las tablas
```bash
rails db:migrate
```
Populamos con datos
```bash
rails db:seed
```
Y por ultimo para arrancar el server
```bash
rails s
```
### Ante cualquier cambio (git pull)
Hay que correr lo siguiente (siempre desde el bash)
```bash
bundle i
rails db:migrate:reset
rails db:seed
rails s
```

