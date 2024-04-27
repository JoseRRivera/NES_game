.include "constants.inc"

.segment "ZEROPAGE"
; If adding values to zero page, import here
.importzp player_x, player_y, player_dir, player_state
.importzp frame_rate_controller, controller_info
.importzp stage, offset_high, offset_low

.segment "CODE"
.import main
.export reset_handler
.proc reset_handler
  SEI
  CLD
  LDX #$40
  STX $4017
  LDX #$FF
  TXS
  INX
  STX $2000
  STX $2001
  STX $4010
  BIT $2002
vblankwait:
  BIT $2002
  BPL vblankwait

	LDX #$00
	LDA #$FF
clear_oam:
	STA $0200,X ; set sprite y-positions off the screen
	INX
	INX
	INX
	INX
	BNE clear_oam

	; initialize zero-page values

  ; initializing sprite zp values
	LDA #$00
	STA player_x
	LDA #$CF
	STA player_y
  LDA #$04
  STA player_dir
  LDA #$04
  STA player_state

  ; how many frames until sprites update their walk state
  LDA #$06
  STA frame_rate_controller

  ; start at stage 0
  LDA #$04
  STA stage

  LDA#$00
  STA offset_high
  STA offset_low

vblankwait2:
  BIT $2002
  BPL vblankwait2
  JMP main
.endproc
