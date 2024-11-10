DEVICE     = atmega328p
CLOCK      = 16000000L
AVR_GCC    = $(AVR_BIN)/avr-gcc
AVR_OBJCPY = $(AVR_BINUTIL)/avr-objcopy
AVR_SIZE   = $(AVR_BINUTIL)/avr-size
AVR_OBJDMP = $(AVR_BINUTIL)/avr-objdump

BIN_DIR    = bin
LNK_DIR    = linker
CODE_DIRS  = ./src
INC_DIRS  = ./include

CC=$(AVR_GCC)
OPT=-Os -flto
DEPFLAGS=-MP -MD
DEFINE_FLAGS=-DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

CFLAGS=-Wall $(foreach D,$(INC_DIRS),-I$(D)) $(OPT) $(DEPFLAGS) $(DEFINE_FLAGS) 

CFILES=$(foreach D,$(CODE_DIRS),$(wildcard $(D)/*.c))

OBJECTS=$(patsubst %.c,%.o,$(CFILES))
DEPFILES=$(patsubst %.c,%.d,$(CFILES))

all:	$(BIN_DIR)/main.hex

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(DEPFILES) $(BIN_DIR)/main.hex $(BIN_DIR)/main.elf $(BIN_DIR)/main.hex.dump $(BIN_DIR)/main.elf.dump $(OBJECTS)

$(BIN_DIR)/main.elf: $(OBJECTS)
	$(CC) -mrelax -flto -nostartfiles -Wl,-T $(LNK_DIR)/linker.ld -Wl,--section-start=.text=0x7E00 -o $(BIN_DIR)/main.elf $(OBJECTS)

$(BIN_DIR)/main.hex: $(BIN_DIR)/main.elf
	rm -f bin/main.hex
	$(AVR_OBJCPY) -j .text -j .data -O ihex $(BIN_DIR)/main.elf $(BIN_DIR)/main.hex
	$(AVR_SIZE) bin/main.elf

disasm:	$(BIN_DIR)/main.hex.dump $(BIN_DIR)/main.elf.dump

$(BIN_DIR)/main.hex.dump: $(BIN_DIR)/main.hex
	$(AVR_OBJDMP) -D -s -m avr5 --no-addresses --no-show-raw-insn $(BIN_DIR)/main.hex > $(BIN_DIR)/main.hex.dump

$(BIN_DIR)/main.elf.dump: $(BIN_DIR)/main.elf
	$(AVR_OBJDMP) -D -s -m avr5 --no-addresses --no-show-raw-insn $(BIN_DIR)/main.elf > $(BIN_DIR)/main.elf.dump

-include $(DEPFILES)
