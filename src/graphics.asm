.importzp nmi_ready
.importzp nmi_count
.import palette
.importzp scroll_nmt
.importzp scroll_x
.import crand
.import rand
.import mod6
.importzp dice_res_1
.importzp dice_res_2

.export oam
.export ppu_init
.export ppu_update_frame
.export ppu_disable
.export ppu_switch
.export ppu_wait
.export ppu_write_logo
.export ppu_set_xscroll
.export ppu_show_start_instruction
.export sprite_init
.export sprite_cursor_set
.export sprite_cursor_set_b
.export sprite_cursor_color_switch
.export dice_roll
.export dice_hide
.export ppu_start_game_animation
.export ppu_state_switch_left
.export ppu_state_switch_right

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
.byte $0A, $11, $22, $21
.byte $00, $00, $00, $00

.segment "ZEROPAGE"
ppu_byte_buffer: .res 1
ppu_loop_counter: .res 1
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
    lda PPU_STATUS

    lda #$20
	sta PPU_ADDR
	ldx #$00
	stx PPU_ADDR

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL

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

.macro ppu_set_tile_off tile, tx, ty
    lda scroll_nmt
    clc
    adc #1
    and #%00000001
    asl A
    asl A
    adc #($20 + (ty >> 3))
    sta PPU_ADDR
    lda #(((ty << 5) + tx) & 255);FFS
    sta PPU_ADDR
    lda #(tile)
    sta PPU_DATA
.endmacro
.macro ppu_set_tile_on tile, tx, ty
    lda scroll_nmt
    and #%00000001
    asl A
    asl A
    adc #($20 + (ty >> 3))
    sta PPU_ADDR
    lda #(((ty << 5) + tx) & 255);FFS
    sta PPU_ADDR
    lda #(tile)
    sta PPU_DATA
.endmacro

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
    ldx PPU_STATUS

    and #%00000001
    asl A
    asl A
    clc
    adc #$21
    sta PPU_ADDR
    ldx #0
    stx PPU_ADDR

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
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
    lda PPU_STATUS

    lda #$26
    sta PPU_ADDR
    lda #$EA
    sta PPU_ADDR

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL

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

ppu_start_game_animation:
    jsr ppu_switch
    jsr ppu_update_frame
    jsr ppu_wait

    lda PPU_STATUS

    ppu_set_tile_on TILE_BORDER_B, 0, 2

    ldx #0
    stx PPU_SCROLL
    stx PPU_SCROLL

    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_BL
    sta PPU_DATA
    lda #TILE_EMPTY
    ldx #16
    :
        sta PPU_DATA
        dex
        bne :-
    lda #TILE_CORNER_BR
    sta PPU_DATA
    lda #TILE_BORDER_B
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    lda #1
    sta ppu_loop_counter

@loop:
    jsr ppu_update_frame
    jsr ppu_wait

    lda PPU_STATUS

    lda scroll_nmt
    and #%00000001
    asl A
    asl A
    adc #$20
    sta ppu_byte_buffer
    inc ppu_loop_counter
    lda ppu_loop_counter
    asl A
    sec
    sbc #1
    pha
    lsr A
    lsr A
    lsr A
    clc
    adc ppu_byte_buffer
    sta ppu_address_buffer_high
    sta PPU_ADDR
    pla
    asl A
    asl A
    asl A
    asl A
    asl A
    sta ppu_address_buffer_low
    sta PPU_ADDR

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL

    lda #TILE_FULL
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #10
    cmp ppu_loop_counter
    bpl :+

    lda #TILE_ONE
    pha
    sta PPU_DATA
    lda ppu_loop_counter
    sec
    sbc #10
    pha
    sta PPU_DATA
    jmp :++

    :

    lda #TILE_FULL
    pha
    sta PPU_DATA
    lda ppu_loop_counter
    pha
    sta PPU_DATA

    :

    lda #TILE_BORDER_L
    sta PPU_DATA
    lda #TILE_EMPTY
    ldx #16
    :
        sta PPU_DATA
        dex
        bne :-
    lda #TILE_BORDER_R
    sta PPU_DATA
    pla
    tax
    pla
    sta PPU_DATA
    stx PPU_DATA
    lda #TILE_FULL
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    
    jsr ppu_update_frame
    jsr ppu_wait
    
    lda #13
    cmp ppu_loop_counter
    beq @loop_end

    lda PPU_STATUS

    lda #32
    clc
    adc ppu_address_buffer_low
    sta ppu_address_buffer_low
    lda #0
    adc ppu_address_buffer_high
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL

    lda #TILE_BORDER_H
    ldx #7
    :
        sta PPU_DATA
        dex
        bne :-
    lda #TILE_DCORNER_L
    sta PPU_DATA
    lda #TILE_EMPTY
    ldx #16
    :
        sta PPU_DATA
        dex
        bne :-
    lda #TILE_DCORNER_R
    sta PPU_DATA
    lda #TILE_BORDER_H
    ldx #7
    :
        sta PPU_DATA
        dex
        bne :-

    jmp @loop

