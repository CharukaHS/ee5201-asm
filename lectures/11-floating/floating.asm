%include "print.inc"

section .data
  data1 dq 11.33
  data2 dq 13.67
  data3 dq 25.00

  txteq db "Equal", 0x0, 0xA,
  txteql equ $-txteq

  txta db "Above", 0x0, 0xA,
  txtal equ $-txta

  txtb db "Below", 0x0, 0xA,
  txtbl equ $-txtb

section .text
global _start
_start:
  finit     ; floating point stack init (ST0 - ST7 registers)
  fld qword[data1]  ; load  data1 to the top of fpstack, ST0 = data1
  fadd qword[data2] ;  ST0 = ST0 + data2

  fcomp qword[data3]  ;  compare ST0 with data3
  fstsw ax  ; copy status word into given register
  sahf      ; copy value in ax to cpu
  je equal
  ja great  
  jb less

equal:
  print txteq, txteql
  call exit

great:
  print txta, txtal
  call exit

less:
  print txtb, txtbl
  call exit

exit:
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80
  ret