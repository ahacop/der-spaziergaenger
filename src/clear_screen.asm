// clear screen and turn black
.macro clear_screen(screen, color, clearByte) {
  lda #color
  sta background_color
  sta border_color
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
