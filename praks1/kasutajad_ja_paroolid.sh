#!/bin/bash

# Kontrollime, kas on antud kaks argumenti (kasutajate ja paroolide failid)
if [ $# -ne 2 ]; then
    echo "Kasutamine: $0 <kasutajate_fail> <paroolide_fail>"
    exit 1
fi

# Määrame sisendargumendid muutujatesse
kasutajate_fail="$1"
paroolide_fail="$2"

# Kontrollime, kas mõlemad failid eksisteerivad ja on loetavad
if [ ! -f "$kasutajate_fail" ] || [ ! -r "$kasutajate_fail" ]; then
    echo "Faili ei leitud või pole loetav: $kasutajate_fail"
    exit 1
fi

if [ ! -f "$paroolide_fail" ] || [ ! -r "$paroolide_fail" ]; then
    echo "Faili ei leitud või pole loetav: $paroolide_fail"
    exit 1
fi

# Kontrollime, kas mõlemal failil on sama arv ridu
kasutajate_arv=$(wc -l < "$kasutajate_fail")
paroolide_arv=$(wc -l < "$paroolide_fail")

if [ "$kasutajate_arv" -ne "$paroolide_arv" ]; then
    echo "Viga: $kasutajate_fail ja $paroolide_fail ridade arv ei ühti."
    exit 1
fi

# Loeme kasutajate ja paroolide failid rea haaval
paste "$kasutajate_fail" "$paroolide_fail" | while IFS=$'\t' read -r kasutajanimi parool; do
    if [[ -z "$kasutajanimi" || -z "$parool" ]]; then
        echo "Vigane kirje failides. Nii kasutajanimi kui ka parool on kohustuslikud."
        continue
    fi

    # Lisame kasutaja ilma kodukataloogi loomiseta (-M lipp)
    sudo useradd -m "$kasutajanimi"

    # Määrame kasutajale parooli
    echo "$kasutajanimi:$parool" | sudo chpasswd
    if [ $? -eq 0 ]; then
        echo "Kasutaja $kasutajanimi lisatud koos määratud parooliga."
    else
        echo "Parooli seadmine ebaõnnestus kasutajale $kasutajanimi."
    fi
done

echo "Kõik kasutajad failist $kasutajate_fail on töödeldud."
