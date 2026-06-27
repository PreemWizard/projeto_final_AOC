# =================================================================
# Trabalho final de AOC - Sequencia de LEDs
# Utiliza o conceito de manipulacao da memoria e chamada de funcoes
# para criar alguns padraoes com leds
# Funcoes:
# limpa_matriz -> apaga todos os leds da matriz;
# alternado1_matriz e alternado2_matriz -> cria um padrao de cores
# alternadas;
# quadrado1_matriz, quadrado2_matriz e quadrado3_matriz -> cria um
# padrao de quadrado
# diagonal_matriz e diagonal_inversa_matriz -> cria um padrao na
# diagonal da esquerda pra direita e da direita pra esqquerda, 
# formando um X
# acende_matriz -> acende os leds da mtriz com cores que alteram
# a cada iteracao
# =================================================================

.equ VERDE, 0x0000FF00
.equ AZUL,  0x000000FF
.equ VERMELHO,  0x00FF0000
.equ PRETO, 0x00000000

.text
main:
    li s0, LED_MATRIX_0_BASE
    li s1, LED_MATRIX_0_WIDTH
    li s2, LED_MATRIX_0_HEIGHT
    mul s3, s1, s2 # numero de leds na matriz
    
    jal ra, limpa_matriz
    
loop:
    jal ra, acende_matriz
    jal ra, limpa_matriz
    jal ra, alternado1_matriz
    jal ra, alternado2_matriz
    jal ra, limpa_matriz
    jal ra, quadrado1_matriz
    jal ra, quadrado2_matriz
    jal ra, quadrado3_matriz
    jal ra, diagonal_matriz
    jal ra, diagonal_inversa_matriz
    jal ra, limpa_matriz

    j loop
    
acende_matriz:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    mv   t0, s0                 # endereco atual
    mv   t1, s3                 # contador = total de pixels
    li   t2, PRETO              # cor inicial
    li   t3, 0x00071101         # incremento de cor
    li   t4, 0x00FFFFFF         # mascara RGB
    li   t5, 0x00101010         # minimo RGB
    or   t2, t2, t5             # aplica minimo antes do loop
 
acende_loop:
    sw   t2, 0(t0)              # acende pixel atual
    add  t2, t2, t3             # incrementa cor
    and  t2, t2, t4             # mascara alpha
    or   t2, t2, t5             # brilho minimo
 
    addi t0, t0, 4              # avanca para o proximo pixel
    addi t1, t1, -1             # decrementa contador
    bnez t1, acende_loop
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret

    
alternado1_matriz:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    mv   t0, s0
    addi t1, s3, 1           
    srli t1, t1, 1
    li   t2, AZUL
 
alternado1_loop:
    sw   t2, 0(t0)
    addi t0, t0, 8
    addi t1, t1, -1
    bnez t1, alternado1_loop
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret

    
alternado2_matriz:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    mv   t0, s0
    addi t1, s3, 1          
    srli t1, t1, 1
    li   t2, VERMELHO
 
alternado2_loop:
    sw   t2, 4(t0)
    addi t0, t0, 8
    addi t1, t1, -1
    bnez t1, alternado2_loop
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret


quadrado1_matriz:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    mv t0, s0
    add t1, x0, s1
    li   t2, VERMELHO
 
quadrado1_loop:
    sw   t2, 0(t0)
    addi t0, t0, 4
    addi t1, t1, -1
    bnez t1, quadrado1_loop
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret

quadrado2_matriz:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    slli t3, s1, 2              # t3 = tamanho de uma linha (s1 * 4)
    addi t4, s1, -1
    slli t4, t4, 2              # t4 = offset pixel direito ((s1-1) * 4)
 
    mv   t0, s0
    add  t0, t0, t3             # pula a primeira linha
 
    addi t1, s2, -2             # t1 = linhas do meio (s2 - 2)
    li   t2, VERMELHO
 
quadrado2_loop:
    sw   t2, 0(t0)              # pixel esquerdo
    add  t5, t0, t4
    sw   t2, 0(t5)              # pixel direito
    add  t0, t0, t3             # avanca uma linha
    addi t1, t1, -1
    bnez t1, quadrado2_loop
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret
    
quadrado3_matriz:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    addi t0, s2, -1             # t0 = altura - 1
    mul  t0, t0, s1             # t0 = (altura - 1) * largura
    slli t0, t0, 2              # t0 = (altura - 1) * largura * 4
    add  t0, s0, t0             # t0 = BASE + offset da ultima linha
 
    mv   t1, s1                 # contador = numero de colunas
    li   t2, VERMELHO
 
quadrado3_loop:
    sw   t2, 0(t0)
    addi t0, t0, 4
    addi t1, t1, -1
    bnez t1, quadrado3_loop
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret

    
    
diagonal_matriz:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    mv   t0, s0                 # endereco do pixel atual
    mv   t1, s1                 # contador = numero de colunas (um pixel por linha)
    li   t5, VERMELHO
 
    # avanco = (num_colunas + 1) * 4
    addi t6, s1, 1              # t6 = num_colunas + 1
    slli t6, t6, 2              # t6 = (num_colunas + 1) * 4
 
diagonal_loop:
    sw   t5, 0(t0)              # acende pixel da diagonal
 
    add  t0, t0, t6             # avanca para o proximo pixel da diagonal
    addi t1, t1, -1
    bnez t1, diagonal_loop
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret
    
    
diagonal_inversa_matriz:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    # endereco do canto superior direito
    addi t0, s1, -1             # t0 = s1 - 1
    slli t0, t0, 2              # t0 = (s1 - 1) * 4
    add  t0, s0, t0             # t0 = BASE + offset canto direito
 
    mv   t1, s1                 # contador = numero de colunas
    li   t5, VERMELHO
 
    # avanco = (num_colunas - 1) * 4
    addi t6, s1, -1             # t6 = num_colunas - 1
    slli t6, t6, 2              # t6 = (num_colunas - 1) * 4
 
diagonal_inversa_loop:
    sw   t5, 0(t0)              # acende pixel da diagonal
    add  t0, t0, t6             # avanca para o proximo pixel
    addi t1, t1, -1
    bnez t1, diagonal_inversa_loop
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret

limpa_matriz:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    mv   t0, s0                 # endereco atual
    mv   t1, s3                 # contador = total de pixels
    li   t2, PRETO
 
limpa_loop:
    sw   t2, 0(t0)              # apaga pixel atual
    addi t0, t0, 4              # avanca para o proximo pixel
    addi t1, t1, -1             # decrementa contador
    bnez t1, limpa_loop
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    ret
