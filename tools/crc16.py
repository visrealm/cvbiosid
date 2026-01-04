#!/usr/bin/env python3
import sys, glob, os

def crc16_cvbasic(filepath):
    poly = 0x8005
    crc = 0xFFFF

    with open(filepath, "rb") as f:
        data = f.read()

    for byte in data:
        # CVBasic feed: #V = PEEK(#I) * 16; #CRC = #CRC XOR (#V * 16)
        v = (byte * 16) & 0xFFFF
        crc = (crc ^ ((v * 16) & 0xFFFF)) & 0xFFFF

        # Bit loop
        for _ in range(8):
            if (crc & 0x8000) != 0:
                crc = (((crc * 2) & 0xFFFF) ^ poly) & 0xFFFF
            else:
                crc = (crc * 2) & 0xFFFF
    return crc

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python crc16_cvbasic.py <file1> [file2 ...]")
        sys.exit(1)

    files = []
    for arg in sys.argv[1:]:
        files.extend(glob.glob(arg))

    print("File            | CRC16 (CVBasic-style)")
    print("----------------+-----------------------")
    for path in files:
        if os.path.isfile(path):
            result = crc16_cvbasic(path)
            print(f"{os.path.basename(path):<15} | {result:#06x} ({result})")