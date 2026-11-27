# t3_control.asm
# Instrucciones: beq, bne, j, jal, jr, sw, lw (pila), addi, sll, ori, add, li, move, syscall(10, 11).
# Casos tabla 3 cubiertos:
#  beq/bne: cada uno tomado y no tomado; salto hacia atras (bucle con bne)
#  j: salto incondicional | jal/jr: procedimiento f que llama a g (no hoja), $ra guardado en la pila
#  syscall 11 (imprimir caracter) y 10 (terminar)
        .text
main:
        li   $s0, 5
        li   $s1, 5
        li   $s2, 7
        li   $s3, 0
        beq  $s0, $s1, t1         # tomado
        ori  $s3, $s3, 0x01       # no debe ejecutarse
t1:     beq  $s0, $s2, t2         # no tomado
        ori  $s3, $s3, 0x02       # se ejecuta
t2:     bne  $s0, $s2, t3         # tomado
        ori  $s3, $s3, 0x04       # no debe ejecutarse
t3:     bne  $s0, $s1, t4         # no tomado
        ori  $s3, $s3, 0x08       # se ejecuta
t4:     j    t5                   # salto incondicional
        ori  $s3, $s3, 0x10       # no debe ejecutarse
t5:     ori  $s3, $s3, 0x20
        move $a0, $s3
        jal  phex
        li   $s4, 0               # suma 10+9+...+1 con salto hacia atras
        li   $s5, 10
loop:   add  $s4, $s4, $s5
        addi $s5, $s5, -1
        bne  $s5, $zero, loop
        move $a0, $s4
        jal  phex
        jal  pnl
        li   $a0, 3
        move $s6, $sp
        jal  f
        move $s7, $v1
        move $a0, $s7
        jal  phex
        move $a0, $s6
        jal  phex
        move $a0, $sp
        jal  phex
        jal  pnl
        li   $a0, 79              # 'O'
        li   $v0, 11
        syscall
        li   $a0, 75              # 'K'
        li   $v0, 11
        syscall
        jal  pnl
        li   $v0, 10
        syscall

# f(x) = g(x) + g(x+1)  (no es hoja: guarda $ra y x en la pila)
f:      addi $sp, $sp, -8
        sw   $ra, 4($sp)
        sw   $a0, 0($sp)
        jal  g
        move $t4, $v1
        lw   $a0, 0($sp)
        addi $a0, $a0, 1
        jal  g
        add  $v1, $v1, $t4
        lw   $ra, 4($sp)
        addi $sp, $sp, 8
        jr   $ra
# g(x) = 2x + 1  (hoja)
g:      sll  $v1, $a0, 1
        addi $v1, $v1, 1
        jr   $ra

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
