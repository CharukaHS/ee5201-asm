%include "print.inc"
section .data
  message db "Hello", 0xa, 0x0
  size equ $-message

section .text
global _start
_start:
  print message, size, 5
  call exit

exit:
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80