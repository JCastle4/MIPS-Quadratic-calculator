#
# Name: Castillo Salas, Jason
# Project: 5
# Due: 12/8/2022
# Course: cs-2640-04-f22
#
# Description:
# program that prompts the user for the coefficients a, b, and c of a quadratic equation ax2 + bx + c = 0 and outputs the solutions as shown
#

	.data
header:	.asciiz	"Quadratic Equation Solver v0.1 by J. Castillo\n\n"
prompta:	.asciiz	"Enter value for a? "
promptb:	.asciiz	"Enter value for b? "
promptc:	.asciiz	"Enter value for c? "
prompti:	.asciiz	"Roots are imaginary."
promptz:	.asciiz	"Not a quadratic equation."
x:	.asciiz	"x = "
xa:	.asciiz	"x1 = "
xb:	.asciiz	"\nx2 = "
xx:	.asciiz	" x^2 + "
bx:	.asciiz	" x + "
zer:	.asciiz	" = 0\n"
newline:	.asciiz	"\n"
a:	.float	0.0
bl:	.float	0.0
c:	.float	0.0
	.text
main:

	la	$a0, header
	li	$v0, 4
	syscall

	la 	$a0, prompta
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	s.s	$f0, a

	la 	$a0, promptb
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	s.s	$f0, bl

	la 	$a0, promptc
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	s.s	$f0, c

	l.s	$f12, a
	l.s	$f13, bl
	l.s	$f14, c

	la	$a0, newline
	li	$v0, 4
	syscall

	jal	quadeq

	move	$t1, $v0

	l.s	$f4, a
	l.s	$f5, bl
	l.s	$f6, c

	mov.s	$f12, $f4
	li	$v0, 2
	syscall
	la	$a0, xx
	li	$v0, 4
	syscall
	mov.s	$f12, $f5
	li	$v0, 2
	syscall
	la	$a0, bx
	li	$v0, 4
	syscall
	mov.s	$f12, $f6
	li	$v0, 2
	syscall
	la	$a0, zer
	li	$v0, 4
	syscall
	move	$v0, $t1


	addi	$v0, $v0, 1
	beqz	$v0, imaginary
	addi	$v0, $v0, -1
	beqz	$v0, zero
	addi	$v0, $v0, -1
	beqz	$v0, one
	addi	$v0, $v0, -1
	beqz	$v0, two	

	li	$v0, 10
	syscall

imaginary:
	la	$a0, prompti
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall
zero:
	la	$a0, promptz
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall	
one:
	la	$a0, x
	li	$v0, 4
	syscall
	mov.s	$f12, $f0
	li	$v0, 2
	syscall

	li	$v0, 10
	syscall	
two:
	la	$a0, xa
	li	$v0, 4
	syscall
	mov.s	$f12, $f0
	li	$v0, 2
	syscall
	la	$a0, xb
	li	$v0, 4
	syscall
	mov.s	$f12, $f1
	li	$v0, 2
	syscall

	li	$v0, 10
	syscall	
quadeq:
	li.s	$f4, 0.0
	c.eq.s	$f12, $f4		#a==0 true 
	bc1t	azero
				#a!=0
	mul.s	$f6,$f13,$f13	#b^2
	mul.s	$f5,$f12,$f14
	li.s	$f11, 4.0
	mul.s	$f5, $f5, $f11	#4ac
	sub.s	$f6, $f6, $f5	#f6 == d

	c.lt.s	$f6, $f4
	bc1f	dfalse
	li	$v0, -1
	jr	$ra

azero:	
	c.eq.s	$f13, $f4		#a==0 && b==0
	bc1f	aelse	
	li	$v0, 0
	jr	$ra
aelse:				#a==0 && b!=0
	li.s	$f11, -1.0
	mul.s	$f5, $f14, $f11
	div.s	$f0, $f5, $f13
	li	$v0, 1
	jr	$ra

dfalse:
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)
	addiu	$sp, $sp, -4
	s.s	$f12, ($sp)
	mov.s	$f12, $f6
	jal	sqrts
	mov.s	$f7, $f0
	l.s	$f12, ($sp)	
	addiu	$sp, $sp, 4
	lw	$ra, ($sp)
	addiu	$sp, $sp, 4

	#sqrt.s	$f7, $f6		#sqrt(b^2 - 4ac)
	li.s	$f11, -1.0
	mul.s 	$f8, $f13, $f11	#-b
	li.s	$f11, 2.0
	mul.s 	$f9, $f12, $f11	#2a
	add.s	$f0, $f8, $f7
	div.s	$f0, $f0, $f9	#x1
	sub.s	$f1, $f8, $f7
	div.s	$f1, $f1, $f9	#x2
	li	$v0, 2
	jr	$ra

sqrts:
	sqrt.s	$f0, $f12	
	jr	$ra