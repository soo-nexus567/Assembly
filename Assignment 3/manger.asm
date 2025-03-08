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
    extern isfloat
    extern atof
    extern huron

array_size equ 12

segment .data
    prompt_input db "For the array enter a sequence of 64-bit floats separated by white space.", 10,"After the last input press enter followed by Control+D:", 10, 0
    output_count db "Array count is %lu", 10, 0
    format_string db "%s", 0
    format_string1 db "%f", 0
    prompt_tryagain db "That ain't no float, try again", 10, 0
    three_inputs db "Too many inputs! The program will now exit.", 10, 0
    huron_applied db "Area: %lf", 10, 0
    results dq 0.0
segment .bss
    align 64
    storedata resb 832
    nice_array resq array_size
segment .text
manger:
    ; Back up GPRs
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rcx
    push    rdx
    push    rsi
    push    rdi
    push    r8 
    push    r9 
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
    pushf

    ; Save all the floating-point numbers
    mov     rax, 7
    mov     rdx, 0
    xsave   [storedata]

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
    jg more_than_three

    movsd   xmm0, [nice_array]  
    movsd [ ], xmm0   ; Load the first element (side_a) into xmm0

    ; Print the first value using printf
    mov     rdi, format_string1      ; Address of the format string "%f"
    mov     rsi, results               ; Pass the value in xmm0 as the second argument (float)
    call    printf                  ; Call printf to print the value
    

    ; movsd [results], xmm0
    ; mov rax, 0
    ; mov rdi, huron_applied
    ; mov rsi, results
    ; call printf

    ; Restore all the floating-point numbers
    mov     rax, 7
    mov     rdx, 0
    xrstor  [storedata]

    mov     rax, r15

    ;Restore the original values to the GPRs
    popf          
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9 
    pop     r8 
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rbp

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
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rcx
    push    rdx
    push    rsi
    push    rdi
    push    r8 
    push    r9 
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
    pushf

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
    popf          
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9 
    pop     r8 
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rbp

    ret