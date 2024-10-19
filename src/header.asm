.segment "HEADER"

INES_MAPPER	= 0 ; 0 = NROM meaning 32k PRG 8k CHR
INES_MIRROR	= 1 ; 0 = horizontal (for vertical)
INES_SRAM	= 0

.byte 'N', 'E', 'S', $1A
.byte $02 ; 2 * 16k PRG
.byte $01 ; 1 * 8k CHR
.byte INES_MIRROR | (INES_SRAM << 1) | ((INES_MAPPER & $f) << 4)
.byte (INES_MAPPER & %11110000)
.byte $0, $0, $0, $0, $0, $0, $0, $0

