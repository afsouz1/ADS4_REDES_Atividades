#!/bin/bash

# Exibir Menu

menu(){
    clear
    echo
    echo " --- Gerenciador DHCP ---"
    echo
    echo " (1) - Instalar DHCP"
    echo " (2) - Configurar DHCP"
    echo " (3) - Parar Serviço DHCP"
    echo " (4) - Reiniciar Serviço DHCP"
    echo " (5) - Verificar Status Serviço DHCP"
    echo " (0) - Sair do Gerenciador"
    echo
    echo -n "Escolha uma opção: "

}

# Opção 1 - Instalar DHCP

instalar(){
    echo
    echo "Instalando..."
    sudo apt update
    sudo apt upgrade -y
    echo "Função concluída..."
}

# Opção 2 - Configurar DHCP

configurar(){
    echo "Configurando o arquivo /etc/dhcp/dhcpd.conf..."

    # Verificar se o arquivo /etc/dhcp/dhcpd.conf existe
    if [ ! -f /etc/dhcp/dhcpd.conf ]; then
        echo "Erro: O arquivo /etc/dhcp/dhcpd.conf não foi encontrado!"
        echo "Verifique a instalação do isc-dhcp-server."
        exit 1
    fi

    # Criar uma configuração mínima no arquivo /etc/dhcp/dhcpd.conf
    cat <<EOF > /etc/dhcp/dhcpd.conf
# Configuração básica do servidor DHCP
default-lease-time 600;
max-lease-time 7200;

# Intervalo de IPs que serão atribuídos pelo DHCP
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.100 192.168.1.200;
    option routers 192.168.1.1;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 8.8.8.8, 8.8.4.4;
    option broadcast-address 192.168.1.255;
}
EOF

    echo "Arquivo de configuração criado com sucesso!"

    # Configurar a interface de rede (substitua pela sua interface de rede real)
    INTERFACE="eth0"  # Alterar para a sua interface de rede, por exemplo, wlan0
    sed -i "s/^INTERFACESv4=.*/INTERFACESv4=\"$INTERFACE\"/" /etc/default/isc-dhcp-server

    # Reiniciar o serviço após a configuração
    systemctl restart isc-dhcp-server
    echo "Configuração aplicada com sucesso!"
    echo "Função concluída..."
}

# Opção 3 - Parar serviço DHCP

parar() {
    echo "Parando o serviço DHCP..."
    systemctl stop isc-dhcp-server
    echo "Função concluída..."
}


# Opção 4 - Reiniciar Serviço DHCP

reiniciar() {
    echo "Reiniciando o serviço DHCP..."
    systemctl restart isc-dhcp-server

    # Verificar se o serviço reiniciou corretamente
    if [ $? -eq 0 ]; then
        echo "Serviço DHCP reiniciado com sucesso!"
    else
        echo "Erro: O serviço DHCP não conseguiu ser reiniciado."
        echo "Tentando verificar o status..."
        verificar_status_servico
        # Sugerir possíveis correções
        echo "Verifique a configuração do arquivo /etc/dhcp/dhcpd.conf e a interface de rede no arquivo /etc/default/isc-dhcp-server."
    fi
}

# Opção 5 - Verificar Status DHCP

status() {
    echo "Verificando o status do serviço DHCP..."
    systemctl status isc-dhcp-server.service --no-pager
}



# Seleção para rodar o menu
opcao() {
    case $1 in
        1)
            instalar
            ;;
        2)
            configurar
            ;;
        3)
            parar
            ;;
        4)
            reiniciar
            ;;
        5)
            status
            ;;
        0)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida! Tente novamente."
            ;;
    esac
}

# Loop Menu

while true; do
    menu
    read opcao
    opcao $opcao
    read -p "Pressione [Enter] para continuar..."
done

