;----------------------------------------------------------------------------------------
; Programa: Encontra o maior e menor valor de um vetor com variáveis de 16 bits com sinal
; Autor: Alexandre Camillo, Arthur Sasse e Lucas Farias
; Data: 04/05/2021
;----------------------------------------------------------------------------------------

; Foi reaproveitado o código da questão anterior para comparar duas variáveis de 16 bits.
; O programa percorre o vetor enquanto o número de iterações não alcançou o tamanho dele
; e pra cada elemento do vetor ele chama a subrotina COMPARA e verifica se esse elemento é
; maior, menor ou igual ao maior valor até o momento. Se for maior, o elemento é o novo maior
; e se não for, faz o mesmo procedimento para o menor valor. Ao final, retorna os valores
; encontrados na pilha e armazena nas variáveis correspondentes.

ORG 200H

; Variáveis do programa principal

; Vetor e endereço inicial
VETOR: DW -8131, 8742, -2776, -22921, -25767, -19187, -4006, -29665, -17011, 14587, -27918, -15392, -21223, -4255, 3091, 5098, -10222, -4561, 4270, 1260
VET_INI: DW VETOR

MAIOR_VALOR: DW 0
MENOR_VALOR: DW 0

; Variáveis da rotina para encontrar o maior e menor valor do vetor

; Ponteiro para armazenar o valor atual do vetor
PTR: DW 0
;Tamanho do vetor
TAM: DS 1
; Maior valor do vetor
MAX: DW 0
; Menor valor do vetor
MIN: DW 0
; Variável para armazenar a quantidade de iterações
I: DB 1
; Variáveis para armazenar o SP
ROTINA_RET1: DS 1
ROTINA_RET2: DS 1

; Variáveis da rotina para comparar duas váriáveis

VAR1: DW 0
VAR2: DW 0

; Ponteiro auxiliar
PTR_AUX: DW 0

RET_COMPARA1: DS 1
RET_COMPARA2: DS 1

ORG 0

MAIN:
     ; Coloca o endereço inicial do vetor na pilha
     LDA VET_INI
     PUSH
     LDA VET_INI+1
     PUSH

     ; Coloca o tamanho do vetor no acumulador e chama a rotina
     LDA #20
     JSR INICIO

     ; Pega o menor valor retornado na pilha e salva
     POP
     STA MENOR_VALOR+1
     POP
     STA MENOR_VALOR

     ; Pega o maior valor retornado na pilha e salva
     POP
     STA MAIOR_VALOR+1
     POP
     STA MAIOR_VALOR

     HLT

INICIO:
       ; Salva o tamanho do vetor
       STA TAM

       ; Salva o valor de retorno da rotina
       POP
       STA ROTINA_RET2
       POP
       STA ROTINA_RET1

       ; Salva o endereço inicial no ponteiro
       POP
       STA PTR+1
       POP
       STA PTR

       ; Adiciona o primeiro valor do vetor como máximo e mínimo
       LDA @PTR
       STA MAX
       STA MIN

       LDA PTR
       ADD #1
       STA PTR

       LDA @PTR
       STA MAX+1
       STA MIN+1

LACO:
     ; Avança com o ponteiro pro próximo elemento do vetor
     LDA PTR
     ADD #1
     STA PTR

     ; Coloca o endereço desse elemento na pilha
     LDA PTR
     PUSH
     LDA PTR+1
     PUSH

     ; Coloca o maior até aqui na pilha
     LDA MAX
     PUSH
     LDA MAX+1
     PUSH

     ; Pula para a rotina de comparação
     JSR COMPARA

     ; Se retornou 1 no acumulador, o valor atual é o novo maior
     JP TROCA_MAX

     ; Se retornou 0 ou -1, continua com a comparação para o mínimo
     LDA PTR
     PUSH
     LDA PTR+1
     PUSH

     LDA MIN
     PUSH
     LDA MIN+1
     PUSH

     JSR COMPARA

     ; Se retornou -1, o valor atual é o novo menor
     JN  TROCA_MIN

     ; Se retornou 0 ou 1, apenas anda com o ponteiro
     LDA PTR
     ADD #1
     STA PTR

     JMP CONTINUA

TROCA_MAX:
          ; Troca o maior pelo elemento atual
          LDA @PTR
          STA MAX

          LDA PTR
          ADD #1
          STA PTR

          LDA @PTR
          STA MAX+1

          JMP CONTINUA

TROCA_MIN:
          ; Troca o menor pelo elemento atual
          LDA @PTR
          STA MIN

          LDA PTR
          ADD #1
          STA PTR

          LDA @PTR
          STA MIN+1

          JMP CONTINUA

CONTINUA:
         ; Incrementa o número de iterações
         LDA I
         ADD #1
         STA I

         ; Verifica se acabou
         SUB TAM
         JNZ LACO

         ; Se acabou, coloca os resultados na pilha
         LDA MAX
         PUSH
         LDA MAX+1
         PUSH

         LDA MIN
         PUSH
         LDA MIN+1
         PUSH

         ; Coloca os endereços de retorno para serem utilizados no final
         LDA ROTINA_RET1
         PUSH
         LDA ROTINA_RET2
         PUSH

         RET

COMPARA:
        ; Salva o valor de retorno da rotina
        POP
        STA RET_COMPARA2
        POP
        STA RET_COMPARA1

        ; Salva o maior em VAR2
        POP
        STA VAR2+1
        POP
        STA VAR2

        ; Utiliza o ponteiro auxiliar para salvar o elemento
        ; atual em VAR1
        POP
        STA PTR_AUX+1
        POP
        STA PTR_AUX

        LDA @PTR_AUX
        STA VAR1

        LDA PTR_AUX
        ADD #1
        STA PTR_AUX

        LDA @PTR_AUX
        STA VAR1+1

        ; Coloca os endereços de retorno para serem utilizados no final
        LDA RET_COMPARA1
        PUSH
        LDA RET_COMPARA2
        PUSH

TESTES:
       ; Testa se a parte alta de VAR1 é positiva
       LDA VAR1+1
       AND #128
       JNZ NEGATIVO ; Se der 0, VAR1 é positivo

       ; A partir daqui VAR1 é positivo

       LDA VAR2+1
       AND #128  ; Se não der 0, VAR2 é negativo,
       JNZ MAIOR ; ou seja, VAR1 é maior

SUBTRACAO:
          LDA VAR1+1
          SUB VAR2+1; Subtrai VAR2 de VAR1 para observar o resultado
          JN  MENOR ; Se a subtração der negativo, VAR1 é menor
          JP  MAIOR ; Se der positivo, VAR1 é maior

          ; Se der 0 temos que testar a parte baixa

          LDA VAR1
          SUB VAR2
          JZ  IGUAIS; Se a subtração deu zero, as duas são iguais
          JC  MENOR ; Se deu carry, VAR1 é menor

          ; Se passou nos testes acima, VAR1 é maior

          JMP MAIOR

; Caso onde VAR1 é negativo
NEGATIVO:
         LDA VAR2+1
         AND #128  ; Se der 0, VAR2 é positivo,
         JZ  MENOR ; então VAR1 é menor

         ; Volta para a parte de subtração
         JMP SUBTRACAO
IGUAIS:
       ; Coloca resultado no acumulador
       LDA #0
       RET
MAIOR:
      ; Coloca resultado no acumulador
      LDA #1
      RET
MENOR:
      ; Coloca resultado no acumulador
      LDA #-1
      RET
END 0
