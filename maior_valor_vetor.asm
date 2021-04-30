;---------------------------------------------------
; Programa: Acha o maior valor de um vetor de 16 bits com sinal
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 30/04/21
;---------------------------------------------------
ORG 200h

; Variáveis do programa principal

; Vetor e endereço inicial
VETOR: DW 57405, 8742, 62760, 42615, 39769, 46349, 61530, 35871, 48525, 14587, 37618, 50144, 44313, 61281, 3091, 5098, 55314, 60975, 4270, 1260
VET_INI: DW VETOR

; Variáveis da rotina

; Ponteiro para armazenar o valor atual do vetor
PTR: DW 0
;Tamanho do vetor
TAM: DS 1
; Maior valor do vetor
MAX: DW 0
; Menor valor do vetor
MIN: DW 0
; Variável para armazenar a quantidade de iterações
I: DB 1
; Valor do SP para retorno
SP: DW 0

ORG 0

MAIN:
     ; Coloca o endereço inicial do vetor na pilha
     LDA VET_INI
     PUSH
     LDA VET_INI+1
     PUSH

     ; Coloca o tamanho do vetor no acumulador e chama a rotina
     LDA #20
     JSR INICIO

     HLT

INICIO:
       ; Salva o tamanho do vetor
       STA TAM

       ; Salva o valor do SP
       STS SP

       ; Tira as duas primeiras posições da pilha
       POP
       POP

       ; Salva o endereço inicial no ponteiro
       POP
       STA PTR+1
       POP
       STA PTR

       ; Adiciona o primeiro valor do vetor como máximo
       LDA @PTR
       STA MAX

       LDA PTR
       ADD #1
       STA PTR

       LDA @PTR
       STA MAX+1

       ; Avança com o ponteiro pro segundo elemento do vetor
       LDA PTR
       ADD #1
       STA PTR

LACO:
     ; Coloca o ponteiro na parte alta do elemento
     LDA PTR
     ADD #1
     STA PTR

     ; Verifica se é negativo
     LDA @PTR
     AND #128
     JNZ NEGATIVO

     ; Verifica se o maior é negativo
     ; Para o caso do primeiro valor do vetor ser negativo
     LDA MAX+1
     AND #128
     JNZ PA_TROCA_MAX

     ; Se o valor atual e o maior são positivos,
     ; subtrai a parte alta do maior até aqui
     LDA @PTR
     SUB MAX+1
     JN  PA_CONTINUA
     JP  PA_TROCA_MAX

     ; Move ponteiro para a parte baixa
     LDA PTR
     SUB #1
     STA PTR

     ; Subtrai a parte baixa do maior até aqui
     LDA @PTR
     SUB MAX
     JP  PB_TROCA_MAX

     JMP PB_CONTINUA

NEGATIVO:
         ; Verifica se o maior valor é negativo
         LDA MAX+1
         AND #128
         JZ  PA_CONTINUA

         ; Agora é o caso onde os dois são negativos

         ; Subtrai a parte alta do maior valor
         LDA @PTR
         SUB MAX+1
         JN  PA_CONTINUA
         JP  PA_TROCA_MAX

         ; Move para a parte baixa
         LDA PTR
         SUB #1
         STA PTR

         ; Subtrai a parte baixa do maior valor
         LDA @PTR
         SUB MAX
         JN  PB_CONTINUA
         JP  PB_TROCA_MAX

PA_TROCA_MAX:
             ; Salva a parte alta no maior valor
             LDA @PTR
             STA MAX+1

             ; Move para a parte baixa
             LDA PTR
             SUB #1
             STA PTR

             ; Salva a parte baixa no maior valot
             LDA @PTR
             STA MAX

             ; Posiciona o ponteiro no próximo elemento
             LDA PTR
             ADD #2
             STA PTR

             ; Incrementa o número de iterações
             LDA I
             ADD #1
             STA I

             ; Verifica se acabou
             SUB TAM
             JNZ LACO

             ; Restaura o SP
             LDS SP
             RET

PB_TROCA_MAX:
             ; Salva a parte baixa no maior valot
             LDA @PTR
             STA MAX

             ; Move para a parte alta
             LDA PTR
             ADD #1
             STA PTR

             ; Salva a parte alta no maior valor
             LDA @PTR
             STA MAX+1

             ; Posiciona o ponteiro no próximo elemento
             LDA PTR
             ADD #1
             STA PTR

             ; Incrementa o número de iterações
             LDA I
             ADD #1
             STA I

             ; Verifica se acabou
             SUB TAM
             JNZ LACO

             ; Restaura o SP
             LDS SP
             RET

PA_CONTINUA:
            ; Posiciona o ponteiro no próximo valor
            LDA PTR
            ADD #1
            STA PTR

            ; Incrementa o número de iterações
            LDA I
            ADD #1
            STA I

            ; Verifica se acabou
            SUB TAM
            JNZ LACO

            ; Restaura o SP
            LDS SP
            RET


PB_CONTINUA:
            ; Posiciona o ponteiro no próximo valor
            LDA PTR
            ADD #2
            STA PTR

            ; Incrementa o número de iterações
            LDA I
            ADD #1
            STA I

            ; Verifica se acabou
            SUB TAM
            JNZ LACO

            ; Restaura o SP
            LDS SP
            RET
END 0

























