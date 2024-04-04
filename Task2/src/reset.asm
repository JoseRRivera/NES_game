.include "constants.inc"

.segment "ZEROPAGE"
; If adding values to zero page, import here
.importzp UP_player_x, UP_player_y, UP_player_dir, UP_player_state
.importzp DOWN_player_x, DOWN_player_y, DOWN_player_dir, DOWN_player_state
.importzp LEFT_player_x, LEFT_player_y, LEFT_player_dir, LEFT_player_state
.importzp RIGHT_player_x, RIGHT_player_y, RIGHT_player_dir, RIGHT_player_state
.importzp frame_rate_controller

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

  ; initializing UP sprite zp values
	LDA #$80
	STA UP_player_x
	LDA #$a0
	STA UP_player_y
  LDA #$10
  STA UP_player_dir
  LDA #$04
  STA UP_player_state

  ; initializing DOWN sprite zp values
	LDA #$90
	STA DOWN_player_x
	LDA #$a0
	STA DOWN_player_y
  LDA #$04
  STA DOWN_player_dir
  LDA #$04
  STA DOWN_player_state

  ; initializing LEFT sprite zp values
	LDA #$80
	STA LEFT_player_x
	LDA #$90
	STA LEFT_player_y
  LDA #$1C
  STA LEFT_player_dir
  LDA #$04
  STA LEFT_player_state

  ; initializing RIGHT sprite zp values
	LDA #$90
	STA RIGHT_player_x
	LDA #$90
	STA RIGHT_player_y
  LDA #$28
  STA RIGHT_player_dir
  LDA #$04
  STA RIGHT_player_state

  ; how many frames until sprites update their walk state
  LDA #$0B
  STA frame_rate_controller

vblankwait2:
  BIT $2002
  BPL vblankwait2
  JMP main
.endproc
