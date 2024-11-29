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
echo "Instalando ProFTPd"
echo
apt install proftpd
echo
echo "Instalando FileZilla"
echo
apt install filezilla
echo
echo "Fim do script"
echo

# Verifica se é necessário reiniciar o sistema
if [ -f /var/run/reboot-required ]; then
    echo "Atualizações concluídas. O sistema precisa ser reiniciado."
    read -p "Deseja reiniciar o sistema agora? (s/n): " resposta
    if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
        echo "Reiniciando o sistema..."
        sudo reboot
    else
        echo "Você pode reiniciar o sistema mais tarde, se desejar."
    fi
else
    echo "Não é necessário reiniciar o sistema."
fi
echo
echo
