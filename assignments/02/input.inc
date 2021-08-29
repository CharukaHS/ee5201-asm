%macro scanf 2
  mov rax, 0x3
  mov rbx, 0x0
  mov rcx, %1
  mov rdx, %2
  int 0x80
%endmacro