#!/bin/bash

# Kontrollib, kas skript käivitatakse root-õigustega
if [ "$(id -u)" -ne 0 ]; then
  echo "Palun käivita see skript root kasutajana."
  exit 1
fi

# Logi funktsioon
logi() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Pakettide nimekirja uuendamine ja sõltuvuste paigaldamine
logi "Uuendatakse pakettide nimekirja ja paigaldatakse sõltuvused..."
apt update -y
apt install -y wget lsb-release gnupg

# Laadib alla ja installib MySQL APT konfiguratsioonifaili
logi "Laaditakse alla MySQL APT konfiguratsioonifail..."
wget https://dev.mysql.com/get/mysql-apt-config_0.8.30-1_all.deb || { echo "Allalaadimine ebaõnnestus!"; exit 1; }

logi "Installitakse MySQL APT konfiguratsioonifail..."
dpkg -i mysql-apt-config_0.8.30-1_all.deb || { echo "Konfiguratsioonifaili install ebaõnnestus!"; exit 1; }

# Uuendab repositooriumi nimekirja
logi "Uuendatakse pakettide nimekirja..."
apt update || { echo "Paketid ei uuendatud!"; exit 1; }

# Paigaldab MySQL serveri
logi "Paigaldatakse MySQL server..."
apt install mysql-server -y || { echo "MySQL serveri paigaldus ebaõnnestus!"; exit 1; }

# Käivita ja aktiveeri MySQL teenus
logi "Käivitatakse ja lubatakse MySQL automaatne käivitamine..."
systemctl start mysql || { echo "MySQL käivitamine ebaõnnestus!"; exit 1; }
systemctl enable mysql || { echo "MySQL automaatse käivitamise lubamine ebaõnnestus!"; exit 1; }

# MySQL esialgne turvaseadistus
logi "Käivitatakse MySQL turvaskript..."
mysql_secure_installation

# Puhastamine
logi "Eemaldatakse allalaaditud konfiguratsioonifail..."
rm -f mysql-apt-config_0.8.30-1_all.deb

# Lõputeade
logi "MySQL serveri paigaldus on lõpule viidud ja teenus on käivitatud!"

