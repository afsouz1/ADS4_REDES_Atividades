#!/bin/bash

# Verifica se o script está sendo executado com privilégios de superusuário
if [ "$(id -u)" -ne 0 ]; then
    echo "Por favor, execute este script com sudo."
    exit 1
fi
echo
echo "Atualizando lista de pacotes..."
echo
apt update
echo
echo "Atualizando pacotes instalados..."
echo
apt upgrade -y
echo
echo "Processo de atualização concluído!"
echo
echo
echo "Instalando Apache2"
echo
apt install apache2
echo
echo "Instalando MySql Server"
echo
apt install mysql-server
echo
echo "Instalando PHP"
apt install php libapache2-mod-php php-mcrypt php-mysql php-cgi php-curl php-json -y
echo
echo "Fim do script"
echo
