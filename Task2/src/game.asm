; Can separate .segments from this file, .include here
.include "constants.inc"
.include "header.inc"
.include "zeropage.inc"

; Ignore for now 
.segment "CODE"
.proc irq_handler
  RTI
.endproc

; Procs every frame: IMPORTANT
.proc nmi_handler
  ;;;
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
  ;;;

  ;;; Edit nmi here
  ; DEC frame_rate_controller
  LDA frame_rate_controller
  CMP #$00
  BEQ update_player
  JMP draw_player
update_player:
  LDA #$0B
  STA frame_rate_controller
  JSR update_players
draw_player:
  JSR draw_UP_player
  JSR draw_DOWN_player
  JSR draw_LEFT_player
  JSR draw_RIGHT_player

  ;;;
	STA $2005
	STA $2005
  RTI
  ;;;
.endproc

; Procs when resetting, see reset.asm for changes
; Important for setting initial values 
.import reset_handler

;;;
;;;
;;;
;;;
;;; Main function
.export main
.proc main

  ;;;
  ; Write palettes to PPU
  ;;; 
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes
  ;;;
  ;;;

  LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$C6
	STA PPUADDR
	LDX #$04
	STX PPUDATA

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK

forever:
  JMP forever
.endproc

.proc update_players
  ; save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  ; update player states
up_player:
  LDA UP_player_state
  CMP #$04
  BEQ second_UP_frame
  LDA #$04
  STA UP_player_state
  JMP down_player
second_UP_frame:
  LDA #$08
  STA UP_player_state

  ; update player states
down_player:
  LDA DOWN_player_state
  CMP #$04
  BEQ second_DOWN_frame
  LDA #$04
  STA DOWN_player_state
  JMP left_player
second_DOWN_frame:
  LDA #$08
  STA DOWN_player_state

  ; update player states
left_player:
  LDA LEFT_player_state
  CMP #$04
  BEQ second_LEFT_frame
  LDA #$04
  STA LEFT_player_state
  JMP right_player
second_LEFT_frame:
  LDA #$08
  STA LEFT_player_state

  ; update player states
right_player:
  LDA RIGHT_player_state
  CMP #$04
  BEQ second_RIGHT_frame
  LDA #$04
  STA RIGHT_player_state
  JMP exit
second_RIGHT_frame:
  LDA #$08
  STA RIGHT_player_state


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

.proc draw_UP_player
  ; save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  ; write player ship tile numbers
  LDA UP_player_dir
  CLC
  ADC UP_player_state
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
  LDA UP_player_y
  STA $0200
  LDA UP_player_x
  STA $0203

  ; top right tile (x + 8):
  LDA UP_player_y
  STA $0204
  LDA UP_player_x
  CLC
  ADC #$08
  STA $0207

  ; bottom left tile (y + 8):
  LDA UP_player_y
  CLC
  ADC #$08
  STA $0208
  LDA UP_player_x
  STA $020b

  ; bottom right tile (x + 8, y + 8)
  LDA UP_player_y
  CLC
  ADC #$08
  STA $020c
  LDA UP_player_x
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

.proc draw_DOWN_player
  ; save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  ; write player ship tile numbers
  LDA DOWN_player_dir
  CLC
  ADC DOWN_player_state
  TAX
  STX $0211 ; $0201 + $10 = $0211
  INX
  STX $0215 ; $0205 + $10 = $0215
  INX
  STX $0219 ; $0209 + $10 = $0219
  INX
  STX $021d ; $020d + $10 = $021d

  ; write player ship tile attributes
  ; use palette 0
  LDA #$00
  STA $0212
  STA $0216
  STA $021a
  STA $021e

  ; store tile locations
  ; top left tile:
  LDA DOWN_player_y
  STA $0210 ; $0200 + $10 = $0210
  LDA DOWN_player_x
  STA $0213 ; $0203 + $10 = $0213

  ; top right tile (x + 8):
  LDA DOWN_player_y
  STA $0214 ; $0204 + $10 = $0214
  LDA DOWN_player_x
  CLC
  ADC #$08
  STA $0217 ; $0207 + $10 = $0217

  ; bottom left tile (y + 8):
  LDA DOWN_player_y
  CLC
  ADC #$08
  STA $0218 ; $0208 + $10 = $0218
  LDA DOWN_player_x
  STA $021b ; $020b + $10 = $021b

  ; bottom right tile (x + 8, y + 8)
  LDA DOWN_player_y
  CLC
  ADC #$08
  STA $021c ; $020c + $10 = $021c
  LDA DOWN_player_x
  CLC
  ADC #$08
  STA $021f ; $020f + $10 = $021f

  ; restore registers and return
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS
.endproc

