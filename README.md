# Arduino_Bootloader
A Minimal bootloader implementation for Arduino Uno and Arduino Nano which uses atmega328p chip

# Table of Contents
- [Arduino_Bootloader](#arduino_bootloader)
- [How To Build](#how-to-build)
  - [Prerequisites](#prerequisites)
    - [`avr-gcc` package](#avr-gcc-package)
    - [`avr-binutils` package](#avr-binutils-package)
    - [`make` utility](#make-utility)
  - [Compile](#compile)
  - [Clean](#clean)
  - [Compile and Disassemble](#compile-and-disassemble)
- [How To Burn Bootloader to atmega328p (Arduino Uno/Nano)](#how-to-burn-bootloader-to-atmega328p-arduino-unonano)
  - [Prerequisites](#prerequisites-1)
    - [`avrdude` package](#avrdude-package)
    - [Arduino Must Be Plugged Into a USB port](#arduino-must-be-plugged-into-a-usb-port)
  - [Uploading Program](#uploading-program)
- [IDE Configuration](#ide-configuration)
  - [Include Directory](#include-directory)
  - [C Defines](#c-defines)

## How To Build

### Prerequisites
#### `avr-gcc` package
  * On macOS, install via `brew install avr-gcc`
  * On macOS, learn `${AVR_BIN}` directory via `brew ls avr-gcc`
    * <details> <summary>Example output</summary>
     
      ```
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/avr/include/ (293 files)
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/avr/lib/ (618 files)
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-c++
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-cpp
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-g++
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc-9.4.0
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc-ar
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc-nm
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc-ranlib
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcov
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcov-dump
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcov-tool
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-man
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/lib/avr-gcc/ (791 files)
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/libexec/gcc/ (13 files)
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/sbom.spdx.json
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/share/doc/ (20 files)
        /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/share/man/ (6 files)
      ```
      
    </details>
    
    * Example `${AVR_BIN}`: `/opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin`
  * Alternatively, you can download an avr toolchain and download it for your environment via a search engine.
    * `${AVR_BIN}` configuration is similar, just point it to the `bin` directory which contains `avr-gcc` executable.

#### `avr-binutils` package
  * On macOS, install via `brew install avr-binutils`
  * On macOS, learn `${AVR_BINUTIL}` directory via `brew ls avr-binutils`
    * <details> <summary>Example output</summary>
     
      ```
        /opt/homebrew/Cellar/avr-binutils/2.42/avr/bin/ (10 files)
        /opt/homebrew/Cellar/avr-binutils/2.42/avr/lib/ (121 files)
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-addr2line
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-ar
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-as
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-c++filt
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-elfedit
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-gprof
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-ld
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-ld.bfd
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-nm
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-objcopy
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-objdump
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-ranlib
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-readelf
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-size
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-strings
        /opt/homebrew/Cellar/avr-binutils/2.42/bin/avr-strip
        /opt/homebrew/Cellar/avr-binutils/2.42/lib/avr/bfd-plugins/libdep.so
        /opt/homebrew/Cellar/avr-binutils/2.42/sbom.spdx.json
        /opt/homebrew/Cellar/avr-binutils/2.42/share/man/ (18 files)
      ```
      
    </details>
    
    * Example `${AVR_BINUTIL}`: `/opt/homebrew/Cellar/avr-binutils/2.42/bin`
  * Alternatively, you can find an avr toolchain and download it for your environment via a search engine.
    * `${AVR_BINUTIL}` configuration is similar, just point it to the `bin` directory which includes `avr-objdump` executable.

#### `make` utility
You need to add `${AVR_BIN}` and `${AVR_BINUTIL}` to your environment variables first. `AVR_BIN` is supposed to be where `avr-gcc` (and other tools) is located. `AVR_BINUTIL` is supposed to be where `avr-objdump` (and other tools) is located.

Example export directives in `~/.zshrc` on macOS to add `AVR_BIN` and `AVR_BINUTIL` to environment variables:
```
export AVR_BIN="/opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin"
export AVR_BINUTIL="/opt/homebrew/Cellar/avr-binutils/2.42/bin"
```

After doing this for the first time, you need to reset shell, or run this, so that shell registers the new variables: `source ~/.zshrc`

### Compile
Run `CC=$AVR_BIN/avr-gcc make` for a compiling the binaries. Binaries are .elf and .hex files under `bin` directory.

### Clean
Run `make clean` for cleaning artifacts of the build step.

### Compile and Disassemble
Run `CC=$AVR_BIN/avr-gcc make disasm` for compiling the binaries, and producing their objdump files for further inspection.

## How To Burn Bootloader to atmega328p (Arduino Uno/Nano)
### Prerequisites

#### `avrdude` package
  * On macOS, install via `brew install avrdude`
  * On macOS, learn location of `avrdude.conf` file via `brew ls avrdude`
   <details> <summary>Example output</summary>
    
   ```
    /opt/homebrew/Cellar/avrdude/8.0/.bottle/etc/avrdude.conf
    /opt/homebrew/Cellar/avrdude/8.0/bin/avrdude
    /opt/homebrew/Cellar/avrdude/8.0/bin/elf2tag
    /opt/homebrew/Cellar/avrdude/8.0/include/ (2 files)
    /opt/homebrew/Cellar/avrdude/8.0/lib/libavrdude.2.0.0.dylib
    /opt/homebrew/Cellar/avrdude/8.0/lib/ (3 other files)
    /opt/homebrew/Cellar/avrdude/8.0/sbom.spdx.json
    /opt/homebrew/Cellar/avrdude/8.0/share/man/man1/avrdude.1
   ```
    
   </details>

   * Config file we are interested in is `/opt/homebrew/Cellar/avrdude/8.0/.bottle/etc/avrdude.conf` in this case.
    
#### Arduino Must Be Plugged Into a USB port
  * On macOS, run `ls /dev/* | grep "usb"` when Arduino is not plugged.
    * Then plug the Arduino run `ls /dev/* | grep "usb"` again. You can deduce the arduino usb port by the difference in the output
    * Example output:
    ```
      /dev/cu.usbserial-10
      /dev/tty.usbserial-10
    ```
    * This means we can use `/dev/cu.usbserial-10` for usb programming device parameter.

### Uploading Program

#### Burning bootloader via usbtinyISP programmer dedicated hardware, use this command: 
```
./upload_scripts/upload_bootloader_via_usbtinyISP.sh -c /opt/homebrew/Cellar/avrdude/8.0/.bottle/etc/avrdude.conf -b ./bin/9.4.0/bootloader.hex -p usbtiny
```
Note that when programming via usbtinyISP, usb port info is not needed.

<details><summary>Wiring</summary>
 
 ![WhatsApp Image 2024-11-01 at 23 01 16](https://github.com/user-attachments/assets/5583627a-686c-4b36-a4d6-175ae6b8d30a)
 
</details>

#### Burning bootloader via arduinoISP programmer, use this command: 
```
./upload_scripts/upload_bootloader_via_arduinoISP.sh -c /opt/homebrew/Cellar/avrdude/8.0/.bottle/etc/avrdude.conf -p /dev/cu.usbserial-10 -b ./bin/9.4.0/bootloader.hex
```

<details><summary>Wiring</summary>
 
[See here](https://docs.arduino.cc/built-in-examples/arduino-isp/ArduinoISP/)

</details>

#### Uploading a hex file, use this command:
```
./upload_scripts/upload_hex_via_usb.sh -c /opt/homebrew/Cellar/avrdude/8.0/.bottle/etc/avrdude.conf -p /dev/cu.usbserial-10 -h ./bin/main.hex
```

<details><summary>Wiring</summary>

![WhatsApp Image 2024-11-01 at 23 01 37](https://github.com/user-attachments/assets/4d736bab-4700-41a3-a6e2-76cb2742aef6)

</details>

## IDE Configuration

### Include Directory
Depending on your avr installation you need to instruct your IDE to 'see' avr library headers. Without this, IDEs like VsCode will not help you with the headers and expressions included from avr library in this project.

* on macOS, avr package library base can be found with this command: `brew ls avr-gcc`
  * <details> <summary>example output on macOS</summary>

    ```
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/avr/include/ (293 files)
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/avr/lib/ (618 files)
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-c++
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-cpp
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-g++
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc-9.4.0
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc-ar
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc-nm
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcc-ranlib
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcov
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcov-dump
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-gcov-tool
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/bin/avr-man
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/lib/avr-gcc/ (791 files)
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/libexec/gcc/ (13 files)
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/sbom.spdx.json
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/share/doc/ (20 files)
      /opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/share/man/ (6 files)
    ```
  </details>
  
    * `${AVR_ROOT}` would be `/opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/` for this output.
* If you installed a avr toolchain manually, you need to find the base of your avr toolchain. It has the same directory structure though, and you can find it easily in the place you have extracted the toolchain.

Supposing your avr library base is located at `${AVR_ROOT}`, your IDE needs to 'see' these include directories

* `${AVR_ROOT}/lib/avr-gcc/9/gcc/avr/9.4.0/include`
* `${AVR_ROOT}/lib/avr-gcc/9/gcc/avr/9.4.0/include-fixed`
* `${AVR_ROOT}/avr/include`

You need to instruct you IDE to 'see' default header directory

* `${WORKSPACE_DIRECTORY}/include`
  * `${WORKSPACE_DIRECTORY}` is this project's root directory.

### C Defines
Depending on your avr device, you need to instruct your IDE to consider some C defines as defined (some with values)

* `__AVR_ATmega328P__`
  * This is used for io.h header, we are using atmega328p chip on Arduino Uno.
* `__AVR_DEVICE_NAME__=atmega328p`
  * This is used for io.h header, we are using atmega328p chip on Arduino Uno. This is only for device name.
* `F_CPU=16000000L`
  * This is the default CPU frequency. If you change the CPU frequency,

### Generating compile_comamnds.json

```
make clean && CC=$AVR_BIN/avr-gcc bear --verbose -- make
```
