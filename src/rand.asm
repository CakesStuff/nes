.export srand
.export rand
.export crand

.segment "BSS"

seed: .res 1

.segment "CODE"

srand:
    sta seed
    rts

crand:
    lsr
    bcc :+
    pha
    jsr rand
    pla
    :
    adc seed
    jmp srand

rand:
    lda seed
    beq :+
    asl
    bcc :++
    :   eor #$1D
    :   jmp srand
