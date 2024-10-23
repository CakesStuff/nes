.export controller_read_safe

.include "defs.inc"

.segment "ZEROPAGE"

buttons: .res 1
input_buffer: .res 1

.segment "CODE"

controller_read_safe:
    jsr controller_read
    sta input_buffer
    :
        jsr controller_read
        cmp input_buffer
        sta input_buffer
        bne :-

    rts


controller_read:
    lda #1
    sta CONTROLLER
    sta buttons
    lsr A
    sta CONTROLLER
    :
        lda CONTROLLER
        lsr A
        rol buttons
        bcc :-

    lda buttons
    rts