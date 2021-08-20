section .data
  message db "Hello World!", 0xA, 0x0
  size equ $-message

section .text
global _start
_start:
  ; printing message
  mov rax, 0x4
  mov rbx, 0x1,
  mov rcx, message
  mov rdx, size
  int 0x80

  ; exit
  mov rax, 1
  mov rbx, 0
  int 0x80