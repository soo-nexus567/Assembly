; Program name: "Program Name". A short description of the purpose of the program
; Copyright (C) <2023>  <Your Name>

; This file is part of the software program "Program Name".

; "Program Name" is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; "Program Name" is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>. 

; Author information
;   Author name : Code Goblin
;   Author email: instalock_caitlyn@bronze2.botlane
;   Author section: 240-99
;   Author CWID : 000000000

; For research purpose only. Please don't copy word for word. Avoid academic dishonesty. 

global manger

    extern scanf
    extern printf
    extern atof
    extern huron
    extern istriangle
array_size equ 12
null equ 0
true equ -1
false equ 0

segment .data
    prompt_input db "For the array enter a sequence of 64-bit floats separated by white space.", 10,"After the last input press enter followed by Control+D:", 10, 0
    output_count db "Array count is %lu", 10, 0
    valid_input db "These inputs have been tested and they are sides of a valid triangle.", 10, 0
    huron_applied db "The Huron formula will be applied to find the area.", 10, 0
    huron_area db "The area is %f sq units. This number will be returned to the caller module.", 10, 0
    format_string db "%s", 0
    format_string1 db "%f", 0
    prompt_tryagain db "That ain't no float, try again", 10, 0
    three_inputs db "These inputs have been tested and they are not the sides of a valid triangle.", 10, 0
    invalid db "These inputs have been tested and they are not the sides of a valid triangle.", 10, 0
    thank_you db "Thank you", 10, 0
    results dq 0.0
    negative_one dq -1.0
segment .bss
    align 64
    storedata resb 832
    nice_array resq array_size
    side_a resq 1
    side_b resq 1
    side_c resq 1
    area resq 1
segment .text
    %include "triangle.inc"
manger:
    ; Back up GPRs
back_register
    ; Save all the floating-point numbers
    backup_compnents storedata

    ; Prompt the input instruction
    mov     rax,0
    mov     rdi, prompt_input
    call    printf

    ; Call input_array which has this equivalent C syntax: 
    ; Signature: ulong input_array(*double array[], ulong max_size)
    ; Parameters:
    ;       array[]: A pointer to an array of double values.
    ;       max_size: The maximum size of the array.
    ; Returns: The count of valid inputs stored in the array.
    ; Purpose: This function stores double-precision floating-point inputs in the
    ; provided array and returns the total number of successfully stored entries.
    mov     rdi, nice_array
    mov     rsi, array_size
    call    input_array
    mov     r15, rax

    ; Output the array count
    cmp r15, 3
    jg no_triangle

    movsd   xmm0, [nice_array]  
    movsd [side_a], xmm0   ; Load the first element (side_a) into xmm0
    movsd   xmm1, [nice_array+8]  
    movsd [side_b], xmm1   ; Load the first element (side_a) into xmm0
    movsd   xmm1, [nice_array+16]  
    movsd [side_c], xmm1   ; Load the first element (side_a) into xmm0
    mov rax, 0
    mov rdi, thank_you
    call printf
    mov     rdi, side_a
    mov     rsi, side_b               ; Pass the value in xmm0 as the second argument (float)
    mov     rdx, side_c
    call    istriangle

    cmp rax, -1
    je no_triangle

    mov rax, 0
    mov rdi, valid_input
    call printf

    mov rax, 0
    mov rdi, huron_applied
    call printf

    ; Print the first value using printf
    mov     rdi, side_a
    mov     rsi, side_b               ; Pass the value in xmm0 as the second argument (float)
    mov     rdx, side_c
    call    huron
    movsd [area], xmm0

    mov     rdi, huron_area       ; Format string for printf
    movsd   xmm0, [area]             ; Load the area value into xmm0
    mov     rax, 1                   ; 1 floating-point argument
    call    printf                   ; Call printf to print the area


    

    

    ; Restore all the floating-point numbers
    mov     rax, 7
    mov     rdx, 0
    xrstor  [storedata]
    mov     rax, r15
    movsd   xmm0, [area]
    movsd xmm0, xmm0
    ;Restore the original values to the GPRs
    restore_registers

    ret
more_than_three:
    ; Print a message if the input count exceeds 3
    mov     rax, 0
    mov     rdi, three_inputs
    call    printf

    ; Exit the program immediately
    jmp     exit
input_array:
    ; Back up GPRs
    back_register

    ; Save all the floating-point numbers
    mov     rax, 7
    mov     rdx, 0
    xsave   [storedata]

    mov     r13, rdi    ; r13 contains the array
    mov     r14, rsi    ; r14 contains the max size
    mov     r15, 0      ; r15 is the index of the loop
    sub     rsp, 1024   ; Create a 1024 bits temporary space on the stack

begin:
    mov     rax, 0
    mov     rdi, format_string
    mov     rsi, rsp
    call    scanf

    ; Check if the input is a Ctrl-D
    cdqe
    cmp     rax, -1
    je      exit
    
    ; Check if the input is a float
    mov     rax, 0
    mov     rdi, rsp
    call    isfloat
    cmp     rax, 0
    je      tryagain

    ; Convert the input into a float
    mov     rax, 0
    mov     rdi, rsp
    call    atof

    ; Copy the float into the array
    movsd   [r13 + r15 * 8], xmm0

    ; Increase r15, repeat the loop if r15 is less than the max size
    inc     r15
    cmp     r15, r14
    jl      begin

    ; Jump to exit otherwise
    jmp     exit      

tryagain:
    ; Prompt the user to try again and repeat the loop
    mov     rax, 0
    mov     rdi, prompt_tryagain
    call    printf
    jmp     begin

exit:
    ; Get rid of the 1024 bits temporary space on the stack
    add     rsp, 1024

    ; Restore all the floating-point numbers
    mov     rax, 7
    mov     rdx, 0
    xrstor  [storedata]
    mov     rax, r15


    ;Restore the original values to the GPRs
    restore_registers

    ret
no_triangle:
    mov rax, 0
    mov rdi, invalid
    call printf
    movsd xmm0, [negative_one]
    ;Restore the original values to the GPRs
    restore_registers
    ret
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