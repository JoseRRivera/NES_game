.include "readonly.inc"
.include "constants.inc"
.importzp controller_info, player_dir, player_state, player_x, player_y

.segment "CODE"
.export update_player
.proc update_player
  ; save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  LDA controller_info        ; Load button presses
  AND #BTN_LEFT   ; Filter out all but Left
  BEQ check_right ; If result is zero, left not pressed
  DEC player_x  ; If the branch is not taken, move player left
  LDA #$1C
  STA player_dir
  LDA player_state
  CMP #$00
  BEQ set_state
  JMP player
check_right:
  LDA controller_info
  AND #BTN_RIGHT
  BEQ check_up
  INC player_x
  LDA #$28
  STA player_dir
  LDA player_state
  CMP #$00
  BEQ set_state
  JMP player
check_up:
  LDA controller_info
  AND #BTN_UP
  BEQ check_down
  DEC player_y
  LDA #$10
  STA player_dir
  LDA player_state
  CMP #$00
  BEQ set_state
  JMP player
check_down:
  LDA controller_info
  AND #BTN_DOWN
  BEQ no_movement
  INC player_y
  LDA #$04
  STA player_dir
  LDA player_state
  CMP #$00
  BEQ set_state
  JMP player

set_state:
  LDA #$04
  STA player_state
  JMP player

no_movement:
  LDA #$00
  STA player_state

  ; update player states
player:
  LDA player_state
  CMP #$00
  BEQ exit
  CMP #$04
  BEQ second_frame
  LDA #$04
  STA player_state
  JMP exit
second_frame:
  LDA #$08
  STA player_state


  ; restore registers and return
exit:
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS
.endproc

.export draw_player
.proc draw_player
  ; save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  ; write player ship tile numbers
  LDA player_dir
  CLC
  ADC player_state
  TAX
  STX $0201
  INX
  STX $0205
  INX
  STX $0209
  INX
  STX $020d

  ; write player ship tile attributes
  ; use palette 0
  LDA #$00
  STA $0202
  STA $0206
  STA $020a
  STA $020e

  ; store tile locations
  ; top left tile:
  LDA player_y
  STA $0200
  LDA player_x
  STA $0203

  ; top right tile (x + 8):
  LDA player_y
  STA $0204
  LDA player_x
  CLC
  ADC #$08
  STA $0207

  ; bottom left tile (y + 8):
  LDA player_y
  CLC
  ADC #$08
  STA $0208
  LDA player_x
  STA $020b

  ; bottom right tile (x + 8, y + 8)
  LDA player_y
  CLC
  ADC #$08
  STA $020c
  LDA player_x
  CLC
  ADC #$08
  STA $020f

  ; restore registers and return
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS
.endproc