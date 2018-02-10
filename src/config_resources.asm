.var walker_sprites = LoadBinary("resources/walker_low.bin")
.pc = sprite_ram*64 "Sprite Data"
.fill walker_sprites.getSize(), walker_sprites.get(i)
