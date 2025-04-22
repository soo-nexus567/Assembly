;Copyright Info
;  "Assignment 4" is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.

;  "Assignment 4" is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY// without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.

;  You should have received a copy of the GNU General Public License
;  along with this program.  If not, see <https://www.gnu.org/licenses/>.
;Author information
;  Author name: Jonathan Soo
;  Author email: jonathansoo07@csu.fullerton.edu
;  Author section: 240-11
;  Author CWID : 884776980
;Purpose
;  Calculate the third side of a triangle using float-point arthmetic
;  Get input from user and ouput using C functions

;Program information
;  Program name: Assignment 4
;  Copyright (C) <2025> <Jonathan Soo>
;  Programming languages: Several modules in x86-64 and two in C
;  Date program began:     2025-March-25
;  Date program completed: 2025-March-26
;  Date comments upgraded: 2025-March-27
;  Files in this program: executive.asm, fill_random_array.asm, isnan.asm, main.c, sort.c, normalize_array.asm, show_array.asm, r.sh
;  Status: Complete.  No errors found after extensive testing.
;
;This file
;   File name: fill_random_array.asm
;   Language: x86-64
;   Assemble: nasm -f elf64 -o executive.o executive.asm
;   Editor: VS Code
;   Link: gcc -m64 -no-pie -o learn.out fill_random_array.o normalize_array.o show_array.o executive.o main.o sort.o isnan.o -std=c2x -Wall -z noexecstack -lm
global fill_random_array
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern stdin
    extern input_array
    extern isnan

segment .data
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Data segment: Stores formatted strings and other static data          |
    ; └────────────────────────────────────────────────────────────────────────┘
    fmt_failed db "RDRAND failed. Retrying...", 10, 0  
    fmt_rax db "RDRAND value: %llx", 10, 0
    fmt_float db "Random double: %lf", 10, 0        
    r14_value dq 0

segment .bss
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Uninitialized data segment: Used for temporary storage                |
    ; └────────────────────────────────────────────────────────────────────────┘
    align 64
    storedata resb 832
    nice_array resq 100  

segment .text
    global fill_random_array

fill_random_array:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Backup registers and save processor state                             |
    ; └────────────────────────────────────────────────────────────────────────┘
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
    pushf                           ; Save the flags register
    mov rax,7
    mov rdx,0
    xsave [storedata]               ; Save the processor state to memory

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Initialize array parameters                                          |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     r13, rdi                ; r13 stores the address of the array
    mov     r14, rsi                ; r14 stores the array size
    mov     r15, 0                  ; r15 is used as a counter/index for the array
    sub     rsp, 1024               ; Allocate space on the stack for further use

    jmp     generate_random_floats  ; Jump to the code for generating random floats

set_max_size:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Set the maximum size of the array to 100 if needed                    |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     r14, 100                ; Ensure the array size does not exceed 100

generate_random_floats:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Begin generating random floating-point numbers                        |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rbx, r14                ; rbx holds the size of the array

generate_loop:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Generate a new random number and store it in the array                |
    ; └────────────────────────────────────────────────────────────────────────┘
    cmp     r15, r14                ; Compare the counter (r15) with the array size
    jge     end_loop                ; If the counter exceeds the size, exit the loop

    rdrand  rax                     ; Use the RDRAND instruction to generate a random number
    jnc     generate_loop           ; If RDRAND fails, retry

    
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Convert the random integer to a floating-point number in IEEE 754     |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rcx, 0x3DF0000000000000  ; Set the constant multiplier for IEEE 754 format
    movq    xmm1, rcx               ; Load the multiplier into xmm1
    cvtsi2sd xmm0, rax              ; Convert the random integer (rax) to a double in xmm0
    mulsd   xmm0, xmm1              ; Multiply the value in xmm0 by the multiplier to get a float in [0, 1)

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Check if the number is a valid (non-NaN) value                        |
    ; └────────────────────────────────────────────────────────────────────────┘
    call    isnan
    cmp     rax, 0
    jp      generate_loop           ; If the value is NaN (jump to retry)

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Store the random number in the array                                  |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd   [r13 + r15 * 8], xmm0   ; Store the value in the array (r13 + r15 * 8)

    inc     r15                     ; Increment the counter (r15)
    jmp     generate_loop           ; Continue the loop to generate the next random number

nan_detected:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Handle NaN cases by regenerating the number                           |
    ; └────────────────────────────────────────────────────────────────────────┘
    jmp     generate_loop           ; Jump back to the loop to regenerate the value

end_loop:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Restore processor state after completion                              |
    ; └────────────────────────────────────────────────────────────────────────┘
    add     rsp, 1024               ; Restore the stack pointer

    mov     rax, 7
    mov     rdx, 0
    xrstor [storedata]              ; Restore the processor state from memory

    mov     rax, r15                ; Return the count of generated random numbers

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Restore registers and return from function                            |
    ; └────────────────────────────────────────────────────────────────────────┘
    popf                            ; Restore the flags register
    pop     r15                     ; Restore r15
    pop     r14                     ; Restore r14
    pop     r13                     ; Restore r13
    pop     r12                     ; Restore r12
    pop     r11                     ; Restore r11
    pop     r10                     ; Restore r10
    pop     r9                      ; Restore r9
    pop     r8                      ; Restore r8
    pop     rdi                     ; Restore rdi
    pop     rsi                     ; Restore rsi
    pop     rdx                     ; Restore rdx
    pop     rcx                     ; Restore rcx
    pop     rbx                     ; Restore rbx
    pop     rbp                     ; Restore rbp

    ret                             ; Return from the function
