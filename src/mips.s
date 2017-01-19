	.data
a_global:
	.space 4000
	.text
	.data
num_global: .word 0
	.text

divide_global:
	li $t0, 12
	sub $sp, $sp, $t0
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	add $t0, $zero, $zero
	addi $t2, $a0, 0
	lw $t2, 0($t2)
	li $t1, 1000
	mul $t0, $t0, $t1
	add $t0, $t0, $t2
	li $t1, 4
	mul $t0, $t0, $t1
	la $t1, a_global
	add $t0, $t1, $t0
	lw $t0, 0($t0)
	sw $t0, 8($sp)

divide_global_for_cond_a:
	addi $t0, $a0, 0
	lw $t0, 0($t0)
	addi $t1, $a0, 4
	lw $t1, 0($t1)
	sne $t2, $t0, $t1
	beq $t2, $zero, divide_global_for_end_a

divide_global_for_cond_b:
	addi $t0, $a0, 0
	lw $t0, 0($t0)
	addi $t1, $a0, 4
	lw $t1, 0($t1)
	slt $t2, $t0, $t1
	add $t0, $t2, $zero
	beq $t2, $zero, divide_global_shortcircuit_c
	add $t1, $zero, $zero
	addi $t4, $a0, 4
	lw $t4, 0($t4)
	li $t3, 1000
	mul $t1, $t1, $t3
	add $t1, $t1, $t4
	li $t3, 4
	mul $t1, $t1, $t3
	la $t3, a_global
	add $t1, $t3, $t1
	lw $t1, 0($t1)
	addi $t3, $sp, 8
	lw $t3, 0($t3)
	sge $t4, $t1, $t3
	add $t0, $t4, $zero

divide_global_shortcircuit_c:
	beq $t0, $zero, divide_global_for_end_b
	addi $t0, $a0, 4
	lw $t1, 0($t0)
	addi $t1, $t1, -1
	sw $t1, 0($t0)

divide_global_for_incr_b:
	j divide_global_for_cond_b

divide_global_for_end_b:
	addi $t0, $a0, 0
	lw $t0, 0($t0)
	addi $t1, $a0, 4
	lw $t1, 0($t1)
	slt $t2, $t0, $t1
	beq $t2, $zero, divide_global_endif_d
	add $t0, $zero, $zero
	addi $t2, $a0, 4
	lw $t2, 0($t2)
	li $t1, 1000
	mul $t0, $t0, $t1
	add $t0, $t0, $t2
	li $t1, 4
	mul $t0, $t0, $t1
	la $t1, a_global
	add $t0, $t1, $t0
	lw $t0, 0($t0)
	add $t1, $zero, $zero
	addi $t3, $a0, 0
	lw $t3, 0($t3)
	li $t2, 1000
	mul $t1, $t1, $t2
	add $t1, $t1, $t3
	li $t2, 4
	mul $t1, $t1, $t2
	la $t2, a_global
	add $t1, $t2, $t1
	sw $t0, 0($t1)
	addi $t0, $a0, 0
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)

divide_global_endif_d:

divide_global_for_cond_e:
	addi $t0, $a0, 0
	lw $t0, 0($t0)
	addi $t1, $a0, 4
	lw $t1, 0($t1)
	slt $t2, $t0, $t1
	add $t0, $t2, $zero
	beq $t2, $zero, divide_global_shortcircuit_f
	add $t1, $zero, $zero
	addi $t4, $a0, 0
	lw $t4, 0($t4)
	li $t3, 1000
	mul $t1, $t1, $t3
	add $t1, $t1, $t4
	li $t3, 4
	mul $t1, $t1, $t3
	la $t3, a_global
	add $t1, $t3, $t1
	lw $t1, 0($t1)
	addi $t3, $sp, 8
	lw $t3, 0($t3)
	sle $t4, $t1, $t3
	add $t0, $t4, $zero

divide_global_shortcircuit_f:
	beq $t0, $zero, divide_global_for_end_e
	addi $t0, $a0, 0
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)

divide_global_for_incr_e:
	j divide_global_for_cond_e

divide_global_for_end_e:
	addi $t0, $a0, 0
	lw $t0, 0($t0)
	addi $t1, $a0, 4
	lw $t1, 0($t1)
	slt $t2, $t0, $t1
	beq $t2, $zero, divide_global_endif_g
	add $t0, $zero, $zero
	addi $t2, $a0, 0
	lw $t2, 0($t2)
	li $t1, 1000
	mul $t0, $t0, $t1
	add $t0, $t0, $t2
	li $t1, 4
	mul $t0, $t0, $t1
	la $t1, a_global
	add $t0, $t1, $t0
	lw $t0, 0($t0)
	add $t1, $zero, $zero
	addi $t3, $a0, 4
	lw $t3, 0($t3)
	li $t2, 1000
	mul $t1, $t1, $t2
	add $t1, $t1, $t3
	li $t2, 4
	mul $t1, $t1, $t2
	la $t2, a_global
	add $t1, $t2, $t1
	sw $t0, 0($t1)
	addi $t0, $a0, 4
	lw $t1, 0($t0)
	addi $t1, $t1, -1
	sw $t1, 0($t0)

divide_global_endif_g:

divide_global_for_incr_a:
	j divide_global_for_cond_a

