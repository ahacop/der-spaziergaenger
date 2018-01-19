TARGETS := streetw
C1541 := /Applications/Vice64/tools/c1541
X64 := open /Applications/Vice/x64.app

.PRECIOUS: %.d64

all: $(TARGETS)

%.prg: %.asm
  acme --cpu 6510 --format cbm --outfile $@ $<

%.d64: %.prg
  $(C1541) -format foo,id d64 $@ -write $<

%: %.d64
  $(X64) $<

clean:
  rm -f $(TARGETS) *.prg *.d64

  let $CLASSPATH='$CLASSPATH:/Applications/KickAssembler/KickAss.jar'
  exec ":!mkdir -p bin & java cml.kickass.KickAssembler '" . current_file . "' -log 'bin/" . base_name . "_BuildLog.txt' -o 'bin/" . base_name . "_Compiled.prg' -vicesymbols -showmem -symbolfiledir bin && x64 -moncommands 'bin/" . base_name . ".vs' 'bin/" . base_name . "_Compiled.prg'"
