.const BORDER_LEFT = 25
.const BORDER_TOP = 50
.const DOUBLE_SPRITE_WIDTH = 24*2
.const DOUBLE_SPRITE_HEIGHT = 21*2

.namespace sprites {
  .label positions = VIC2
  .label position_x_high_bits = VIC2 + 16
  .label enable_bits = VIC2 + 21
  .label colors = VIC2 + 39
  .label vertical_stretch_bits = VIC2 + 23
  .label horizontal_stretch_bits = VIC2 + 29
  .label pointers = screen_ram + 1024 - 8
  .label multicolor_bits = VIC2 + 28
  .label color1 = VIC2 + 37
  .label color2 = VIC2 + 38
}

setup_player_sprite:
  lda #%00000001
  sta sprites.enable_bits
  .for (var i = 0; i < 1; i++) {
    ldx #BORDER_LEFT + 2 + [DOUBLE_SPRITE_WIDTH+2]*i + 32
    stx sprites.positions + 2*i + 0
    stx sprites.positions + 2*i + 8
    ldy #BORDER_TOP + 2 + 32
    sty sprites.positions + 2*i + 1
    ldy #BORDER_TOP + DOUBLE_SPRITE_HEIGHT + 4
    sty sprites.positions + 2*i + 9
    lda #i + 1
    sta sprites.colors + i
    sta sprites.colors + i + 4

    lda #250 + i
    sta sprites.pointers + i

    lda 250*64 + 64*[i+1] - 1
    and #%10000000
    beq !hires+
    !multicolor:
    lda #1 << i
    ora sprites.multicolor_bits
    sta sprites.multicolor_bits
    jmp !end+
    !hires:
    lda #255 - [1 << i]
    and sprites.multicolor_bits
    sta sprites.multicolor_bits
    !end:
    lda 250*64 + 64*[i+1] - 1
    and #%00001111
    sta sprites.colors + i
  }
  rts

draw_player_sprite:
  rts
