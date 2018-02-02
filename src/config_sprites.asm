.label BORDER_LEFT = 22
.label BORDER_TOP = 42
.label address_sprites_pointer = address_sprites / $40
.const CENTER_X = 184
.const CENTER_Y = 150
.const SPRITE_WIDTH = 24
.const SPRITE_HEIGHT = 21

.struct SpritepadFile {
  sprites
}

.struct Sprite {
  raw_bytes,
  multicolor_mode,
  overlay,
  color
}

.function parse_sprite(file, sprite_index) {
  .var raw_bytes = List()
  .for (var i = 0; i < 64; i++) {
    .eval raw_bytes.add(file.get(64*sprite_index + i))
  }
  .var attributes = raw_bytes.get(raw_bytes.size() - 1)
  .var multicolor_mode = [attributes & %10000000] == %10000000
  .var overlay = [attributes & %00010000] == %00010000
  .var color = attributes & %00001111
  .return Sprite(raw_bytes, multicolor_mode, overlay, color)
}

.function parse_spritepad_file(file) {
  .var result = SpritepadFile(List())
  .for (var i = 0; i < file.getSize() / 64; i++) {
    .eval result.sprites.add(parse_sprite(file, i))
  }
  .return result
}

.struct Animation {
  frames,
  first_frame_index,
  frames_end,
  sprite_id
}

.function init_animation(frames, first_frame_index, sprite_id) {
  .return Animation(frames, first_frame_index, first_frame_index + frames.size(), sprite_id)
}

.const FILENAMES = List().add(
    "resources/walker_up.bin"
).lock()

.const SPRITEPAD_FILES = List()
.for (var i = 0; i < FILENAMES.size(); i++) {
  .eval SPRITEPAD_FILES.add(parse_spritepad_file(LoadBinary(FILENAMES.get(i))))
}
.eval SPRITEPAD_FILES.lock()

.const ANIMATIONS = List()
.var next_frames_end = 256
.var next_sprite = 0
.for (var i = 0; i < SPRITEPAD_FILES.size(); i++) {
  .var file = SPRITEPAD_FILES.get(i)
  .var frame_sets = List()
  .if (file.sprites.get(0).overlay) {
    .eval frame_sets.add(List(), List())
    .for (var s = 0; s < file.sprites.size()/2; s++) {
      .eval frame_sets.get(0).add(file.sprites.get(2*s+1))
      .eval frame_sets.get(1).add(file.sprites.get(2*s+0))
    }
  } else {
    .eval frame_sets.add(file.sprites)
  }
  .for (var j = 0; j < frame_sets.size(); j++) {
    .var frames = frame_sets.get(j)
    .var animation = init_animation(frames, next_frames_end - frames.size(), next_sprite)
    .eval next_frames_end = animation.first_frame_index
    .eval next_sprite++
    .eval animation.lock()
    .eval ANIMATIONS.add(animation)
  }
}
.eval ANIMATIONS.lock()

.namespace sprites {
  .label positions = VIC2
  .label position_x_high_bits = VIC2 + 16
  .label enable_bits = VIC2 + 21
  .label colors = VIC2 + 39
  .label vertical_stretch_bits = VIC2 + 23
  .label horizontal_stretch_bits = VIC2 + 29
  .label pointers = screen_ram + $03f8
  .label multicolor_bits = VIC2 + 28
  .label color1 = VIC2 + 37
  .label color2 = VIC2 + 38
}

draw_animations:
  .for (var i = 0; i < ANIMATIONS.size(); i++) {
    .var animation = ANIMATIONS.get(i)
    advance_optimized_frame(i, animation, walker_current_frame, walker_frame_counts)
  }
  rts

setup_player_sprite:
  .const OFFSET = 50
  // Don't use ANIMATIONS.size() since some of them can be overlayed
  .var next_x = CENTER_X - SPRITEPAD_FILES.size()*OFFSET/2
  .var next_y = CENTER_Y - SPRITEPAD_FILES.size()*OFFSET/2
  .for (var i = 0; i < ANIMATIONS.size(); i++) {
    .var animation = ANIMATIONS.get(i)
    .var sprite_bit = [%00000001 << animation.sprite_id]
    .var first_frame = animation.frames.get(0)
    lda #sprite_bit
    ora sprites.enable_bits
    sta sprites.enable_bits
    .if (first_frame.multicolor_mode) {
      lda #sprite_bit
      ora sprites.multicolor_bits
      sta sprites.multicolor_bits
    }
    lda #first_frame.color
    sta sprites.colors + i

    lda current_frames + i
    sta sprites.pointers + i

    .if (first_frame.overlay) {
      .eval next_x -= OFFSET
      .eval next_y -= OFFSET
    }
    ldx #next_x
    stx sprites.positions + 2*i
    ldy #next_y
    sty sprites.positions + 2*i + 1
    .eval next_x += OFFSET
    .eval next_y += OFFSET
  }
  rts

.pc = * "Data"
.namespace walker_current_frame {
  counter: .byte 1
  index: .byte 0
  ping_pong: .byte 0
}

walker_frame_counts:
  .byte 5, 5, 5, 5, 5, 5, 5, 5

current_frames:
  .for (var i = 0; i < ANIMATIONS.size(); i++) {
    .var animation = ANIMATIONS.get(i)
    .byte animation.first_frame_index
  }

sprite_bitmaps:
  .for (var a = 0; a < ANIMATIONS.size(); a++) {
    .var animation = ANIMATIONS.get(a)
    .pc = animation.first_frame_index*64
    .for (var j = 0; j < animation.frames.size(); j++) {
      .fill 64, animation.frames.get(j).raw_bytes.get(i)
    }
  }

.macro advance_optimized_frame(animation_id, animation, current_frame, frame_counts) {
  ldy current_frame.counter
  dey
  beq actually_advance_frame
  sty current_frame.counter
  jmp end
actually_advance_frame:
  ldx current_frames + animation_id
  inx
  ldy current_frame.index
  iny
  cpx #animation.frames_end
  bne update
wrap_around:
  ldx #animation.first_frame_index
  ldy #0
update:
  sty current_frame.index
  lda frame_counts, y
  sta current_frame.counter
  stx current_frames + animation_id
  stx sprites.pointers + animation.sprite_id
  jmp end
end:
}
