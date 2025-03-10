.import reset
.import ppu_init
.import ppu_update_frame
.import ppu_switch
.import ppu_wait
.import ppu_write_logo
.import ppu_disable
.import ppu_set_xscroll
.import ppu_show_start_instruction
.import controller_read_safe
.import controller_wait_on
.import controller_wait_off
.import sprite_init
.import sprite_cursor_set
.import sprite_cursor_set_b
.import srand
.import ppu_start_game_animation
.import game_update

.export main
.exportzp dice_res_1
.exportzp dice_res_2

.include "defs.inc"

.segment "ZEROPAGE"

dice_res_1: .res 1
dice_res_2: .res 1

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

	jsr sprite_init
	jsr ppu_update_frame
	jsr ppu_wait

	lda #(BUTTON_START)
	jsr controller_wait_on
	lda #(BUTTON_START)
	jsr controller_wait_off

	lda #0
	jsr srand

	jsr ppu_update_frame
	jsr ppu_wait
	;Wait on vblank to not mess up screen
	jsr ppu_start_game_animation

	jsr ppu_update_frame
	jsr ppu_wait
	ldx #(DICE_ROLL_X * 8)
	ldy #(DICE_ROLL_Y * 8)
	jsr sprite_cursor_set_b
	jsr ppu_update_frame
	jsr ppu_wait

	:
		jsr game_update
		cmp #0
		bne :+

		jsr ppu_update_frame
		jsr ppu_wait
		jmp :-
	:

	;UNUSED
	lda #(BUTTON_START)
	jsr controller_wait_on
	lda #(BUTTON_START)
	jsr controller_wait_off

	jsr ppu_disable
	jsr ppu_wait
	jmp reset
