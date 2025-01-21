#!/bin/bash

# Função para exibir o menu
mostrar_menu() {
    clear
    echo "==============================="
    echo "  Gerenciador de Servidor DHCP"
    echo "==============================="
    echo "1. Instalar o servidor DHCP"
    echo "2. Remover o servidor DHCP"
    echo "3. Configurar o servidor DHCP"
    echo "4. Parar o serviço DHCP"
    echo "5. Reiniciar o serviço DHCP"
    echo "6. Sair"
    echo "==============================="
    echo -n "Escolha uma opção: "
}

# Função para instalar o servidor DHCP
instalar_dhcp() {
    echo "Instalando o servidor DHCP..."
    apt-get update
    apt-get install -y isc-dhcp-server
    echo "Instalação concluída!"
}

# Função para remover o servidor DHCP
remover_dhcp() {
    echo "Removendo o servidor DHCP..."
    apt-get remove --purge -y isc-dhcp-server
    apt-get autoremove -y
    echo "Servidor DHCP removido com sucesso!"
}

# Função para configurar o servidor DHCP
configurar_dhcp() {
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
}

# Função para verificar o status do serviço DHCP
verificar_status_servico() {
    echo "Verificando o status do serviço DHCP..."
    systemctl status isc-dhcp-server.service --no-pager
}

# Função para parar o serviço DHCP
parar_dhcp() {
    echo "Parando o serviço DHCP..."
    systemctl stop isc-dhcp-server
    echo "Serviço DHCP parado."
}

# Função para reiniciar o serviço DHCP
reiniciar_dhcp() {
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

# Função para verificar a interface configurada
verificar_interface_rede() {
    INTERFACE_CONFIGURADA=$(grep "INTERFACESv4" /etc/default/isc-dhcp-server | cut -d'=' -f2 | tr -d ' "')

    if [ -z "$INTERFACE_CONFIGURADA" ]; then
        echo "Erro: Nenhuma interface de rede configurada no arquivo /etc/default/isc-dhcp-server!"
        echo "Verifique e configure a variável INTERFACESv4 corretamente."
        exit 1
    else
        echo "A interface de rede configurada é: $INTERFACE_CONFIGURADA"
    fi
}

# Função principal para rodar o menu
opcao_selecionada() {
    case $1 in
        1)
            instalar_dhcp
            ;;
        2)
            remover_dhcp
            ;;
        3)
            configurar_dhcp
            ;;
        4)
            parar_dhcp
            ;;
        5)
            reiniciar_dhcp
            ;;
        6)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida! Tente novamente."
            ;;
    esac
}

# Loop para exibir o menu
while true; do
    mostrar_menu
    read opcao
    opcao_selecionada $opcao
    read -p "Pressione [Enter] para continuar..."
done
