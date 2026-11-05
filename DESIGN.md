---
name: Weverton Souza
description: Portfólio de editor de vídeo — imagem em tela cheia, cortes secos, nome grande.
colors:
  ground: "#0c0b0a"
  ground-raised: "#151412"
  bone: "#ece8e1"
  bone-dim: "#b9b4ab"
  ash: "#8d8880"
  hairline: "rgba(236, 232, 225, 0.14)"
  hairline-strong: "rgba(236, 232, 225, 0.32)"
typography:
  display:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "clamp(64px, 13.2vw, 196px)"
    fontWeight: 800
    lineHeight: 0.88
    letterSpacing: "-0.01em"
    fontVariation: '"wdth" 72'
  headline:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "clamp(44px, 7.4vw, 96px)"
    fontWeight: 800
    lineHeight: 0.88
    letterSpacing: "-0.01em"
    fontVariation: '"wdth" 72'
  title:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "clamp(26px, 2.6vw, 38px)"
    fontWeight: 800
    lineHeight: 0.95
    fontVariation: '"wdth" 72'
  quote:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "clamp(21px, 2vw, 28px)"
    fontWeight: 400
    lineHeight: 1.32
    letterSpacing: "-0.01em"
    fontVariation: '"wdth" 96'
  body-large:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "clamp(17px, 1.4vw, 20px)"
    fontWeight: 400
    lineHeight: 1.55
    fontVariation: '"wdth" 100'
  body:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "17px"
    fontWeight: 400
    lineHeight: 1.55
    fontVariation: '"wdth" 100'
  label:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "12px"
    fontWeight: 600
    letterSpacing: "0.14em"
    fontVariation: '"wdth" 112'
  label-button:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "14px"
    fontWeight: 700
    letterSpacing: "0.08em"
    fontVariation: '"wdth" 112'
  label-nav:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "13px"
    fontWeight: 600
    letterSpacing: "0.12em"
    fontVariation: '"wdth" 112'
rounded:
  none: "0px"
spacing:
  gallery: "6px"
  gutter: "clamp(16px, 3.4vw, 48px)"
  column-gap: "clamp(16px, 2vw, 28px)"
  row-gap: "clamp(40px, 5vw, 72px)"
  section: "clamp(96px, 13vw, 176px)"
  container: "1440px"
components:
  button-solid:
    backgroundColor: "{colors.bone}"
    textColor: "{colors.ground}"
    typography: "{typography.label-button}"
    rounded: "{rounded.none}"
    padding: "0 26px"
    height: "52px"
  button-solid-hover:
    backgroundColor: "transparent"
    textColor: "{colors.bone}"
  button-line:
    backgroundColor: "transparent"
    textColor: "{colors.bone}"
    typography: "{typography.label-button}"
    rounded: "{rounded.none}"
    padding: "0 26px"
    height: "52px"
  button-line-hover:
    backgroundColor: "rgba(236, 232, 225, 0.06)"
    textColor: "{colors.bone}"
  nav-cta:
    backgroundColor: "transparent"
    textColor: "{colors.bone}"
    typography: "{typography.label-nav}"
    rounded: "{rounded.none}"
    padding: "10px 18px"
  nav-cta-hover:
    backgroundColor: "{colors.bone}"
    textColor: "{colors.ground}"
  play-tag:
    backgroundColor: "{colors.bone}"
    textColor: "{colors.ground}"
    typography: "{typography.label}"
    rounded: "{rounded.none}"
    padding: "10px 14px 10px 12px"
---

# Design System: Weverton Souza

## Overview

**Creative North Star: "A Sala de Corte"**

O site se comporta como a tela de uma produtora de vídeo: chão preto quente, imagem real ocupando tudo, cortes secos em vez de transições, e o nome do editor composto como um crédito de abertura de filme. A interface recua para os frames aparecerem; toda a cor do site vem das imagens, nunca da UI.

A densidade é baixa e o ritmo é de trailer: blocos grandes de trabalho, muito espaço vertical entre seções, uma família tipográfica só, esticada nos dois extremos do eixo de largura do Archivo. Títulos são condensados e pesados; créditos e rótulos são largos e espaçados, em caixa alta, como letreiro de ficha técnica. Tudo é reto: sem cantos arredondados, sem sombra, sem vidro. A estrutura é feita de hairlines de 1px.

Rejeições confirmadas pelo dono e pelo contrato de direção: o "kit de site de IA" (Bebas com itálico serifado, rótulos "// mono", números em degradê, cursor custom, marquee, brilho, ruído, glassmorphism) e qualquer acento colorido de marca.

**Key Characteristics:**
- Preto quente + osso, sem acento; a cor é dos frames.
- Archivo variável usado em dois extremos de largura (wdth 72 nos títulos, wdth 112 nos créditos).
- Cantos retos (0px) e hairlines de 1px como única estrutura.
- Plano: nenhuma sombra; profundidade só por imagem e scrim.
- Movimento por corte seco; reveals curtos uma vez; tudo respeita prefers-reduced-motion.

## Colors

Uma paleta de sala escura: dois pretos quentes, três tons de osso e duas hairlines translúcidas. Nenhum matiz próprio.

