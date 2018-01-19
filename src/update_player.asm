player_x_high:
  lda $d010                      // load 9th Bit
  eor #$01                       // eor against #$01
  sta $d010                      // store into 9th bit

update_player:
  dec $d000                      // decrease X-Coord until zero
  rts
  beq player_x_high                // switch 9th Bit of X-Coord

/*animate_player:*/
  /*lda delay_animation_pointer    // pointer is either #$01 or #$00*/
  /*eor #$01                       // eor flips between 0 and 1*/
  /*sta delay_animation_pointer    // store back into pointer*/
  /*beq delay_animation            // skip animation for this refresh if 0*/
  /*lda sprite_player_current_frame  // load current frame number*/
  /*bne dec_player_frame             // if not progress animation*/

/*reset_player_frames:*/
  /*lda #sprite_frames_player        // load number of frames for player*/
  /*sta sprite_player_current_frame  // store into current frame counter*/
  /*lda #sprite_pointer_player       // load original sprite shape pinter*/
  /*sta screen_ram + $3f8          // store in Sprite#0 pointer register*/

/*dec_player_frame:*/
  /*inc screen_ram + $3f8          // increase current pointer position*/
  /*dec sprite_player_current_frame  // decrease current Frame*/
  /*beq reset_player_frames          // if current frame is zero, reset*/

/*delay_animation:*/
  /*rts                            // do nothing in this refresh, return*/
