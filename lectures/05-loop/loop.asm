section .data
  hello db "Hello World", 0xA, 0x0
  size equ $-hello

section .text
global _start
_start:
  mov rsi, 0  ; i

  call loop
  call exit

loop:
  mov rax, 0x4
  mov rbx, 0x1
  mov rcx, hello
  mov rdx, size
  int 0x80
  inc rsi     ; increment

  ; check i < 10
  cmp rsi, 10
  jl loop
  
  ret

exit:
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80
