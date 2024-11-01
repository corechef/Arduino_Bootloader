## What Is This?

This is the binary hex file output of this project compiled with `avr-gcc` version 9.4.0 on MacOS. 

## Why Is It Included In the Repository?

It is used as a reference for future builds, if there is a change between the output hex file of a new build and this, we can deduce there is an effective change and it needs to be investigated.

### How to Investigate Diff?

To view diff between hex files:

1- `objdump` the reference one:
```
${AVR_BINUTIL}/avr-objdump -D -s -m avr5 --no-addresses --no-show-raw-insn bin/9.4.0/bootloader.hex > bin/9.4.0/bootloader.hex.dump
```
#### Caution
In case your objdump version does not support `--no-addresses` and `--no-show-raw-insn`, run the command without those parameters. When you run the above command, `objdump` will let you know if it does not support the flags. Purpose of these flags is to make it easier to see meaningful diffs between the two objdump files.
```
${AVR_BINUTIL}/avr-objdump -D -s -m avr5 bin/9.4.0/bootloader.hex > bin/9.4.0/bootloader.hex.dump
```


2- `objdump` the new one:
```
${AVR_BINUTIL}/avr-objdump -D -s -m avr5 --no-addresses --no-show-raw-insn ./bin/main.hex > ./bin/main.hex.dump
```
#### Caution
In case your objdump version does not support `--no-addresses` and `--no-show-raw-insn`, run the command without those parameters. When you run the above command, `objdump` will let you know if it does not support the flags. Purpose of these flags is to make it easier to see meaningful diffs between the two objdump files.
```
${AVR_BINUTIL}/avr-objdump -D -s -m avr5 ./bin/main.hex > ./bin/main.hex.dump
```

`make disasm` command can be helpful for this.

3- `diff` the two objdump files, or put the two objdumps to a diffchecker program of your choice, and investigate binary changes.
```
diff ./bin/main.hex.dump bin/9.4.0/bootloader.hex.dump
```

