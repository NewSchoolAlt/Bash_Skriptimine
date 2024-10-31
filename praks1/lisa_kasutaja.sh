#!/bin/bash

# Kontrolli, kas on antud kasutajanimi
if [ -z "$1" ]; then
    echo "Palun sisestage kasutajanimi."
    exit 1
fi

KASUTAJA=$1

# Loo kasutaja ilma paroolita ja määra Bash shell
sudo useradd -m -s /bin/bash "$KASUTAJA"

# Loo kodukatalooge ja peidetud failid
sudo mkdir -p /home/"$KASUTAJA"/.config
sudo mkdir -p /home/"$KASUTAJA"/.local/share

# Muuda katalooge kasutaja omandiks
sudo chown -R "$KASUTAJA":"$KASUTAJA" /home/"$KASUTAJA"

echo "Kasutaja $KASUTAJA on loodud ja kodukataloog on seadistatud."
figlet "Made by olev" | /usr/games/lolcat
