.label VIC2 = $d000
.label address_sprites = $3000
.label screen_ram = $0400     // location of screen ram
.label color_ram = $d800
.label border_color = $d020
.label background_color0 = $d021
.label background_color1 = $d022
.label background_color2 = $d023
.label background_color3 = $d024
.label sprite_multicolor0 = $d025
.label sprite_multicolor1 = $d026

.label init_sid = $11ed     // init routine for music
.label play_sid = $1004     // play music routine
.label delay_counter = $90       // used to time color switch in the border
.label pra = $dc00     // CIA#1 (Port Register A)
.label prb = $dc01     // CIA#1 (Port Register B)
.label ddra = $dc02     // CIA#1 (Data Direction Register A)
.label ddrb = $dc03     // CIA#1 (Data Direction Register B)

// $00-$FF  PAGE ZERO (256 bytes)
// $00-$01   Reserved for IO
.label ZeroPageTemp    = $02
// $03-$8F   Reserved for BASIC
// using $73-$8A CHRGET as BASIC not used for our game
.label ZeroPageParam1  = $73
.label ZeroPageParam2  = $74
.label ZeroPageParam3  = $75
.label ZeroPageParam4  = $76
.label ZeroPageParam5  = $77
.label ZeroPageParam6  = $78
.label ZeroPageParam7  = $79
.label ZeroPageParam8  = $7A
.label ZeroPageParam9  = $7B
// $90-$FA   Reserved for Kernal
.label ZeroPageLow     = $FB
.label ZeroPageHigh    = $FC
.label ZeroPageLow2    = $FD
.label ZeroPageHigh2   = $FE
// $FF       Reserved for Kernal

ScreenRAMRowStartLow: // screen_ram + 40*0, 40*1, 40*2 ... 40*24
  .fill 25, <screen_ram + i*40
ScreenRAMRowStartHigh: // screen_ram + 40*0, 40*1, 40*2 ... 40*24
  .fill 25, >screen_ram + i*40

ColorRAMRowStartLow: // color_ram + 40*0, 40*1, 40*2 ... 40*24
  .fill 25, <color_ram + i*40
ColorRAMRowStartHigh: // color_ram + 40*0, 40*1, 40*2 ... 40*24
  .fill 25, >color_ram + i*40
