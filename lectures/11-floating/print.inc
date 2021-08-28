%macro print 2
  mov rax, 0x4
  mov rbx, 0x1
  mov rcx, %1
  mov rdx, %2
  int 0x80
%endmacro