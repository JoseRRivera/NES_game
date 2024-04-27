.include "readonly.inc"
.include "constants.inc"
.importzp offset_high, offset_low, stage, tile_offset, mega_x, mega_y, left_or_right, switch_stage, ppuctrl_settings, scroll

.segment "CODE"
.export draw_nametable
.proc draw_nametable
    PHA
    TXA
    PHA
    PHP

    LDA #$00
    STA left_or_right
    LDY #$00


load_leftnametable:

    TYA
    LOOP:
    SEC           ; Set the carry flag to indicate a borrow
    SBC #$3C      ; Subtract 60 (3C in hexadecimal) from the accumulator
    BCS LOOP      ; Branch to LOOP if no borrow (carry flag set)
    ADC #$3C
    TAX

    TYA
    PHA
    ;;
    LDA stage
    CMP #$04
    BNE draw2
    LDA stage1,Y
    JMP draw
draw2:
    LDA test,Y
draw:
    ;;
    ; LDA test,Y
    JSR draw_byte_givenX
    PLA
    TAY
    INY
    CPY #60
    BNE load_leftnametable

    LDA #$01
    STA left_or_right

load_rightnametable:
    TYA
    LOOP2:
    SEC           ; Set the carry flag to indicate a borrow
    SBC #60     ; Subtract 60 (3C in hexadecimal) from the accumulator
    BCS LOOP2      ; Branch to LOOP if no borrow (carry flag set)
    ADC #60
    TAX

    TYA
    PHA
    LDA stage
    CMP #$04
    BNE draw2right
    LDA stage1,Y
    JMP drawright
draw2right:
    LDA test,Y
drawright:
    JSR draw_byte_givenX
    PLA
    TAY
    INY
    CPY #120
    BNE load_rightnametable

    PLP
    PLA
    TAX
    PLA
    RTS

.endproc

.export draw_byte_givenX
.proc draw_byte_givenX
; Draws a byte given the Mega Index in name table

    PHA

    TXA
    LSR A
    LSR A
    STA mega_y
    TXA
    AND #%00000011
    STA mega_x

    LDA mega_y
    LSR A
    LSR A
    AND #%00000011
    STA offset_high

    LDA mega_x
    ASL
    ASL
    ASL
    STA mega_x
    LDA mega_y
    ASL
    ASL
    ASL
    ASL
    ASL
    ASL
    CLC
    ADC mega_x
    STA offset_low

    PLA

    JSR draw_byte

    RTS

.endproc

.export draw_byte
.proc draw_byte
; Draws 4 megatiles horizontally
; Inputs:
;   A - byte to decrypt
;   offset_high - Offset
;   offset_low - Offset

LDY #$00        ; Initialize X register as loop counter
Loop:
    ASL A
    ROL tile_offset
    ASL A 
    ROL tile_offset

    PHA
    LDA tile_offset
    AND #%00000011
    STA tile_offset
    PLA

    ; ASL A         ; Shift all bits in the accumulator to the left by one position
    ; ASL A           ; Rotate again to move the next two bits into the lower position        ; Shift all bits in the accumulator to the left by one position

    PHA

    LDA stage
    CLC
    ADC tile_offset
    JSR draw_megatiles

    LDA offset_low   ; Load offset_low into accumulator
    CLC               ; Clear carry flag
    ADC #$01          ; Increment offset_low
    STA offset_low    ; Store the result back into offset_low
    BCC NoOverflow    ; Branch if no overflow (carry flag not set)
    INC offset_high   ; Increment offset_high if there's an overflow
NoOverflow:
    PLA
    INY           ; Increment X register (for the next storage location)
    CPY #$04      ; Compare X with 4 (loop for 4 iterations)
    BNE Loop

    RTS
.endproc

.export draw_megatiles
.proc draw_megatiles
; Draws megatile starting at PPU address plus offset
; Inputs:
;   A - Value to write
;   offset high - Offset
;   offset low - Offset

    ;first draw
    JSR draw_with_offset
    ;second draw
    PHA
    LDA offset_low   ; Load offset_low into accumulator
    CLC               ; Clear carry flag
    ADC #$01          ; Increment offset_low
    STA offset_low    ; Store the result back into offset_low
    BCC NoOverflow    ; Branch if no overflow (carry flag not set)
    INC offset_high   ; Increment offset_high if there's an overflow
NoOverflow:
    PLA 
    JSR draw_with_offset
    ;thrid draw
    PHA
    LDA offset_low   ; Load offset_low into accumulator
    CLC               ; Clear carry flag
    ADC #31          ; Increment offset_low
    STA offset_low    ; Store the result back into offset_low
    BCC NoOverflow2    ; Branch if no overflow (carry flag not set)
    INC offset_high   ; Increment offset_high if there's an overflow
NoOverflow2:
    PLA 
    JSR draw_with_offset
    ;fourth draw
    PHA
    LDA offset_low   ; Load offset_low into accumulator
    CLC               ; Clear carry flag
    ADC #$01          ; Increment offset_low
    STA offset_low    ; Store the result back into offset_low
    BCC NoOverflow3    ; Branch if no overflow (carry flag not set)
    INC offset_high   ; Increment offset_high if there's an overflow
NoOverflow3:
    PLA 
    JSR draw_with_offset

    PHA
    LDA offset_low   ; Load offset_low into accumulator
    SEC               ; Set carry flag to indicate a borrow
    SBC #32          ; Decrement offset_low
    STA offset_low    ; Store the result back into offset_low
    BCS NoUnderflow   ; Branch if no underflow (carry flag set)
    DEC offset_high   ; Decrement offset_high if there's an underflow
NoUnderflow:
    PLA
    RTS               ; Return from subroutine

.endproc

.export draw_with_offset
.proc draw_with_offset

; Subroutine to write a value to PPU data at address 2000 + offset
; Inputs:
;   A - Value to write
;   offset high - Offset
;   offset low - Offset
    PHA

    LDA PPUSTATUS
    LDA left_or_right
    CMP #$00
    BNE right
    LDA #$20      ; Load 20 into the accumulator (2000 in hex)
    JMP draw

right:
    LDA #$24 

draw:
    CLC           ; Clear carry flag
    ADC offset_high       ; Add carry flag and the offset
    STA PPUADDR       ; Store the result in a temporary location
    LDA #$00
    CLC
    ADC offset_low
    STA PPUADDR

    PLA

    STA PPUDATA

    RTS           ; Return from subroutine
.endproc

.export draw_stage2
.proc draw_stage2

    LDA #$00 
    STA ppuctrl_settings
    STA PPUCTRL
    STA PPUMASK

    LDA #$08
    STA stage
    JSR draw_nametable

    LDA #$00
    STA switch_stage

    LDA #%10010000  ; turn on NMIs, sprites use first pattern table
    STA ppuctrl_settings
    STA PPUCTRL
    LDA #$00
    STA scroll
    LDA #%00011110  ; turn on screen
    STA PPUMASK

    RTS

.endproc
