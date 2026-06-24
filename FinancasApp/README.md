# Finanças — App de finanças e despesas (iOS)

App nativo em **SwiftUI** para organizar receitas, despesas, orçamentos mensais
e visualizar para onde vai o seu dinheiro. Os dados ficam salvos **localmente no
iPhone** usando SwiftData (nada vai para a internet).

## Recursos

- **Resumo**: saldo do mês, total de receitas e despesas, e um gráfico de pizza
  das despesas por categoria.
- **Transações**: lance receitas e despesas com valor, categoria, data e
  descrição. Toque para editar, deslize para apagar.
- **Orçamento mensal**: defina um limite de gasto por categoria e acompanhe o
  progresso com barras (fica vermelho quando você ultrapassa).
- **Categorias**: já vem com várias categorias prontas e você pode criar novas,
  escolhendo nome, cor e ícone.

## Como rodar no seu iPhone

Você precisa de um **Mac com o Xcode 16+** (gratuito na Mac App Store).

1. Copie a pasta `FinancasApp` para o Mac.
2. Abra `FinancasApp.xcodeproj` no Xcode.
3. No topo, em **Signing & Capabilities** do alvo `FinancasApp`, selecione o seu
   *Team* (basta uma conta Apple gratuita) e, se quiser, troque o
   *Bundle Identifier* (`com.weverton.financas`) por algo único seu.
4. Conecte o iPhone via cabo, selecione-o como destino no topo do Xcode.
5. Aperte ▶︎ (Run). Na primeira vez, no iPhone vá em
   **Ajustes → Geral → VPN e Gerenciamento de Dispositivos** e confie no seu
   certificado de desenvolvedor.

> Com conta Apple gratuita, o app roda no aparelho por 7 dias e depois precisa
> ser reinstalado pelo Xcode. Com a conta paga do Apple Developer Program
> (US$ 99/ano), o prazo é de 1 ano e você pode publicar na App Store.

## Requisitos

- iOS 17 ou superior (necessário para SwiftData e Swift Charts).
- Xcode 16 ou superior.

## Estrutura

```
FinancasApp/
├── FinancasApp.xcodeproj      → projeto do Xcode
└── FinancasApp/
    ├── FinancasAppApp.swift    → ponto de entrada e configuração do banco
    ├── Models/                 → Transaction, Category, Budget, TransactionType
    ├── Views/                  → telas (Resumo, Transações, Orçamento, Categorias)
    ├── Helpers/                → moeda, cores, datas, dados iniciais
    └── Assets.xcassets/        → ícone e cor de destaque
```
