#!/bin/bash

# Verifica se o script está sendo executado com privilégios de superusuário
if [ "$(id -u)" -ne 0 ]; then
    echo "Por favor, execute este script com sudo."
    exit 1
fi
echo
echo "[1] Atualizando lista de pacotes..."
echo
apt update
echo
echo "[2] Atualizando pacotes instalados..."
echo
apt upgrade -y
echo
echo "[3] Processo de atualização concluído!"
echo
echo
echo "[4] Instalando SAMBA"
echo
apt install samba
echo
echo "[4] Configurando o Samba...."
echo
echo

# Caminho do arquivo de configuração
teste="/etc/samba/smb.conf"

# Verificar se o arquivo já existe
if [ -f "$teste" ]; then
    echo
    echo "[5] O arquivo $teste já existe."
    echo
    cd /etc/samba/
    echo "[6] Realizando backup do arquivo smb.conf para smb.conf2..."
    # Fazendo backup do arquivo de configuração
    cp smb.conf smb.conf2
    echo
    echo
else
    echo "[5] O arquivo $teste não existe, criando..."
    echo
    mkdir /etc/samba/ && touch /etc/samba/smb.conf
    echo
    echo "[6] Arquivo criado!"
    echo

fi

echo
# Caminho do arquivo de configuração
arquivo="/etc/samba/smb.conf"
echo "[7] Configurando o arquivo smb.conf..."
echo

# Escrever o conteúdo no arquivo
cat << EOF > "$arquivo"
[global]

workgroup = GRUPO
server string = %h server (Samba, Ubuntu)
dns proxy = no
interfaces = lo eth0 eth1
bind interfaces only = true
log file = /var/log/samba/log.%m
max log size = 1000
syslog = 0
panic action = /usr/share/samba/panic-action %d
security = share
encrypt passwords = true
passdb backend = tdbsam
obey pam restrictions = yes
guest account = nobody
invalid users = root
passwd program = /usr/bin/passwd %u

[Servidor]
comment = Servidor de Arquivos
path = /home/servidor
browseable = yes
read only = yes
guest ok = yes

EOF

echo
echo "[8] Configuração escrita em $arquivo"
echo
echo "[9] Criando a pasta /home/servidor..."

# Caminho do arquivo de configuração
teste="/home/iftm/servidor"

# Verificar se o arquivo já existe
if [ -f "$teste" ]; then
    echo
    echo "[10] A pasta $teste já existe."
    echo
    echo "[11] Alterando permissões da pasta Servidor..."
    echo
    chmod 777 /home/iftm/servidor/
    echo
else
    echo "[10] A pasta $teste não existe, será criada."
    echo
    mkdir /home/iftm/servidor
    echo
    echo "[11] Alterando permissões da pasta Servidor..."
    echo
    cd /home/iftm
    chmod 777 /home/iftm/servidor/
    echo
fi
echo
echo "[12] Reiniciando o Samba..."
echo
/etc/init.d/samba restart
echo
echo "[13] Fim do script"
echo
echo
