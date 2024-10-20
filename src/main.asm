.import ppu_init
.import ppu_enable_frame

.export main

.segment "CODE"
main:
	jsr ppu_init

loop:
	jsr ppu_enable_frame
	jmp loop
