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

check_w:
  lda #%11111101  // select row 1
  sta pra
  lda prb         // load column information
  and #%00000010  // test 'w' key
  beq go_up

check_s:
  lda #%11111101  // select row 1
  sta pra
  lda prb         // load column information
  and #%00100000  // test 's' key
  beq go_down
  rts             // return

go_up:
  lda sprites.positions + 1
  cmp #BORDER_TOP
  beq skip
  dec sprites.positions + 1
  dec sprites.positions + 3
  rts

go_down:
  lda sprites.positions + 1
  cmp #$e5
  beq skip
  inc sprites.positions + 1
  inc sprites.positions + 3
  rts

go_right:
  /*lda #address_sprites_pointer + 1*/
  /*sta sprites.pointers*/
  ldx sprites.positions
  inx
  bne not_boundary
toggle_high_bit:
  lda sprites.position_x_high_bits
  eor #%00000101
  sta sprites.position_x_high_bits
not_boundary:
  stx sprites.positions
  stx sprites.positions + 2
  rts
go_left:
  /*lda #address_sprites_pointer*/
  /*sta sprites.pointers*/
  ldx sprites.positions
  dex
  cpx #$ff
  bne not_boundary
  jmp toggle_high_bit

exit_to_basic:
  lda #$00
  sta $d015        // turn off all sprites
  jmp $ea81        // jmp to regular interrupt routine
  rts

skip:
  rts              // don't change Y-Coordinate
