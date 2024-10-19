CA65 = cc65/bin/ca65
LD65 = cc65/bin/ld65
MAKE = make

SOURCES = $(shell find src -type f -name "*.asm")
OBJECTS = $(patsubst src/%.asm, build/%.o, $(SOURCES))

default: all

build:
	@mkdir -p $@

all: build/rom.nes build/rom.nes.dbg build/rom.map build/rom.labels

build/%.o: src/%.asm cc65 | build
	@$(CA65) $< -g -o $@
build/rom.nes build/rom.nes.dbg build/rom.map: $(OBJECTS) | build
	@$(LD65) -C linker.ld $^ -m build/rom.map -Ln build/rom.labels --dbgfile build/rom.nes.dbg -o build/rom.nes

cc65: $(CA65) $(LD65)

$(CA65) $(LD65):
	@$(MAKE) -C cc65

clean:
	@$(MAKE) -C cc65 clean
	@rm -rf build

.PHONY: clean all default cc65
