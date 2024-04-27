; Can separate .segments from this file, .include here
.include "constants.inc"
.include "header.inc"
.include "zeropage.inc"
.include "readonly.inc"

; Ignore for now 
.segment "CODE"
.proc irq_handler
  RTI
.endproc

.import read_controller1
.import draw_player
.import update_player
.import draw_nametable
.import draw_stage2
.import load_attributes

; Procs every frame: IMPORTANT
.proc nmi_handler
  ;;;
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
  ;;;

  JSR read_controller1

  LDA controller_info        ; Load button presses
  AND #BTN_A   ; Filter out all but Left
  BNE stage_command ; If result is zero, left not pressed
  JMP after_stage
stage_command:
  LDA #$01
  STA switch_stage

after_stage:

  ;;; Edit nmi here
  DEC frame_rate_controller
  LDA frame_rate_controller
  CMP #$00
  BEQ update
  JMP draw
update:
  LDA #$06
  STA frame_rate_controller
  JSR update_player
draw:
  ;JSR draw_player

  LDA scroll
  CMP #255 ; did we scroll to the end of a nametable?
  BNE increase_scroll
  ; if yes,
  ; update base nametable
  LDA ppuctrl_settings
  CMP #%0000001 ; are we at the end of second name table? 
  ;if yes, do not update scrolls
  BNE exit
  ; else: go to second name table 
  EOR #%0000001 ; flip bit #1 to its opposite
  STA ppuctrl_settings
  STA PPUCTRL
  LDA #00
  STA scroll

increase_scroll:
  INC scroll
  LDA scroll ; X scroll first
  STA PPUSCROLL
  LDA #00 ; then Y scroll
  STA PPUSCROLL

exit:

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

  LDA #00   ; Y is only 240 lines tall!
  STA scroll

  ;JSR load_attributes

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
  CPX #32
  BNE load_palettes
  ;;;
  ;;;

  JSR draw_nametable

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA ppuctrl_settings
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK

forever:
  LDA switch_stage
  CMP #$01
  BNE forever

  JSR draw_stage2

  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "graphics.chr"
