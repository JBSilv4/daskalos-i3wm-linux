#!/bin/bash

# Obter o uso total e livre de memória
MEMORY_INFO=$(free -h | grep Mem)

# Extrair informações de uso
TOTAL=$(echo "$MEMORY_INFO" | awk '{print $2}')
USED=$(echo "$MEMORY_INFO" | awk '{print $3}')
FREE=$(echo "$MEMORY_INFO" | awk '{print $4}')

# Formatar a saída
echo " ${USED}B"

