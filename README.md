# CVBIOSID

Identify the ColecoVision BIOS image installed in your machine.

## Building (CMake)

Prerequisites: CMake 3.13+, Python 3, Git, and a C/C++ compiler. The build can auto-fetch and build the required CVBasic toolchain, or you can point it at existing installs.

Quick start:

```bash
mkdir build
cd build
cmake ..
cmake --build . --target coleco   # or: cmake --build . --target all_platforms
```

Build outputs land in `build/roms/`. Intermediate assembly lives in `build/asm/`.

Options:

```bash
cmake .. -DBUILD_TOOLS_FROM_SOURCE=OFF          # use existing cvbasic/gasm80 if already on PATH
cmake .. -DCVBASIC_GIT_TAG=v1.0.0               # pin tool versions when building from source
cmake .. -DGASM80_GIT_TAG=v1.0.0 -DPLETTER_GIT_TAG=master
```

## License
This code is licensed under the [MIT](https://opensource.org/licenses/MIT "MIT") license

