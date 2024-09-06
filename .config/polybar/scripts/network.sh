#!/bin/bash

# Definir ícones para cada tipo de conexão
icon_wired=" "      # Ícone para conexão com fio
icon_wireless=" "   # Ícone para conexão sem fio
icon_no_connection=" "  # Ícone para desconectado

# Função para verificar se uma interface está ativa
is_interface_up() {
    ip link show "$1" | grep -q "state UP"
}

# Obter uma lista de interfaces ativas
active_interfaces=$(ip -o link show | awk -F': ' '{print $2}' | while read -r iface; do
    if is_interface_up "$iface"; then
        echo "$iface"
    fi
done)

# Verificar se há interfaces ativas
if [ -z "$active_interfaces" ]; then
    echo "$icon_no_connection No active network interface found"
    exit 1
fi

# Iterar sobre todas as interfaces ativas e coletar as informações
output=""
for iface in $active_interfaces; do
    # Identificar se a interface é wireless ou wired
    if [[ $iface == wlan* || $iface == wlp* ]]; then
        icon=$icon_wireless
    elif [[ $iface == eth* || $iface == enp* ]]; then
        icon=$icon_wired
    else
        icon=$icon_no_connection
    fi
    
    # Obter o endereço IP da interface ativa
    ip_address=$(ip -o -4 addr show $iface | awk '{print $4}' | cut -d/ -f1)
    
    # Obter os dados de uso da interface ativa
    down=$(cat /sys/class/net/$iface/statistics/rx_bytes)
    up=$(cat /sys/class/net/$iface/statistics/tx_bytes)
    
    # Adicionar informações ao output
    output+="$icon$iface: $ip_address | "
done

# Remover o último delimitador
output=${output% | }

# Exibir o resultado
echo "$output"

