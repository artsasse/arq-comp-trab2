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

multresult: DS 2
multiplicando: DS 1
multiplicador: DS 2
multcounter: DS 2

ult_end: DS 2


char: DS 1
ORG 0

LDS #200h

main:
        LDA #3
        STA multiplicando

        LDA #0
        STA multiplicador
        LDA #1
        STA multiplicador+1

        LDA #0
        STA multresult
        STA multresult+1

        JSR multiplica

        LDS #31h

        HLT

multiplica:
        LDA multresult     ; Pega o byte menos significativo
        ADD multiplicando  ; Soma o byte menos significativo com o multiplicando
        STA multresult     ; Guarda o resultado

        LDA #0             ; Zera o acumulador

        ADC multresult+1   ; Pega o byte mais significativo
        STA multresult+1   ; e soma o carry (1 caso a soma anterior dê overflow)

        LDA multiplicador  ;
        SUB #1             ;
        STA multiplicador  ;

        LDA multiplicador+1   ; Pega o byte mais significativo do multiplicador

        SBC #0                ; e subtrai o carry (1 caso a soma anterior dê overflow)
        STA multiplicador+1   ;


        OR multiplicador
        OR #0
        JZ retorna      ; se terminou de multiplicar retorna


        JMP multiplica

retorna:
        RET           ; retorna para o PC onde a rotina foi chamada

