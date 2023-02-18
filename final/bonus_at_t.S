/*
 * Don't forget to include "positions.h"
 */
#include "positions.h"

.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl 	%ebp
	movl	%esp, %ebp
	pushal	
	movl 	0x8(%ebp), 	%esi/* v1 */
	movl 	0xc(%ebp), 	%edi/* v2 */
	movl 	0x10(%ebp), %ecx/* n */
	movl 	0x14(%ebp), %ebx/* v */
add_loop:	/* adunam cei 2 vectori */
	movl 	(%esi), %eax	/* v1 */
	addl 	$4, %esi
	addl 	(%edi), %eax	/* v1 + v2 */
	addl 	$4, %edi
	movl 	%eax, (%ebx)	/* v = v1 + v2 */
	addl 	$4, %ebx
	loopl 	add_loop

	movl 	0x10(%ebp), %ecx/* n */
	movl 	0x14(%ebp), %ebx/* v */
first_pos:	/* scadem prima valoare */
	movl  	$FIRST_POSITION, %eax
	imul 	%ecx		/* n */
	xorl 	%edx, %edx
	movl	$10, %ecx
	idivl 	%ecx /* pozitia relativa = pozitia reala * n / 10 */
	subl	$FIRST_VALUE,(%ebx, %eax, 0x4)

	movl 	0x10(%ebp), %ecx/* n */
second_pos:	/* scadem a doua valoare */
	movl  	$SECOND_POSITION, %eax
	imul 	%ecx		/* n */
	xorl 	%edx, %edx
	movl	$10, %ecx
	idivl 	%ecx /* pozitia relativa = pozitia reala * n / 10 */
	subl	$SECOND_VALUE,(%ebx, %eax, 0x4)

	movl 	0x10(%ebp), %ecx/* n */
third_pos:	/* scadem a treia valoare */
	movl  	$THIRD_POSITION, %eax
	imul 	%ecx		/* n */
	xorl 	%edx, %edx
	movl	$10, %ecx
	idivl 	%ecx /* pozitia relativa = pozitia reala * n / 10 */
	subl	$THIRD_VALUE,(%ebx, %eax, 0x4)


	popal
	leave
	ret
