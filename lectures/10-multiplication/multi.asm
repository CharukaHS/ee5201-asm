; only single digit
%include "print.inc"

section .data
  n1 db '3'
  n2 db '3'

section .bss
  result resb 2

section .text
global _start
_start:
  mov al, [n1]
  sub al, '0'

  mov bl, [n2]
  sub bl, '0'

  mul bl            ; al = al * bl

  add al, '0'

  mov [result], al
  print result, 2

  mov rax, 0x1
  mov rbx, 0x0
  int 0x80