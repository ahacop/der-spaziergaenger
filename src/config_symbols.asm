.label VIC2 = $d000
.label address_sprites = 250*64
.label screen_ram      = $0400     // location of screen ram
.label init_sid        = $11ed     // init routine for music
.label play_sid        = $1004     // play music routine
.label delay_counter   = $90       // used to time color switch in the border
.label pra             = $dc00     // CIA#1 (Port Register A)
.label prb             = $dc01     // CIA#1 (Port Register B)
.label ddra            = $dc02     // CIA#1 (Data Direction Register A)
.label ddrb            = $dc03     // CIA#1 (Data Direction Register B)
