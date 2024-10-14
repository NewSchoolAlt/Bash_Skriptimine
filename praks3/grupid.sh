#!/bin/bash
echo " "
echo " kui tahad lõpetada siis vajuta X klahvi ja enter "
echo " "
while true; do
    # Küsi kasutaja nimi
    read -p "Sisesta kasutaja nimi: " username

    # Kasutaja lõpetab skripti sisestades 'x'
    if [ "$username" == "x" ]; then
        echo "Skript lõpetatud."
        exit 0
    fi

    # Küsi grupi nimi
    read -p "Sisesta grupi nimi (opilased/opetajad): " group

    # Kontrolli grupi nime
    if [[ "$group" != "opilased" && "$group" != "opetajad" ]]; then
        echo "Vale grupi nimi. Lubatud on ainult 'opilased' või 'opetajad'."
        continue
    fi

    # Kontrolli kasutaja nime formaati
    if ! [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo "Vale kasutajanimi. Kasutajanimed peavad algama tähega ja sisaldama ainult tähti, numbreid, allkriipse ja sidekriipse."
        continue
    fi

    # Loo kasutaja
    sudo useradd -m -s /bin/bash "$username"
    if [ $? -ne 0 ]; then
        echo "Kasutaja loomine ebaõnnestus."
        continue
    fi

    # Lisa kasutaja gruppi
    sudo usermod -aG "$group" "$username"
    if [ $? -ne 0 ]; then
        echo "Kasutaja lisamine gruppi ebaõnnestus."
        continue
    fi

    # Määra kodukataloogi õigused
    sudo chown "$username:$group" "/home/$username"
    sudo chmod 700 "/home/$username"

    # Määra kasutajale parool
    sudo passwd "$username"

    # Näita kasutaja infot
    echo "Kasutaja $username loodud!"
    echo "Grupp: $group"
    echo "Kodukataloog: /home/$username"
done
