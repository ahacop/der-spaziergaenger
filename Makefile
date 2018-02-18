PREFIX = main
BINDIR := ./bin
KICKASS := $$CLASSPATH:/Applications/KickAssembler/KickAss.jar
JAVA := java -classpath $(KICKASS) cml.kickass.KickAssembler
X64 := x64

LOGFILE = $(PREFIX).log
PRGFILE = $(PREFIX).prg
VSFILE = $(PREFIX).vs

.PHONY: all
all: run

.PHONY: build
build: main.asm
	mkdir -p ./bin && $(JAVA) $? -log $(BINDIR)/$(LOGFILE) -o $(BINDIR)/$(PRGFILE) -vicesymbols -showmem -symbolfiledir $(BINDIR)

.PHONY: run
run: build
	x64 -moncommands $(BINDIR)/$(VSFILE) $(BINDIR)/$(PRGFILE)

.PHONY: clean
clean:
	rm -rf $(BINDIR)
