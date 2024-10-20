.import main
.import oam
.export reset

.include "defs.inc"

.segment "CODE"
reset:
	sei
	lda #0
	sta PPU_CTRL
	sta PPU_MASK
	sta APU_CTRL
	sta APU_DMC_SETTINGS
	lda #$40
	sta APU_FRAME_COUNTER
	cld
	ldx #$FF
	txs
	bit $2002
	:
		bit $2002
		bpl :-

	lda #0
	ldx #0
	:
		sta $0000, X
		sta $0300, X
		sta $0400, X
		sta $0500, X
		sta $0600, X
		sta $0700, X
		inx
		bne :-

	lda #255
	:
		sta oam, X
		inx
		inx
		inx
		inx
		bne :-

	:
		bit $2002
		bpl :-

	lda #%10001000
	sta PPU_CTRL
	jmp main

