.export mod6

.segment "CODE"

mod6:
    lsr A
    tax
    lda mod6_table, X
    rol A
    rts

.segment "RODATA"

mod6_table:
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1, 2
    .byte 0, 1
