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

# Caminho do arquivo de configuração
arquivo="/etc/proftpd/proftpd.conf"

# Verificar se o arquivo já existe
if [ -f "$arquivo" ]; then
    echo "O arquivo $arquivo existe, será substituído."
else
    echo "O arquivo $arquivo não existe, será criado."
fi

# Escrever o conteúdo no arquivo
cat << EOF > "$arquivo"
Include /etc/proftpd/modules.conf
UseIPv6 off
<IfModule mod_ident.c>
  IdentLookups off
</IfModule>

ServerName "iftm"
ServerType standalone
DeferWelcome off

DefaultServer on
ShowSymlinks on

TimeoutNoTransfer 600
TimeoutStalled 600
TimeoutIdle 1200

DisplayLogin welcome.msg
DisplayChdir .message true
ListOptions "-l"

DenyFilter \*.*/

DefaultRoot ~

Port 21

<IfModule mod_dynmasq.c>
</IfModule>

MaxInstances 30

User proftpd
Group nogroup

Umask 022 022

AllowOverwrite on

TransferLog /var/log/proftpd/xferlog
SystemLog /var/log/proftpd/proftpd.log

<IfModule mod_quotatab.c>
QuotaEngine off
</IfModule>

<IfModule mod_ratio.c>
Ratios off
</IfModule>

<IfModule mod_delay.c>
DelayEngine on
</IfModule>

<IfModule mod_ctrls.c>
ControlsEngine off
ControlsMaxClients 2
ControlsLog /var/log/proftpd/controls.log
ControlsInterval 5
ControlsSocket /var/run/proftpd/proftpd.sock
</IfModule>

<IfModule mod_ctrls_admin.c>
AdminControlsEngine off
</IfModule>

Include /etc/proftpd/conf.d/
EOF

echo "Configuração escrita em $arquivo"
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
