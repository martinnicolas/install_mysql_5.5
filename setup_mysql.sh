echo "Mysql setup \$* method: $*"

if [ -n "$1" ]; then

echo "-----------"

echo "1 - Eliminar archivos de la instalación anterior"
sudo rm /var/lib/mysql/ -R
echo "2 - Eliminar mysql profile"
sudo rm /etc/mysql/ -R
echo "3 - Desinstalar la versión actual de mysql"
sudo apt-get autoremove ‘mysql*’ --purge
echo "4 - Descargar la versión 5.5 que se necesite desde el sitio de mysql"
wget https://cdn.mysql.com/archives/mysql-5.5/mysql-5.5.37-linux2.6-x86_64.tar.gz
echo "5 - Agregar grupo de usuarios mysql"
sudo groupadd mysql
echo "6 - Agregar mysql (not the current user) al grupo de usuarios mysql"
sudo useradd -g mysql mysql
echo "7 - Extraer el archivo"
sudo tar -xvf mysql-5.5.37-linux2.6-x86_64.tar.gz
echo "8 - Moverlo a /usr/local"
sudo mv mysql-5.5.37-linux2.6-x86_64 /usr/local/
echo "9 - Crear directorio mysql en /usr/local moviendo el archivo descomprimido"
cd /usr/local
sudo mv mysql-5.5.37-linux2.6-x86_64 mysql
echo "10 - set MySql directory owner and user group"
cd mysql
sudo chown -R mysql:mysql *
echo "11 - Instalar el paquete (funciona para la versión 5.6 tmb)"
sudo apt-get install libaio1
echo "12 - Ejecutar el script de instalacion mysql"
sudo scripts/mysql_install_db --user=mysql
echo "13 - Set mysql directory owner from outside the mysql directory"
cd ..
sudo chown -R root mysql
echo "14 - Set data directory owner from inside mysql directory"
sudo chown -R mysql data
echo "15 - Copy the mysql configuration file"
sudo cp support-files/my-medium.cnf /etc/my.cnf
echo "16 -  Iniciar mysql "
sudo bin/mysqld_safe --user=mysql &
sudo cp support-files/mysql.server /etc/init.d/mysql.server
echo "17 - Setear la clave del user root"
sudo bin/mysqladmin -u root password $1
echo "18 - Agregar el path de mysql al sistema"
sudo ln -s /usr/local/mysql/bin/mysql /usr/local/bin/mysql
echo "19 - Iniciar servidor mysql"
sudo /etc/init.d/mysql.server start
sudo /etc/init.d/mysql.server status
echo "20 -  Agregar mysql para que arranque al inicio"
sudo update-rc.d -f mysql.server defaults
echo "21 - Descarga de libmysql "
sudo apt-get install zlib1g-dev
cd
wget http://people.debian.org/~nobse/mysql-5.5/mysql-common_5.5.13-2_all.deb
wget http://people.debian.org/~nobse/mysql-5.5/libmysqlclient-dev_5.5.13-2_amd64.deb
wget http://people.debian.org/~nobse/mysql-5.5/libmysqlclient18_5.5.13-2_amd64.deb

echo "21 - instalacion de lbmysql-client"
sudo dpkg -i mysql-common_5.5.13-2_all.deb
sudo dpkg -i libmysqlclient18_5.5.13-2_amd64.deb
sudo dpkg -i libmysqlclient-dev_5.5.13-2_amd64.deb
echo "eliminacion de duplicado de my.cnf"
sudo rm /etc/mysql/my.cnf

echo "-----------"
echo "FIN DE LA INSTALACION"
echo "-----------"


else
echo "No parameters Password Mysql found"
fi