@loop_end:

    lda PPU_STATUS

    ppu_set_tile_on TILE_BORDER_T, 0, ((12 * 2) + 2)

    ldx #0
    stx PPU_SCROLL
    stx PPU_SCROLL

    ldx #6
    :
        sta PPU_DATA
        dex
        bne :-
    lda #TILE_CORNER_TL
    sta PPU_DATA
    lda #TILE_EMPTY
    ldx #16
    :
        sta PPU_DATA
        dex
        bne :-
    lda #TILE_CORNER_TR
    sta PPU_DATA
    lda #TILE_BORDER_T
    ldx #7
    :
        sta PPU_DATA
        dex
        bne :-

    jsr ppu_update_frame
    jsr ppu_wait

    lda PPU_STATUS

    ppu_set_tile_on TILE_DICE_TL, (DICE_ROLL_X-1), (DICE_ROLL_Y-1)
    ppu_set_tile_on TILE_DICE_TR, (DICE_ROLL_X),   (DICE_ROLL_Y-1)
    ppu_set_tile_on TILE_DICE_BL, (DICE_ROLL_X-1), (DICE_ROLL_Y)
    ppu_set_tile_on TILE_DICE_BR, (DICE_ROLL_X),   (DICE_ROLL_Y)
    ppu_set_tile_on TILE_CONF_TL, (CONF_BTN_X-1),  (CONF_BTN_Y-1)
    ppu_set_tile_on TILE_CONF_TR, (CONF_BTN_X),    (CONF_BTN_Y-1)
    ppu_set_tile_on TILE_CONF_BL, (CONF_BTN_X-1),  (CONF_BTN_Y)
    ppu_set_tile_on TILE_CONF_BR, (CONF_BTN_X),    (CONF_BTN_Y)

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    
    jsr ppu_update_frame
    jsr ppu_wait

    rts

.segment "BSS"

states_left: .res 13
states_right: .res 13

.segment "CODE"
ppu_state_switch_left:
    sta ppu_byte_buffer
    lsr A
    lsr A
    sta ppu_address_buffer_high
    lda ppu_byte_buffer
    asl A
    asl A
    asl A
    asl A
    asl A
    asl A
    sta ppu_address_buffer_low

    lda scroll_nmt
    and #%00000001
    asl A
    asl A
    adc #$20
    adc ppu_address_buffer_high
    sta ppu_address_buffer_high
    lda ppu_address_buffer_low
    adc #5
    sta ppu_address_buffer_low

    jsr ppu_update_frame
    jsr ppu_wait

    lda PPU_STATUS
    lda ppu_address_buffer_high
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda ppu_byte_buffer
    tax

    lda states_left, X
    cmp #0
    bne :+
        lda #1
        sta states_left, X
        jmp @this_extended
    :
    lda #0
    sta states_left, X

    lda ppu_byte_buffer
    cmp #1
    bne :+
        jmp @ppu_state_switch_left_1_retracted
    :

    dex

    lda states_left, X
    cmp #0

    beq :+

    ;------|
    ;-+----/
    ;-/

    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_EMPTY_BR
    sta PPU_DATA
    lda #TILE_BORDER_T
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_TL
    sta PPU_DATA
    jmp :++

    :

    ;-\
    ;-|
    ;-/

    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_DCORNER_L
    sta PPU_DATA
    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    :
    
@middle_row_start_retracted:

    lda ppu_address_buffer_low
    clc
    adc #32
    sta ppu_address_buffer_low
    lda ppu_address_buffer_high
    adc #0
    sta ppu_address_buffer_high
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda #TILE_CROSS
    sta PPU_DATA
    sta PPU_DATA

    lda #TILE_BORDER_L
    sta PPU_DATA
    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    lda ppu_address_buffer_low
    clc
    adc #32
    sta ppu_address_buffer_low
    lda ppu_address_buffer_high
    adc #0
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda ppu_byte_buffer
    cmp #12
    bne :+
        jmp @ppu_state_switch_left_12_retracted
    :

    tax
    inx

    lda states_left, X
    cmp #0
    beq :+
    
    ;-\
    ;-+----\
    ;------|

    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_EMPTY_TR
    sta PPU_DATA
    lda #TILE_BORDER_B
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_BL
    sta PPU_DATA
    jmp :++

    :

    ;-\
    ;-|
    ;-/

    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_DCORNER_L
    sta PPU_DATA
    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    :

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    rts

