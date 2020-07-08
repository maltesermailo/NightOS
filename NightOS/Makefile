# OS Build File
CFLAGS ?=-ffreestanding -mcmodel=large -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -g
LDFLAGS ?=-ffreestanding -O2 -nostdlib -z max-page-size=0x1000
NASM = nasm
BUILDDIR=build
CC=x86_64-elf-gcc

ARCHDIR=kernel/arch/amd64

.PHONY: all clean install install-headers install-kernel

PROJDIRS := kernel

SRCFILES := $(shell find $(PROJDIRS) -type f -name "*.c")
ASMSRCFILES := $(shell find $(PROJDIRS) -type f -name "*.s")
HDRFILES := $(shell find $(PROJDIRS) -type f -name "*.h")
OBJFILES := $(patsubst %.c,%.o,$(SRCFILES))
ASMOBJFILES := $(patsubst %.s,%.s.o,$(ASMSRCFILES))

kernel.bin: $(OBJFILES) $(ASMOBJFILES)
	@echo $(ASMOBJFILES)
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(LDFLAGS) $(OBJFILES) $(ASMOBJFILES) -lgcc
	
%.o: %.c
	@$(CC) $(CFLAGS) -c $< -o $@

$(ARCHDIR)/start.s.o: $(ARCHDIR)/start.s
	@$(NASM) -f elf64 -g -F dwarf $< -o $@ 

%.s.o: %.s
	@$(NASM) -f elf64 -g -F dwarf $< -o $@ 

clean:
	-@$(RM) $(shell find . -type f -name "*.o")