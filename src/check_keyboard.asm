check_keyboard:
  lda #%11111111  // CIA#1 Port A set to output
  sta ddra
  lda #%00000000  // CIA#1 Port B set to inputt
  sta ddrb

check_space:
  lda #%01111111  // select row 8
  sta pra
  lda prb         // load column information
  and #%00010000  // test 'space' key to exit
  beq exit_to_basic

check_a:
  lda #%11111101
  sta pra
  lda prb
  and #%00000100
  beq go_left

check_d:
  lda #%11111011
  sta pra
  lda prb
  and #%00000100
  beq go_right

go_up:
  lda #0
  sta player.xvelocity
  rts
go_right:
  lda #player.horizontal_speed
  sta player.xvelocity
  rts
go_left:
  lda #-player.horizontal_speed
  sta player.xvelocity
  rts

exit_to_basic:
  lda #$00
  sta $d015        // turn off all sprites
  jmp $ea81        // jmp to regular interrupt routine
  rts

skip:
  rts              // don't change Y-Coordinate
