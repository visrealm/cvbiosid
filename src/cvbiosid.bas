'
' Project: CVBIOSID
'
' Identify ColecoVision BIOS
'
' Copyright (c) 2025 Troy Schrapel
'
' This code is licensed under the MIT license
'
' https://github.com/visrealm/cvbiosid
'

' ==========================================
' ENTRY POINT
' ------------------------------------------
GOTO main

CONST FALSE = 0
CONST TRUE  = -1

' ==========================================
' INCLUDES
' ------------------------------------------
include "vdp-utils.bas"


' ==========================================
' CONSTANTS
' ------------------------------------------
CONST CVBASIC_DIRECT_SPRITES = 1

' ==========================================
' GLOBALS ( I guess everything is global :D )
' ------------------------------------------

DIM #CRC, #I
DIM J2

CRC16:
  #CRC = $FFFF   ' initial value
  J = 0

  FOR #I = 0 TO 8191
    #V = PEEK(#I) * 16
    #CRC = #CRC XOR (#V * 16)
    FOR J2 = 0 TO 7
      IF (#CRC AND $8000) <> 0 THEN
        #CRC = (#CRC * 2) XOR $8005
      ELSE
        #CRC = #CRC * 2
      END IF
    NEXT J2
    IF (#I AND $ff) = 0 THEN
      PRINT AT XY(13,8), " "
      SELECT CASE ((#I / 256) AND $3)
        CASE 3
          PRINT "..."
        CASE 2
          PRINT ".. "
        CASE 1
          PRINT ".  "
        CASE ELSE
          PRINT "   "
      END SELECT
    END IF
  NEXT #I
  RETURN

' ==========================================
' ACTUAL ENTRY POINT
' ------------------------------------------
main:
  MODE 2

  vdpR1Flags = $02
  
    ' what are we working with?
  GOSUB vdpDetect

  VDP_REG(7) = defaultReg(7)
  VDP_REG(0) = defaultReg(0)  ' VDP_REG() doesn't accept variables, so...
  VDP_REG(1) = defaultReg(1) OR vdpR1Flags
  VDP_REG(2) = defaultReg(2)
  VDP_REG(3) = defaultReg(3)
  VDP_REG(4) = defaultReg(4)
  VDP_REG(5) = defaultReg(5)
  VDP_REG(6) = defaultReg(6)


  DEFINE VRAM PLETTER #VDP_PATT_TAB1 + (32 * 8), 95 * 8, fontPletter
  DEFINE VRAM PLETTER #VDP_PATT_TAB2 + (32 * 8), 95 * 8, fontPletter
  DEFINE VRAM PLETTER #VDP_PATT_TAB3 + (32 * 8), 95 * 8, fontPletter

  FILL_BUFFER($f4)
  #addr = #VDP_COLOR_TAB1
  FOR I = 0 TO 192
    DEFINE VRAM #addr, NAME_TABLE_WIDTH, VARPTR rowBuffer(0)
    #addr = #addr + NAME_TABLE_WIDTH
  NEXT I

  FILL_BUFFER($20)
  #addr = #VDP_NAME_TAB
  FOR I = 0 TO 23
    DEFINE VRAM #addr, NAME_TABLE_WIDTH, VARPTR rowBuffer(0)
    #addr = #addr + NAME_TABLE_WIDTH
  NEXT I

  VDP_ENABLE_INT

  PRINT AT XY(0,23), "COLECO BIOS ID (C) 2026 VISREALM"

  PRINT AT XY(1,8), "READING BIOS"
  
  GOSUB CRC16

  PRINT AT XY(1,8), "BIOS CRC16: ", #CRC

  PRINT AT XY(1,12), "ID: "

  IF #CRC = $d939 THEN
    PRINT "NTSC - FACTORY"
  ELSEIF #CRC = $1aa0 THEN
    PRINT "NTSC - SHORT DELAY"
  ELSEIF #CRC = $8340 THEN
    PRINT "NTSC - BUTTON SKIP"
  ELSEIF #CRC = $1458 THEN
    PRINT "NTSC - NO DELAY"
  ELSEIF #CRC = $a684 THEN
    PRINT "NTSC - BUTTON SKIP ALT FONT"
  ELSEIF #CRC = $a8d2 THEN
    PRINT "NTSC - BUTTON SKIP BOLD FONT"
  ELSEIF #CRC = $d09f THEN
    PRINT "PAL - FACTORY"
  ELSEIF #CRC = $f047 THEN
    PRINT "PAL - BUTTON SKIP"
  ELSE
    PRINT "UNKNOWN BIOS"
  END IF

  WHILE 1
  WEND

include "font.pletter.bas"