.include "constants.inc"

.segment "ZEROPAGE"
.importzp controller_info

.segment "CODE"
.export read_controller1
.proc read_controller1
  PHA
  TXA
  PHA
  PHP

  ; write a 1, then a 0, to CONTROLLER1
  ; to latch button states
  LDA #$01
  STA CONTROLLER1
  LDA #$00
  STA CONTROLLER1

  LDA #%00000001
  STA controller_info

get_buttons:
  LDA CONTROLLER1 ; Read next button's state
  LSR A           ; Shift button state right, into carry flag
  ROL controller_info        ; Rotate button state from carry flag
                  ; onto right side of pad1
                  ; and leftmost 0 of pad1 into carry flag
  BCC get_buttons ; Continue until original "1" is in carry flag

  PLP
  PLA
  TAX
  PLA
  RTS
.endproc