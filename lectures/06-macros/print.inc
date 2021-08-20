%macro print 3
  mov rsi, 0

loop:
  mov rax, 0x4
  mov rbx, 0x1
  mov rcx, %1
  mov rdx, %2
  int 0x80

  inc rsi

  cmp rsi, %3
  jl loop
%endmacro