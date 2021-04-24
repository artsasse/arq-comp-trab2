;---------------------------------------------------
; Programa: Armazena decimal em variável de 16 bits
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 22/04/2021
;---------------------------------------------------
ORG 100h
;main - vars
valor: DS 2
;multiplica - vars
multresult: DS 2
multiplicando: DS 1
multiplicador: DS 2
retorno: DS 2

ORG 0

main:
        ; guarda valor 0x3 no multiplicando (1 byte)
        LDA #3
        PUSH
        ;LDA #3
        ;STA multiplicando

        ; guarda valor 0x100 no multiplicador (2 bytes)
        LDA #0
        PUSH  ; 0x00 na parte baixa
        LDA #1
        PUSH  ; 0x01 na parte alta

        ;LDA #0
        ;STA multiplicador
        ;LDA #1
        ;STA multiplicador+1

        ; carrega o endereço do resultado da multiplicacao
        LDA #valor   ; parte baixa
        PUSH
        LDA #valor+1 ; parte alta
        PUSH

        ; chama rotina de multiplicacao
        JSR multiplica

        LDS #31h

        HLT

multiplica:  ; (multiplicando:1B, multiplicador:2B, multresult:2B)

        ; salva o endereço de retorno para quem chamou a rotina
        POP
        STA retorno  ; parte baixa do endereco
        POP
        STA retorno+1  ; parte alta do endereco

        ; salva endereço do resultado da multiplicacao
        POP
        STA multresult+1    ; parte alta
        POP
        STA multresult      ; parte baixa

        ; zera a variavel do resultado da multiplicacao
        LDA #0
        STA @multresult
        STA @multresult+1

        ; salva valor do multiplicador
        POP
        STA multiplicador+1 ; parte alta
        POP
        STA multiplicador   ; parte baixa

        ; salva valor do multiplicando
        POP
        STA multiplicando

loop_multiplica:    ; parte que vai se repetir

        LDA @multresult     ; Pega o byte menos significativo
        ADD multiplicando  ; Soma o byte menos significativo com o multiplicando
        STA @multresult     ; Guarda o resultado

        LDA #0             ; Zera o acumulador

        ADC @multresult+1   ; Pega o byte mais significativo
        LDA #7Fh
        STA @multresult+1   ; e soma o carry (1, se a soma anterior deu overflow)

        LDA multiplicador  ;
        SUB #1             ;
        STA multiplicador  ;

        LDA multiplicador+1   ; Pega o byte mais significativo do multiplicador
        SBC #0                ; e subtrai o carry (1 se a subtracao anterior deu overflow)
        STA multiplicador+1   ;


        OR multiplicador
        OR #0
        JNZ loop_multiplica   ; se os termos da multiplicacao ainda nao zeraram,
                              ; continua a multiplicacao

        LDA retorno+1         ; joga a parte mais significativa do endereço
        PUSH                  ; de retorno na pilha

        LDA retorno           ; joga a parte menos significativa do endereço
        PUSH                  ; de retorno na pilha

        RET           ; retorna para o PC onde a rotina foi chamada

