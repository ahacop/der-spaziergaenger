.var yellow_man = LoadBinary("resources/yellow_man.bin")
*= address_sprites
.fill yellow_man.getSize(), yellow_man.get(i)
