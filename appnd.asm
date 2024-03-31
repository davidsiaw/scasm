since we can only push 0 to 63. to change the top two bits we use the appnd instruction

essentially adds 0x40 to the top of the stack
; appnd 1

essentially adds 0x80 to the top of the stack
; pushi 0
; appnd 2

essentially adds 0xc0 to the top of the stack
; pushi 0
; appnd 3

; halt!

these instructions means that you can store stuff in the first 256 bytes within 4 instructions. (3 if you use the first 64)
