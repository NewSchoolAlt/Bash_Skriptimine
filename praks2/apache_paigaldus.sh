#!/bin/bash

# Kontrollime, kas apache2 on paigaldatud
if dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -q "ok installed"; then
    echo "Apache2 on juba paigaldatud."
    # Näitame teenuse staatust
    systemctl status apache2
else
    echo "Apache2 ei ole paigaldatud. Paigaldame nüüd..."
    # Paigaldame apache2
    sudo apt-get update
    sudo apt-get install -y apache2
    echo "Apache2 on nüüd paigaldatud."
    # Käivitame teenuse ja näitame staatust
    sudo systemctl start apache2
    sudo systemctl status apache2
fi
