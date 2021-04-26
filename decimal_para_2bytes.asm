;---------------------------------------------------
; Programa: Armazena decimal em variável de 16 bits
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 26/04/2021
;---------------------------------------------------

ORG 100h
nums: DS 5
nums_qtd: DB 0
count: DB 5

; Inicializando potencias de 10: 1, 10, 100, 1000 e 10000
potencia: DB 1, 0, 10, 0, 100, 0, 232, 3, 16, 39

decimal: DB 0, 0

PTRnums: DW nums
PTRpot: DW potencia

multresult: DS 2
multiplicando: DS 2
multiplicador: DS 2
multcounter: DS 2

ORG 0

LDS #200h

main:
     JSR leitura    ; Chama a rotina de leitura

     LDA #5         ;
     SUB count      ; Pega a qtd de nums inseridos
     STA nums_qtd   ; e guarda em nums_qtd

     JSR trata_nums

     LDA decimal
     PUSH
     LDA decimal+1
     PUSH

     HLT


trata_nums:
           LDA #nums          ; Calcula endereço
           ADD count          ; do num a ser tratado
           STA PTRnums        ;

           ;LDA count          ; Calcula o endereço
           ;ADD nums_qtd       ; da
           ;SUB #5             ; potência de 10 do número
           ;STA multiplicando  ; que está sendo tratado
           ;LDA #2             ;
           ;STA multiplicador  ;
           ;LDA #0             ;
           ;STA multresult     ;
           ;JSR multiplica     ;
           ;LDA #potencia      ;
           ;ADD multresult     ;
           ;STA PTRpot         ;


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

           LDA decimal        ; Soma o byte menos
           ADD multresult     ; significatido do decimal
           STA decimal        ; com o menos significativo do multresult

           LDA decimal+1      ; Soma o byte mais significativo com o carry
           ADC multresult+1   ;
           STA decimal+1


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
