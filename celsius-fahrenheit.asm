;---------------------------------------------------
; Program:
; Author:
; Date:
;---------------------------------------------------


ORG 800h
nums: DS 5
count: DB 5

; Inicializando potencias de 10: 1, 10, 100, 1000 e 10000
potencia: DB 1, 0, 10, 0, 100, 0, 232, 3, 16, 39

decimal: DB 0, 0

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
shiftcounter: DB 0

unidades: DB 0
dezenas: DB 0
centenas: DB 0
milhares: DB 0
dez_milhares: DB 0
carry: DB 0
carry2: DB 0
carry_soma: DB 0

ORG 0

LDS #2000h

main:
    LDA PTRdecimal+1                ; Coloca o endereço da variável
    PUSH                            ; na pilha
    LDA PTRdecimal                  ;
    PUSH                            ;

    JSR ler_decimal_salva_em_2bytes ; chama a rotina principal

    LDA PTRdecimal+1                ; Coloca o endereço da variável
    PUSH                            ; na pilha
    LDA PTRdecimal                  ;
    PUSH                            ;

    JSR converter

    LDA PTRdecimal+1                ; Coloca o endereço da variável
    PUSH                            ; na pilha
    LDA PTRdecimal                  ;
    PUSH                            ;
    JSR printar

    HLT

printar:
    ; salva endereço de retorno
    POP
    STA endereco_retorno
    POP
    STA endereco_retorno+1

    ; salva endereço da parte baixa da variavel (passada como argumento) em PTRresultado
    POP
    STA PTRresultado
    POP
    STA PTRresultado+1

    ; salva o endereço da parte alta da variavel em PTRresultado2
    LDA PTRresultado
    ADD #1
    STA PTRresultado2
    LDA PTRresultado+1
    ADC #0
    STA PTRresultado2+1

    ; faz as somas, se for necessario
soma_unidades:
    LDA unidades
    SUB #4              ; verifica se unidades > 4. Se for, soma 3.
    JP soma_3_unidades
    JMP soma_dezenas
soma_3_unidades:
    ADD #7              ; restaura o valor e soma 3
    STA unidades
    SUB #15
    JP  carry_unidades  ; se for > 15, teve carry nos 4 bits mais baixos
    LDA #0
    STA carry_soma      ; zera a variavel, se nao teve carry
    JMP soma_dezenas
carry_unidades:
    LDA #1
    STA carry_soma

soma_dezenas:
    LDA dezenas
    ADD carry_soma
    SUB #4
    JP soma_3_dezenas
    LDA #0
    STA carry_soma
    JMP soma_centenas
soma_3_dezenas:
    ADD #7
    STA dezenas
    SUB #15
    JP  carry_dezenas  ; se for > 15, teve carry nos 4 bits mais baixos
    LDA #0
    STA carry_soma      ; zera a variavel, se nao teve carry
    JMP soma_centenas
carry_dezenas:
    LDA #1
    STA carry_soma

soma_centenas:
    LDA centenas
    ADD carry_soma
    SUB #4
    JP soma_3_centenas
    LDA #0
    STA carry_soma
    JMP soma_milhares
soma_3_centenas:
    ADD #7
    STA centenas
    SUB #15
    JP  carry_centenas  ; se for > 15, teve carry nos 4 bits mais baixos
    LDA #0
    STA carry_soma      ; zera a variavel, se nao teve carry
    JMP soma_milhares
carry_centenas:
    LDA #1
    STA carry_soma

soma_milhares:
    LDA milhares
    ADD carry_soma
    SUB #4
    JP soma_3_milhares
    LDA #0
    STA carry_soma
    JMP soma_dez_milhares
soma_3_milhares:
    ADD #7
    STA milhares
    SUB #15
    JP  carry_milhares  ; se for > 15, teve carry nos 4 bits mais baixos
    LDA #0
    STA carry_soma      ; zera a variavel, se nao teve carry
    JMP soma_dez_milhares
carry_milhares:
    LDA #1
    STA carry_soma

soma_dez_milhares:
    LDA dez_milhares
    ADD carry_soma
    SUB #4
    JP soma_3_dez_milhares
    LDA #0
    STA carry_soma
    JMP shift_left_parte_baixa
soma_3_dez_milhares:
    ADD #7
    STA dez_milhares

    ; valor binario, parte baixa
