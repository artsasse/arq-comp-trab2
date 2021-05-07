;---------------------------------------------------
; Program: Converte de Celsius para Fahrenheit
; Author: Arthur Sasse, Lucas Farias e Alexandre Camillo
; Date:   06/05/2021
;---------------------------------------------------

; Ideia Geral: Conversao aproximada

; A formula comum é esta:
; TF = TC * 1,8 + 32

; No nosso programa vamos usar uma conversao aproximada
; TF = (TC * 7)/4 + 32
; Obs: 7/4 = 1,75, mas nosso programa faz apenas divisoes inteiras

; Exemplos:
;
; * 0° Celsius
;   Formula: 32°F
;   Programa: 32°F

; * 19° Celsius
;   Formula: 66,2°F
;   Programa: 65°F

; * 30° Celsius
;   Formula: 86°F
;   Programa: 84°F

ORG 800h

; salvar variavel
nums: DS 3
count: DB 3
potencia: DB 1, 10, 100
decimal: DW 0
PTRnums: DW nums
PTRpot: DW potencia
PTRdecimal: DW decimal
PTRresultado: DS 2

; multiplicacao
multresult: DS 1
multiplicando: DS 1
multiplicador: DS 1

; conversao
shiftcounter: DB 0

; escrita no console
unidades: DB 0
dezenas: DB 0
centenas: DB 0

; geral
endereco_retorno: DS 2

ORG 0

LDS #2000h

main:
    LDA PTRdecimal+1                ; Coloca o endereço da variável
    PUSH                            ; na pilha
    LDA PTRdecimal                  ;
    PUSH                            ;
    JSR ler_decimal_salva_em_1byte  ; chama subrotina

    LDA PTRdecimal+1                ; Coloca o endereço da variável
    PUSH                            ; na pilha
    LDA PTRdecimal                  ;
    PUSH                            ;
    JSR converter                   ; chama subrotina

    LDA PTRdecimal+1                ; Coloca o endereço da variável
    PUSH                            ; na pilha
    LDA PTRdecimal                  ;
    PUSH                            ;
    JSR printar                     ; chama subrotina

    HLT

; PRINTAR -------------------------------------------------
printar:
    ; salva endereço de retorno
    POP
    STA endereco_retorno
    POP
    STA endereco_retorno+1

    ; salva endereço da variavel (passada como argumento) em PTRresultado
    POP
    STA PTRresultado
    POP
    STA PTRresultado+1

    ; verifica as centenas (subtrai 100)
conta_centenas:
    LDA @PTRresultado
    SUB #100
    JN restaura_centenas
    STA @PTRresultado
    LDA centenas
    ADD #1
    STA centenas
    JMP conta_centenas

restaura_centenas:
    ADD #100
    STA @PTRresultado

    ; verifica as dezenas (subtrai 10)
conta_dezenas:
    LDA @PTRresultado
    SUB #10
    JN restaura_dezenas
    STA @PTRresultado
    LDA dezenas
    ADD #1
    STA dezenas
    JMP conta_dezenas

restaura_dezenas:
    ADD #10
    STA @PTRresultado

    ; verifica as unidades (subtrai 1)
conta_unidades:
    LDA @PTRresultado
    SUB #1
    JN restaura_unidades
    STA @PTRresultado
    LDA unidades
    ADD #1
    STA unidades
    JMP conta_unidades

restaura_unidades:
    ADD #1
    STA @PTRresultado

escrita:
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

; CONVERTER -------------------------------------------------
converter:
    ; salva endereço de retorno
    POP
    STA endereco_retorno
    POP
    STA endereco_retorno+1

    ; salva endereço da variavel (passada como argumento) em PTRresultado
    POP
    STA PTRresultado
    POP
    STA PTRresultado+1

multiplica_por_7:
    ; Reseta multresult
    LDA #0
    STA multresult

    ; carrega 7 no multiplicador
    LDA #7
    STA multiplicador

    ; carrega a variavel no multiplicando
    LDA @PTRresultado
    STA multiplicando

    JSR multiplica

    ; salva o resultado na variavel
    LDA multresult
    STA @PTRresultado

dividir:  ; divide por 4 (2 shifts para direita)
    LDA @PTRresultado
    SHR
    STA @PTRresultado
    ; verifica se ja fez 2 divisoes por 2
    LDA shiftcounter
    ADD #1
    STA shiftcounter
    SUB #2
    JNZ dividir

soma32:
    LDA @PTRresultado
    ADD #32
    STA @PTRresultado

    ; retorna para a main
    LDA endereco_retorno+1
    PUSH
    LDA endereco_retorno
    PUSH
    RET

; LER_DECIMAL_SALVA_EM_1BYTE -------------------------------------------------
ler_decimal_salva_em_1byte:
    pop                     ; Salva o endereço de retorno
    STA endereco_retorno    ;
    pop                     ;
    STA endereco_retorno+1  ;

    pop                     ; Pega o endereço da variavel
    STA PTRresultado        ; passada na pilha
    pop                     ;
    STA PTRresultado+1      ;

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
                       ; a potencia de 10


    LDA PTRpot         ; Prepara o ponteiro de potências
    ADD #1             ; com a próxima potência a ser
    STA PTRpot         ; utilizada

    LDA @PTRnums       ; Configura o multiplicador
    STA multiplicador  ; da rotina 'multiplica' com
                       ; o dígito a ser tratado

    LDA #0             ; Reseta a variável
    STA multresult     ; multresult

    JSR multiplica

    LDA @PTRresultado  ; Soma o byte menos
    ADD multresult     ; significatido do decimal
    STA @PTRresultado  ; com o menos significativo do multresult

    LDA count
    ADD #1
    STA count
    SUB #3
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
    SUB #1      ; e pula para a próxima etapa caso
    STA count   ;
    OR #0       ;
    JZ retorna  ; tenha lido 3 chars

    JMP leitura

multiplica:
    LDA multiplicador    ; Se o multiplicador está zerado retorna
    OR #0                ;
    JZ retorna           ;

    LDA multresult       ; Pega o byte menos significativo
    ADD multiplicando    ; Soma o byte menos significativo com o multiplicando
    STA multresult       ; Guarda o resultado

    LDA multiplicador     ; Subtrai 1 do multiplicador
    SUB #1                ;
    STA multiplicador     ;

    JMP multiplica

retorna:
    RET           ; retorna para o PC onde a rotina foi chamada
