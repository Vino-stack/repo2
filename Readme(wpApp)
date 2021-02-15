1.Installing LAMP Stack on Server
sudo apt-get install apache2 apache2-utils php libapache2-mod-php php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip mariadb-server mariadb-client

2.Configuring your Cloud SQL instance for WordPress

mysql -h 104.197.207.227 -u root -p

CREATE DATABASE wordpress;

CREATE USER wordpress IDENTIFIED BY 'very-long-wordpress-password';

GRANT ALL PRIVILEGES ON wordpress.* TO wordpress;

FLUSH PRIVILEGES;

3.Install wget
  sudo apt-get install wget
  
4.Install wordpress
sudo wget http://wordpress.org/latest.tar.gz

5.On Debian systems, run the following commands.
  sudo tar xvzf latest.tar.gz
  sudo mkdir -p  /var/www/html
  sudo cp -r wordpress/*  /var/www/html
  
6. Before starting WordPress installer make sure that Apache and MySQL services are running and 
   also run the following commands to avoid ‘wp-config.php‘ error file creation – we will revert changes afterward.
   
   sudo service apache2 restart
   sudo service mysql restart
   sudo chown -R www-data  /var/www/html
   sudo chmod -R 755  /var/www/html
   
7.Open a browser and enter your server’s IP or virtual domain name on URL using the HTTP protocol.
  http://your_server_IP/index.php