shift_left_parte_baixa:

    LDA @PTRresultado
    SHL
    STA @PTRresultado
    LDA #0
    ADC #0
    STA carry

    ; valor binario, parte alta
shift_left_parte_alta:
    LDA @PTRresultado2
    SHL
    STA @PTRresultado2
    LDA #0
    ADC #0
    STA carry2
    LDA @PTRresultado2
    OR carry
    STA @PTRresultado2
    LDA #0
    STA carry

    ; unidades
shift_left_unidades:
    LDA unidades
    SHL
    STA unidades
    LDA #0
    ADC #0
    STA carry
    LDA unidades
    OR carry2
    STA unidades
    LDA #0
    STA carry2

    ; dezenas
shift_left_dezenas:
    LDA dezenas
    SHL
    STA dezenas
    LDA #0
    ADC #0
    STA carry2
    LDA dezenas
    OR carry
    STA dezenas
    LDA #0
    STA carry

    ; centenas
shift_left_centenas:
    LDA centenas
    SHL
    STA centenas
    LDA #0
    ADC #0
    STA carry
    LDA centenas
    OR carry2
    STA centenas
    LDA #0
    STA carry2

    ; milhares
shift_left_milhares:
    LDA milhares
    SHL
    STA milhares
    LDA #0
    ADC #0
    STA carry2
    LDA milhares
    OR carry
    STA milhares
    LDA #0
    STA carry

    ; dezenas de milhares
shift_left_dez_milhares:
    LDA dez_milhares
    SHL
    OR carry2
    STA dez_milhares
    LDA #0
    STA carry2

    LDA @PTRresultado
    OR @PTRresultado2
    OR #0
    JNZ soma_unidades

escrita:
    LDA dez_milhares
    ADD #30h
    STA dez_milhares
    LDA #2
    TRAP dez_milhares

    LDA milhares
    ADD #30h
    STA milhares
    LDA #2
    TRAP milhares

    LDA centenas
    ADD #30h
    STA centenas
    LDA #2
    TRAP centenas

    LDA dezenas
    ADD #30h
    STA dezenas
    LDA #2
    TRAP dezenas

    LDA unidades
    ADD #30h
    STA unidades
    LDA #2
    TRAP unidades

    LDA endereco_retorno+1
    PUSH
    LDA endereco_retorno
    PUSH

    RET

converter:
    ; salva endereço de retorno
    POP
    STA endereco_retorno
    POP
    STA endereco_retorno+1

    ; salva endereço da parte baixa da variavel (passada como argumento) em PTRresultado
    POP
    STA PTRresultado
    POP
    STA PTRresultado+1

    ; salva o endereço da parte alta da variavel em PTRresultado2
    LDA PTRresultado
    ADD #1
    STA PTRresultado2
    LDA PTRresultado+1
    ADC #0
    STA PTRresultado2+1

multiplica_por_7:
    ; Reseta multresult
    LDA #0
    STA multresult
    STA multresult+1

    ; carrega 7 no multiplicador
    LDA #7
    STA multiplicador
    LDA #0
    STA multiplicador+1

    ; carrega a variavel no multiplicando
    LDA @PTRresultado
    STA multiplicando
    LDA @PTRresultado2
    STA multiplicando+1

    JSR multiplica

    ; salva o resultado na variavel
    LDA multresult
    STA @PTRresultado
    LDA multresult+1
    STA @PTRresultado2

dividir:  ; divide por 4 (2 shifts aritméticos para direita)
    LDA @PTRresultado2  ; pega parte alta
    SRA  ; shift aritmético
    STA @PTRresultado2
    JC shift_carry_parte_baixa
    LDA @PTRresultado
    SHR  ; shift logico
    STA @PTRresultado
    JMP dividir_count

shift_carry_parte_baixa:
    LDA @PTRresultado  ; pega parte baixa
    SHR  ; shift logico
    OR #128  ; garante que o bit mais significativo vai ser 1
    STA @PTRresultado

dividir_count:   ; verifica se ja fez 2 divisoes por 2
    LDA shiftcounter
    ADD #1
    STA shiftcounter
    SUB #2
    JNZ dividir

soma32:
    LDA @PTRresultado
    ADD #32
    STA @PTRresultado
    LDA @PTRresultado2
    ADC #0
    STA @PTRresultado2

    ; retorna para a main
    LDA endereco_retorno+1
    PUSH
    LDA endereco_retorno
    PUSH
    RET

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
