// clear screen and turn black
.macro clear_screen(screen, clearByte) {
  ldx #BLACK
  stx $d020
  stx $d021
	lda #clearByte
	ldx #0
!loop:
	sta screen, x
	sta screen + $100, x
	sta screen + $200, x
	sta screen + $300, x
	inx
	bne !loop-
}
