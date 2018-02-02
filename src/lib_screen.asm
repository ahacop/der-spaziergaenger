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

// macro: lib_screen_draw_text
//   xpos = X Position 0-39 (Address)
//   ypos = Y Position 0-24 (Address)
//   string = 0 terminated string (Address)
//   color = Text Color (Value)
.macro lib_screen_draw_text(xpos, ypos, string, color) {
  ldy ypos // load y position as index into list

  lda ScreenRAMRowStartLow, y // load low address byte
  sta ZeroPageLow

  lda ScreenRAMRowStartHigh, y // load high address byte
  sta ZeroPageHigh

  ldy xpos // load x position into Y register

  ldx #0
!loop:   lda string, x
  cmp #0
  beq !done+
  sta (ZeroPageLow), y
  inx
  iny
  jmp !loop-
!done:
  ldy ypos // load y position as index into list

  lda ColorRAMRowStartLow, y // load low address byte
  sta ZeroPageLow

  lda ColorRAMRowStartHigh, y // load high address byte
  sta ZeroPageHigh

  ldy xpos // load x position into Y register

  ldx #0
!loop:  lda string, x
  cmp #0
  beq !done+
  lda #color
  sta (ZeroPageLow), y
  inx
  iny
  jmp !loop-
!done:
}

// macro: lib_screen_draw_decimal
//   xpos = X Position 0-39 (Address)
//   ypos = Y Position 0-24 (Address)
//   decimal = decimal number 2 nybbles (Address)
//   color = Text Color (Value)
.macro lib_screen_draw_decimal(xpos, ypos, decimal, color) {
  ldy ypos // load y position as index into list
  lda ScreenRAMRowStartLow, y // load low address byte
  sta ZeroPageLow
  lda ScreenRAMRowStartHigh, y // load high address byte
  sta ZeroPageHigh

  ldy xpos // load x position into Y register

  // get high nybble
  lda decimal
  and #$F0

  // convert to ascii
  lsr
  lsr
  lsr
  lsr
  ora #$30

  sta (ZeroPageLow), y

  // move along to next screen position
  iny

  // get low nybble
  lda decimal
  and #$0F

  // convert to ascii
  ora #$30

  sta (ZeroPageLow), y

  // now set the colors
  ldy ypos // load y position as index into list

  lda ColorRAMRowStartLow, y // load low address byte
  sta ZeroPageLow

  lda ColorRAMRowStartHigh, y // load high address byte
  sta ZeroPageHigh

  ldy xpos // load x position into Y register

  lda #color
  sta (ZeroPageLow), y

  // move along to next screen position
  iny

  sta (ZeroPageLow), y
}
