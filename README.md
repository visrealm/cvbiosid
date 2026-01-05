# CVBIOSID

Identify the ColecoVision BIOS image installed in your machine.

## Build Status

| Windows | Linux | macOS |
|---------|-------|-------|
| [![](https://github.com/visrealm/cvbiosid/actions/workflows/build-windows.yml/badge.svg)](https://github.com/visrealm/cvbiosid/actions/workflows/build-windows.yml) | [![](https://github.com/visrealm/cvbiosid/actions/workflows/build-linux.yml/badge.svg)](https://github.com/visrealm/cvbiosid/actions/workflows/build-linux.yml) | [![](https://github.com/visrealm/cvbiosid/actions/workflows/build-macos.yml/badge.svg)](https://github.com/visrealm/cvbiosid/actions/workflows/build-macos.yml) |

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

