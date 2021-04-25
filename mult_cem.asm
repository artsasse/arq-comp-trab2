;---------------------------------------------------
; Programa: Multiplica algarismo por 100
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 24/04/2021
;---------------------------------------------------

ORG 800h

;main - vars
valor: DS 2
ptr_valor: DW valor

;multiplica - vars
multresult: DS 2    ; variavel local para os resultados parciais
result_ender: DS 2  ; variavel com o endereço que vai receber o resultado final
multiplicando: DS 2
multiplicador: DS 2
retorno: DS 2
old_sp: DS 2

ORG 0

main:
        ; guarda valor 0x9 no multiplicador (1 byte)
        LDA #9
        PUSH

        ; carrega o endereço do resultado da multiplicacao
        LDA ptr_valor   ; parte baixa
        PUSH
        LDA ptr_valor+1 ; parte alta
        PUSH

        ; chama rotina de multiplicacao
        JSR multiplica

        ; para o programa
        HLT

multiplica:     ; (multiplicador:1B, result_ender:2B)

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
        STA multiplicador

        ; zera a variavel de resultado parcial
        STS old_sp   ; salva endereço original que estava no SP
        LDS #0       ; zera o SP
        STS multresult ; zera o conteudo de "valor"
        LDS old_sp   ; restaura o valor original de SP

loop_multiplica:  ; parte que vai se repetir

        LDA multresult      ; Pega o byte menos significativo
        ADD #64h            ; Soma com o multiplicando (100)
        STA multresult      ; Guarda o resultado

        LDA #0              ; carrega zero no acumulador
        ADC multresult+1    ; soma com parte alta do resultado parcial
                            ; e soma o carry (1 caso a soma anterior dê overflow)
        STA multresult+1    ; Guarda o resultado

        LDA multiplicador   ; multiplicador funciona como um contador
        SUB #1              ; de somas sucessivas
        STA multiplicador   ;

        OR #0                 ; verifica se o multiplicador esta zerado
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

