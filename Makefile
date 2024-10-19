CA65 = cc65/bin/ca65
LD65 = cc65/bin/ld65
MAKE = make

SOURCES = $(shell find src -type f -name "*.asm")
OBJECTS = $(patsubst src/%.asm, build/%.o, $(SOURCES))

CYAN = \e[1;36m
PURPLE = \e[1;35m
YELLOW = \e[1;33m
GREEN = \e[1;32m
RED = \e[1;31m
RESET = \e[0m

PRE_CLEAN = [ /\\/ ]
PRE_DONE = [ \\/\\ ]
PRE_DIR = [ DIR ]
PRE_ASM = [ A65 ]
PRE_NES = [ L65 ]

default: all
	@echo "$(GREEN)$(PRE_DONE) Done$(RESET)"

build:
	@echo "$(PURPLE)$(PRE_DIR)$(RESET) $@"
	@mkdir -p $@

all: build/rom.nes build/rom.nes.dbg build/rom.map build/rom.labels

build/%.o: src/%.asm cc65 | build
	@echo "$(CYAN)$(PRE_ASM)$(RESET) $<"
	@$(CA65) $< -g -o $@
build/rom.nes build/rom.nes.dbg build/rom.map: $(OBJECTS) | build
	@echo "$(YELLOW)$(PRE_NES)$(RESET) $@"
	@$(LD65) -C linker.ld $^ -m build/rom.map -Ln build/rom.labels --dbgfile build/rom.nes.dbg -o build/rom.nes

cc65: $(CA65) $(LD65)

$(CA65) $(LD65):
	@$(MAKE) -C cc65

clean:
	@rm -rf build
	@echo "$(RED)$(PRE_CLEAN) Clean$(RESET)"

clean_all: clean
	@$(MAKE) -C cc65 clean

.PHONY: clean all default cc65
