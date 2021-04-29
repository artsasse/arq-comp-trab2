;---------------------------------------------------
; Programa: Compara o valor de duas variáveis de 16 bits
; Autor: Alexandre Camillo, Arthur Sasse e Lucas Farias
; Data: 29/04/2021
;---------------------------------------------------

ORG 200

; Números a serem comparados
X: DW 270
Y: DW 50

; Variáveis da rotina
VAR1: DW 0
VAR2: DW 0

; Variável para armazenar o SP
SP: DW 0

ORG 0

MAIN:
     ; Armazena a parte baixa do endereço de X na pilha
     LDA X
     PUSH

     ; Armazena a parte alta do endereço de X na pilha
     LDA X+1
     PUSH

     ; Armazena a parte baixa do endereço de Y na pilha
     LDA Y
     PUSH

     ; Armazena a parte alta do endereço de Y na pilha
     LDA Y+1
     PUSH

     JSR ROTINA

     HLT

ROTINA:
       ; Salva o valor do SP
       STS SP

       ; Tira as duas primeiras posições da pilha
       POP
       POP

       ; Salva a parte alta de Y em VAR2
       POP
       STA VAR2+1

       ; Salva a parte baixa de Y em VAR2
       POP
       STA VAR2

       ; Salva a parte alta de X em VAR1
       POP
       STA VAR1+1

       ; Salva a parte baixa de X em VAR1
       POP
       STA VAR1

TESTES:
       OUT 3 ; Limpa o banner

       ; Testa se a parte alta de VAR1 é positiva
       LDA VAR1+1
       AND #128
       JNZ NEGATIVO ; Se der 0 VAR1 é positivo

       ; Se a parte alta for 0, utilizamos a parte baixa
       LDA VAR1
       AND #128
       JNZ NEGATIVO

       ; A partir daqui A é positivo

       LDA VAR2+1
       AND #128  ; Se não der 0, VAR2 é negativo,
       JNZ MAIOR ; ou seja, VAR1 é maior

       LDA VAR2
       AND #128
       JNZ MAIOR

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

         LDA VAR2
         AND #128
         JZ  MENOR

         ; A partir daqui A e B são negativos

         LDA VAR1+1
         SUB VAR2+1
         JN  MAIOR
         JP  MENOR

         LDA VAR1
         SUB VAR2
         JN  MAIOR
         JP  MENOR
IGUAIS:
       LDA #0
       ADD #30h ; Transforma em ASCII
       OUT 2

       ; Restaura o SP
       LDS SP
       RET
MAIOR:
      LDA #1
      ADD #30h
      OUT 2
      ; Restaura o SP
      LDS SP
      RET
MENOR:
      LDA #-1
      LDA #2Dh
      OUT 2
      LDA #31h
      OUT 2

      ; Restaura o SP
      LDS SP
      RET
END 0
