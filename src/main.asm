.import ppu_init
.import ppu_update_frame
.import ppu_switch
.import ppu_set_tile
.import ppu_wait
.import ppu_write_logo
.import ppu_disable
.import ppu_set_xscroll
.import ppu_show_start_instruction
.import controller_read_safe

.export main

.segment "CODE"
main:
	jsr ppu_init

	lda #1
	jsr ppu_write_logo
	
	lda #0
@start_loop:
	pha
	jsr ppu_set_xscroll
	jsr ppu_update_frame
	jsr ppu_wait
	pla
	clc
	adc #4
	bne @start_loop

	lda #0
	jsr ppu_set_xscroll
	jsr ppu_switch
	jsr ppu_update_frame
	jsr ppu_wait

	jsr ppu_show_start_instruction
	jsr ppu_update_frame
	jsr ppu_wait

	:
		jsr controller_read_safe
		and #%00010000
		beq :-
		jsr ppu_switch
		jsr ppu_update_frame
		jsr ppu_wait

	:
		jsr controller_read_safe
		cmp #0
		beq :--
		jmp :-
