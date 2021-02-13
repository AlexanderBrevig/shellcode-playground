CC=gcc
CFLAGS=-m32 -w
CFLAGS64=-m64 -fno-stack-protector -z execstack -w

AS=nasm #Assembly compiler
ASFLAGS=-f elf -g #Assembly flags
ASFLAGS64=-f elf64 -g #Assembly flags

LD=ld #Linker
LDFLAGS=-m elf_i386 #Linker flags
LDFLAGS64=-m elf_x86_64 #Linker flags

SRC=$(wildcard *.asm) #Sources
OBJECTS=$(SRC:.asm=.o) #Object files
ASMPROGS=$(SRC:.asm=)

SRC64=$(wildcard *.asm64) #Sources
OBJECTS64=$(SRC64:.asm64=.o64) #Object files
ASMPROGS64=$(SRC64:.asm64=)

CSRC=$(wildcard *.c)
CPROGS=$(CSRC:.c=)
CPROGS64=$(CSRC:.c=64)

all: $(ASMPROGS) $(CPROGS) $(ASMPROGS64)

clean:
	rm -rf *o 
	rm -rf *o64

$(OBJECTS) : $(SRC)
	$(AS) $(ASFLAGS) $< -o $@

$(ASMPROGS) : $(OBJECTS)
	$(LD) $(LDFLAGS) $@.o -o bin/$@

$(OBJECTS64) : $(SRC64)
	$(AS) $(ASFLAGS64) $< -o $@

$(ASMPROGS64) : $(OBJECTS64)
	$(LD) $(LDFLAGS64) $^ -o bin/$@

$(CPROGS) : $(CSRC)
	$(CC) $(CFLAGS) $@.c -o bin/$@
	$(CC) $(CFLAGS64) $@.c -o bin/$@64

.PHONY: raw
raw:
	$(foreach src, $(ASMPROGS),: && printf $(src) && printf '\t\\x' && objdump -d bin/$(src) | grep "^ " | cut -f2 | tr -d ' ' | tr -d '\n' | sed 's/.\{2\}/&\\x /g'| head -c-3 | tr -d ' ' && echo ' ' && printf '\n')
	$(foreach src, $(ASMPROGS64),: && printf $(src) && printf '\t\\x' && objdump -d bin/$(src) | grep "^ " | cut -f2 | tr -d ' ' | tr -d '\n' | sed 's/.\{2\}/&\\x /g'| head -c-3 | tr -d ' ' && echo ' ' && printf '\n')
