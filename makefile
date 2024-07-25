.PHONY: clean
.PHONY: build
.PHONY: run
.PHONY: copy

SDK = $(PLAYDATE_SDK_PATH)
SDKBIN=$(SDK)/bin
GAME=$(notdir $(CURDIR))
SIM=PlaydateSimulator


build: clean compile run

run: open

clean:
	rm -rf '$(GAME).pdx'

compile: $(GAME).pdx

$(GAME).pdx : Source/main.lua Source/pdxinfo
	"$(SDKBIN)/pdc" 'Source' '$(GAME).pdx'

open:
	$(SDKBIN)/PlaydateSimulator $(GAME).pdx
