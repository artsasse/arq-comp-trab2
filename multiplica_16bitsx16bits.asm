;---------------------------------------------------
; Programa: Armazena decimal em variável de 16 bits
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 22/04/2021
;---------------------------------------------------
ORG 100h

multresult: DS 2
multiplicando: DS 2
multiplicador: DS 2
multcounter: DS 2

ORG 0

LDS #200h

main:
        LDA #0
        STA multiplicando
        LDA #1
        STA multiplicando + 1

        LDA #3
        STA multiplicador
        LDA #0
        STA multiplicador+1

        LDA #0
        STA multresult
        STA multresult+1

        JSR multiplica

        LDA #31h

        HLT

multiplica:


        LDA multresult      ; Pega o byte menos significativo
        ADD multiplicando   ; Soma o byte menos significativo com o multiplicando
        STA multresult      ; Guarda o resultado

        LDA multiplicando+1 ; Zera o acumulador

        ADC multresult+1    ; Pega o byte mais significativo
        STA multresult+1    ; e soma o carry (1 caso a soma anterior dê overflow)

        LDA multiplicador   ;
        SUB #1              ;
        STA multiplicador   ;

        LDA multiplicador+1   ; Pega o byte mais significativo do multiplicador

        SBC #0                ; e subtrai o carry (1 caso a soma anterior dê overflow)
        STA multiplicador+1   ;


        OR multiplicador
        OR #0
        JZ retorna      ; se terminou de multiplicar retorna


        JMP multiplica

retorna:
        RET           ; retorna para o PC onde a rotina foi chamada

