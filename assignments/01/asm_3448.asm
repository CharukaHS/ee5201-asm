%include "input.inc"
%include "print.inc"

section .data
  ; user prompt
  msg db "Enter the index number (4 digits) : ", 0x0 
  s_msg equ $-msg

  ; new line
  ln db 0xA, 0x0

  ; greeting message
  msggreet db "Hello :D ", 0x0, 0xA
  s_msggreet equ $-msggreet

  ; index message
  msgvar1 db "Your index number is ", 0x0
  s_msgvar1 equ $-msgvar1

  ; reverse index message
  msgvar2 db "Your index number in reverse is ", 0x0
  s_msgvar2 equ $-msgvar2

  ; remainder message
  msgremain db "Remainder of dividing your index number by two is ", 0x0
  s_msgremain equ $-msgremain

  ; addition message
  msgadd db "Choosing addition as the operation", 0xA, 0x0
  s_msgadd equ $-msgadd

  ; addition result
  msgaddres db "Addition of variables is ", 0x0
  s_msgaddres equ $-msgaddres

  ; subtraction message
  msgsub db "Choosing subtraction as the operation", 0xA, 0x0
  s_msgsub equ $-msgsub

  ; subtraction result
  msgsubres db "Magnitude of variable subtraction is ", 0x0
  s_msgsubres equ $-msgsubres

  ; character request
  msgchar db "Enter a character ", 0x0
  s_msgchar equ $-msgchar

  ; char is a digit
  msgisdigit db "Character is a digit", 0xA, 0x0
  s_msgisdigit equ $-msgisdigit

  ; char is not a digit
  msgisnotdigit db "Character is not a digit", 0xA, 0x0
  s_msgisnotdigit equ $-msgisnotdigit

  ; digit is even
  msgiseven db "Digit is even", 0xA, 0x0
  s_msgiseven equ $-msgiseven

  ; digit is odd
  msgisodd db "Digit is odd", 0xA, 0x0
  s_msgisodd equ $-msgisodd

section .bss
  var1 resb 4 ; index number
  var2 resb 4 ; index number in reverse
  issub resb 1  ; hold remainder to determine addition or subtraction
  temp resb 5 ; temp 4bit storage for calculations
  highest resb 4  ; store highest of var1 or var2
  lowest resb 4   ; store lowest of var1 or var2
  userchar resb 1 ; user input character
  userd resb 1  ; store remainder when finding odd even

section .text
global _start
_start:
  ; request users index number
  print msg, s_msg

  ; read index number
  scanf var1, 0x5

  ; reverse the index number, save in var2
  mov rsi, 0x0  ; cursor set at the start of the string
  mov rdi, 0x3  ; cursor set at the end of the string
  
reverse:
  mov rax, [var1+rdi] ; move var1[n-i] to rax
  mov [var2+rsi], rax ; move rax to var2[i]

  inc rsi ; increment start cursor
  dec rdi ; increment end cursor
  
  cmp rsi, 0x4  ; rsi == 4 means, all digits are reversed
  jl reverse  ; loop

print_greetings:
  print msggreet, s_msggreet

printing_reversing_results:
  ; print index
  print msgvar1, s_msgvar1
  print var1, 4
  print ln, 1

  ; print index in reverse
  print msgvar2, s_msgvar2
  print var2, 4
  print ln, 1

dividing_by_2:
  mov al, [var1+0x3]  ; move last digit of index to al
  mov bl, '2' ; divide by

  ; remove ascii thing
  sub al, '0' 
  sub bl, '0'

  div bl  ; al = al / bl

  ; remainder is saved in ah
  add ah, '0'
  mov [issub], ah

  ; print the remainder
  print msgremain, s_msgremain
  print issub, 1
  print ln, 1

select_operation:
  mov ah, [issub]
  cmp ah, '1'
  jge subtraction

addition:
  print msgadd, s_msgadd ; print decision

  ; temp is 5 bit, hiding 5th bit to avoid printing random values
  ; when the addition result is 4bits
  mov ah, 0x0
  mov [temp], ah

  mov rsi, 0x3 ; no of digits - 1
  mov cl, 0x0  ; store carrier bit

add_loop:
  mov al, [var1+rsi] ; al = var1[rsi]
  mov bl, [var2+rsi]  ; bl = var2[rsi]

  sub al, 48  ; to remove ascii offset, chr(48)==0

  add al, bl  ;  al = al + bl
  add al, cl  ; add carrier value

  mov cl, 0x0 ; reset carrier bit

  cmp al, 58  ; check al is greater than 9 in ascii value
  jge add_overflow

add_save:
  mov [temp+rsi+1], al

  dec rsi

  cmp rsi, 0x0
  jge add_loop

  cmp cl, 1
  jne add_print

  ; if cl==1 after 4 iterations that means sum is 5 digits
  ; temp[0] = 1
  mov cl, '1'
  mov [temp], cl

add_print:
  print msgaddres, s_msgaddres
  print temp, 0x5
  print ln, 1

  jmp prompt_char

add_overflow:
  sub al, 10  ; make al a single digit
  mov cl, 1 ; carrier bit = 1
  jmp add_save


subtraction:
  print msgsub, s_msgsub ; print decision

  mov rsi, 0x3 ; no of digits - 1
  mov cl, 0x0 ; store carrier bit

  mov rax, [var1]
  mov rbx, [var2]

  ; dealing with negative results with a little trick.
  ; if var2 is larger than var1, the result is negative
  ; so, to avoid negative values in subtraction always subtract from the highest value
  ; from var1 and var2, highest value should move to "highest" variable
  ; when (var1 < var2), ch registry updates to 1, other times its 0
  ; must be an inefficient method. but ...

  cmp rax, [var2]
  jl sub_swap ; if var1 < var2
  
  ; assign highest and lowest
  mov [highest], rax
  mov [lowest], rbx

sub_loop:
  mov al, [highest+rsi] ; al = highest[rsi]
  mov bl, [lowest+rsi]  ; bl = lowest[rsi]

  sub al, bl  ; al = al - bl
  sub al, cl  ; subtract carrier bit value
  
  mov cl, 0x0 ; reset carrier registry

  cmp al, 0 ; if al is lower than 0
  jl sub_overflow

sub_save:
  add al, 48  ; convert to ascii table value
  mov [temp+rsi], al  ; saves to temp variable

  dec rsi ; decrement counter

  cmp rsi, 0x0  ; check loop is finished
  jge sub_loop

  ; printing results
  print msgsubres, s_msgsubres

  print temp, 0x4
  print ln, 1

  jmp prompt_char

sub_overflow:
  add al, 10
  mov cl, 1
  jmp sub_save

sub_swap:
  mov [highest], rbx
  mov [lowest], rax
  jmp sub_loop

prompt_char:
  print msgchar, s_msgchar  ; print enter character

  scanf userchar, 0x2 ; prompt user input

  mov dh, [userchar]

  cmp dh, 48
  jl notadigit

  cmp dh, 57
  jg notadigit

  ; if a digit is even, its ascii value is also even
  mov al, [userchar]
  mov bl, '2'

  ; remove ascii thing
  sub al, '0' 
  sub bl, '0'

  div bl  ; al = al / bl

  ; remainder is saved in ah
  add ah, 48

  cmp ah, 49
  jge isodd
  jmp iseven

iseven:
  print msgiseven, s_msgiseven
  call exit

isodd:
  print msgisodd, s_msgisodd
  call exit

notadigit:
  print msgisnotdigit, s_msgisnotdigit
  call exit


exit:
  mov rax, 0x1
  mov rbx, 0x0
  int 0x80