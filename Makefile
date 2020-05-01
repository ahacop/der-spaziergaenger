PREFIX = main
BINDIR := ./bin
ASSEMBLER := java -jar /usr/local/opt/kickassembler/KickAss.jar
X64 := /Applications/Vice/tools/x64

LOGFILE = $(PREFIX).log
PRGFILE = $(PREFIX).prg
VSFILE = $(PREFIX).vs

.PHONY: all
all: run

.PHONY: build
build: main.asm
	mkdir -p $(BINDIR) && $(ASSEMBLER) $? -log $(BINDIR)/$(LOGFILE) -o $(BINDIR)/$(PRGFILE) -vicesymbols -showmem -symbolfiledir $(BINDIR)

.PHONY: run
run: build
	$(X64) -moncommands $(BINDIR)/$(VSFILE) $(BINDIR)/$(PRGFILE)

.PHONY: clean
clean:
	rm -rf $(BINDIR)
