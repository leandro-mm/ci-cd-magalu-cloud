#!/bin/bash

# ==============================================================================
# PROJETO: MVP E-Commerce Shell Script (Bash-Commerce)
# ARQUIVO DE SAÍDA: pedidos.csv
# CONFIGURAÇÃO: Respondendo na porta 80
# ==============================================================================

PORT=8080
FILE_DB="pedidos.csv"

echo "===================================================="
echo "=== MAGALU CLOUD - SISTEMA DE PEDIDOS E-COMMERCE ==="
echo "===================================================="

# Requisito 1: Garantir a existência do arquivo de dados (Criação Lazy)
touch "$FILE_DB"

# Função para simular a criação de um pedido automatizado toda vez que a página é atualizada
# (Substitui o 'read' interativo que travava o container)
gerar_pedido_simulado() {
    local produtos=("Bateria" "Teclado Mecanico" "Mouse Gamer" "Monitor UltraWide" "Cabo HDMI")
    # Escolhe um produto aleatório da lista
    local produto_aleatorio=${produtos[$RANDOM % ${#produtos[@]}]}
    
    # Requisito 2: Gerar o número do pedido com base no total de linhas atual + 1
    local current_lines=$(wc -l < "$FILE_DB")
    local order_number=$(( current_lines + 1 ))
    
    # Requisito 4: Gravação estruturada no formato CSV
    echo "${order_number},${produto_aleatorio}" >> "$FILE_DB"
}

# Loop para manter o contêiner vivo e respondendo requisições HTTP na porta 80
while true; do
  # Toda vez que houver um acesso (hit/refresh), simulamos um novo pedido persistido no CSV
  gerar_pedido_simulado

  # Captura as últimas 5 linhas do CSV para exibir dinamicamente no HTML
  ULTIMOS_PEDIDOS=$(tail -n 5 "$FILE_DB" | sed 's/$/<br>/')

  # Escuta na porta 80 e responde com o HTML atualizado
  echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\n\r\n\
  <html>
    <head>
      <title>Magalu Cloud - Bash Commerce</title>
    </head>
    <body style='font-family: sans-serif; background-color: #f4f4f9; padding: 50px;'>
      <h1 style='color: #0086ff;'>====== PROJETO BASH-COMMERCE ======</h1>
      <p><strong>Status do Container:</strong> <span style='color: green; font-weight: bold;'>ONLINE</span></p>
      <p><strong>Hostname do Pod:</strong> $(hostname)</p>
      
      <h3 style='color: #333;'>Último log de pedidos de e-commerce simulado:</h3>
      <pre style='background: #222; color: #fff; padding: 15px; border-radius: 5px; font-family: monospace;'>
$(date '+%Y-%m-%d %H:%M:%S') - [INFO] Aguardando novas requisições de compra...
$(date '+%Y-%m-%d %H:%M:%S') - [SUCCESS] Payload de persistência CSV validado com sucesso.
      </pre>

      <h3 style='color: #333;'>Conteúdo Atual do Banco de Dados (pedidos.csv):</h3>
      <div style='background: #fff; padding: 15px; border: 1px solid #ccc; border-radius: 5px; font-family: monospace;'>
        ${ULTIMOS_PEDIDOS:-<i>Nenhum pedido registrado ainda.</i>}
      </div>
      <p style='font-size: 12px; color: #666; margin-top: 20px;'>💡 Atualize a página para simular novas compras e ver o Hostname mudar no cluster Kubernetes!</p>
    </body>
  </html>" | nc -lkp $PORT -q 1
done
