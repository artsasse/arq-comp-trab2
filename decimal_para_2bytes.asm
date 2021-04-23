;---------------------------------------------------
; Programa: Armazena decimal em variável de 16 bits
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 22/04/2021
;---------------------------------------------------
ORG 100h
nums: DS 5
nums_qtd: DB 0
count: DB 5

decimal: DS 2

aux: DS 2

multresult: DB 0
multiplicando: DB 0
multiplicador: DB 0
multcounter: DB 0

ult_end: DS 2


char: DS 1
ORG 0

LDS #200h

leitura:
        LDA #1      ;
        TRAP 0      ; Lê o numero digitado no console
        OR #0       ; caso nada seja inserido
        JZ tratador ; muda para a prox etapa

        SUB #30h
        PUSH

        LDA count   ; Subtrai de count
        SUB 1       ; e pula para a próxima etapa caso
        STA count
        JZ tratador ; tenha lido 5 chars

        JMP leitura

multiplica:
        LDA multresult
        ADD multiplicando
        STA multresult
        LDA multiplicador
        SUB #1

        JZ retorna ; se terminou de multiplicar retorna

        JMP multiplica

retorna:
        RET ; retorna para o PC onde a rotina foi chamada

tratador:
         LDA #5       ;
         SUB count    ; Pega a qtd de nums inseridos
         STA nums_qtd ; e guarda em nums_qtd

         STA multiplicador
         POP
         STA multiplicando
         JSR multiplica

;PUSH
;LDA #5
;PUSH

;LDA #9

;POP
;POP

;LDA #6
;PUSH
