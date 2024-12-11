DEVICE     = atmega328p
CLOCK      = 16000000L
AVR_OBJCPY = $(AVR_BINUTIL)/avr-objcopy
AVR_SIZE   = $(AVR_BINUTIL)/avr-size
AVR_OBJDMP = $(AVR_BINUTIL)/avr-objdump

BIN_DIR    = bin
LNK_DIR    = linker
CODE_DIRS  = ./src
INC_DIRS   = ./include

OPT=-Os -flto
LNK_OPT=-mrelax -nostartfiles 
DEPFLAGS=-MP -MD
DEFINE_FLAGS=-DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

CFLAGS=-Wall $(foreach DIR,$(INC_DIRS),-I$(DIR)) $(OPT) $(DEPFLAGS) $(DEFINE_FLAGS)

CFILES=$(foreach DIR,$(CODE_DIRS),$(wildcard $(DIR)/*.c))

OBJECTS=$(patsubst %.c,%.o,$(CFILES))
DEPFILES=$(patsubst %.c,%.d,$(CFILES))

DUMPS=$(patsubst %.o,%.dump,$(OBJECTS))

all: $(BIN_DIR)/main.hex

$(BIN_DIR)/main.hex: $(BIN_DIR)/main.elf
	rm -f bin/main.hex
	$(AVR_OBJCPY) -j .text -j .data -O ihex $(BIN_DIR)/main.elf $(BIN_DIR)/main.hex
	$(AVR_SIZE) bin/main.elf

$(BIN_DIR)/main.elf: $(OBJECTS)
	$(CC) $(LNK_OPT) -Wl,-T$(LNK_DIR)/linker.ld -o $(BIN_DIR)/main.elf $(OBJECTS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(DEPFILES) $(BIN_DIR)/main.hex $(BIN_DIR)/main.elf $(BIN_DIR)/main.hex.dump $(BIN_DIR)/main.elf.dump $(OBJECTS) $(DUMPS)

disasm:	$(BIN_DIR)/main.hex.dump $(BIN_DIR)/main.elf.dump $(DUMPS)

$(BIN_DIR)/main.hex.dump: $(BIN_DIR)/main.hex
	$(AVR_OBJDMP) -D -s -m avr5 $(BIN_DIR)/main.hex > $(BIN_DIR)/main.hex.dump

$(BIN_DIR)/main.elf.dump: $(BIN_DIR)/main.elf
	$(AVR_OBJDMP) -D -s -m avr5 $(BIN_DIR)/main.elf > $(BIN_DIR)/main.elf.dump

%.dump: %.o
	$(AVR_OBJDMP) -D -s -m avr5 $< > $@

-include $(DEPFILES)
