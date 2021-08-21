%include "print.inc"

section .data
  n1 db '12516'           ; digit 1
  n2 db '48478'           ; digit 2

section .bss
  sum resb 5              ; to save the sum

section .text
global _start
_start:
  mov rsi, 0x4            ; no. of digits - 1
  mov cl, 0x0             ; to store carrier bit

loop:
  mov al, [n1+rsi]        ; get the n1[rsi] to registry
  mov bl, [n2+rsi]        ; get the n2[rsi] to registry
  
  sub al, 48              ; subtract 48 to remove ascii offset

  add al, bl              ; al = al + bl
  add al, cl              ; add carrier bit value to al

  mov cl, 0x0             ; reset carrier bit registry

  cmp al, 58              ; check al is greater than 9 in ascii table
  jge overflow

savetoresult:
  mov [sum+rsi], al       ; result[rsi] = al

  dec rsi
  
  cmp rsi, 0x0            ; if rsi == 0
  jge loop                ; loop again

  print sum, 5            ; print answer
  call exit               ; exit


overflow:
  sub al, 10              ; make al single digit
  mov cl, 1               ; carrier bit = 1
  jmp savetoresult

exit:
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80
