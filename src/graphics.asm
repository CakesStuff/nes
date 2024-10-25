.importzp nmi_ready
.import palette
.importzp scroll_nmt
.importzp scroll_x

.export oam
.export ppu_init
.export ppu_update_frame
.export ppu_disable
.export ppu_switch
.export ppu_set_tile
.export ppu_wait
.export ppu_write_logo
.export ppu_set_xscroll
.export ppu_show_start_instruction
.export sprite_init
.export sprite_cursor_set
.export sprite_cursor_set_b

.include "defs.inc"

.segment "RODATA"
bgr_palette:
.byte $0A, $1D, $38, $10
.byte $00, $00, $00, $00
.byte $00, $00, $00, $00
.byte $00, $00, $00, $00
spr_palette:
.byte $0A, $28, $38, $39
.byte $0A, $1D, $20, $10
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

ppu_show_start_instruction:
    lda #$26
    sta PPU_ADDR
    lda #$EA
    sta PPU_ADDR
    lda #TILE_LETTER_P
    sta PPU_DATA
    lda #TILE_LETTER_R
    sta PPU_DATA
    lda #TILE_LETTER_E
    sta PPU_DATA
    lda #TILE_LETTER_S
    sta PPU_DATA
    lda #TILE_LETTER_S
    sta PPU_DATA
    lda #TILE_EMPTY
    sta PPU_DATA
    lda #TILE_EMPTY
    sta PPU_DATA
    lda #TILE_LETTER_S
    sta PPU_DATA
    lda #TILE_LETTER_T
    sta PPU_DATA
    lda #TILE_LETTER_A
    sta PPU_DATA
    lda #TILE_LETTER_R
    sta PPU_DATA
    lda #TILE_LETTER_T
    sta PPU_DATA

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL

    rts


.segment "OAM"
oam:
sprite_d_1_tl: .res 4
sprite_d_1_tr: .res 4
sprite_d_1_bl: .res 4
sprite_d_1_br: .res 4
sprite_d_2_tl: .res 4
sprite_d_2_tr: .res 4
sprite_d_2_bl: .res 4
sprite_d_2_br: .res 4
sprite_sel_tl: .res 4
sprite_sel_tr: .res 4
sprite_sel_bl: .res 4
sprite_sel_br: .res 4
sprite_sel_t: .res 4
sprite_sel_l: .res 4
sprite_sel_b: .res 4
sprite_sel_r: .res 4
sprite_sel_tb: .res 4
sprite_sel_lb: .res 4
sprite_sel_bb: .res 4
sprite_sel_rb: .res 4
.res 176

.segment "CODE"

sprite_cursor_set:
.assert SPRITE_Y_OFFSET = 0, error, "Sprite y location is assumed to be Byte 0!"
    tya
    clc
    sbc #8
    sta sprite_sel_tl
    sta sprite_sel_t
    sta sprite_sel_tr
    clc
    adc #8
    sta sprite_sel_l
    sta sprite_sel_r
    clc
    adc #8
    sta sprite_sel_bl
    sta sprite_sel_b
    sta sprite_sel_br
    txa
    ldx #SPRITE_X_OFFSET
    clc
    sbc #8
    sta sprite_sel_tl, X
    sta sprite_sel_l, X
    sta sprite_sel_bl, X
    clc
    adc #8
    sta sprite_sel_t, X
    sta sprite_sel_b, X
    clc
    adc #8
    sta sprite_sel_tr, X
    sta sprite_sel_r, X
    sta sprite_sel_br, X
    ldy #$FF
    sty sprite_sel_tb
    sty sprite_sel_lb
    sty sprite_sel_rb
    sty sprite_sel_bb
    rts

