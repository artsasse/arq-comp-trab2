;---------------------------------------------------
; Programa: Armazena decimal em variável de 16 bits
; Autor: Alexandre Camillo, Arthur Sasse, Lucas Farias
; Data: 22/04/2021
;---------------------------------------------------
ORG 800h

num: DS 5
ptr_num: DW num

multresult: DS 2
multiplicando: DS 1
multiplicador: DS 2

count: DB 0

nums: DS 5
nums_qtd: DB 0

decimal: DS 2

char: DS 1
ORG 0

LDS #200h

leitura:
        LDA #1
        TRAP 0
        OR #0

        JZ retorna_inicio ;se terminou de ler vai pra rotina que retorna ao início do vetor

        SUB #30h

        STA @ptr_num ;salva o algarismo lido no vetor

        LDA count
        ADD #1    ;incrementa o contador de algarismos
        STA count

        LDA ptr_num
        ADD #1   ;percorre uma unidade do vetor de algarismos
        STA ptr_num

        LDA ptr1
        ADD #2   ;percorre duas unidades no vetor de potências
        STA ptr1

        JMP leitura

retorna_inicio:
               LDA ptr_num ;carrega o ponteiro do vetor de números lidos
               SUB count ;diminui o ponteiro até voltar ao início do vetor
               STA ptr_num
main:
     LDA @ptr_num
     push

     STA multiplicando ; salva no multiplicando o primeiro número lido

     LDA @ptr1
     STA multiplicador ; salva no multiplicador a potência correspondente a esse valor lido

     LDA ptr1
     SUB #1
     STA ptr1

     LDA @ptr1
     STA multiplicador+1

     LDA #0
     STA multresult
     STA multresult+1

     JSR multiplica

     LDA count
     SUB #1
     STA count

     JNZ prepara_vetor

     LDS #31h

     HLT

prepara_vetor:
              LDA ptr_num
              ADD #1
              STA ptr_num

              LDA ptr1
              SUB #1
              STA ptr1

              JMP main

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