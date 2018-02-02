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
