#!/bin/bash

# Kontrollime, kas vajalikud teenused on paigaldatud ja töötavad
echo "Kontrollin teenuseid..."
for service in apache2 php mysql-server; do
    if ! dpkg -l | grep -q $service; then
        echo "$service ei ole paigaldatud. Paigaldan selle..."
        sudo apt update && sudo apt install -y $service
    else
        echo "$service on juba paigaldatud."
    fi
done

# Kontrollime, kas MySQL server töötab
sudo systemctl start mysql
sudo systemctl enable mysql

# Luuakse WordPressi andmebaas ja kasutaja
echo "Loon andmebaasi ja kasutaja..."
DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASSWORD="qwerty"

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "Andmebaas ja kasutaja on loodud."

# Laadime alla ja pakkime lahti WordPressi
echo "Laadin alla ja pakkide lahti WordPressi..."
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
sudo cp -R wordpress /var/www/html/

# Seadistame WordPressi konfiguratsioonifaili
echo "Konfigureerin wp-config.php faili..."
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wordpress/wp-config.php

# Seadistame kaustade õigused
echo "Seadistan kaustade õigused..."
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Taaskäivitame Apache serveri
echo "Taaskäivitan Apache serveri..."
sudo systemctl restart apache2

echo "WordPress on paigaldatud ja seadistatud. Kontrollige oma veebilehte brauseris."