### Neutral
- **Preto de Sala** (ground): fundo de toda a página, do drawer e da área atrás do hero. É quente (leve tom marrom), nunca #000 puro na UI.
- **Preto de Moldura** (ground-raised): placeholder atrás de imagens enquanto carregam (cards de trabalho, stills, galeria de cor). Não é uma superfície de card; só aparece por trás de mídia.
- **Osso** (bone): texto principal, títulos, borda e preenchimento do botão sólido, outline de foco, seleção de texto (invertida).
- **Osso Apagado** (bone-dim): texto de apoio — descrições de trabalho, parágrafos do Sobre, links do nav e do rodapé em repouso.
- **Cinza de Película** (ash): créditos/rótulos em caixa alta, coluna direita da lista de serviços, texto do rodapé. Passa 4,5:1 sobre o fundo; não descer abaixo disso.
- **Hairline** (hairline): divisórias de seção, linhas da lista de serviços, topo das legendas de depoimento, borda do nav rolado, rodapé.
- **Hairline Forte** (hairline-strong): borda do botão de linha, linha acima da apresentação no hero, sublinhado de links em repouso.

### Named Rules
**The Cor-Vem-do-Frame Rule.** A UI não tem acento. Nenhum elemento de interface ganha matiz; se algo precisa chamar atenção, inverte para osso sobre preto. A cor é exclusiva das imagens e vídeos.

**The Inversão Rule.** O único estado "forte" do sistema é a inversão osso/preto (botão sólido, CTA do nav no hover, tag de play, seleção de texto). Não criar um segundo estado de ênfase.

## Typography

**Display Font:** Archivo variável (wdth 62–125, wght 300–900), com Helvetica Neue, Arial
**Body Font:** Archivo (mesma família, wdth 100)
**Label/Mono Font:** Archivo (wdth 112); não há mono

**Character:** Uma família só, tensionada pelo eixo de largura: títulos condensados, pesados e apertados como cartaz de filme; créditos largos e espaçados como ficha técnica; corpo neutro no meio. O contraste vem da largura, não de uma segunda fonte.

### Hierarchy
- **Display** (800, wdth 72, clamp 64–196px, lh 0.88, caixa alta): só o nome no hero e a chamada final de contato (que usa clamp 56–168px). Quebra em linhas curtas.
- **Headline** (800, wdth 72, clamp 44–96px, lh 0.88, caixa alta): títulos de seção ("Trabalhos", "Color grading"). O Sobre usa a mesma voz em clamp 44–92px.
- **Title** (800, wdth 72, clamp 26–38px, lh 0.95, caixa alta): nome de cada trabalho; os títulos da galeria de cor usam a mesma voz um passo abaixo (clamp 24–34px, lh 1).
- **Quote** (400, wdth 96, clamp 21–28px, lh 1.32, -0.01em): depoimentos. Ligeiramente condensado, em caixa normal, `text-wrap: pretty`.
- **Body Large** (400, clamp 17–20px, lh 1.55): apresentação do hero (até 46ch), parágrafos do Sobre (até 58ch), texto do contato (até 40ch).
- **Body** (400, 17px, 16px no celular, lh 1.55): texto corrido e descrições (até 60ch).
- **Label** (600, wdth 112, 12px, 0.14em, caixa alta, cinza): créditos de metadado ao lado do que descrevem — tipo do trabalho, cargo do autor do depoimento, legenda e contador do hero, contador do lightbox.
- **Label Button / Nav** (700 / 600, wdth 112, 14px / 13px, 0.08em / 0.12em, caixa alta): botões, links do nav, marca "WS".

### Named Rules
**The Dois-Extremos Rule.** Títulos sempre em wdth 72 peso 800 caixa alta; rótulos sempre em wdth 112 caixa alta espaçada. Nunca usar o meio-termo para nenhum dos dois, e nunca introduzir uma segunda família.

**The Crédito-ao-Lado Rule.** O rótulo em caixa alta é um crédito de metadado: fica ao lado ou abaixo do que identifica (tipo do trabalho à direita do título, cargo na legenda do depoimento). Não é sobretítulo acima de heading.

## Layout

Container de até 1440px com gutter fluido (clamp 16–48px). Seções separadas por muito ar vertical (clamp 96–176px no topo; contato clamp 112–200px), cada uma aberta por um cabeçalho com título à esquerda, texto curto de apoio à direita (até 40ch) e uma hairline embaixo.

- **Hero:** 100svh (mínimo 560px), imagem em tela cheia; tudo ancorado no rodapé da tela — nome à esquerda, legenda do frame à direita, e abaixo de uma hairline forte a apresentação e os dois botões.
- **Trabalhos:** grade de 12 colunas; trabalhos horizontais ocupam 6 colunas na primeira fileira, verticais 4 na fileira seguinte. Gap vertical grande (clamp 40–72px), horizontal clamp 16–28px.
- **Galerias de mídia:** gap de 6px fixo (stills e color grading), como uma folha de contato. Concert: 3 colunas com o primeiro frame em 2×2; Fashion: 5 colunas em 9:16, com o vídeo da campanha como primeiro tile (até 960px, 4 colunas com o vídeo em 2×2; até 600px, 2 colunas com o vídeo na largura toda).
- **Sobre:** foto em 4 colunas, texto da coluna 6 à 12.
- **Breakpoints:** 960px (nav vira drawer, tudo vai para coluna única, depoimentos empilham) e 600px (corpo 16px, botões ocupam a largura, tag de play sempre visível, legenda do hero simplificada, nome grande do hero oculto para não cobrir as imagens; o nome fica no nav).

