section .data
  message db "Enter your name", 0xA, 0x0
  s_message equ $-message

  greetings db "Hello ", 0x0
  s_greetings equ $-greetings

section .bss
  name resb 40

section .text
global _start
_start:
  ; Promote user input
  mov rax, 0x4
  mov rbx, 0x1
  mov rcx, message
  mov rdx, s_message
  int 0x80

  ; Get user input
  mov rax, 0x3
  mov rbx, 0x0
  mov rcx, name
  mov rdx, 40
  int 0x80

  ; Print greetings
  mov rax, 0x4
  mov rbx, 0x1
  mov rcx, greetings
  mov rdx, s_greetings
  int 0x80

  ; Print name
  mov rax, 0x4
  mov rbx, 0x1
  mov rcx, name
  mov rdx, 40
  int 0x80

  ; exit
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80
