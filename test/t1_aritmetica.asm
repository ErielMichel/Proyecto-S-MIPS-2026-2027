# t1_aritmetica.asm
# Instrucciones: add, sub, and, or, slt, slti, sll, srl, addi, addiu, addu,
#   andi, ori, lui, syscall(10, 11), jal/jr (solo para imprimir).
# Casos tabla 3 cubiertos:
#  add/sub: operandos positivos y con uno negativo | and/or: unos en los 16 bits altos
#  slt/slti: resultado 1 y 0, con negativo (signed != unsigned)
#  sll/srl: shamt=0 y !=0, srl sobre valor negativo | addi con inmediato negativo
#  addiu/addu: via li (-32768..32767) y move | andi/ori con inmediato de bit 15 = 1
#  lui con bit 15 = 1 | escritura en $zero y comprobacion | syscall 11 y 10
        .text
main:
        li   $s0, 1000
        li   $s1, -300
        li   $s2, 0xF0F0A5A5
        li   $s3, 0xFF00FFFF
        li   $s4, 0x80000010
        add  $a0, $s0, $s0
        jal  phex
        add  $a0, $s0, $s1
        jal  phex
        add  $a0, $s1, $s1
        jal  phex
        sub  $a0, $s0, $s1
        jal  phex
        sub  $a0, $s1, $s0
        jal  phex
        jal  pnl
        and  $a0, $s2, $s3
        jal  phex
        or   $a0, $s2, $s3
        jal  phex
        and  $a0, $s2, $s1
        jal  phex
        or   $a0, $s1, $s3
        jal  phex
        jal  pnl
        slt  $a0, $s1, $s0
        jal  phex
        slt  $a0, $s0, $s1
        jal  phex
        slt  $a0, $s0, $s0
        jal  phex
        slti $a0, $s1, 5
        jal  phex
        slti $a0, $s0, 5
        jal  phex
        jal  pnl
        slti $a0, $s1, -400
        jal  phex
        slti $a0, $s4, 16
        jal  phex
        jal  pnl
        sll  $a0, $s2, 0
        jal  phex
        sll  $a0, $s2, 4
        jal  phex
        sll  $a0, $s2, 31
        jal  phex
        srl  $a0, $s2, 0
        jal  phex
        srl  $a0, $s2, 4
        jal  phex
        jal  pnl
        srl  $a0, $s1, 31
        jal  phex
        srl  $a0, $s4, 8
        jal  phex
        jal  pnl
        addi $a0, $s0, -1
        jal  phex
        addi $a0, $zero, -32768
        jal  phex
        addi $a0, $s1, -700
        jal  phex
        jal  pnl
        li   $a0, -32768
        jal  phex
        li   $a0, 32767
        jal  phex
        li   $a0, 12345
        jal  phex
        move $a0, $s1
        jal  phex
        addu $a0, $s0, $s1
        jal  phex
        jal  pnl
        li   $s5, -1
        andi $a0, $s5, 0x8001
        jal  phex
        andi $a0, $s2, 0xFFFF
        jal  phex
        ori  $a0, $zero, 0x8000
        jal  phex
        ori  $a0, $s2, 0x8001
        jal  phex
        jal  pnl
        lui  $a0, 0x8000
        jal  phex
        lui  $a0, 0xFFFF
        jal  phex
        lui  $a0, 0x1234
        jal  phex
        jal  pnl
        addi $zero, $zero, 5
        add  $zero, $s0, $s0
        lui  $zero, 0x7FFF
        move $a0, $zero
        jal  phex
        add  $a0, $zero, $s0
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
