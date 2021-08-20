%include "print.inc"

section .data
  message db "Enter a character ", 0x0
  size equ $-message

  dm db "Digit", 0xA, 0x0
  sdm equ $-dm

  ndm db "Not a digit", 0xA, 0x0
  sndm equ $-ndm

section .bss
  c resb 1

section .text
global _start
_start:
  ; print prompt
  print message, size

  ; get input
  mov rax, 0x3
  mov rbx, 0x0
  mov rcx, c
  mov rdx, 1
  int 0x80

  ; move input value to registry
  mov rbx, [c]

  ; ascii value of a digit is between 48-57
  cmp rbx, 48
  jl notadigit

  cmp rbx, 57
  jg notadigit

  ; not between 48-57
  call adigit;

notadigit:
  print ndm, sndm
  call exit;

adigit:
  print dm, sdm
  call exit;

exit:
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80