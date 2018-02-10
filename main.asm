#import "src/config_symbols.asm"

:BasicUpstart2(main)

main:
  lib_screen_set_colors(BLACK, GREY, BLACK, BLACK, BLACK)
  lib_sprite_set_multicolors(LIGHT_RED, BROWN)
  lib_screen_clear_screen(screen_ram, ' ')
  lib_screen_draw_text(title.position.x, title.position.y, title.text, WHITE)
  jsr player_init

  sei

  ldy #$7f    // $7f = %01111111
  sty $dc0d   // Turn off CIAs Timer interrupts ($7f = %01111111)
  sty $dd0d   // Turn off CIAs Timer interrupts ($7f = %01111111)
  lda $dc0d   // by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
  lda $dd0d   // by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed

  lda #$01    // Set Interrupt Request Mask...
  sta $d01a   // ...we want IRQ by Rasterbeam (%00000001)

  lda #<irq   // point IRQ Vector to our custom irq routine
  ldx #>irq
  sta $0314    // store in $314/$315
  stx $0315

  lda #$00    // trigger interrupt at row zero
  sta $d012

  cli
  jmp *
  rts

irq:
  dec $d019          // acknowledge IRQ / clear register for next interrupt
  /*jsr color_cycle    // put color cycle on text*/
  /*jsr play_sid       // jump to play music routine*/
  /*jsr update_ship    // move ship*/
  jsr check_keyboard // check keyboard controls
  jsr lib_sprites_update
  jsr player_update

  jmp $ea31

#import "src/lib_math.asm"
#import "src/lib_screen.asm"
#import "src/lib_sprite.asm"
#import "src/check_keyboard.asm"
#import "src/game_data.asm"
#import "src/config_sprites.asm"
/*#import "src/update_player.asm"*/

#import "src/config_resources.asm"
