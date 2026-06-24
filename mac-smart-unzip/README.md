# Smart Unzip — fim do "Mac espalha o zip em várias pastas"

Quando você abre um `.zip` no Mac, é comum o conteúdo ser **espalhado**: arquivos
soltos no diretório atual, pastas-lixo do macOS (`__MACOSX`, `.DS_Store`) e até
aninhamento redundante (`pasta/pasta/conteúdo`). Esta ferramenta resolve isso.

Você clica com o **botão direito** num zip no Finder e escolhe
**Smart Unzip (pasta única)**. O conteúdo é extraído sempre:

- ✅ Dentro de **uma pasta única**, com o nome do próprio zip — nada solto.
- ✅ Sem o **lixo do macOS** (`__MACOSX`, `.DS_Store`).
- ✅ Sem **aninhamento redundante**: se tudo está dentro de um único subdiretório,
  ele é "achatado" automaticamente.
- ✅ Sem **sobrescrever**: se a pasta já existe, cria `nome 2`, `nome 3`, ...
- ✅ Abre o resultado já **selecionado no Finder**.

## Instalação

```bash
cd mac-smart-unzip
chmod +x install.sh
./install.sh
```

O instalador coloca o motor em `~/.local/bin/smart-unzip` e a Quick Action em
`~/Library/Services`.

## Como usar

1. No Finder, clique com o botão direito em um `.zip`.
2. **Início rápido** (ou **Serviços**) → **Smart Unzip (pasta única)**.

Dá pra selecionar vários zips de uma vez. Também funciona pelo terminal:

```bash
~/.local/bin/smart-unzip arquivo.zip outro.zip
```

## Desinstalar

```bash
./uninstall.sh
```

## Como funciona

| Arquivo | Papel |
|---|---|
| `smart-unzip.sh` | O motor. Toda a lógica de extração organizada vive aqui. |
| `build-quick-action.py` | Gera o bundle `SmartUnzip.workflow` (Quick Action do Automator). |
| `SmartUnzip.workflow/` | A Quick Action que aparece no botão direito do Finder. Só chama o motor. |
| `install.sh` / `uninstall.sh` | Instala/remove o motor e a Quick Action. |

A Quick Action é só um "atalho" que repassa os arquivos selecionados para o
motor (`~/.local/bin/smart-unzip`). Assim, para atualizar o comportamento basta
editar `smart-unzip.sh` e rodar `./install.sh` de novo.

## Recriar a Quick Action na mão (plano B)

Se em alguma versão do macOS a Quick Action pronta não aparecer, dá para recriá-la
em 1 minuto:

1. Abra o **Automator** → **Novo** → **Ação rápida** (Quick Action).
2. "O fluxo recebe" **arquivos ou pastas** no **Finder**.
3. Arraste a ação **Executar Shell Script**.
4. Em "Passar entrada", escolha **como argumentos**.
5. Cole:
   ```bash
   "$HOME/.local/bin/smart-unzip" "$@"
   ```
6. Salve como **Smart Unzip (pasta única)**.