@this_extended:
    lda ppu_byte_buffer
    cmp #1
    bne :+
        jmp @ppu_state_switch_left_1_extended
    :

    dex

    lda states_left, X
    cmp #0

    beq :+

    ;------|
    ;------|
    ;------|
    
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_DCORNER_L
    sta PPU_DATA
    
    jmp :++

    :

    ;-\
    ;-+----\
    ;------|

    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_EMPTY_TR
    sta PPU_DATA
    lda #TILE_BORDER_B
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_BL
    sta PPU_DATA

    :
    
@middle_row_start_extended:

    lda ppu_address_buffer_low
    clc
    adc #32
    sta ppu_address_buffer_low
    lda ppu_address_buffer_high
    adc #0
    sta ppu_address_buffer_high
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda #TILE_FULL
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    lda ppu_byte_buffer
    cmp #10
    bpl :+

    pha
    lda #TILE_FULL
    sta PPU_DATA
    pla
    clc
    adc #1
    sta PPU_DATA
    jmp :++

    :

    sec
    sbc #9
    pha
    lda #TILE_ONE
    sta PPU_DATA
    pla
    sta PPU_DATA

    :

    lda #TILE_BORDER_L
    sta PPU_DATA

    lda ppu_address_buffer_low
    clc
    adc #32
    sta ppu_address_buffer_low
    lda ppu_address_buffer_high
    adc #0
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda ppu_byte_buffer
    cmp #12
    beq @ppu_state_switch_left_12_extended

    tax
    inx

    lda states_left, X
    cmp #0
    beq :+

    ;------|
    ;------|
    ;------|
    
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_DCORNER_L
    sta PPU_DATA

    jmp :++

    :
    
    ;------|
    ;-+----/
    ;-/

    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_EMPTY_BR
    sta PPU_DATA
    lda #TILE_BORDER_T
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_TL
    sta PPU_DATA

    :

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    rts

@ppu_state_switch_left_1_extended:
    lda #TILE_BORDER_B
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_BL
    sta PPU_DATA
    jmp @middle_row_start_extended

@ppu_state_switch_left_1_retracted:
    lda #TILE_BORDER_B
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_BL
    sta PPU_DATA
    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    jmp @middle_row_start_retracted

@ppu_state_switch_left_12_extended:
    lda #TILE_BORDER_T
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_TL
    sta PPU_DATA

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    rts

@ppu_state_switch_left_12_retracted:
    lda #TILE_BORDER_T
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_TL
    sta PPU_DATA
    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    rts

ppu_state_switch_right:
    sta ppu_byte_buffer
    lsr A
    lsr A
    sta ppu_address_buffer_high
    lda ppu_byte_buffer
    asl A
    asl A
    asl A
    asl A
    asl A
    asl A
    sta ppu_address_buffer_low

    lda scroll_nmt
    and #%00000001
    asl A
    asl A
    adc #$20
    adc ppu_address_buffer_high
    sta ppu_address_buffer_high
    lda ppu_address_buffer_low
    adc #21
    sta ppu_address_buffer_low

    jsr ppu_update_frame
    jsr ppu_wait

    lda PPU_STATUS
    lda ppu_address_buffer_high
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda ppu_byte_buffer
    tax

    lda states_right, X
    cmp #0
    bne :+
        lda #1
        sta states_right, X
        jmp @this_extended
    :
    lda #0
    sta states_right, X

    lda ppu_byte_buffer
    cmp #1
    bne :+
        jmp @ppu_state_switch_right_1_retracted
    :

    dex

    lda states_right, X
    cmp #0

    beq :+

    ;------|
    ;-+----/
    ;-/

    lda #TILE_CORNER_TR
    sta PPU_DATA
    lda #TILE_BORDER_T
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_EMPTY_BL
    sta PPU_DATA
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    jmp :++

    :

    ;-\
    ;-|
    ;-/

    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_DCORNER_R
    sta PPU_DATA
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA

    :
    
