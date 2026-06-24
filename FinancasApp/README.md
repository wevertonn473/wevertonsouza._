# Finanças — App de finanças e despesas (iOS)

App nativo em **SwiftUI** para organizar receitas, despesas, orçamentos mensais
e visualizar para onde vai o seu dinheiro. Os dados ficam salvos **localmente no
iPhone** usando SwiftData (nada vai para a internet).

## Recursos

- **Resumo**: saldo do mês, total de receitas e despesas, e um gráfico de pizza
  das despesas por categoria.
- **Transações**: lance receitas e despesas com valor, categoria, data e
  descrição. Toque para editar, deslize para apagar. Tem **busca** (por
  descrição ou categoria) e **filtros** (por tipo e por categoria), com total
  do resultado filtrado.
- **Orçamento mensal**: defina um limite de gasto por categoria e acompanhe o
  progresso com barras (fica vermelho quando você ultrapassa).
- **Metas de economia**: crie metas (viagem, reserva, etc.) com valor-alvo,
  prazo opcional e sugestão de quanto guardar por mês. Adicione aportes e veja
  o progresso.
- **Transações recorrentes** (em *Mais → Recorrentes*): lançamentos automáticos
  para parcelas de financiamento, salário ou assinaturas. Suporta **número fixo
  de parcelas** (ex.: 48x do financiamento do carro), mostrando "parcela X/Y" e
  quantas faltam. O app gera as parcelas vencidas automaticamente ao abrir.
- **Categorias** (em *Mais → Categorias*): já vem com várias categorias prontas
  e você pode criar novas, escolhendo nome, cor e ícone.

## Organização das telas

5 abas: **Resumo · Transações · Orçamento · Metas · Mais**. A aba *Mais* reúne
as ferramentas de gerência (Recorrentes e Categorias).

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
    ├── FinancasAppApp.swift    → ponto de entrada, banco e geração de recorrentes
    ├── Models/                 → Transaction, Category, Budget, RecurringRule, Goal
    ├── Views/                  → telas (Resumo, Transações, Orçamento, Metas, Mais…)
    ├── Helpers/                → moeda, cores, datas, dados iniciais, motor de recorrência
    └── Assets.xcassets/        → ícone do app e cor de destaque
```
