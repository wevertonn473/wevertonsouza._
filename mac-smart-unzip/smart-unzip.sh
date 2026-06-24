#!/bin/bash
#
# smart-unzip.sh — Extração inteligente de .zip no macOS
#
# Resolve o clássico "o Mac espalha os arquivos em várias pastas" ao abrir um zip:
#   • Sempre extrai DENTRO de uma pasta única, com o nome do próprio zip.
#   • Nunca derrama arquivos soltos no diretório atual (fim da bagunça).
#   • Remove o aninhamento redundante (pasta/pasta/...) quando há um único
#     subdiretório envolvendo todo o conteúdo.
#   • Ignora o lixo do macOS (__MACOSX, .DS_Store) — que são justamente as
#     "pastas a mais" que aparecem na extração.
#   • Evita sobrescrever: se a pasta já existe, cria "nome 2", "nome 3", ...
#
# Uso:
#   smart-unzip.sh arquivo1.zip [arquivo2.zip ...]
#
set -euo pipefail

# ----------------------------------------------------------------------------
# feedback: notificação nativa no Mac quando disponível, senão imprime no stdout
# ----------------------------------------------------------------------------
notify() {
  local title="$1" message="$2"
  if command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"${message//\"/\\\"}\" with title \"${title//\"/\\\"}\"" >/dev/null 2>&1 || true
  fi
  echo "[$title] $message"
}

# ----------------------------------------------------------------------------
# achata aninhamento redundante: enquanto a pasta tiver UM único filho que é
# um diretório (e nada mais), sobe o conteúdo desse filho um nível.
# Isso elimina o "pasta/pasta/conteudo" e mantém tudo num lugar só.
# ----------------------------------------------------------------------------
flatten_redundant() {
  local target="$1"
  while true; do
    local count only
    count=$(find "$target" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')
    [ "$count" = "1" ] || break
    only=$(find "$target" -mindepth 1 -maxdepth 1)
    [ -d "$only" ] || break
    # move tudo (inclusive ocultos) do único filho para a pasta destino
    (
      shopt -s dotglob nullglob
      mv -- "$only"/* "$target"/ 2>/dev/null || true
    )
    rmdir -- "$only" 2>/dev/null || break
  done
}

# ----------------------------------------------------------------------------
# extrai um zip de forma organizada
# ----------------------------------------------------------------------------
extract_one() {
  local zip="$1"

  if [ ! -f "$zip" ]; then
    notify "Smart Unzip" "Ignorado (não é um arquivo): $zip"
    return 0
  fi

  local dir base name target i
  dir=$(cd "$(dirname "$zip")" && pwd)
  base=$(basename "$zip")
  name="${base%.[Zz][Ii][Pp]}"          # remove a extensão .zip (case-insensitive)
  [ "$name" != "$base" ] || name="${base%.*}"

  # escolhe uma pasta destino sem colidir com algo existente
  target="$dir/$name"
  i=2
  while [ -e "$target" ]; do
    target="$dir/$name $i"
    i=$((i + 1))
  done
  mkdir -p "$target"

  # extrai ignorando o lixo do macOS
  if ! unzip -q -o "$zip" -x "__MACOSX/*" "*/.DS_Store" ".DS_Store" -d "$target" 2>/dev/null; then
    notify "Smart Unzip" "Falha ao extrair: $base"
    rmdir -- "$target" 2>/dev/null || true
    return 1
  fi

  # limpeza extra de qualquer resíduo do macOS
  find "$target" -name '.DS_Store' -delete 2>/dev/null || true
  find "$target" -depth -type d -name '__MACOSX' -exec rm -rf {} + 2>/dev/null || true

  # elimina aninhamento redundante
  flatten_redundant "$target"

  notify "Smart Unzip" "Extraído em: $(basename "$target")"

  # revela no Finder (somente no macOS)
  if command -v open >/dev/null 2>&1; then
    open -R "$target" >/dev/null 2>&1 || true
  fi
}

main() {
  if [ "$#" -eq 0 ]; then
    echo "Uso: $(basename "$0") arquivo1.zip [arquivo2.zip ...]" >&2
    exit 64
  fi
  local status=0
  for zip in "$@"; do
    extract_one "$zip" || status=1
  done
  exit "$status"
}

main "$@"
