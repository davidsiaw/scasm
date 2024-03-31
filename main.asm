
loop 3 times

# set var 0 to 3
; pushi 3
; pop2v 0

# save this offset on the memory register
; pc2mr

# subtract 1 from the value in var 0
; pushi 1
; pushv 0
; subtr

# save the subtracted value to var 0
; pop2v 0

# tell the jump offset 0 (jump will jump offset + 1 bytes)
; pushi 0

# jump if the subtracted value was 0
; pjmpz

# if the jump did not happen this code runs and copies the contents of the thing
# saved in the mr to the pc (this is a jump too)
; mr2pc

# otherwise finish the program
; halt!
