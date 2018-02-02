// macro: lib_sprite_set_multicolors
//   color0 = Color 0 (Value)
//   color1 = Color 1 (Value)
.macro lib_sprite_set_multicolors(color0, color1) {
  lda #color0
  sta sprite_multicolor0
  lda #color1
  sta sprite_multicolor1
}
