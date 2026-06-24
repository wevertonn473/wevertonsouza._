#!/bin/bash
#
# install.sh — instala o Smart Unzip no macOS
#
#   1. Copia o motor (smart-unzip.sh) para ~/.local/bin/smart-unzip
#   2. Instala a Quick Action em ~/Library/Services
#   3. Atualiza o menu de Serviços do Finder
#
# Depois é só clicar com o botão direito num .zip → Início rápido (Quick
# Actions) → "Smart Unzip (pasta única)".
#
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="$HOME/.local/bin"
ENGINE_DST="$BIN_DIR/smart-unzip"
SERVICES_DIR="$HOME/Library/Services"
WORKFLOW_SRC="$HERE/SmartUnzip.workflow"
WORKFLOW_DST="$SERVICES_DIR/SmartUnzip.workflow"

echo "› Instalando o motor em $ENGINE_DST"
mkdir -p "$BIN_DIR"
cp "$HERE/smart-unzip.sh" "$ENGINE_DST"
chmod +x "$ENGINE_DST"

# Caso a Quick Action ainda não tenha sido gerada, gera agora.
if [ ! -d "$WORKFLOW_SRC" ]; then
  echo "› Gerando a Quick Action"
  python3 "$HERE/build-quick-action.py"
fi

echo "› Instalando a Quick Action em $WORKFLOW_DST"
mkdir -p "$SERVICES_DIR"
rm -rf "$WORKFLOW_DST"
cp -R "$WORKFLOW_SRC" "$WORKFLOW_DST"

echo "› Atualizando o menu de Serviços"
/System/Library/CoreServices/pbs -flush >/dev/null 2>&1 || true

cat <<'EOF'

✅ Pronto!

Como usar:
  • No Finder, clique com o botão direito em um arquivo .zip.
  • Vá em "Início rápido" (ou "Serviços") → "Smart Unzip (pasta única)".
  • O conteúdo é extraído em uma pasta única, limpa e sem aninhamento.

Dica: dá pra usar no terminal também:
  ~/.local/bin/smart-unzip arquivo.zip

Se a Quick Action não aparecer na hora, abra
Ajustes do Sistema → Teclado → Atalhos de teclado → Serviços
e confirme que "Smart Unzip (pasta única)" está marcada (ou faça logout/login).
EOF
