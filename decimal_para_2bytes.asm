;---------------------------------------------------
; Programa: Armazena decimal em variável de 16 bits
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 26/04/2021
;---------------------------------------------------

ORG 100h
nums: DS 5
count: DB 5

; Inicializando potencias de 10: 1, 10, 100, 1000 e 10000
potencia: DB 1, 0, 10, 0, 100, 0, 232, 3, 16, 39

decimal: Dw 0 ; max: 65535

PTRnums: DW nums
PTRpot: DW potencia
PTRdecimal: DW decimal

PTRresultado: DS 2
PTRresultado2: DS 2

multresult: DS 2
multiplicando: DS 2
multiplicador: DS 2
multcounter: DS 2

endereco_retorno: DS 2

ORG 0

LDS #200h

main:
     LDA PTRdecimal+1                ; Coloca o endereço da variável
     PUSH                            ; na pilha
     LDA PTRdecimal                  ;
     PUSH                            ;

     JSR ler_decimal_salva_em_2bytes ; chama a rotina principal

     HLT

ler_decimal_salva_em_2bytes:
                            pop                     ; Salva o endereço de retorno
                            STA endereco_retorno    ;
                            pop                     ;
                            STA endereco_retorno+1  ;

                            pop                     ; Pega o endereço da variavel
                            STA PTRresultado        ; passada na pilha
                            ADD #1                  ;
                            STA PTRresultado2       ;
                            pop                     ;
                            STA PTRresultado+1      ;
                            STA PTRresultado2+1     ;


                            JSR leitura             ; Chama a rotina de leitura dos numeros da console
                            JSR trata_nums          ; Trata os numeros recebidos

                            LDA endereco_retorno+1  ; recupera o endereço de retorno
                            PUSH                    ;
                            LDA endereco_retorno    ;
                            PUSH                    ;

                            RET


trata_nums:
           LDA #nums          ; Calcula endereço
           ADD count          ; do num a ser tratado
           STA PTRnums        ;

           LDA @PTRpot        ; Configura o multiplicando
           STA multiplicando  ; da rotina 'multiplica' com
           LDA PTRpot         ; a potencia de 10 (2bytes)
           ADD #1             ;
           STA PTRpot         ;
           LDA @PTRpot        ;
           STA multiplicando+1;

           LDA PTRpot         ; Prepara o ponteiro de potências
           ADD #1             ; com a próxima potência a ser
           STA PTRpot         ; utilizada

           LDA @PTRnums       ; Configura o multiplicador
           STA multiplicador  ; da rotina 'multiplica' com
           LDA #0             ; o dígito a ser tratado
           STA multiplicador+1;

           LDA #0             ; Reseta a variável
           STA multresult     ; multresult
           STA multresult+1   ;

           JSR multiplica

           LDA @PTRresultado  ; Soma o byte menos
           ADD multresult     ; significatido do decimal
           STA @PTRresultado  ; com o menos significativo do multresult

           LDA @PTRresultado2 ; Soma o byte mais significativo com o carry
           ADC multresult+1
           STA @PTRresultado2

           LDA count
           ADD #1
           STA count
           SUB #5
           JZ retorna

           JMP trata_nums



leitura:
        LDA #1      ;
        TRAP 0      ; Lê o numero digitado no console
        OR #0       ; caso nada seja inserido
        JZ retorna  ; muda para a prox etapa

        SUB #30h
        PUSH

        LDA #nums    ; Armazena o num na
        ADD count    ; posicao correspondente
        SUB #1       ; em nums
        STA PTRnums  ;
        POP          ;
        STA @PTRnums ;

        LDA count   ; Subtrai de count
        SUB #1       ; e pula para a próxima etapa caso
        STA count   ;
        OR #0       ;
        JZ retorna  ; tenha lido 5 chars

        JMP leitura


multiplica:
        LDA multiplicador    ; Se o multiplicador está zerado retorna
        OR multiplicador+1   ;
        OR #0                ;
        JZ retorna           ;

        LDA multresult       ; Pega o byte menos significativo
        ADD multiplicando    ; Soma o byte menos significativo com o multiplicando
        STA multresult       ; Guarda o resultado

        LDA multiplicando+1

        ADC multresult+1     ; Pega o byte mais significativo
        STA multresult+1     ; e soma o carry (1 caso a soma anterior dê overflow)

        LDA multiplicador     ; Subtrai 1 do multiplicador
        SUB #1                ;
        STA multiplicador     ;

        LDA multiplicador+1   ; Pega o byte mais significativo do multiplicador

        SBC #0                ; e subtrai o carry (1 caso a soma anterior dê overflow)
        STA multiplicador+1   ;


        JMP multiplica

retorna:
        RET           ; retorna para o PC onde a rotina foi chamada
