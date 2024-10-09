#!/bin/bash

# Kontrollime, kas skripti käivitab root kasutaja
if [ "$EUID" -ne 0 ]; then
    echo "Seda skripti saab käivitada ainult root kasutaja. Skript lõpetatakse."
    exit 1
fi

# Kontrollime, kas on antud üks argument (kasutajate fail)
if [ $# -ne 1 ]; then
    echo "Kasutamine: $0 <kasutajate_fail>"
    exit 1
fi

# Määrame sisendfaili muutujasse
kasutajate_fail="$1"
logifail="loodud_kasutajad_paroolidega.log"

# Kontrollime, kas kasutajate fail on olemas ja loetav
if [ ! -f "$kasutajate_fail" ] || [ ! -r "$kasutajate_fail" ]; then
    echo "Faili ei leitud või pole loetav: $kasutajate_fail"
    exit 1
fi

# Kontrollime, kas pwgen on paigaldatud
if ! command -v pwgen &> /dev/null; then
    echo "pwgen käsku ei leitud. Palun paigalda pwgen ja proovi uuesti."
    exit 1
fi

# Loome logifaili või tühjendame olemasoleva
> "$logifail"

# Loeme kasutajate faili rea haaval
while IFS= read -r kasutajanimi || [[ -n "$kasutajanimi" ]]; do
    if [[ -z "$kasutajanimi" ]]; then
        echo "Tühi kasutajanimi failis, vahelejätmine."
        continue
    fi

    # Genereerime kasutajale parooli (8 sümbolit, ainult tähed)
    parool=$(pwgen -s 8 1)

    # Lisame kasutaja ja määrame parooli
    sudo useradd -m "$kasutajanimi"
    echo "$kasutajanimi:$parool" | sudo chpasswd

    if [ $? -eq 0 ]; then
        echo "Kasutaja $kasutajanimi lisatud koos genereeritud parooliga."
        # Salvestame kasutaja ja parooli logifaili
        echo "$kasutajanimi:$parool" >> "$logifail"
    else
        echo "Viga kasutaja $kasutajanimi lisamisel."
    fi
done < "$kasutajate_fail"

echo "Kõik kasutajad failist $kasutajate_fail on töödeldud."
echo "Kasutajate paroolid on salvestatud faili: $logifail"
