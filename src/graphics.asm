.importzp nmi_ready
.import palette
.import nmt_update
.importzp nmt_update_len

.export ppu_init
.export ppu_enable_frame
.export ppu_disable

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

ppu_enable_frame:
    lda #1
    sta nmi_ready
    rts

ppu_disable:
    lda #2
    sta nmi_ready
    rts