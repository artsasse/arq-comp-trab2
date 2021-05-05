;---------------------------------------------------
; Programa:
; Autor:
; Data:
;---------------------------------------------------
ORG 300

N: DW 255
QTD_PASSOS: DB 0

AUX: DB 0, 0

ORG 0

LACO:
       LDA N
       AND #1
       JZ  PAR
       LDA N
       STA AUX
       LDA N+1
       STA AUX+1

       LDA N
       SHL
       STA N
       JC SHIFTRL_CARRY
       LDA N+1
       SHL
       STA N+1

       LDA N
       ADD AUX
       STA N

       LDA N+1
       ADC AUX+1
       STA N+1

       LDA N
       ADD #1
       STA N

       LDA N+1
       ADC #0
       STA N+1

       JMP CONTINUA
PAR:
    LDA N+1
    SHR
    STA N+1
    JC SHIFTR_CARRY
    LDA N
    SHR
    STA N


CONTINUA:
         LDA QTD_PASSOS
         ADD #1
         STA QTD_PASSOS

         LDA N
         SUB #1
         JNZ LACO

         HLT

SHIFTR_CARRY:
            LDA N
            SHR
            OR #128 ; Seta o ultimo bit como 1
            STA N
            JMP CONTINUA

SHIFTRL_CARRY:
             LDA N+1
             SHL
             STA N+1

             LDA N
             ADD AUX
             STA N

             LDA N+1
             ADC AUX+1
             STA N+1

             LDA N
             ADD #1
             STA N

             LDA N+1
             ADC #1 ; Seta o primeiro bit como 1 junto com o carry da soma na parte alta do N
             STA N+1

             JMP CONTINUA

