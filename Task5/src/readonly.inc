.segment "RODATA"
palettes:
.byte $0F, $31, $2C, $0C
.byte $0F, $15, $05, $24
.byte $0F, $19, $0A, $29
.byte $0F, $0B, $17, $2B

.byte $0F, $0f, $00, $20
.byte $0F, $19, $09, $29
.byte $0F, $19, $09, $29
.byte $0F, $19, $09, $29

stage1:
;stage 1 left
.byte %11111111, %11111111, %11111111, %11111111
.byte %00000000, %00000000, %00000000, %00000000
.byte %00111111, %11101001, %11111101, %10111101
.byte %00110111, %01011011, %11011001, %10011101
.byte %00100111, %11010101, %01011010, %10011101
.byte %00100101, %01011111, %11011001, %10011101
.byte %00101111, %01101001, %11111001, %10011101
.byte %00100111, %11100101, %01010101, %10011111
.byte %00110111, %01101101, %11111110, %10010101
.byte %00110111, %01100101, %11010110, %10011101
.byte %00110111, %01101001, %11110111, %01011101
.byte %00110111, %01010101, %01110111, %11011101
.byte %00110111, %01101010, %01110101, %11011101
.byte %11110111, %10100110, %10110111, %11111101
.byte %00000000, %00000000, %00000000, %00000000

;stage 1 right
.byte %11111111, %11111111, %11111111, %11111111
.byte %00000000, %00000000, %00000000, %00000000
.byte %01111110, %01111111, %01101011, %11111100
.byte %01110110, %01100111, %11100101, %11011100
.byte %01110110, %10100101, %01010111, %11011000
.byte %01110110, %01100111, %11110101, %01011000
.byte %01110110, %01101111, %01101001, %11111000
.byte %11110110, %01010101, %01011011, %11011000
.byte %01010110, %10111111, %01111001, %11011000
.byte %01110110, %10010111, %01011001, %11011100
.byte %01110101, %11011111, %01101001, %11011100
.byte %01110111, %11011101, %01010101, %11011100
.byte %01110111, %01011101, %10101001, %11011100
.byte %01111111, %11011110, %10011010, %11011111
.byte %00000000, %00000000, %00000000, %00000000

test:
;stage 1 left
.byte %11111111, %11111111, %11111111, %11111111
.byte %00000000, %00000000, %00000000, %00000000
.byte %00010101, %11101110, %11101110, %11101110
.byte %00010101, %11111111, %11111111, %11111111
.byte %00110111, %11010101, %01010101, %01010101
.byte %00111111, %01011010, %10101010, %10101001
.byte %00111101, %10100101, %01100101, %01101001
.byte %00110101, %10100101, %10101010, %01101001
.byte %00101001, %10101010, %10100110, %01101001
.byte %00011001, %01011001, %01010110, %01101001
.byte %00011010, %10101001, %11111110, %01101010
.byte %00011001, %01011010, %11010110, %01010101
.byte %00011001, %01010111, %11011010, %01101010
.byte %11111001, %11111111, %11010110, %10100101
.byte %00000000, %00000000, %00000000, %00000000

;stage 1 right
.byte %11111111, %11111111, %11111111, %11111111
.byte %00000000, %00000000, %00000000, %00000000
.byte %10111011, %10111011, %10111011, %01010100
.byte %11111111, %11111111, %11111111, %01010100
.byte %01010101, %01010101, %01010111, %11011100
.byte %01101010, %10101010, %10100101, %11111100
.byte %01101001, %01011001, %01011010, %01111100
.byte %01101001, %10101010, %01011010, %01011100
.byte %01101001, %10011010, %10101010, %01101000
.byte %01101001, %10010101, %01100101, %01100100
.byte %10101001, %10111111, %01101010, %10100100
.byte %01010101, %10010111, %10100101, %01101100
.byte %10101001, %10100111, %11010101, %01101100
.byte %01011010, %10010111, %11111111, %01101111
.byte %00000000, %00000000, %00000000, %00000000

bitmask:
.byte %11000000
.byte %00110000
.byte %00001100
.byte %00000011