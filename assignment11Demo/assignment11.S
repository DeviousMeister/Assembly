#include <avr/io.h>
#include "asmMacros.s"  // Include macros to print log messages or a single register
.text


.global slowDivisionUint8
slowDivisionUint8:
  // TODO: uint8_t slowDivisionUint8(uint8_t a, uint8_t b)
  clr r19
  mov r19, r24
  clr r18
slowDivisionComp:
  cp r19, r22
  brlo finalDiv
  sub r19, r22
  inc r18
  jmp slowDivisionComp
finalDiv:
  mov r24, r18
  ret


.global greaterThanOrEqualUInt16
greaterThanOrEqualUInt16:
  // TODO: bool greaterThanOrEqualUInt16(uint16_t a, uint16_t b)
  cp r25, r23
  brsh testEqual
  ldi r24, 0
  ret
testEqual:
  breq lowerComp
  ldi r24, 1
  ret
lowerComp:
  cp r24, r22
  brsh greater
  ldi r24, 0
  ret
greater:
  ldi r24, 1
  clr r25
  ret

.global slowDivisionUint16
slowDivisionUint16:
  // TODO: uint16_t slowDivisionUint16(uint16_t a, uint16_t b)
  mov r20, r24
  mov r21, r25
  mov r26, r22
  mov r27, r23
  ldi r30, 1
  ldi r31, 0
  clr r19
  clr r18
slowDivComp:
  call greaterThanOrEqualUInt16
  cp r24, r31
  breq finDiv
  sub r20, r26
  sbc r21, r27
  mov r24, r20
  mov r25, r21
  mov r23, r27
  mov r22, r26
  add r18, r30
  adc r19, r31
  jmp slowDivComp
finDiv:
  mov r24, r18
  mov r25, r19
  ret
  
.global slowModulusUint8
slowModulusUint8:
  // TODO: uint16_t slowModulusUint8(uint8_t a, uint8_t b)
  clr r26
  push r24
  push r22
  call slowDivisionUint8
  mov r20, r24
  pop r22
  pop r24
  mul r20, r22
  mov r26, r0
  sub r24, r26
  ret

.global sumOddsUint8
sumOddsUint8:
  // TODO uint16_t sumOddsUint8(uint8_t a, uint8_t b)
  mov r30, r24
  mov r21, r22
  ldi r31, 1 //odd
  clr r27 //counter
  clr r26 //high bit counter
  ldi r22, 2
  push r26
  call slowModulusUint8
  pop r26
  cpse r24, r31
  add r30, r31 
compareNums:
  cp r21, r30
  brsh ifState
  mov r24, r27
  mov r25, r26
  ret
ifState:
  mov r24, r30
  ldi r22, 2
  push r26
  call slowModulusUint8
  pop r26
  cp r24, r31
  brne endSum 
  add r27, r30
  adc r26, r1
  cpi r30, 255
  breq maxSum
  add r30, r22
  jmp compareNums
endSum:
  add r30, r31
  jmp compareNums
  mov r24, r27
  mov r25, r26
  ret
maxSum:
  mov r24, r30
  mov r25, r26
  ret
