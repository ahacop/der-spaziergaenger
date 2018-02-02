.macro lib_screen_set_colors(border, bg0, bg1, bg2, bg3) {
    lda #border
    sta border_color
    lda #bg0
    sta background_color0
    lda #bg1
    sta background_color1
    lda #bg2
    sta background_color2
    lda #bg3
    sta background_color3
}

.macro lib_screen_clear_screen(screen, clearByte) {
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
