.import controller_read_safe
.import controller_wait_on
.import controller_wait_off
.import dice_roll
.importzp dice_res_1
.importzp dice_res_2
.import sprite_cursor_set
.import sprite_cursor_set_b

.export game_update

.include "defs.inc"

.segment "ZEROPAGE"

game_state: .res 1
sum: .res 1
outside_index: .res 1

.segment "CODE"

game_place_cursor:
    lda game_state
    cmp #STATE_P1_CHOICE
    bne :+
        ldx #(6 * 8)
        jmp :++
    :
        ldx #(26 * 8)
    :

    lda outside_index
    asl A
    clc
    adc #2
    asl A
    asl A
    asl A
    tay
    jmp sprite_cursor_set

game_update:
    lda game_state
    cmp #STATE_P1_ROLL
    bne :+
        jmp @state_p1_roll
    :
    cmp #STATE_P1_CHOICE
    bne :+
        jmp @state_p1_choice
    :
    cmp #STATE_P1_CONFIRM
    bne :+
        jmp @state_p1_confirm
    :
    cmp #STATE_P2_ROLL
    bne :+
        jmp @state_p2_roll
    :
    cmp #STATE_P2_CHOICE
    bne :+
        jmp @state_p2_choice
    :
    jmp @state_p2_confirm

@state_p1_roll:
@state_p2_roll:
    lda #(BUTTON_A)
    jsr controller_wait_on
    lda #(BUTTON_A)
    jsr controller_wait_off
    jsr dice_roll

    lda dice_res_1
    clc
    adc dice_res_2
    sta sum
    lda #1
    sta outside_index

    lda game_state
    cmp #STATE_P1_ROLL
    bne :+
        lda #STATE_P1_CHOICE
        jmp :++
    :
        lda #STATE_P2_CHOICE
    :
    sta game_state

    jsr game_place_cursor

    lda #0
    rts

@state_p1_choice:
@state_p2_choice:
    jsr controller_read_safe
    pha
    and #BUTTON_UP
    beq :+
        lda #1
        cmp outside_index
        beq :+
        dec outside_index
    :
    pla
    pha
    and #BUTTON_DOWN
    beq :+
        lda #12
        cmp outside_index
        beq :+
        inc outside_index
    :
    pla
    pha
    jsr controller_wait_off

    jsr game_place_cursor
    pla
    and #BUTTON_A
    beq :++
        lda outside_index
        cmp dice_res_1
        beq :+
        cmp dice_res_2
        beq :+
        cmp sum
        bne :++
    :
        ;TODO: PLACE SELECTOR, DO THE SELECTING CHECK IF ALREADY SELECTED
    :

    lda #0
    rts

@state_p1_confirm:
@state_p2_confirm:
    ;TODO:
    lda #0
    rts
