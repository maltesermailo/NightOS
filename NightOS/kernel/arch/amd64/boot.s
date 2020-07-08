section .text

start:
	cli

	extern kernel_main
	call kernel_main

	cli
.hang:	hlt
	jmp .hang