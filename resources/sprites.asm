:BasicUpstart2(main)

// PLAYER is sprite #0
// EXIT is sprite #1

.const VIC = $d000
// sprite positions vic + 0 ... vic + 15
.const PLAYER_SPRITE_POSX = VIC + 0
.const PLAYER_SPRITE_POSY = VIC + 1
.const EXIT_SPRITE_POSX = VIC + 2
.const EXIT_SPRITE_POSY = VIC + 3

// Bitfields
// sprite #0 - %00000001
// sprite #1 - %00000010
// ...
// sprite #7 - %10000000
.const SPRITES_POSX_HIGH_BITS = VIC + 16
.const ACTIVE_SPRITES = VIC + 21

// sprite colors - vic + 39 ... vic + 46
.const PLAYER_SPRITE_COLOR = VIC + 39
.const EXIT_SPRITE_COLOR = VIC + 40

.const BORDER_COLOR = VIC + 32
.const BACKGROUND_COLOR = VIC + 33

.const SCREEN = $0400
.const END_SCREEN = SCREEN + 1000
.const SPRITE_DATA_POINTERS = SCREEN + 1024 - 8

// To get the address in the memory multiply it by 64
.const PLAYER_SPRITE_DATA_POINTER = 254
.const EXIT_SPRITE_DATA_POINTER = 253
.const STARTING_LEVEL = level1

main:
  jsr setup_level
game_loop:
  jmp game_loop
rts

setup_level:
  ldx #0
!loop:
.for(var i = 0; i < 1000; i = i + 255) {
  lda STARTING_LEVEL + i, X
  sta SCREEN + i, X
}
  inx
  cpx #255
  bne !loop-

  lda #BLACK
  sta BORDER_COLOR
  sta BACKGROUND_COLOR

  lda END_SCREEN + 0
  sta PLAYER_SPRITE_POSX
  lda END_SCREEN + 1
  sta PLAYER_SPRITE_POSY
  lda END_SCREEN + 2
  sta EXIT_SPRITE_POSX
  lda END_SCREEN + 3
  sta EXIT_SPRITE_POSY
  lda END_SCREEN + 4
  sta SPRITES_POSX_HIGH_BITS
  lda #%00000011 // enable sprites #0 and #1
  sta ACTIVE_SPRITES
  lda #PLAYER_SPRITE_DATA_POINTER
  sta SPRITE_DATA_POINTERS + 0
  lda #EXIT_SPRITE_DATA_POINTER
  sta SPRITE_DATA_POINTERS + 1
  lda #GREEN
  sta EXIT_SPRITE_COLOR
  rts

.pc = PLAYER_SPRITE_DATA_POINTER * 64 "Player Sprite"
player_sprite:
  .byte %00000000,%00111100,%00000000
  .byte %00000000,%01111110,%00000000
  .byte %00000000,%11111111,%00000000
  .byte %00000000,%11111111,%00000000
  .byte %00000000,%01111110,%00000000
  .byte %00000000,%00111100,%00000000
  .byte %00000000,%00011000,%00000000
  .byte %00000001,%11111111,%10000000
  .byte %00000000,%00011000,%00000000
  .byte %00000000,%00011000,%00000000
  .byte %00000000,%00011000,%00000000
  .byte %00000000,%00011000,%00000000
  .byte %00000000,%00111100,%00000000
  .byte %00000000,%01100110,%00000000
  .byte %00000000,%11000011,%00000000
  .byte %00000001,%10000001,%10000000
  .byte %00000011,%00000000,%11000000
  .byte %00000000,%00000000,%00000000
  .byte %00000000,%00000000,%00000000
  .byte %00000000,%00000000,%00000000
  .byte %00000000,%00000000,%00000000

.pc = EXIT_SPRITE_DATA_POINTER * 64 "Exit Sprite"
exit_sprite:
  .byte %00001111,%11111111,%11110000
  .byte %00111111,%11111111,%11111100
  .byte %01111000,%00000000,%00011110
  .byte %01111011,%11110000,%00011110
  .byte %11111011,%11110000,%00011111
  .byte %11111011,%11110000,%00011111
  .byte %11111011,%11110000,%00011111
  .byte %11111011,%11110000,%00011111
  .byte %11111011,%11010000,%00011111
  .byte %11111011,%10110000,%00011111
  .byte %11111011,%11110000,%00011111
  .byte %11111011,%11110000,%00011111
  .byte %11111011,%11110000,%00011111
  .byte %11111011,%11100000,%00011111
  .byte %11111011,%11000000,%00011111
  .byte %11111011,%10000000,%00011111
  .byte %11111011,%00000000,%00011111
  .byte %11111010,%00000000,%00011111
  .byte %01111000,%00000000,%00011110
  .byte %00111111,%11111111,%11111100
  .byte %00001111,%11111111,%11100000

.pc = $ff * 64 "DEBUG SPRITE"
  .fill 64, $ff

.pc = $c000 "Level Data"
level1:
  .text "########################################"
  .text "#                                      #"
  .text "#   reach the exit                     #"
  .text "#                                      #"
  .text "#               #######                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #     #                #"
  .text "#               #######                #"
  .text "#                                      #"
  .text "#              don't touch the fire    #"
  .text "#                                      #"
  .text "########################################"
  .byte 168, 95 //start_pos
  .byte 168, 180 //end_pos
  .byte %00000000 // high bytes
  .word level2
  .fill 17, $ff

level2:
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "    ################################    "
  .text "    #                              #    "
  .text "    #                              #    "
  .text "    #                              #    "
  .text "    ################################    "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .text "                                        "
  .byte 95, 142 //start_pos
  .byte 250, 139 //end_pos
  .byte %00000000 // high bytes
  .word level3
  .fill 17, $ff

level3:
  .text "########                                "
  .text "##    ###                               "
  .text "#      ##                               "
  .text "#       ###############                 "
  .text "##                   ###                "
  .text "####                  ###               "
  .text "######                 #                "
  .text "  ###############       #               "
  .text "   ###############       #              "
  .text "  #################       #             "
  .text "####################       #            "
  .text "##   ################      #            "
  .text "#     ##############       #            "
  .text "#     #############       #             "
  .text "#     ############       #              "
  .text "##   ############       ############### "
  .text "##   ###########                       #"
  .text "##   ###########                       #"
  .text "##   ############                      #"
  .text "##    #########################        #"
  .text "###    ##       ########               #"
  .text "###                                    #"
  .text "##                                     #"
  .text "##         ###                         #"
  .text "####################################### "
  .byte 40, 70 //start_pos
  .byte 40, 145 //end_pos
  .byte %00000000 // high bytes
  .word level1
  .fill 17, $ff
