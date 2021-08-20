
section .data

section .bss
  digit resb 1

section .text
global _start
_start:
  mov rbx, '65'       ;' ' is required, unless it will convert to relavant ascii code (A)
  mov [digit], rbx
  
  mov rax, 0x4
  mov rbx, 0x1
  mov rcx, digit
  mov rdx, 1
  int 0x80

exit:
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80