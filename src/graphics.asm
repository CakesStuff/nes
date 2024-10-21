.importzp nmi_ready
.import palette
.importzp scroll_nmt
.importzp scroll_x

.export ppu_init
.export ppu_update_frame
.export ppu_disable
.export ppu_switch
.export ppu_set_tile
.export ppu_wait
.export ppu_write_logo
.export ppu_set_xscroll

.include "defs.inc"

.segment "RODATA"
bgr_palette:
.byte $0A, $1D, $38, $10
.byte $00, $00, $00, $00
.byte $00, $00, $00, $00
.byte $00, $00, $00, $00
spr_palette:
.byte $0A, $00, $00, $00
.byte $00, $00, $00, $00
.byte $00, $00, $00, $00
.byte $00, $00, $00, $00

.segment "ZEROPAGE"
ppu_byte_buffer: .res 1
ppu_address_buffer:
ppu_address_buffer_low: .res 1
ppu_address_buffer_high: .res 1

.segment "CODE"
ppu_init:
    ;Copy palettes
    ldx #0
	:
		lda bgr_palette, X
		sta palette, X
		inx
		cpx #$20
		bcc :-

    jsr ppu_disable

    jsr ppu_clear

    rts

ppu_clear:
    lda #$20
	sta PPU_ADDR
	ldx #$00
	stx PPU_ADDR
	lda #TILE_EMPTY
	ldy #8
@loop:
	:
		sta PPU_DATA
		inx
		bne :-
	
	dey
	bne @loop
    rts

ppu_update_frame:
    lda #1
    sta nmi_ready
    rts

ppu_disable:
    lda #2
    sta nmi_ready
    rts

ppu_switch:
    ldx scroll_nmt
    inx
    stx scroll_nmt
    rts

ppu_set_tile:
    pha
    lda scroll_nmt
    clc
    adc #1
    and #%00000001
    asl A
    asl A
    adc #$20
    sta ppu_byte_buffer
    tya
    lsr A
    lsr A
    lsr A
    adc ppu_byte_buffer
    sta PPU_ADDR
    tya
    asl A
    asl A
    asl A
    asl A
    asl A
    stx ppu_byte_buffer
    clc
    adc ppu_byte_buffer
    sta PPU_ADDR
    pla
    sta PPU_DATA
    rts

ppu_wait:
    lda nmi_ready
    cmp #0
    bne ppu_wait
    rts

ppu_set_xscroll:
    sta scroll_x
    rts

.segment "RODATA"

.linecont +
.define logo_data_table \
    logo_data_1, \
    logo_data_2, \
    logo_data_3, \
    logo_data_4, \
    logo_data_5, \
    logo_data_6, \
    logo_data_7, \
    logo_data_8, \
    logo_data_9, \
    logo_data_10, \
    logo_data_11, \
    logo_data_12, \
    logo_data_13
logo_data_table_low: .lobytes logo_data_table
logo_data_table_high: .hibytes logo_data_table