sprite_cursor_set_b:
.assert SPRITE_Y_OFFSET = 0, error, "Sprite y location is assumed to be Byte 0!"
    tya
    clc
    sbc #8
    sta sprite_sel_tl
    sta sprite_sel_t
    sta sprite_sel_tb
    sta sprite_sel_tr
    clc
    adc #8
    sta sprite_sel_l
    sta sprite_sel_r
    clc
    adc #8
    sta sprite_sel_lb
    sta sprite_sel_rb
    clc
    adc #8
    sta sprite_sel_bl
    sta sprite_sel_b
    sta sprite_sel_bb
    sta sprite_sel_br
    txa
    ldx #SPRITE_X_OFFSET
    clc
    sbc #8
    sta sprite_sel_tl, X
    sta sprite_sel_l, X
    sta sprite_sel_lb, X
    sta sprite_sel_bl, X
    clc
    adc #8
    sta sprite_sel_t, X
    sta sprite_sel_b, X
    clc
    adc #8
    sta sprite_sel_tb, X
    sta sprite_sel_bb, X
    clc
    adc #8
    sta sprite_sel_tr, X
    sta sprite_sel_r, X
    sta sprite_sel_rb, X
    sta sprite_sel_br, X
    rts

sprite_dice_1_set_tile:
    ldx #SPRITE_TILE_OFFSET
    sta sprite_d_1_tl, X
    clc
    adc #16
    sta sprite_d_1_tr, X
    clc
    adc #16
    sta sprite_d_1_bl, X
    clc
    adc #16
    sta sprite_d_1_br, X
    rts

sprite_dice_2_set_tile:
    ldx #SPRITE_TILE_OFFSET
    sta sprite_d_2_tl, X
    clc
    adc #16
    sta sprite_d_2_tr, X
    clc
    adc #16
    sta sprite_d_2_bl, X
    clc
    adc #16
    sta sprite_d_2_br, X
    rts

sprite_init:
    ldx #SPRITE_ATTRIBUTE_OFFSET
    lda #((SPRITE_PALETTE_DICE) & SPRITE_FLAG_MASK)
    sta sprite_d_1_tl, X
    sta sprite_d_1_tr, X
    sta sprite_d_1_bl, X
    sta sprite_d_1_br, X
    sta sprite_d_2_tl, X
    sta sprite_d_2_tr, X
    sta sprite_d_2_bl, X
    sta sprite_d_2_br, X

    lda #SPRITE_D_1
    jsr sprite_dice_1_set_tile
    lda #SPRITE_D_1
    jsr sprite_dice_2_set_tile

    ldx #SPRITE_ATTRIBUTE_OFFSET
    lda #((SPRITE_PALETTE_CURSOR) & SPRITE_FLAG_MASK)
    sta sprite_sel_tl, X
    ora #SPRITE_FLAG_FLIP_H
    sta sprite_sel_tr, X
    ora #SPRITE_FLAG_FLIP_V
    sta sprite_sel_br, X
    and #((~SPRITE_FLAG_FLIP_H) & SPRITE_FLAG_MASK)
    sta sprite_sel_bl, X

    lda #((SPRITE_PALETTE_CURSOR) & SPRITE_FLAG_MASK)
    sta sprite_sel_t, X
    sta sprite_sel_tb, X
    sta sprite_sel_l, X
    sta sprite_sel_lb, X
    ora #(SPRITE_FLAG_FLIP_H | SPRITE_FLAG_FLIP_V);   :)
    sta sprite_sel_b, X
    sta sprite_sel_bb, X
    sta sprite_sel_r, X
    sta sprite_sel_rb, X

    ldx #SPRITE_TILE_OFFSET
    lda #SPRITE_SEL_TL
    sta sprite_sel_tl, X
    sta sprite_sel_tr, X
    sta sprite_sel_bl, X
    sta sprite_sel_br, X
    lda #SPRITE_SEL_T
    sta sprite_sel_t, X
    sta sprite_sel_tb, X
    sta sprite_sel_b, X
    sta sprite_sel_bb, X
    lda #SPRITE_SEL_L
    sta sprite_sel_l, X
    sta sprite_sel_lb, X
    sta sprite_sel_r, X
    sta sprite_sel_rb, X

    rts
