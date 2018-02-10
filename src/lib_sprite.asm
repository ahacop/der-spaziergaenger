.label max_num_sprites = 8

.namespace sprites {
  .label positions = VIC2
  .label position_x_high_bits = VIC2 + 16
  .label enable_bits = VIC2 + 21
  .label colors = VIC2 + 39
  .label vertical_stretch_bits = VIC2 + 23
  .label horizontal_stretch_bits = VIC2 + 29
  .label pointers = sprite_data_pointers
  .label multicolor_bits = VIC2 + 28
  number_mask: .byte %00000001, %00000010, %00000100, %00001000,                                     %00010000, %00100000, %01000000, %10000000

  .namespace animations {
    active: .fill @max_num_sprites, 0
    start_frame: .fill @max_num_sprites, 0
    frame: .fill @max_num_sprites, 0
    end_frame: .fill @max_num_sprites, 0
    stop_frame: .fill @max_num_sprites, 0
    frame_speed: .fill @max_num_sprites, 0
    delay: .fill @max_num_sprites, 0
    loop: .fill @max_num_sprites, 0
    current: .byte 0
    frame_current: .byte 0
    end_frame_current: .byte 0
  }
}

// macro: lib_sprite_set_multicolors
//   color0 = Color 0 (Value)
//   color1 = Color 1 (Value)
.macro lib_sprite_set_multicolors(color0, color1) {
  lda #color0
  sta sprite_multicolor0
  lda #color1
  sta sprite_multicolor1
}

// macro: lib_sprite_enable
//   sprite_num = Sprite number (Value)
//   enable = Enable boolean (Value)
.macro lib_sprite_enable(sprite_num, enable) {
  ldy sprite_num
  lda sprites.number_mask, y

  ldy #enable
  beq !disable+
!enable:
  ora sprites.enable_bits
  sta sprites.enable_bits
  jmp !done+
!disable:
  eor #$FF // get mask compliment
  and sprites.enable_bits
  sta sprites.enable_bits
!done:
}

.macro lib_sprite_set_frame(sprite_num, frame_index) {
  ldy sprite_num
  clc // Clear carry before add
  lda #frame_index // Get first number
  adc #sprite_ram // Add
  sta sprites.pointers, y
}

.macro lib_sprite_set_frame_aa(sprite_num, frame_index) {
  ldy sprite_num

  clc // Clear carry before add
  lda frame_index // Get first number
  adc #sprite_ram // Add

  sta sprites.pointers, y
}

.macro lib_sprite_set_color(sprite_num, color) {
  ldy sprite_num
  lda #color
  sta sprites.colors, y
}

.macro lib_sprite_multicolor_enable(sprite_num, enable) {
  ldy sprite_num
  lda sprites.number_mask, y

  ldy #enable
  beq !disable+
!enable:
  ora sprites.multicolor_bits
  sta sprites.multicolor_bits
  jmp !done+
!disable:
  eor #$FF // get mask compliment
  and sprites.multicolor_bits
  sta sprites.multicolor_bits
!done:
}

// macro: lib_sprite_set_position_aaaa
.macro lib_sprite_set_position_aaaa(sprite_num, xposh, xposl, ypos) {
  lda sprite_num // get sprite number
  asl // *2 as registers laid out 2 apart
  tay // copy accumulator to y register

  lda xposl // get XPos Low Byte
  sta sprites.positions, y // set the XPos sprite register
  lda ypos // get YPos
  sta sprites.positions+1, y // set the YPos sprite register

  ldy sprite_num
  lda sprites.number_mask, y // get sprite mask

  eor #$FF // get compliment
  and sprites.position_x_high_bits // clear the bit
  sta sprites.position_x_high_bits // and store

  ldy xposh // get XPos High Byte
  beq !end+ // skip if XPos High Byte is zero
  ldy sprite_num
  lda sprites.number_mask, y // get sprite mask

  ora sprites.position_x_high_bits // set the bit
  sta sprites.position_x_high_bits // and store
!end:
}

// macro: lib_sprite_play_animation
//   Sprite Number    (Address)
//   StartFrame       (Value)
//   EndFrame         (Value)
//   Speed            (Value)
//   Loop True/False  (Value)
.macro lib_sprite_play_animation(sprite_num, start_frame, end_frame, speed, loop) {
  ldy sprite_num
  lda #1
  sta sprites.animations.active, y
  lda #start_frame
  sta sprites.animations.start_frame, y
  sta sprites.animations.frame, y
  lda #end_frame
  sta sprites.animations.end_frame, y
  lda #speed
  sta sprites.animations.frame_speed, y
  sta sprites.animations.delay, y
  lda #loop
  sta sprites.animations.loop, y
}

lib_sprites_update:
  ldx #0
!loop:
  // skip this sprite anim if not active
  lda sprites.animations.active, x
  bne !active+
  jmp !skip+

!active:
  stx sprites.animations.current
  lda sprites.animations.frame, x
  sta sprites.animations.frame_current

  lda sprites.animations.end_frame, x
  sta sprites.animations.end_frame_current

  lib_sprite_set_frame_aa(sprites.animations.current, sprites.animations.frame_current)

  dec sprites.animations.delay, x
  bne !skip+

  // reset the delay
  lda sprites.animations.frame_speed, x
  sta sprites.animations.delay, x

  // change the frame
  inc sprites.animations.frame, x

  // check if reached the end frame
  lda sprites.animations.end_frame_current
  cmp sprites.animations.frame, x
  bcs !skip+

  // check if looping
  lda sprites.animations.loop, x
  beq !destroy+

  // reset the frame
  lda sprites.animations.start_frame, x
  sta sprites.animations.frame, x
  jmp !skip+

!destroy:
  // turn off
  lda #0
  sta sprites.animations.active, x
  lib_sprite_enable(sprites.animations.current, 0)

!skip:
  // loop for each sprite anim
  inx
  cpx #max_num_sprites
  beq !finished+
  jmp !loop-
!finished:
  rts