@middle_row_start_retracted:

    lda ppu_address_buffer_low
    clc
    adc #32
    sta ppu_address_buffer_low
    lda ppu_address_buffer_high
    adc #0
    sta ppu_address_buffer_high
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_BORDER_R
    sta PPU_DATA

    lda #TILE_CROSS
    sta PPU_DATA
    sta PPU_DATA

    lda ppu_address_buffer_low
    clc
    adc #32
    sta ppu_address_buffer_low
    lda ppu_address_buffer_high
    adc #0
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda ppu_byte_buffer
    cmp #12
    bne :+
        jmp @ppu_state_switch_right_12_retracted
    :

    tax
    inx

    lda states_right, X
    cmp #0
    beq :+
    
    ;-\
    ;-+----\
    ;------|

    lda #TILE_CORNER_BR
    sta PPU_DATA
    lda #TILE_BORDER_B
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_EMPTY_TL
    sta PPU_DATA
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    jmp :++

    :

    ;-\
    ;-|
    ;-/

    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_DCORNER_R
    sta PPU_DATA
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA

    :

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    rts

@this_extended:
    lda ppu_byte_buffer
    cmp #1
    bne :+
        jmp @ppu_state_switch_right_1_extended
    :

    dex

    lda states_right, X
    cmp #0

    beq :+

    ;------|
    ;------|
    ;------|
    
    lda #TILE_DCORNER_R
    sta PPU_DATA
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    
    jmp :++

    :

    ;-\
    ;-+----\
    ;------|

    lda #TILE_CORNER_BR
    sta PPU_DATA
    lda #TILE_BORDER_B
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_EMPTY_TL
    sta PPU_DATA
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA

    :
    
@middle_row_start_extended:

    lda ppu_address_buffer_low
    clc
    adc #32
    sta ppu_address_buffer_low
    lda ppu_address_buffer_high
    adc #0
    sta ppu_address_buffer_high
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda #TILE_BORDER_R
    sta PPU_DATA

    lda ppu_byte_buffer
    cmp #10
    bpl :+

    pha
    lda #TILE_FULL
    sta PPU_DATA
    pla
    clc
    adc #1
    sta PPU_DATA
    jmp :++

    :

    sec
    sbc #9
    pha
    lda #TILE_ONE
    sta PPU_DATA
    pla
    sta PPU_DATA

    :

    lda #TILE_FULL
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    lda ppu_address_buffer_low
    clc
    adc #32
    sta ppu_address_buffer_low
    lda ppu_address_buffer_high
    adc #0
    sta PPU_ADDR
    lda ppu_address_buffer_low
    sta PPU_ADDR

    lda ppu_byte_buffer
    cmp #12
    beq @ppu_state_switch_right_12_extended

    tax
    inx

    lda states_right, X
    cmp #0
    beq :+

    ;------|
    ;------|
    ;------|
    
    lda #TILE_DCORNER_R
    sta PPU_DATA
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    jmp :++

    :
    
    ;------|
    ;-+----/
    ;-/

    lda #TILE_CORNER_TR
    sta PPU_DATA
    lda #TILE_BORDER_T
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_EMPTY_BL
    sta PPU_DATA
    lda #TILE_BORDER_H
    sta PPU_DATA
    sta PPU_DATA

    :

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    rts

@ppu_state_switch_right_1_extended:
    lda #TILE_CORNER_BR
    sta PPU_DATA
    lda #TILE_BORDER_B
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    jmp @middle_row_start_extended

@ppu_state_switch_right_1_retracted:
    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_BR
    sta PPU_DATA
    lda #TILE_BORDER_B
    sta PPU_DATA
    sta PPU_DATA
    jmp @middle_row_start_retracted

@ppu_state_switch_right_12_extended:
    lda #TILE_CORNER_TR
    sta PPU_DATA
    lda #TILE_BORDER_T
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    rts

@ppu_state_switch_right_12_retracted:
    lda #TILE_EMPTY
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #TILE_CORNER_TR
    sta PPU_DATA
    lda #TILE_BORDER_T
    sta PPU_DATA
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

.segment "RODATA"

DICE_BRING_UP_AMOUNT = (112 - 1)
dice_table:
    .byte (3  + DICE_BRING_UP_AMOUNT)
    .byte (11 + DICE_BRING_UP_AMOUNT)
    .byte (0  + DICE_BRING_UP_AMOUNT)
    .byte (8  + DICE_BRING_UP_AMOUNT)
    .byte (14 + DICE_BRING_UP_AMOUNT)
    .byte (6  + DICE_BRING_UP_AMOUNT)

.segment "ZEROPAGE"
dice_1_state: .res 1
dice_2_state: .res 1
dice_wait_time: .res 1
dice_wait_index: .res 1