## Elevation & Depth

Totalmente plano. Não existe `box-shadow`, `text-shadow` nem blur em lugar nenhum. Profundidade vem só de imagem e de scrim: o hero escurece de baixo para cima (preto de sala de 92% até transparente em 62% da altura) e um pouco no topo para o nav; o lightbox cobre tudo com preto a 96%; o nav rolado ganha fundo preto a 94% e uma hairline.

### Named Rules
**The Sem-Sombra Rule.** Nenhum elemento flutua. Separação é hairline de 1px ou mudança de fundo; leitura sobre imagem é scrim em gradiente do próprio preto de sala, nunca sombra no texto.

## Shapes

Cantos retos em tudo (0px): botões, imagens, tags, lightbox. Nenhuma pílula, nenhum círculo. A estrutura é linear: hairlines de 1px separam seções, linhas de lista e legendas; botões são retângulos de borda 1px. As únicas geometrias recorrentes são as proporções de cinema da mídia (16:9, 9:16, 4:5 no celular).

## Components

### Buttons
Retangulares, firmes, em caixa alta larga — como um letreiro de ficha técnica.
- **Shape:** cantos retos (0px), borda de 1px, altura mínima 52px (60px na seção de contato, com 15px de texto), ícone opcional de 18px à esquerda com gap de 12px.
- **Sólido:** osso com texto preto; é a ação de WhatsApp. No hover inverte para transparente com texto osso (a borda osso fica).
- **Linha:** transparente, borda hairline forte; no hover a borda vira osso e o fundo ganha um véu de osso a 6%.
- **Transição:** cor de fundo e texto em 250ms com a curva expo-out do sistema.
- **Focus:** outline osso de 2px com 3px de offset (global).

### Navigation
- **Style:** barra fixa de 68px, transparente sobre o hero; ao rolar ganha fundo preto a 94% e hairline embaixo.
- **Links:** label-nav em osso apagado, hover para osso. Marca "WS"/nome em 800, wdth 112, 0.12em.
- **CTA "Orçamento":** retângulo de borda osso (10px 18px), inverte para osso sólido no hover.
- **Mobile (≤960px):** links somem; fica o CTA e um botão de três traços de 1,5px que vira X. O drawer cobre a tela abaixo do nav, com links em voz Display a 40px separados por hairlines e o botão sólido de WhatsApp no fim.

### Work Card (assinatura)
- **Mídia:** sem moldura, fundo preto de moldura enquanto carrega, 16:9 (ou 0.865 nos verticais).
- **Hover:** a imagem principal aproxima 3% em 1,2s; cards com stills tocam um corte seco de frames a cada 520ms; a tag de play (osso sólido, label, ícone de 12px) sobe 6px e aparece no canto inferior esquerdo. No celular a tag fica sempre visível.
- **Info:** título em voz Title à esquerda, crédito do tipo à direita, descrição em osso apagado abaixo.

### Hero Cut (assinatura)
Frames reais em tela cheia trocando por corte seco (opacidade 0→1 sem transição) a cada 1,5s, pausando fora da tela, com aba oculta e com reduced-motion. A legenda à direita (contador tabular "01 / 09", tipo e nome do projeto) troca no mesmo instante que o frame.

### Lightbox
Fundo preto a 96%, palco 16:9 até 1280px (9:16 para verticais, livre para fotos). Fechar e navegar são botões de texto/ícone em osso apagado sem fundo, hover para osso.

## Do's and Don'ts

### Do:
- **Do** deixar a cor vir só das imagens; UI em preto de sala, osso e cinza.
- **Do** usar Archivo nos dois extremos: wdth 72 peso 800 caixa alta para títulos, wdth 112 caixa alta espaçada para créditos e botões.
- **Do** manter cantos retos (0px) e separar tudo com hairlines de 1px.
- **Do** trocar imagens por corte seco; reveals de conteúdo são opacidade + 8px em 400ms, uma vez, desligados com prefers-reduced-motion.
- **Do** usar scrim do próprio preto de sala para legibilidade sobre imagem.
- **Do** colocar o crédito em caixa alta ao lado do que ele identifica.

### Don't:
- **Don't** usar o kit de site de IA: Bebas com itálico serifado, rótulos "// mono", números em degradê, cursor custom, marquee, brilho, ruído ou glass.
- **Don't** introduzir acento colorido, segunda família tipográfica ou fonte mono.
- **Don't** arredondar cantos nem usar pílulas.
- **Don't** usar sombra, text-shadow ou blur.
- **Don't** usar crossfade entre frames; o corte é seco.
- **Don't** colocar rótulo em caixa alta como sobretítulo acima de heading.
