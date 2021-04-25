;---------------------------------------------------
; Programa: Multiplica numero de 16 bits por numero de 16 bits (usando pilha)
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 24/04/2021
;---------------------------------------------------

ORG 100h

;main - vars
valor: DS 2

;multiplica - vars
multresult: DS 2    ; variavel local para os resultados parciais
result_ender: DS 2  ; variavel com o endereço que vai receber o resultado final
multiplicando: DS 2
multiplicador: DS 2
retorno: DS 2
old_sp: DS 2

ORG 0

main:
        ; guarda valor 0x100 no multiplicando (2 bytes)
        LDA #2
        PUSH  ; 0x02 na parte baixa
        LDA #1
        PUSH  ; 0x01 na parte alta

        ; guarda valor 0x3 no multiplicador (2 bytes)
        LDA #3
        PUSH  ; 0x03 na parte baixa
        LDA #0
        PUSH  ; 0x00 na parte alta

        ; carrega o endereço do resultado da multiplicacao
        LDA #valor   ; parte baixa
        PUSH
        LDA #valor+1 ; parte alta
        PUSH

        ; chama rotina de multiplicacao
        JSR multiplica

        ; para o programa
        HLT

multiplica:     ; (multiplicando:1B, multiplicador:2B, result_ender:2B)

        ; salva o endereço de retorno para quem chamou a rotina
        POP
        STA retorno  ; parte baixa do endereco
        POP
        STA retorno+1  ; parte alta do endereco

        ; salva endereço do resultado final da multiplicacao
        POP
        STA result_ender+1    ; parte alta
        POP
        STA result_ender      ; parte baixa

        ; salva valor do multiplicador
        POP
        STA multiplicador+1 ; parte alta
        POP
        STA multiplicador   ; parte baixa

        ; salva valor do multiplicando
        POP
        STA multiplicando+1 ; parte alta
        POP
        STA multiplicando   ; parte baixa

        ; zera a variavel de resultado parcial
        STS old_sp   ; salva endereço original que estava no SP
        LDS #0       ; zera o SP
        STS multresult ; zera o conteudo de "valor"
        LDS old_sp   ; restaura o valor original de SP

loop_multiplica:  ; parte que vai se repetir

        LDA multresult      ; Pega o byte menos significativo
        ADD multiplicando   ; Soma o byte menos significativo com o multiplicando
        STA multresult      ; Guarda o resultado

        LDA multiplicando+1 ; carrega parte alta do multiplicando no acumulador

        ADC multresult+1    ; soma com parte alta do resultado parcial
                            ; e soma o carry (1 caso a soma anterior dê overflow)
        STA multresult+1    ; Guarda o resultado

        LDA multiplicador   ; multiplicador funciona como um contador
        SUB #1              ; de somas sucessivas
        STA multiplicador   ;

        LDA multiplicador+1   ; Pega o byte mais significativo do multiplicador
        SBC #0                ; e subtrai o carry (1 caso a soma anterior dê overflow)
        STA multiplicador+1   ;

        OR multiplicador      ; verifica se o multiplicador
        OR #0                 ; esta zerado
        JNZ loop_multiplica   ; se os termos da multiplicacao ainda nao zeraram,
                              ; continua a multiplicacao

        ; salva o resultado final
        STS old_sp
        LDS multresult
        STS @result_ender
        LDS old_sp

        ; restaura endereço de retorno na pilha
        LDA retorno+1         ; joga a parte mais significativa do endereço
        PUSH                  ; de retorno na pilha

        LDA retorno           ; joga a parte menos significativa do endereço
        PUSH                  ; de retorno na pilha

        RET           ; retorna para o PC onde a rotina foi chamada