divide_global_for_end_a:
	addi $t0, $sp, 8
	lw $t0, 0($t0)
	add $t1, $zero, $zero
	addi $t3, $a0, 0
	lw $t3, 0($t3)
	li $t2, 1000
	mul $t1, $t1, $t2
	add $t1, $t1, $t3
	li $t2, 4
	mul $t1, $t1, $t2
	la $t2, a_global
	add $t1, $t2, $t1
	sw $t0, 0($t1)
	addi $t0, $a0, 0
	lw $t0, 0($t0)
	add $v0, $t0, $zero
	j divide_global_end

divide_global_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra

qsort_global:
	li $t0, 36
	sub $sp, $sp, $t0
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	addi $t0, $a0, 0
	lw $t0, 0($t0)
	addi $t1, $a0, 4
	lw $t1, 0($t1)
	sge $t2, $t0, $t1
	beq $t2, $zero, qsort_global_endif_a
	li $t0, 0
	add $v0, $t0, $zero
	j qsort_global_end

qsort_global_endif_a:
	addi $t0, $a0, 0
	lw $t0, 0($t0)
	sw $t0, 12($sp)
	addi $t0, $a0, 4
	lw $t0, 0($t0)
	sw $t0, 16($sp)
	addi $a0, $sp, 12
	jal divide_global
	add $t0, $v0, $zero
	lw $a0, 4($sp)
	addi $t1, $sp, 8
	sw $t0, 0($t1)
	addi $t0, $a0, 0
	lw $t0, 0($t0)
	sw $t0, 20($sp)
	addi $t0, $sp, 8
	lw $t0, 0($t0)
	li $t1, 1
	sub $t2, $t0, $t1
	sw $t2, 24($sp)
	addi $a0, $sp, 20
	jal qsort_global
	add $t0, $v0, $zero
	lw $a0, 4($sp)
	addi $t0, $sp, 8
	lw $t0, 0($t0)
	li $t1, 1
	add $t2, $t0, $t1
	sw $t2, 28($sp)
	addi $t0, $a0, 4
	lw $t0, 0($t0)
	sw $t0, 32($sp)
	addi $a0, $sp, 28
	jal qsort_global
	add $t0, $v0, $zero
	lw $a0, 4($sp)
	li $t0, 0
	add $v0, $t0, $zero
	j qsort_global_end

qsort_global_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 36
	jr $ra

main:
	li $t0, 20
	sub $sp, $sp, $t0
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	la $t0, num_global
	add $a1, $v0, $zero
	li $v0, 5
	syscall
	sw $v0, 0($t0)
	add $v0, $a1, $zero
	li $t0, 0
	addi $t1, $sp, 8
	sw $t0, 0($t1)

main_for_cond_a:
	addi $t0, $sp, 8
	lw $t0, 0($t0)
	la $t1, num_global
	lw $t1, 0($t1)
	slt $t2, $t0, $t1
	beq $t2, $zero, main_for_end_a
	add $t0, $zero, $zero
	addi $t2, $sp, 8
	lw $t2, 0($t2)
	li $t1, 1000
	mul $t0, $t0, $t1
	add $t0, $t0, $t2
	li $t1, 4
	mul $t0, $t0, $t1
	la $t1, a_global
	add $t0, $t1, $t0
	add $a1, $v0, $zero
	li $v0, 5
	syscall
	sw $v0, 0($t0)
	add $v0, $a1, $zero

main_for_incr_a:
	addi $t0, $sp, 8
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	j main_for_cond_a

main_for_end_a:
	li $t0, 0
	sw $t0, 12($sp)
	la $t0, num_global
	lw $t0, 0($t0)
	li $t1, 1
	sub $t2, $t0, $t1
	sw $t2, 16($sp)
	addi $a0, $sp, 12
	jal qsort_global
	add $t0, $v0, $zero
	lw $a0, 4($sp)
	la $t0, num_global
	lw $t0, 0($t0)
	add $a1, $v0, $zero
	add $a2, $a0, $zero
	li $v0, 1
	add $a0, $t0, $zero
	syscall
	add $v0, $a1, $zero
	add $a0, $a2, $zero
	li $t0, 0
	addi $t1, $sp, 8
	sw $t0, 0($t1)

main_for_cond_b:
	addi $t0, $sp, 8
	lw $t0, 0($t0)
	la $t1, num_global
	lw $t1, 0($t1)
	slt $t2, $t0, $t1
	beq $t2, $zero, main_for_end_b
	add $t0, $zero, $zero
	addi $t2, $sp, 8
	lw $t2, 0($t2)
	li $t1, 1000
	mul $t0, $t0, $t1
	add $t0, $t0, $t2
	li $t1, 4
	mul $t0, $t0, $t1
	la $t1, a_global
	add $t0, $t1, $t0
	lw $t0, 0($t0)
	add $a1, $v0, $zero
	add $a2, $a0, $zero
	li $v0, 1
	add $a0, $t0, $zero
	syscall
	add $v0, $a1, $zero
	add $a0, $a2, $zero

main_for_incr_b:
	addi $t0, $sp, 8
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	j main_for_cond_b

main_for_end_b:
	li $t0, 0
	add $v0, $t0, $zero
	j main_end

main_end:
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra
