#!/bin/bash

# Kontrollime, kas PHP on juba paigaldatud
if dpkg -l | grep -q php; then
    echo "PHP on juba paigaldatud!"
    exit 0
fi

# Määrame PHP versiooni
PHP_VERSION="8.2"  # Asenda vastavalt vajadusele

echo "Paigaldame PHP ja vajalikud abipaketid..."

# Paigaldame PHP ja vajalikud moodulid
sudo apt update
sudo apt install -y php${PHP_VERSION} libapache2-mod-php${PHP_VERSION} php${PHP_VERSION}-mysql

# Kontrollime, kas paigaldus õnnestus
if ! dpkg -l | grep -q php${PHP_VERSION}; then
    echo "PHP paigaldus ebaõnnestus!"
    exit 1
fi

# Lubame ja taaskäivitame Apache teenuse
sudo systemctl enable apache2
sudo systemctl restart apache2

echo "PHP ja abipaketid on edukalt paigaldatud!"

# Lisame Git commit-i, kui skript on osa Git projektist
if [ -d ".git" ]; then
    git add php_paigaldus.sh
    git commit -m "Lisatud php_paigaldus.sh skript"
    git push
    echo "Skript on salvestatud ja üles laetud GitHub-i."
else
    echo "Git repot ei leitud. Veendu, et oled õigel teel!"
fi

