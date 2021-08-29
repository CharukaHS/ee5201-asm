%include "print.inc"
%include "input.inc"

section .data
  msg1 db "Index number is 3448", 0x0, 0xA
  msg1l equ $-msg1

  msg2 db "Dividing 8443 by 4, remainder is ", 0x0
  msg2l equ $-msg2

  msg3 db "Select an arithmatic operation (+,-,/,*) "
  msg3l equ $-msg3

  msg4 db "Wrong operation, should've typed - or / ", 0x0, 0xA
  msg4l equ $-msg4

  msgsub db "Subtracting...", 0x0, 0xA
  msgsubl equ $-msgsub

  msgdiv db "Dividing...", 0x0, 0xA
  msgdivl equ $-msgdiv

  txteq db "Equal to 50", 0x0, 0xA,
  txteql equ $-txteq

  txta db "Greater than 50", 0x0, 0xA,
  txtal equ $-txta

  txtb db "Less than 50", 0x0, 0xA,
  txtbl equ $-txtb

  nl db 0x0, 0xA
  nll equ $-nl

  var1 dq 34.48
  var2 dq 84.43
  rindex dq 8443
  fifty dq 50.00

section .bss
  op resb 1

section .text
global _start
_start:
  print msg1, msg1l
  print msg2, msg2l

  ; division
  mov al, [rindex]
  mov bl, '4'

  ; remove ascii offset
  sub al, '0'
  sub bl, '0'

  div bl  ; al = al / bl, remainder is in ah

  ; convert to ascii
  add ah, '0'

  ; print remainder
  mov [rindex], ah
  print rindex, 0x4
  call println

  ; get user input
  print msg3, msg3l
  scanf op, 0x1
  
  mov rbx, [op]
  ; check the input is -
  cmp rbx, 45
  je subtraction

  ; checkthe input is /
  cmp rbx, 47
  je division

  ; printing the error msg
  print msg4, msg4l

  call exit

subtraction:
  print msgsub, msgsubl

  finit ; floating point stack init
  fld qword[var2] ; ST0 = var2
  fsub qword[var1]  ; ST0 = var2 - var1

  call compare
  ret

division:
  print msgdiv, msgdivl;

  finit ; floating point stack init
  fld qword[var2] ; ST0 = var2
  fdiv qword[var1]  ; ST0 = var2 / var1

  call compare
  ret

compare:
  fcomp qword[fifty]  ;  compare ST0 with 50.0
  fstsw ax ; copy status word into given register
  sahf      ; copy value in ax to cpu
  je equal
  ja great  
  jb less
  ret

equal:
  print txteq, txteql
  call exit
  ret

great:
  print txta, txtal
  call exit
  ret

less:
  print txtb, txtbl
  call exit
  ret
  
println:
  ; print new line
  print nl, nll
  ret

exit:
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80
  ret
