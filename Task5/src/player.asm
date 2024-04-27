.include "readonly.inc"
.include "constants.inc"
.importzp controller_info, player_dir, player_state, player_x, player_y, scroll, stage

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

check_left:
  LDA controller_info        ; Load button presses
  AND #BTN_LEFT   ; Filter out all but Left
  BEQ check_right ; If result is zero, left not pressed
  JSR MoveLeft
  JMP player

check_right:
  LDA controller_info
  AND #BTN_RIGHT
  BEQ check_up
  JSR MoveRight
  JMP player

check_up:
  LDA controller_info
  AND #BTN_UP
  BEQ check_down
  JSR MoveUp
  JMP player

check_down:
  LDA controller_info
  AND #BTN_DOWN
  BEQ no_movement
  JSR MoveDown
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

  LDA player_x
  STA $03
  CLC
  ADC scroll
  STA $04
  LDA player_y
  STA $06

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

.export check_collide
.proc check_collide
; Checks for collisions at locations
; Input:
;   X - X position of player
;   Y - Y position of player 
; Output:
;   Stores the 2 bit representation of the tile at X, Y in $00

  TXA

  LSR
  LSR
  LSR
  LSR
  LSR
  LSR
  STA $00
  TYA 
  LSR
  LSR
  LSR
  LSR
  ASL
  ASL
  CLC
  ADC $00
  ADC $01 ; name table offset, set when X + PPUSCROLL overflows, read from second nametable
  TAY

  TXA
  LSR
  LSR
  LSR
  LSR
  AND #%00000011
  TAX

  LDA stage
  CMP #$04
  BEQ first
  LDA test,Y
  JMP mask

first:
  LDA stage1,Y

mask:
  AND bitmask,X


Loop:
  CPX #$03
  BEQ exit
  LSR
  LSR
  INX
  JMP Loop
exit:

  STA $00

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
  JSR check_bush
  ; LDA #%00100000
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

.export MoveLeft
.proc MoveLeft

  DEC player_x
  LDA player_x
  CMP #255
  BNE continue
  LDA #00
  STA $01

continue:
  DEC scroll
  LDA #$1C
  STA player_dir
  JSR changeState
  LDA player_x
  CLC 
  ADC scroll
  ; if over flow, set #01 to 1
  TAX
  LDA player_y
  CLC
  ADC #$01
  TAY
  JSR check_collide
  LDA $00
  AND #%00000010
  BNE second_pixel
  INC player_x
  INC scroll

second_pixel:
  LDA player_x
  CLC 
  ADC scroll
  TAX
  LDA player_y
  CLC
  ADC #16
  TAY
  JSR check_collide
  LDA $00
  AND #%00000010
  BNE exit
  INC player_x
  INC scroll

exit:

  RTS

.endproc

.export MoveRight
.proc MoveRight

  INC player_x
  INC scroll
  LDA #$28
  STA player_dir
  JSR changeState
  LDA player_x
  CLC
  ADC #15
  CLC 
  ADC scroll
  ; if over flow, set #01 to 60
  BCC continue 
  LDA #60
  STA $01
continue:
  TAX
  LDA player_y
  CLC
  ADC #$01
  TAY
  JSR check_collide
  LDA $00
  AND #%00000010
  BNE second_pixel
  DEC player_x
  DEC scroll

second_pixel:
  LDA player_x
  CLC
  ADC #15
  CLC 
  ADC scroll
  TAX
  LDA player_y
  CLC
  ADC #16
  TAY
  JSR check_collide
  LDA $00
  AND #%00000010
  BNE exit
  DEC player_x
  DEC scroll

exit:

  RTS

.endproc

.export MoveUp
.proc MoveUp

  DEC player_y
  LDA #$10
  STA player_dir
  JSR changeState

  LDA player_x
  CLC 
  ADC scroll
  TAX
  LDA player_y
  CLC
  ADC #$01
  TAY
  JSR check_collide
  LDA $00
  AND #%00000010
  BNE second_pixel
  INC player_y

second_pixel:
  LDA player_x
  CLC
  ADC #15
  CLC 
  ADC scroll
  TAX
  LDA player_y
  CLC
  ADC #$01
  TAY
  JSR check_collide
  LDA $00
  AND #%00000010
  BNE exit
  INC player_y

exit:

  RTS

.endproc

.export MoveDown
.proc MoveDown

  INC player_y
  LDA #$04
  STA player_dir
  JSR changeState

  LDA player_x
  CLC 
  ADC scroll
  TAX
  LDA player_y
  CLC
  ADC #16
  TAY
  JSR check_collide
  LDA $00
  AND #%00000010
  BNE second_pixel
  DEC player_y

second_pixel:
  LDA player_x
  CLC
  ADC #15
  CLC 
  ADC scroll
  TAX
  LDA player_y
  CLC
  ADC #16
  TAY
  JSR check_collide
  LDA $00
  AND #%00000010
  BNE exit
  DEC player_y

exit:

  RTS

.endproc

.export changeState
.proc changeState

  LDA player_state
  CMP #$00
  BEQ state
  JMP exit

state:
  LDA #$04
  STA player_state

exit:
  RTS

.endproc

.export check_bush
.proc check_bush

  LDA player_x
  CLC 
  ADC #7
  CLC 
  ADC scroll
  ; if over flow, set #01 to 1
  TAX
  LDA player_y
  CLC
  ADC #8
  TAY
  JSR check_collide
  LDA $00
  CMP #%10
  BNE visible
  LDA #%00100000
  STA $07
  JMP exit

visible:
  LDA #%00000000
  STA $07

exit:
  RTS

.endproc