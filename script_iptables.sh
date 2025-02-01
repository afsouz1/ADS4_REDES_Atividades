#!/bin/bash

install() {
	echo
	echo "Instalando o Iptables"
	echo
	sudo apt update
	sudo apt install iptables
	echo
	echo "Serviço instalado, realize a configuração!"
	echo
}

start() {
    echo
    echo "Definindo as regras..."
    echo
    sudo iptables -A INPUT -m multiport -p tcp --dport 80,443 -j REJECT  # Rejeitar SSH
    sudo iptables -A OUTPUT -m multiport -p tcp --dport 80,443 -j REJECT  # Rejeitar SSH
    echo
}

stop() {
    echo
    echo "Removendo as regras..."
    echo
    sudo iptables -D INPUT -m multiport -p tcp --dport 80,443 -j REJECT  # Rejeitar SSH
    sudo iptables -D OUTPUT -m multiport -p tcp --dport 80,443 -j REJECT  # Rejeitar SSH
    echo
}

remove() {
	echo
	echo "Desinstalando o Iptables..."
	echo
	sudo apt remove -y iptables
}

restart() {
	echo
	echo "Reiniciando o Serviço Iptables..."
	echo
	stop
	start
}

list() {
	echo
	echo "Listar as regras de Entrada..."
	echo
	sudo iptables -L INPUT
	echo "Listar as regras de Saída..."
	echo
	sudo iptables -L OUTPUT
}

help() {
	echo
	echo "Comandos disponiveis:"
	echo "  install    - Realiza a instalação do serviço Iptables;"
	echo "  start      - Definir as regras do Iptables;"
	echo "  stop       - Remover as regras do Iptables;"
	echo "  remove     - Desinstalar o Iptables;"
	echo "  restart    - Reincia o serviço Iptables;"
	echo "  list       - Lista as regras do Iptables;"
	echo
}

case "$1" in
	install)
	  install;;
	start)
	  start;;
	stop)
	  stop;;
	remove)
	  remove;;
	restart)
      restart;;
	list)
	  list;;
    help)
      help;;
	*)
    	  echo
	  echo "Comando inválido! Utilize: $0 {comando}"
	  echo "Dúvidas? Utilize o comando 'help'"
	  echo
	  exit 1;;
esac
