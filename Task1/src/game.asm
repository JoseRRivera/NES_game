.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
	STA $2005
	STA $2005
  RTI
.endproc

.import reset_handler

.export main
.proc main
  ; write a palette
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

  ; write sprite data
  LDX #$00
load_sprites:
  LDA sprites,X
  STA $0200,X
  INX
  CPX #$C0
  BNE load_sprites

	; write nametables
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$C6
	STA PPUADDR
	LDX #$04
	STX PPUDATA
	
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$C7
	STA PPUADDR
	LDX #$05
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$E6
	STA PPUADDR
	LDX #$06
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$E7
	STA PPUADDR
	LDX #$07
	STX PPUDATA

;
;
;
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$C8
	STA PPUADDR
	LDX #$08
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$C9
	STA PPUADDR
	LDX #$08
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$E8
	STA PPUADDR
	LDX #$08
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$E9
	STA PPUADDR
	LDX #$08
	STX PPUDATA

;
;
;
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$CA
	STA PPUADDR
	LDX #$09
	STX PPUDATA
	
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$CB
	STA PPUADDR
	LDX #$09
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$EA
	STA PPUADDR
	LDX #$09
	STX PPUDATA
	
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$EB
	STA PPUADDR
	LDX #$09
	STX PPUDATA

;
;
;
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$CC
	STA PPUADDR
	LDX #$0A
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$CD
	STA PPUADDR
	LDX #$0B
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$EC
	STA PPUADDR
	LDX #$0C
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$ED
	STA PPUADDR
	LDX #$0D
	STX PPUDATA

;
;
;
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$CE
	STA PPUADDR
	LDX #$0E
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$CF
	STA PPUADDR
	LDX #$0E
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$EE
	STA PPUADDR
	LDX #$0E
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$EF
	STA PPUADDR
	LDX #$0E
	STX PPUDATA

;
;
;
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$D0
	STA PPUADDR
	LDX #$0F
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$D1
	STA PPUADDR
	LDX #$0F
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$F0
	STA PPUADDR
	LDX #$0F
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$F1
	STA PPUADDR
	LDX #$0F
	STX PPUDATA

;
;
;
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$D2
	STA PPUADDR
	LDX #$18
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$D3
	STA PPUADDR
	LDX #$19
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$F2
	STA PPUADDR
	LDX #$1A
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$F3
	STA PPUADDR
	LDX #$1B
	STX PPUDATA


;
;
;
	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$D6
	STA PPUADDR
	LDX #$20
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$D7
	STA PPUADDR
	LDX #$21
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$F6
	STA PPUADDR
	LDX #$22
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$F7
	STA PPUADDR
	LDX #$23
	STX PPUDATA

	; finally, attribute table
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$EA
	STA PPUADDR
	LDA #%10010000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$eb
	STA PPUADDR
	LDA #%00100000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$EC
	STA PPUADDR
	LDA #%00100000
	STA PPUDATA

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

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes:
.byte $16, $31, $2C, $0F
.byte $16, $15, $05, $32
.byte $16, $2A, $1B, $0F
.byte $16, $2A, $1B, $0F

.byte $16, $0f, $00, $20
.byte $16, $19, $09, $29
.byte $16, $19, $09, $29
.byte $16, $19, $09, $29

; .byte $0f, $12, $23, $27
; .byte $0f, $2b, $3c, $39
; .byte $0f, $0c, $07, $13
; .byte $0f, $19, $09, $29

sprites:
; down
.byte $68, $04, $00, $50
.byte $68, $05, $00, $58
.byte $70, $06, $00, $50
.byte $70, $07, $00, $58

.byte $68, $08, $00, $60
.byte $68, $09, $00, $68
.byte $70, $0A, $00, $60
.byte $70, $0B, $00, $68

.byte $68, $09, $40, $70
.byte $68, $08, $40, $78
.byte $70, $0B, $40, $70
.byte $70, $0A, $40, $78

; up
.byte $78, $0C, $00, $50
.byte $78, $0D, $00, $58
.byte $80, $0E, $00, $50
.byte $80, $0F, $00, $58

.byte $78, $10, $00, $60
.byte $78, $11, $00, $68
.byte $80, $12, $00, $60
.byte $80, $13, $00, $68

.byte $78, $11, $40, $70
.byte $78, $10, $40, $78
.byte $80, $13, $40, $70
.byte $80, $12, $40, $78

; left
.byte $88, $14, $00, $50
.byte $88, $15, $00, $58
.byte $90, $16, $00, $50
.byte $90, $17, $00, $58

.byte $88, $18, $00, $60
.byte $88, $19, $00, $68
.byte $90, $1A, $00, $60
.byte $90, $1B, $00, $68

.byte $88, $1C, $00, $70
.byte $88, $1D, $00, $78
.byte $90, $1E, $00, $70
.byte $90, $1F, $00, $78

; right
.byte $98, $15, $40, $50
.byte $98, $14, $40, $58
.byte $A0, $17, $40, $50
.byte $A0, $16, $40, $58

.byte $98, $19, $40, $60
.byte $98, $18, $40, $68
.byte $A0, $1B, $40, $60
.byte $A0, $1A, $40, $68

.byte $98, $1D, $40, $70
.byte $98, $1C, $40, $78
.byte $A0, $1F, $40, $70
.byte $A0, $1E, $40, $78


.segment "CHR"
.incbin "graphics.chr"
