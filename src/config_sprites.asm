.const BORDER_LEFT = 25
.const BORDER_TOP = 50
.const DOUBLE_SPRITE_WIDTH = 24*2
.const DOUBLE_SPRITE_HEIGHT = 21*2
.const address_sprites_pointer = address_sprites / $40

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
  ldx #BORDER_LEFT + 2 + 32
  stx sprites.positions
  stx sprites.positions + 8
  ldy #BORDER_TOP + 2 + 32
  sty sprites.positions + 1
  ldy #BORDER_TOP + DOUBLE_SPRITE_HEIGHT + 4
  sty sprites.positions + 9
  lda #1
  sta sprites.colors
  sta sprites.colors + 4

  lda #address_sprites_pointer
  sta sprites.pointers

  lda #address_sprites + 64 - 1
  and #%10000000
  beq !hires+
  !multicolor:
  lda #1 << 0
  ora sprites.multicolor_bits
  sta sprites.multicolor_bits
  jmp !end+
  !hires:
  lda #255 - [1 << 0]
  and sprites.multicolor_bits
  sta sprites.multicolor_bits
  !end:
  lda #address_sprites + 64 - 1
  and #%00001111
  sta sprites.colors
  rts

draw_player_sprite:
  rts
