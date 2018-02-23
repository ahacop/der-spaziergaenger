.namespace player {
  .label up_animation = 0
  .label left_animation = 6
  .label right_animation = 12
  .label frame = 0
  .label horizontal_speed = 2
  .label state_run_up = 0
  .label state_run_left = 1
  .label state_run_right = 2
  .label animation_delay = 6
  state: .byte state_run_up
  sprite: .byte 0
  x_high: .byte 0
  x_low: .byte 175
  ypos: .byte 229
  xvelocity: .byte 0
  xvelocity_abs: .byte 0
  .label xminhigh = 0 // 0*256 + 20 = 20 minX
  .label xminlow = 20
  .label xmaxhigh = 1 // 1*256 + 68 = 324 maxX
  .label xmaxlow = 68

  jump_table_low:
    .byte <player_update_run_up
    .byte <player_update_run_left
    .byte <player_update_run_right
  jump_table_high:
    .byte >player_update_run_up
    .byte >player_update_run_left
    .byte >player_update_run_right
}

player_init:
  lib_sprite_enable(player.sprite, 1)
  lib_sprite_set_frame(player.sprite, player.up_animation)
  lib_sprite_set_color(player.sprite, ORANGE)
  lib_sprite_multicolor_enable(player.sprite, 1)
  jsr player_set_run_up
  rts

player_update:
  jsr player_update_state
  jsr player_update_velocity
  jsr player_update_position
  rts

player_update_state:
  // now run the state machine
  ldy player.state

  // write the state's routine address to a zeropage temporary
  lda player.jump_table_low, y
  sta ZeroPageLow
  lda player.jump_table_high, y
  sta ZeroPageHigh

  // jump to the update routine that temp_address now points to
  jmp (ZeroPageLow)

player_update_run_up:
  lda player.xvelocity
  beq !done+
  bpl !positive+
!negative:
  jsr player_set_run_left
  jmp !done+
!positive:
  jsr player_set_run_right
!done:
  rts

player_update_run_left:
  lda player.xvelocity
  beq !zero+
  bpl !positive+
!negative:
  jmp !done+
!positive:
  jsr player_set_run_right
  jmp !done+
!zero:
  jsr player_set_run_up
!done:
  rts

player_update_run_right:
  lda player.xvelocity
  beq !zero+
  bpl !positive+
!negative:
  jsr player_set_run_left
  jmp !done+
!zero:
  jsr player_set_run_up
!positive:
!done:
  rts

player_set_run_left:
  lda #player.state_run_left
  sta player.state
  lib_sprite_play_animation(player.sprite, 6, 11, player.animation_delay, 1)
  rts

player_set_run_right:
  lda #player.state_run_right
  sta player.state
  lib_sprite_play_animation(player.sprite, 12, 17, player.animation_delay, 1)
  rts

player_set_run_up:
  lda #player.state_run_up
  sta player.state
  lib_sprite_play_animation(player.sprite, 0, 5, player.animation_delay, 1)
  rts

player_update_position:
  lda player.xvelocity
  beq !done+ // if zero velocity
  bpl !positive+
!negative:
  // subtract the x velocity abs from the x position
  libmath_sub16bit_aavaaa(
    player.x_high,
    player.x_low,
    0,
    player.xvelocity_abs,
    player.x_high,
    player.x_low
  )
  jmp !done+
!positive:
  // add the x velocity abs to the x position
  libmath_add16bit_aavaaa(
    player.x_high,
    player.x_low,
    0,
    player.xvelocity_abs,
    player.x_high,
    player.x_low
  )
!done:
  libmath_min16bit_aavv(player.x_high, player.x_low, player.xmaxhigh, player.xmaxlow)
  libmath_max16bit_aavv(player.x_high, player.x_low, player.xminhigh, player.xminlow)
  lib_sprite_set_position_aaaa(
    player.sprite,
    player.x_high,
    player.x_low,
    player.ypos
  )
  rts

player_update_velocity:
  libmath_abs_aa(player.xvelocity, player.xvelocity_abs)
  rts
