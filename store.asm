store to memory
since we can push immediate up to 63 we can use the first 64 memory addresses with 3 instructions

push the memory address
; pushi 1

push the value to store
; pushi 5

pop the value to store and save it to the memory described at the top of the stack
; pop2m

; halt!

second fastest is the 2 instruction save to variable

fastest is save to stack but its super limited

why only up to 63?

honestly could be less but want to strike a balance between ease of asm generation and opcode space usage

if you want your big numbers you should include them as data in your application and load them sequentially from memory and use them