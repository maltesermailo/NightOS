ENTRY(_start)

KERNEL_LMA = 1M;
KERNEL_VMA = 0xffffff0000000000;

SECTIONS
{
    . = KERNEL_LMA;

    .multiboot :
    {
        *(.multiboot)
        . = ALIGN(4096);
    }

    .bootstrap :
    {
        kernel/arch/amd64/start.s.o (.text)
        kernel/arch/amd64/start.s.o (.bss)
    }

    _bootstrap_end = .;

    . = KERNEL_VMA;

    .text : AT(ADDR(.text) + _bootstrap_end - KERNEL_VMA)
    {
        _code = .;
        kernel/arch/amd64/boot.s.o (.text)
        *(EXCLUDE_FILE(*kernel/arch/amd64/start.s.o) .text)
        *(.rodata*)
        . = ALIGN(4096);
    }

   .data : AT(ADDR(.data) + _bootstrap_end - KERNEL_VMA)
   {
        _data = .;
        *(.data)
        . = ALIGN(4096);
   }

   .eh_frame : AT(ADDR(.eh_frame) + _bootstrap_end - KERNEL_VMA)
   {
       _ehframe = .;
       *(.eh_frame)
        . = ALIGN(4096);
   }

   .bss : AT(ADDR(.bss) + _bootstrap_end - KERNEL_VMA)
   {
       _bss = .;
       *(EXCLUDE_FILE(*kernel/arch/amd64/start.s.o) .bss)

       /*
        * You usually need to include generated COMMON symbols
        * under kernel BSS section or use gcc's -fno-common
        */

        *(COMMON)
       . = ALIGN(4096);
   }

   _end = .;

   /DISCARD/ :
   {
        *(.comment)
   }
}