logo_data_1:    .byte TILE_CORNER_BR,   TILE_BORDER_B,  TILE_CORNER_BL, TILE_CORNER_BR, TILE_DCORNER_B, TILE_CORNER_BL, TILE_CORNER_BR, TILE_DCORNER_B, TILE_CORNER_BL, TILE_T_BR,      TILE_BORDER_B,  TILE_T_BL,      TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY,     TILE_T_BR,      TILE_BORDER_B,  TILE_T_BL,      TILE_CORNER_BR, TILE_DCORNER_B, TILE_CORNER_BL, TILE_CORNER_BR, TILE_BORDER_B,  TILE_CORNER_BL
logo_data_2:    .byte TILE_BORDER_R,    TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_T_TR,      TILE_FULL,      TILE_T_TL,      TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY,     TILE_T_TR,      TILE_FULL,      TILE_T_TL,      TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L
logo_data_3:    .byte TILE_BORDER_R,    TILE_BORDER_H,  TILE_DCORNER_L, TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_H,  TILE_DCORNER_L
logo_data_4:    .byte TILE_BORDER_R,    TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L
logo_data_5:    .byte TILE_DCORNER_R,   TILE_BORDER_H,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_H,  TILE_DCORNER_L
logo_data_6:    .byte TILE_BORDER_R,    TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_V,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_BORDER_L
logo_data_7:    .byte TILE_CORNER_TR,   TILE_BORDER_T,  TILE_CORNER_TL, TILE_CORNER_TR, TILE_DCORNER_T, TILE_CORNER_TL, TILE_CORNER_TR, TILE_BORDER_T,  TILE_CORNER_TL, TILE_CORNER_TR, TILE_BORDER_T,  TILE_CORNER_TL, TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY,     TILE_CORNER_TR, TILE_BORDER_T,  TILE_CORNER_TL, TILE_CORNER_TR, TILE_DCORNER_T, TILE_CORNER_TL, TILE_CORNER_TR, TILE_BORDER_T,  TILE_CORNER_TL
logo_data_8:    .byte TILE_EMPTY,       TILE_EMPTY,     TILE_EMPTY,     TILE_CORNER_BR, TILE_BORDER_B,  TILE_BORDER_B,  TILE_BORDER_B,  TILE_BORDER_B,  TILE_CORNER_BL, TILE_CORNER_BR, TILE_BORDER_B,  TILE_BORDER_B,  TILE_BORDER_B,  TILE_BORDER_B,  TILE_CORNER_BL, TILE_CORNER_BR, TILE_BORDER_B,  TILE_CORNER_BL, TILE_CORNER_BR, TILE_BORDER_B,  TILE_CORNER_BL, TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY
logo_data_9:    .byte TILE_EMPTY,       TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_EMPTY_BR,  TILE_BORDER_T,  TILE_BORDER_T,  TILE_EMPTY_BL,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_EMPTY_BR,  TILE_BORDER_T,  TILE_BORDER_T,  TILE_EMPTY_BL,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_EMPTY_TR,  TILE_EMPTY_TL,  TILE_FULL,      TILE_BORDER_L,  TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY
logo_data_10:   .byte TILE_EMPTY,       TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_EMPTY_TR,  TILE_BORDER_B,  TILE_BORDER_B,  TILE_EMPTY_TL,  TILE_DCORNER_L, TILE_BORDER_R,  TILE_BORDER_L,  TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_BORDER_L,  TILE_CORNER_TR, TILE_EMPTY_BL,  TILE_FULL,      TILE_FULL,      TILE_EMPTY_BR,  TILE_CORNER_TL, TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY
logo_data_11:   .byte TILE_EMPTY,       TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_EMPTY_BR,  TILE_BORDER_T,  TILE_BORDER_T,  TILE_EMPTY_BL,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_BORDER_L,  TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_BORDER_L,  TILE_CORNER_BR, TILE_EMPTY_TL,  TILE_FULL,      TILE_FULL,      TILE_EMPTY_TR,  TILE_CORNER_BL, TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY
logo_data_12:   .byte TILE_EMPTY,       TILE_EMPTY,     TILE_EMPTY,     TILE_BORDER_R,  TILE_EMPTY_TR,  TILE_BORDER_B,  TILE_BORDER_B,  TILE_EMPTY_TL,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_EMPTY_TR,  TILE_BORDER_B,  TILE_BORDER_B,  TILE_EMPTY_TL,  TILE_BORDER_L,  TILE_BORDER_R,  TILE_FULL,      TILE_EMPTY_BR,  TILE_EMPTY_BL,  TILE_FULL,      TILE_BORDER_L,  TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY
logo_data_13:   .byte TILE_EMPTY,       TILE_EMPTY,     TILE_EMPTY,     TILE_CORNER_TR, TILE_BORDER_T,  TILE_BORDER_T,  TILE_BORDER_T,  TILE_BORDER_T,  TILE_CORNER_TL, TILE_CORNER_TR, TILE_BORDER_T,  TILE_BORDER_T,  TILE_BORDER_T,  TILE_BORDER_T,  TILE_CORNER_TL, TILE_CORNER_TR, TILE_BORDER_T,  TILE_CORNER_TL, TILE_CORNER_TR, TILE_BORDER_T,  TILE_CORNER_TL, TILE_EMPTY,     TILE_EMPTY,     TILE_EMPTY

.segment "CODE"

ppu_write_logo:
    and #%00000001
    asl A
    asl A
    clc
    adc #$21
    sta PPU_ADDR
    ldx #0
    stx PPU_ADDR
@xloop:
    lda logo_data_table_low, x
    sta ppu_address_buffer_low
    lda logo_data_table_high, x
    sta ppu_address_buffer_high

    lda #TILE_EMPTY
    ;skip four lines
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    ldy #0
@yloop:
    lda (ppu_address_buffer), y
    sta PPU_DATA
    iny
    cpy #24
    bcc @yloop

    lda #TILE_EMPTY
    ;skip four lines
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    inx
    cpx #13
    bcc @xloop

    rts