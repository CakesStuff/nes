INES_MAPPER	= 0
INES_MIRROR	= 1
INES_SRAM	= 0

PPU_CTRL = $2000
PPU_MASK = $2001
PPU_STATUS = $2002
PPU_OAM_ADDR = $2003
PPU_OAM_DATA = $2004
PPU_SCROLL = $2005
PPU_ADDR = $2006
PPU_DATA = $2007
PPU_OAM_DMA_HIGH = $4014

APU_CTRL = $4015
APU_DMC_SETTINGS = $4010
CONTROLLER = $4016
APU_FRAME_COUNTER = $4017

TILE_EMPTY      = $00
TILE_ZERO       = $01
TILE_ONE        = $02
TILE_TWO        = $03
TILE_THREE      = $04
TILE_FOUR       = $05
TILE_FIVE       = $06
TILE_SIX        = $07
TILE_SEVEN      = $08
TILE_EIGHT      = $09
TILE_NINE       = $0A
TILE_BORDER_B   = $0B
TILE_CORNER_BL  = $0C
TILE_BORDER_H   = $0D
TILE_BORDER_L   = $0E
TILE_FULL       = $0F
TILE_CROSS      = $10
TILE_CORNER_BR  = $11
TILE_CORNER_TL  = $12
TILE_CORNER_TR  = $13
TILE_BORDER_T   = $14
TILE_BORDER_R   = $15
TILE_DCORNER_R  = $16
TILE_DCORNER_L  = $17
TILE_DCORNER_T  = $18
TILE_DCORNER_B  = $19
TILE_BORDER_V   = $1A
TILE_T_BR       = $1B
TILE_T_BL       = $1C
TILE_T_TR       = $1D
TILE_T_TL       = $1E
TILE_EMPTY_BR   = $1F
TILE_EMPTY_BL   = $20
TILE_EMPTY_TR   = $21
TILE_EMPTY_TL   = $22
TILE_LETTER_P   = $23
TILE_LETTER_R   = $24
TILE_LETTER_E   = $25
TILE_LETTER_S   = $26
TILE_LETTER_T   = $27
TILE_LETTER_A   = $28
TILE_DICE_TL    = $29
TILE_DICE_TR    = $2A
TILE_DICE_BL    = $2B
TILE_DICE_BR    = $2C
TILE_CONF_TL    = $2D
TILE_CONF_TR    = $2E
TILE_CONF_BL    = $2F
TILE_CONF_BR    = $30
TILE_LETTER_L   = $31
TILE_LETTER_Y   = $32
TILE_LETTER_W   = $33
TILE_LETTER_O   = $34
TILE_LETTER_N   = $35
TILE_EXCLAMATION= $36

SPRITE_D_3      = $00
SPRITE_D_3_3_1  = $01
SPRITE_D_3_1_1  = $02
SPRITE_D_1      = $03
SPRITE_D_1_1_6  = $04
SPRITE_D_1_6_6  = $05
SPRITE_D_6      = $06
SPRITE_D_6_4    = $07
SPRITE_D_4      = $08
SPRITE_D_4_4_2  = $09
SPRITE_D_4_2_2  = $0A
SPRITE_D_2      = $0B
SPRITE_D_2_2_5  = $0C
SPRITE_D_2_5_5  = $0D
SPRITE_D_5      = $0E
SPRITE_D_5_3    = $0F

SPRITE_SEL_TL   = $40
SPRITE_SEL_T    = $41
SPRITE_SEL_L    = $42

SPRITE_PALETTE_CURSOR   = %00
SPRITE_PALETTE_DICE     = %01
SPRITE_FLAG_BEHIND      = %00100000
SPRITE_FLAG_FLIP_H      = %01000000
SPRITE_FLAG_FLIP_V      = %10000000
SPRITE_FLAG_MASK        = %11100111
SPRITE_Y_OFFSET         = %00
SPRITE_TILE_OFFSET      = %01
SPRITE_ATTRIBUTE_OFFSET = %10
SPRITE_X_OFFSET         = %11

BUTTON_RIGHT    = %00000001
BUTTON_LEFT     = %00000010
BUTTON_DOWN     = %00000100
BUTTON_UP       = %00001000
BUTTON_START    = %00010000
BUTTON_SELECT   = %00100000
BUTTON_B        = %01000000
BUTTON_A        = %10000000

DICE_ROLL_X = 16
DICE_ROLL_Y = 21
CONF_BTN_X = 16
CONF_BTN_Y = 16

STATE_P1_ROLL       = 0
STATE_P1_CHOICE     = 1
STATE_P1_CONFIRM    = 2
STATE_P2_ROLL       = 3
STATE_P2_CHOICE     = 4
STATE_P2_CONFIRM    = 5
