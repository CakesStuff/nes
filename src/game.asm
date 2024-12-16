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
int_sum: .res 1

.segment "CODE"

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
    cmp #STATE_P2_ROLL
    bne :+
        jmp @state_p2_roll
    :
    jmp @state_p2_choice

@state_p1_roll:
@state_p2_roll:
    lda #(BUTTON_A)
    jsr controller_wait_on
    lda #(BUTTON_A)
    jsr controller_wait_off
    jsr dice_roll
    ldx #CONF_BTN_X
    ldy #CONF_BTN_Y
    jsr sprite_cursor_set_b

    lda dice_res_1
    clc
    adc dice_res_2
    sta sum
    lda #0
    sta int_sum

    lda #0
    rts

@state_p1_choice:
    ;TODO:
    rts

@state_p2_choice:
    ;TODO:
    rts