.proc draw_LEFT_player
  ; save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  ; write player ship tile numbers
  LDA LEFT_player_dir
  CLC
  ADC LEFT_player_state
  TAX
  STX $0221 ; $0211 + $10 = $0221
  INX
  STX $0225 ; $0215 + $10 = $0225
  INX
  STX $0229 ; $0219 + $10 = $0229
  INX
  STX $022d ; $021d + $10 = $022d

  ; write player ship tile attributes
  ; use palette 0
  LDA #$00
  STA $0222
  STA $0226
  STA $022a
  STA $022e

  ; store tile locations
  ; top left tile:
  LDA LEFT_player_y
  STA $0220 ; $0210 + $10 = $0220
  LDA LEFT_player_x
  STA $0223 ; $0213 + $10 = $0223

  ; top right tile (x + 8):
  LDA LEFT_player_y
  STA $0224 ; $0214 + $10 = $0224
  LDA LEFT_player_x
  CLC
  ADC #$08
  STA $0227 ; $0217 + $10 = $0227

  ; bottom left tile (y + 8):
  LDA LEFT_player_y
  CLC
  ADC #$08
  STA $0228 ; $0218 + $10 = $0228
  LDA LEFT_player_x
  STA $022b ; $021b + $10 = $022b

  ; bottom right tile (x + 8, y + 8)
  LDA LEFT_player_y
  CLC
  ADC #$08
  STA $022c ; $021c + $10 = $022c
  LDA LEFT_player_x
  CLC
  ADC #$08
  STA $022f ; $021f + $10 = $022f

  ; restore registers and return
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS
.endproc

.proc draw_RIGHT_player
  ; save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  ; write player ship tile numbers
  LDA RIGHT_player_dir
  CLC
  ADC RIGHT_player_state
  TAX
  STX $0231 ; $0221 + $10 = $0231
  INX
  STX $0235 ; $0225 + $10 = $0235
  INX
  STX $0239 ; $0229 + $10 = $0239
  INX
  STX $023d ; $022d + $10 = $023d

  ; write player ship tile attributes
  ; use palette 0
  LDA #$00
  STA $0232
  STA $0236
  STA $023a
  STA $023e

  ; store tile locations
  ; top left tile:
  LDA RIGHT_player_y
  STA $0230 ; $0220 + $10 = $0230
  LDA RIGHT_player_x
  STA $0233 ; $0223 + $10 = $0233

  ; top right tile (x + 8):
  LDA RIGHT_player_y
  STA $0234 ; $0224 + $10 = $0234
  LDA RIGHT_player_x
  CLC
  ADC #$08
  STA $0237 ; $0227 + $10 = $0237

  ; bottom left tile (y + 8):
  LDA RIGHT_player_y
  CLC
  ADC #$08
  STA $0238 ; $0228 + $10 = $0238
  LDA RIGHT_player_x
  STA $023b ; $022b + $10 = $023b

  ; bottom right tile (x + 8, y + 8)
  LDA RIGHT_player_y
  CLC
  ADC #$08
  STA $023c ; $022c + $10 = $023c
  LDA RIGHT_player_x
  CLC
  ADC #$08
  STA $023f ; $022f + $10 = $023f

  ; restore registers and return
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP
  RTS
.endproc



.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes:
.byte $16, $12, $23, $27
.byte $16, $2b, $3c, $39
.byte $16, $0c, $07, $13
.byte $16, $19, $09, $29

.byte $16, $0f, $00, $20
.byte $16, $19, $09, $29
.byte $16, $19, $09, $29
.byte $16, $19, $09, $29

.segment "CHR"
.incbin "graphics.chr"
