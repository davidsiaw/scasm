asm here is a literate asm
only lines that start with ; are executed
loop 3 times

set the offset to 0x1000
; offset 1000h

set var 0 to 3
; pushi 3
; pop2v 0

save this offset on the memory register
actually saves the next offset because the pc is incremented before the
instruction executes, so when the instruction does its thing it sees an
already incremented thing. this is fine. pc2mr basically just means remember
this place
; pc2mr

subtract 1 from the value in var 0
; pushi 1
; pushv 0
; subtr

save the subtracted value to var 0
; pop2v 0

tell the jump offset 0 (jump will jump offset + 1 bytes)
this means a 0 jump just jumps the next instruction. otherwise
a zero jump is the equivalent of a noop
; pushi 0

jump if the subtracted value was 0
; pjmpz

if the jump did not happen this code runs and copies the contents of the thing
saved in the mr to the pc (this is a jump too)
; mr2pc

otherwise finish the program
; halt!
