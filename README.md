# CVBIOSID

Identify the ColecoVision BIOS image installed in your machine.

## Build Status

| Windows | Linux | macOS |
|---------|-------|-------|
| [![](https://github.com/visrealm/cvbiosid/actions/workflows/build-windows.yml/badge.svg)](https://github.com/visrealm/cvbiosid/actions/workflows/build-windows.yml) | [![](https://github.com/visrealm/cvbiosid/actions/workflows/build-linux.yml/badge.svg)](https://github.com/visrealm/cvbiosid/actions/workflows/build-linux.yml) | [![](https://github.com/visrealm/cvbiosid/actions/workflows/build-macos.yml/badge.svg)](https://github.com/visrealm/cvbiosid/actions/workflows/build-macos.yml) |

## What It Does

On a real ColecoVision, ADAM (or compatible), the cart reads the first 8 KB of BIOS space and computes a CRC16 (poly $8005, init $FFFF). It prints the CRC and matches it against known variants. Unknown CRCs are still shown so you can compare manually.

Identified BIOS CRCs:

- NTSC – Factory: $D939
- NTSC – Short Delay: $1AA0
- NTSC – Button Skip: $8340
- NTSC – No Delay: $1458
- NTSC – Button Skip (alt font): $A684
- NTSC – Button Skip (bold font): $A8D2
- PAL – Factory: $D09F
- PAL – Button Skip: $F047

There’s also a matching Python helper in `tools/crc16.py` that uses the same CRC16 parameters, so you can verify dumps on your PC.

## Building

### Prerequisites

* CMake 3.13 or later
* Python 3
* Git
* C/C++ compiler (MSVC, GCC, Clang, etc.)

The build will auto-download and build the required tools from source when needed:
* [CVBasic](https://github.com/visrealm/CVBasic) - compiler
* [gasm80](https://github.com/visrealm/gasm80) - assembler
* [Pletter](https://github.com/nanochess/Pletter) - compression

### Quick Start

```bash
git clone https://github.com/visrealm/cvbiosid.git
cd cvbiosid

mkdir build
cd build
cmake ..
cmake --build .
```

ROMs are written to `build/roms/`; intermediate assembly is in `build/asm/`.

### Build Options

```bash
cmake .. -DBUILD_TOOLS_FROM_SOURCE=OFF          # use existing cvbasic/gasm80 if already on PATH
cmake .. -DCVBASIC_GIT_TAG=v1.0.0               # pin tool versions when building from source
cmake .. -DGASM80_GIT_TAG=v1.0.0 -DPLETTER_GIT_TAG=master
```

## License
This code is licensed under the [MIT](https://opensource.org/licenses/MIT "MIT") license

