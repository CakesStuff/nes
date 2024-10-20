.export nmi
.export oam
.exportzp nmi_ready
.export palette
.export nmt_update
.exportzp nmt_update_len

;inspired by https://github.com/bbbradsmith/NES-ca65-example/blob/master/example.s
.include "defs.inc"

.segment "ZEROPAGE"
nmi_count: .res 1
nmi_ready: .res 1
nmt_update_len: .res 1
nmi_lock: .res 1
scroll_nmt: .res 1
scroll_x: .res 1
scroll_y: .res 1

.segment "BSS"
palette: .res 32
nmt_update: .res 256

.segment "OAM"
oam: .res 256

.segment "CODE"
nmi:
	pha
	txa
	pha
	tya
	pha
	
	lda nmi_lock
	beq :+
		jmp @nmi_end
	:
	lda #1
	sta nmi_lock
	
	inc nmi_count

	lda nmi_ready
	bne :+
		jmp @ppu_update_end
	:
	cmp #2
	bne :+
		lda #0
		sta PPU_MASK
		sta nmi_ready
		jmp @ppu_update_end
	:

	ldx #0
	stx PPU_OAM_ADDR
	lda #>oam
	sta PPU_OAM_DMA_HIGH
	
	lda #%10001000 ; NMI enable | sprite tile select
	sta PPU_CTRL
	lda PPU_STATUS
	lda #$3F
	sta PPU_ADDR
	stx PPU_ADDR
	:
		lda palette, X
		sta PPU_DATA
		inx
		cpx #32
		bcc :-

	ldx #0
	cpx nmt_update_len
	bcs @scroll
	@nmt_update_loop:
		lda nmt_update, X
		sta PPU_ADDR
		inx
		lda nmt_update, X
		sta PPU_ADDR
		inx
		lda nmt_update, X
		sta PPU_DATA
		inx
		cpx nmt_update_len
		bcc @nmt_update_loop

	lda #0
	sta nmt_update_len
@scroll:
	lda scroll_nmt
	and #%00000011
	ora #%10001000
	sta PPU_CTRL
	lda scroll_x
	sta PPU_SCROLL
	lda scroll_y
	sta PPU_SCROLL
	lda #%00011110
	sta PPU_MASK
	ldx #0
	stx nmi_ready
@ppu_update_end:
	;music here
	lda #0
	sta nmi_lock
@nmi_end:
	pla
	tay
	pla
	tax
	pla
	rti

