;---------------------------------------------------
; Programa: Compara o valor de duas variáveis de 16 bits
; Autor: Alexandre Camillo, Arthur Sasse e Lucas Farias
; Data: 29/04/2021
;---------------------------------------------------

; A idéia geral do programa é ir verificando o sinal das variáveis.
; Então se as duas forem positivas, faz uma subtração para saber
; e vê se a primeira é maior, menor ou igual. O mesmo ocorre se forem
; ambas negativas. Se tiverem sinais opostos, já retorna o resultado.
; É retornado o no acumulador se as duas variáveis forem iguai, se a
; primeira for maior, retorna 1 e se for menor retorna -1. O valor
; retornado é apresentado no banner.

ORG 200

; Números a serem comparados
X: DW 49000
Y: DW 546

; Ponteiro para armazenar o endereço dos números
PTR: DW X

; Variáveis da rotina
VAR1: DW 0
VAR2: DW 0

; Ponteiro auxiliar
PTR_AUX: DS 1

; Variáveis para armazenar o SP
ROTINA_RET1: DS 1
ROTINA_RET2: DS 1

ORG 0

MAIN:
     ; Armazena a parte baixa do endereço de X na pilha
     LDA PTR
     PUSH

     ; Armazena a parte alta do endereço de X na pilha
     ADD #1
     PUSH

     ; Armazena a parte baixa do endereço de Y na pilha
     ADD #1
     PUSH

     ; Armazena a parte alta do endereço de Y na pilha
     ADD #1
     PUSH

     JSR ROTINA

     ; Verifica se o acumulador retornou -1
     JN  MENOS_UM

     ; Para retorno de 0 ou 1, basta transformar em ASCII e printar
     ADD #30h
     OUT 2

     HLT

MENOS_UM:
         ; Para retorno de -1, primeiro printamos o "-" e depois o 1
         LDA #2Dh
         OUT 2
         LDA #31h
         OUT 2

         HLT
ROTINA:
       ; Salva o valor de retorno da rotina
       POP
       STA ROTINA_RET2

       POP
       STA ROTINA_RET1

       ; Salva a parte alta de Y em VAR2
       POP
       STA PTR_AUX
       LDA @PTR_AUX
       STA VAR2+1

       ; Salva a parte baixa de Y em VAR2
       POP
       STA PTR_AUX
       LDA @PTR_AUX
       STA VAR2

       ; Salva a parte alta de X em VAR1
       POP
       STA PTR_AUX
       LDA @PTR_AUX
       STA VAR1+1

       ; Salva a parte baixa de X em VAR1
       POP
       STA PTR_AUX
       LDA @PTR_AUX
       STA VAR1

       ; Coloca os endereços de retorno para serem utilizados no final
       LDA ROTINA_RET1
       PUSH

       LDA ROTINA_RET2
       PUSH

TESTES:
       OUT 3 ; Limpa o banner

       ; Testa se a parte alta de VAR1 é positiva
       LDA VAR1+1
       AND #128
       JNZ NEGATIVO ; Se der 0, VAR1 é positivo

       ; A partir daqui A é positivo

       LDA VAR2+1
       AND #128  ; Se não der 0, VAR2 é negativo,
       JNZ MAIOR ; ou seja, VAR1 é maior

       ; A partir daqui VAR1 e VAR2 são positivos

       LDA VAR1+1
       SUB VAR2+1; Subtrai VAR2 de VAR1 para observar o resultado
       JN  MENOR ; Se a subtração der negativo, VAR1 é menor
       JP  MAIOR ; Se der positivo, VAR1 é maior

       ; Se der 0 temos que testar a parte baixa

       LDA VAR1
       SUB VAR2
       JN  MENOR ; Mesma lógica do código anterior
       JP  MAIOR

       ; Se passou nos testes acima, os dois são iguais

       JMP IGUAIS

; Caso onde VAR1 é negativo
NEGATIVO:
         LDA VAR2+1
         AND #128  ; Se der 0, VAR2 é positivo,
         JZ  MENOR ; então VAR1 é menor

         ; A partir daqui VAR1 e VAR2 são negativos

         LDA VAR1+1
         SUB VAR2+1
         JN  MENOR
         JP  MAIOR

         LDA VAR1
         SUB VAR2
         JN  MENOR
         JP  MAIOR
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
