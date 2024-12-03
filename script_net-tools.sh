#!/bin/bash

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
echo "Instalando o net-tools"
echo
apt install net-tools
echo
echo
ifconfig
