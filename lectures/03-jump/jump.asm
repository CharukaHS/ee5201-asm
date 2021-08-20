section .data
  meq db "RAX values is equal to  1", 0xA, 0x0
  smeq equ $-meq

  mneq db "RAX values is not equal to  1", 0xA, 0x0
  smneq equ $-mneq

section .text
global _start
_start:
  mov rax, 0  ; change here
  cmp rax, 1  ; comparing
  je label1   ; jump to label 1 if rax==1
  jne label2  ; jump to label 2 if rax!=1

label1:
  mov rax, 0x4
  mov rbx, 0x1
  mov rcx, meq
  mov rdx, smeq
  int 0x80
  jmp exit

label2:
  mov rax, 0x4
  mov rbx, 0x1
  mov rcx, mneq
  mov rdx, smneq
  int 0x80
  jmp exit

exit:
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80
