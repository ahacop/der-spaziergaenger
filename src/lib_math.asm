// macro: lib_math_add_8bit
//  number1 = 1st Number (Address)
//  number2 = 2nd Number (Address)
//  sum = Sum (Address)
.macro lib_math_add_8bit(number1, number2, sum) {
  clc // Clear carry before add
  lda number1 // Get first number
  adc #number2 // Add to second number
  sta sum  // Store in sum
}

//macro: libmath_add16bit_aavaaa
//  .n1h = 1st Number High Byte (Address)
//  .n1l = 1st Number Low Byte (Address)
//  .n2h = 2nd Number High Byte (Value)
//  .n2l = 2nd Number Low Byte (Address)
//  .sumh = Sum High Byte (Address)
//  .suml = Sum Low Byte (Address)
.macro libmath_add16bit_aavaaa(n1h, n1l, n2h, n2l, sumh, suml) {
  clc // Clear carry before first add
  lda n1l // Get LSB of first number
  adc n2l // Add LSB of second number
  sta suml // Store in LSB of sum
  lda n1h // Get MSB of first number
  adc #n2h // Add carry and MSB of NUM2
  sta sumh // Store sum in MSB of sum
}

//macro: libmath_sub16bit_aavaaa
//  .n1h = 1st Number High Byte (Address)
//  .n1l = 1st Number Low Byte (Address)
//  .n2h = 2nd Number High Byte (Value)
//  .n2l = 2nd Number Low Byte (Address)
//  .sumh = Sum High Byte (Address)
//  .suml = Sum Low Byte (Address)
.macro libmath_sub16bit_aavaaa(n1h, n1l, n2h, n2l, sumh, suml) {
  sec // sec is the same as clear borrow
  lda n1l // Get LSB of first number
  sbc n2l // Subtract LSB of second number
  sta suml // Store in LSB of sum
  lda n1h // Get MSB of first number
  sbc #n2h // Subtract borrow and MSB of NUM2
  sta sumh // Store sum in MSB of sum
}

//macro: libmath_abs_aa
// .N = Number (Address)
// .R = Result (Address)
.macro libmath_abs_aa(n, r) {
  lda n
  bpl !positive+
  eor #$FF        // invert the bits
  sta r
  inc r          // add 1 to give the two's compliment
  jmp !done+
!positive:
  sta r
!done:
}

// macro: libmath_min16bit_aavv
//   n1h = Number 1 High (Address)
//   n1l = Number 1 Low (Address)
//   n2h = Number 2 High (Value)
//   n2l = Number 2 Low (Value)
.macro libmath_min16bit_aavv(n1h, n1l, n2h, n2l) {
  // high byte
  lda n1h // load Number 1
  cmp #n2h // compare with Number 2
  bmi !skip+ // if Number 1 < Number 2 then skip
  lda #n2h
  sta n1h // else replace Number1 with Number2

  // low byte
  lda #n2l // load Number 2
  cmp n1l // compare with Number 1
  bcs !skip+ // if Number 2 >= Number 1 then skip
  sta n1l // else replace Number1 with Number2
!skip:
}

// macro: libmath_max16bit_aavv
//   n1h = Number 1 High (Address)
//   n1l = Number 1 Low (Address)
//   n2h = Number 2 High (Value)
//   n2l = Number 2 Low (Value)
.macro libmath_max16bit_aavv(n1h, n1l, n2h, n2l) {
  // high byte
  lda #n2h // load Number 2
  cmp n1h // compare with Number 1
  bcc !skip+ // if Number 2 < Number 1 then skip
  sta n1h // else replace Number1 with Number2

  // low byte
  lda #n2l // load Number 2
  cmp n1l // compare with Number 1
  bcc !skip+ // if Number 2 < Number 1 then skip
  sta n1l // else replace Number1 with Number2
!skip:
}