.segment "CODE"

dice_hide:
    lda #$FF
    jmp dice_set_y

dice_set_y:
    ldx #SPRITE_Y_OFFSET
    sta sprite_d_1_tl, X
    sta sprite_d_1_tr, X
    sta sprite_d_2_tl, X
    sta sprite_d_2_tr, X
    clc
    adc #8
    bcc :+
    lda #$FF
    :
    sta sprite_d_1_bl, X
    sta sprite_d_1_br, X
    sta sprite_d_2_bl, X
    sta sprite_d_2_br, X
    rts

dice_roll:
    lda nmi_count
    jsr crand
    jsr rand
    jsr mod6
    sta dice_res_1
    inc dice_res_1
    tax
    lda dice_table, X
    sta dice_1_state
    and #$F
    jsr sprite_dice_1_set_tile
    jsr rand
    jsr mod6
    sta dice_res_2
    inc dice_res_2
    tax
    lda dice_table, X
    sta dice_2_state
    and #$F
    jsr sprite_dice_2_set_tile

    lda #%100000
    sta dice_wait_time

@roll_loop:
    lda dice_wait_time
    lsr A
    lsr A
    lsr A
    lsr A
    lsr A
    sta dice_wait_index

@wait_loop:
    jsr ppu_update_frame
    jsr ppu_wait

    dec dice_wait_index
    lda dice_wait_index
    bne @wait_loop

    ldx #SPRITE_Y_OFFSET
    dec sprite_d_1_tl, X
    lda sprite_d_1_tl, X
    jsr dice_set_y

    dec dice_1_state
    lda dice_1_state
    and #$F
    jsr sprite_dice_1_set_tile
    dec dice_2_state
    lda dice_2_state
    and #$F
    jsr sprite_dice_2_set_tile

    inc dice_wait_time
    lda dice_wait_time
    sec
    sbc #(%100000 + DICE_BRING_UP_AMOUNT)
    bne @roll_loop

    rts

sprite_cursor_set:
.assert SPRITE_Y_OFFSET = 0, error, "Sprite y location is assumed to be Byte 0!"
    tya
    sec
    sbc #17
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
    sta sprite_sel_bl
    sta sprite_sel_b
    sta sprite_sel_bb
    sta sprite_sel_br
    txa
    ldx #SPRITE_X_OFFSET
    sec
    sbc #16
    sta sprite_sel_tl, X
    sta sprite_sel_l, X
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
    sta sprite_sel_br, X
    ldy #$FF
    sty sprite_sel_lb
    sty sprite_sel_rb
    rts

sprite_cursor_set_b:
.assert SPRITE_Y_OFFSET = 0, error, "Sprite y location is assumed to be Byte 0!"
    tya
    sec
    sbc #17
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
    sec
    sbc #16
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

sprite_cursor_color_switch:
    ldx #SPRITE_ATTRIBUTE_OFFSET
    lda sprite_sel_tl, X
    eor #%10
    sta sprite_sel_tl, X
    lda sprite_sel_tr, X
    eor #%10
    sta sprite_sel_tr, X
    lda sprite_sel_bl, X
    eor #%10
    sta sprite_sel_bl, X
    lda sprite_sel_br, X
    eor #%10
    sta sprite_sel_br, X
    lda sprite_sel_t, X
    eor #%10
    sta sprite_sel_t, X
    lda sprite_sel_l, X
    eor #%10
    sta sprite_sel_l, X
    lda sprite_sel_b, X
    eor #%10
    sta sprite_sel_b, X
    lda sprite_sel_r, X
    eor #%10
    sta sprite_sel_r, X
    lda sprite_sel_tb, X
    eor #%10
    sta sprite_sel_tb, X
    lda sprite_sel_lb, X
    eor #%10
    sta sprite_sel_lb, X
    lda sprite_sel_bb, X
    eor #%10
    sta sprite_sel_bb, X
    lda sprite_sel_rb, X
    eor #%10
    sta sprite_sel_rb, X
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

    ldx #SPRITE_X_OFFSET
    lda #160
    sta sprite_d_2_br, X
    sta sprite_d_2_tr, X
    sec
    sbc #8
    sta sprite_d_2_bl, X
    sta sprite_d_2_tl, X
    lda #96
    sta sprite_d_1_br, X
    sta sprite_d_1_tr, X
    sec
    sbc #8
    sta sprite_d_1_bl, X
    sta sprite_d_1_tl, X
    jsr dice_hide

    rts
