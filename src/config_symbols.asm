.label VIC2 = $d000
.label address_sprites = 250*64
.label screen_ram = $0400     // location of screen ram
.label color_ram = $d800
.label border_color = $d020
.label background_color = $d021
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
  .byte <screen_ram,     <screen_ram+40,  <screen_ram+80
  .byte <screen_ram+120, <screen_ram+160, <screen_ram+200
  .byte <screen_ram+240, <screen_ram+280, <screen_ram+320
  .byte <screen_ram+360, <screen_ram+400, <screen_ram+440
  .byte <screen_ram+480, <screen_ram+520, <screen_ram+560
  .byte <screen_ram+600, <screen_ram+640, <screen_ram+680
  .byte <screen_ram+720, <screen_ram+760, <screen_ram+800
  .byte <screen_ram+840, <screen_ram+880, <screen_ram+920
  .byte <screen_ram+960

ScreenRAMRowStartHigh: // screen_ram + 40*0, 40*1, 40*2 ... 40*24
  .byte >screen_ram,     >screen_ram+40,  >screen_ram+80
  .byte >screen_ram+120, >screen_ram+160, >screen_ram+200
  .byte >screen_ram+240, >screen_ram+280, >screen_ram+320
  .byte >screen_ram+360, >screen_ram+400, >screen_ram+440
  .byte >screen_ram+480, >screen_ram+520, >screen_ram+560
  .byte >screen_ram+600, >screen_ram+640, >screen_ram+680
  .byte >screen_ram+720, >screen_ram+760, >screen_ram+800
  .byte >screen_ram+840, >screen_ram+880, >screen_ram+920
  .byte >screen_ram+960

ColorRAMRowStartLow: // color_ram + 40*0, 40*1, 40*2 ... 40*24
  .byte <color_ram,     <color_ram+40,  <color_ram+80
  .byte <color_ram+120, <color_ram+160, <color_ram+200
  .byte <color_ram+240, <color_ram+280, <color_ram+320
  .byte <color_ram+360, <color_ram+400, <color_ram+440
  .byte <color_ram+480, <color_ram+520, <color_ram+560
  .byte <color_ram+600, <color_ram+640, <color_ram+680
  .byte <color_ram+720, <color_ram+760, <color_ram+800
  .byte <color_ram+840, <color_ram+880, <color_ram+920
  .byte <color_ram+960

ColorRAMRowStartHigh: // color_ram + 40*0, 40*1, 40*2 ... 40*24
  .byte >color_ram,     >color_ram+40,  >color_ram+80
  .byte >color_ram+120, >color_ram+160, >color_ram+200
  .byte >color_ram+240, >color_ram+280, >color_ram+320
  .byte >color_ram+360, >color_ram+400, >color_ram+440
  .byte >color_ram+480, >color_ram+520, >color_ram+560
  .byte >color_ram+600, >color_ram+640, >color_ram+680
  .byte >color_ram+720, >color_ram+760, >color_ram+800
  .byte >color_ram+840, >color_ram+880, >color_ram+920
  .byte >color_ram+960
