global isfloat

null equ 0
true equ -1
false equ 0

segment .data
   ; This segment is empty

segment .bss
   ; This segment is empty

segment .text
isfloat:

; Back up registers to protect caller data
push rbp
mov  rbp,rsp
push rdi
push rsi
push rdx
push rcx
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
push rbx
pushf

; Make a copy of the passed-in array of ASCII values
mov r13, rdi
xor r14, r14  ; Initialize r14 as the array index

; Check for leading '+' or '-' signs
cmp byte [r13], '+'  ; Check for '+'
je increment_index
cmp byte [r13], '-'  ; Check for '-'
jne continue_validation

increment_index:
inc r14

continue_validation:

; Loop to validate chars before the decimal point
loop_before_point:
   mov rax, 0
   xor rdi, rdi  ; Zero out rdi
   mov dil, byte [r13 + r14]  ; Load the next byte into rdi
   call is_digit
   cmp rax, false
   je is_it_radix_point
   inc r14
   jmp loop_before_point

is_it_radix_point:
; Check if the next character is a radix point '.'
cmp byte [r13 + r14], '.'
jne return_false  ; If not, return false (invalid input)

; Loop to validate digits after the radix point
start_loop_after_finding_a_point:
    inc r14
    mov rax, 0
    xor rdi, rdi
    mov dil, byte [r13 + r14]
    call is_digit
    cmp rax, false
    jne start_loop_after_finding_a_point

; Check for end of string (null terminator)
cmp byte [r13 + r14], null
jne return_false  ; If it's not the end of the string, return false
mov rax, true  ; Return true if a valid float

jmp restore_gpr_registers

return_false:
mov rax, false  ; Return false if input is not a valid float

restore_gpr_registers:
; Restore all general purpose registers
popf
pop rbx
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rcx
pop rdx
pop rsi
pop rdi
pop rbp

ret


;=================== is_digit function ==========================

true equ -1
false equ 0
ascii_value_of_zero equ 0x30
ascii_value_of_nine equ 0x39

segment .text
is_digit:
; Back up registers
push rbp
mov rbp, rsp
push rdi
push rsi
push rdx
push rcx
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
push rbx
pushf

; Copy the passed-in character (rdi) to r13
mov r13b, dil

; Check if the character is between '0' and '9'
cmp r13b, ascii_value_of_zero
jl is_digit_return_false
cmp r13b, ascii_value_of_nine
jg is_digit_return_false

; Return true if it's a valid digit
xor rax, rax
mov rax, true

jmp is_digit_restore_gpr_registers

is_digit_return_false:
xor rax, rax
mov rax, false

is_digit_restore_gpr_registers:
; Restore registers
popf
pop rbx
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rcx
pop rdx
pop rsi
pop rdi
pop rbp

ret