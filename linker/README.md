## Why Do We Need A Custom Linker Script?

We need our bootloader program to start at a specific program memory location without any intermediary jumps. A bootloader program for atmega328p chip can start at a memory location like `0x7e00`. So my entry point should exactly start there.

I accomplish that with this:
1- Create a custom section name in the linker file. `.text.my_bootloader`.
2- Set an attribute on my entry-point function (`bootloader_func`) that sets its section to `.text.my_bootloader`
3- Modify the `.text` merge bit of the linker script like this so `.text.my_bootloader` section comes before other `.text` sections.
```
    *(.text.my_bootloader)
    . = ALIGN(2);
    *(.text)
    . = ALIGN(2);
    *(.text.*)
    . = ALIGN(2);
```
4- Give a linker argument to the linking stage at the build command that specifies where the `.text` section of the final executable shall start. (Makefile)
```
    $(CC) $(LNK_OPT) -Wl,-T $(LNK_DIR)/linker.ld -Wl,--section-start=.text=0x7E00 -o $(BIN_DIR)/main.elf $(OBJECTS)
```

This way I ensure that the first instruction of `bootloader_func` is written to the bootloader reset address which is typically `0x7e00` for this project.