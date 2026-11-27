# t2_memoria.asm
# Instrucciones: lw, sw, lb, lbu, sb, li (lui/ori/addiu), move (addu), addi, jal/jr (para imprimir), syscall(10, 11).
# Casos tabla 3 cubiertos:
#  lw/sw: desplazamiento positivo y negativo
#  lb/lbu: byte con bit 7 = 1 en las 4 posiciones de la palabra (d[1:0] = 0..3)
#  sb: en las 4 posiciones de una misma palabra, comprobando con lw que los demas bytes no cambian
#  syscall 11 y 10
        .text
main:
        move $s0, $gp            # base de datos (0x1800)
        li   $s1, 0x80F1E2D3
        li   $s2, 0x11223344
        sw   $s1, 0($s0)
        sw   $s2, 8($s0)
        addi $s3, $s0, 16
        sw   $s1, -4($s3)
        lw   $a0, 0($s0)
        jal  phex
        lw   $a0, 8($s0)
        jal  phex
        lw   $a0, 12($s0)
        jal  phex
        lw   $a0, -4($s3)
        jal  phex
        lw   $a0, -8($s3)
        jal  phex
        jal  pnl
        lb   $a0, 0($s0)
        jal  phex
        lb   $a0, 1($s0)
        jal  phex
        lb   $a0, 2($s0)
        jal  phex
        lb   $a0, 3($s0)
        jal  phex
        jal  pnl
        lbu  $a0, 0($s0)
        jal  phex
        lbu  $a0, 1($s0)
        jal  phex
        lbu  $a0, 2($s0)
        jal  phex
        lbu  $a0, 3($s0)
        jal  phex
        jal  pnl
        lb   $a0, 8($s0)
        jal  phex
        lb   $a0, 9($s0)
        jal  phex
        lbu  $a0, 10($s0)
        jal  phex
        lb   $a0, 11($s0)
        jal  phex
        jal  pnl
        li   $s4, 0x123456AA
        li   $s5, 0x123456BB
        li   $s6, 0x123456CC
        li   $s7, 0x123456DD
        sw   $s2, 0($s3)
        sb   $s4, 0($s3)
        lw   $a0, 0($s3)
        jal  phex
        sb   $s5, 1($s3)
        lw   $a0, 0($s3)
        jal  phex
        sb   $s6, 2($s3)
        lw   $a0, 0($s3)
        jal  phex
        sb   $s7, 3($s3)
        lw   $a0, 0($s3)
        jal  phex
        jal  pnl
        lb   $a0, -3($s3)
        jal  phex
        lbu  $a0, 3($s3)
        jal  phex
        jal  pnl
        li   $v0, 10
        syscall

# ---- subrutinas ----
# phex: imprime $a0 como 8 digitos hex y un espacio (usa $t0-$t3, $a0, $v0)
phex:   move $t0, $a0
        li   $t1, 8
ph_lp:  srl  $t2, $t0, 28
        sll  $t0, $t0, 4
        slti $t3, $t2, 10
        bne  $t3, $zero, ph_dg
        addi $t2, $t2, 55        # 'A'-10
        j    ph_ou
ph_dg:  addi $t2, $t2, 48        # '0'
ph_ou:  move $a0, $t2
        li   $v0, 11
        syscall
        addi $t1, $t1, -1
        bne  $t1, $zero, ph_lp
        li   $a0, 32             # espacio
        li   $v0, 11
        syscall
        jr   $ra
# pnl: imprime un salto de linea
pnl:    li   $a0, 10
        li   $v0, 11
        syscall
        jr   $ra
