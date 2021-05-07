;---------------------------------------------------
; Programa: Conjectura de Collatz
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 30/04/2021
;---------------------------------------------------
ORG 300

N: DW 325
QTD_PASSOS: DB 0

AUX: DB 0, 0

ORG 0

LACO:
       LDA N               ; Carrega o byte menos significativo
       AND #1              ; de N e checa se é par
       JZ  PAR             ; caso seja pula para a rotina PAR

       LDA N               ; Salva o valor de N
       STA AUX             ; em uma
       LDA N+1             ; variável auxiliar
       STA AUX+1           ;

       LDA N               ; Faz o shift para a esquerda
       SHL                 ; do byte menos significativo de N
       STA N               ; para começar a multiplicar por 2

       JC SHIFTL_CARRY    ; Caso a operação anterior acione o CARRY, vai para a rotina SHIFTRL_CARRY

       LDA N+1             ; Faz o shift para a esquerda
       SHL                 ; do byte mais significativo de N
       STA N+1             ; para terminar a multiplicação por 2

       LDA N               ; Soma o byte menos significativo de N (multiplicado por 2)
       ADD AUX             ; com o byte menos significativo de AUX, que contem o primeiro valor de N
       STA N               ; completando a multiplicação por 3 no byte menos significativo

       LDA N+1             ; Soma o byte mais significativo de N (multiplicado por 2)
       ADC AUX+1           ; com o byte mais significativo de AUX, que contem o primeiro valor de N
       STA N+1             ; completando a multiplicação por 3 em N

       LDA N               ; Soma 1 a N
       ADD #1              ;
       STA N               ;

       LDA N+1             ; Caso a soma anterior ative a CARRY
       ADC #0              ; soma a CARRY ao
       STA N+1             ; byte mais significativo de N

       JMP CONTINUA


PAR:
    LDA N+1                ; Faz o shift para a direita
    SHR                    ; no byte mais significativo
    STA N+1                ; de N

    JC SHIFTR_CARRY        ; Caso a operação anterior acione o CARRY, vai para a rotina SHIFTR_CARRY

    LDA N                  ; Faz o shift para a direita
    SHR                    ; no byte menos significativo
    STA N                  ; de N


CONTINUA:
         LDA QTD_PASSOS    ; Adiciona 1 à
         ADD #1            ; quantidade de passos
         STA QTD_PASSOS    ;

         LDA N             ; Verifica se N
         SUB #1            ; chegou a 1
         JNZ LACO          ;

         HLT

SHIFTR_CARRY:
            LDA N          ; Faz o shift para a direita
            SHR            ; no byte menos significativo de N

            OR #128        ; Seta o bit mais significativo do byte como 1
            STA N          ; pela carry do shift do byte mais significativo
                           ; terminando a divisão por 2

            JMP CONTINUA

SHIFTL_CARRY:
             LDA N+1       ; Faz o shift para a esquerda
             SHL           ; do byte mais significativo de N
             STA N+1       ; para terminar a multiplicação por 2

             LDA N         ; Soma o byte menos significativo de N (multiplicado por 2)
             ADD AUX       ; com o byte menos significativo de AUX, que contem o primeiro valor de N
             STA N         ; completando a multiplicação por 3 no byte menos significativo

             LDA N+1       ; Soma o byte mais significativo de N (multiplicado por 2)
             ADC AUX+1     ; com o byte mais significativo de AUX, que contem o primeiro valor de N
             STA N+1       ; completando a multiplicação por 3 em N

             LDA N         ; Caso a soma anterior ative a CARRY
             ADD #1        ; soma a CARRY ao
             STA N         ; byte mais significativo de;

             LDA N+1       ; Caso a soma anterior ative a CARRY  soma a CARRY ao byte mais significativo de N
             ADC #1        ; Soma mais 1 devido ao shift para a esquerda do byte menos significativo
             STA N+1       ; que ativou a CARRY e desviou para essa rotina (SHIFTL_CARRY)

             JMP CONTINUA


