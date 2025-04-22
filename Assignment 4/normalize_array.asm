; Copyright Info
; "Assignment 4" is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; "Assignment 4" is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY// without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.
; Author information
; Author name: Jonathan Soo
; Author email: jonathansoo07@csu.fullerton.edu
; Author section: 240-11
; Author CWID : 884776980
; Purpose: Calculate the third side of a triangle using floating-point arithmetic
; Get input from user and output using C functions

; Program information
; Program name: Assignment 4
; Copyright (C) <2025> <Jonathan Soo>
; Programming languages: Several modules in x86-64 and two in C
; Date program began:     2025-March-25
; Date program completed: 2025-March-26
; Date comments upgraded: 2025-March-27
; Files in this program: executive.asm, fill_random_array.asm, isnan.asm, main.c, sort.c, normalize_array.asm, show_array.asm, r.sh
; Status: Complete.  No errors found after extensive testing.

; This file
; File name: normalize_array.asm
; Language: x86-64
; Assemble: nasm -f elf64 -o normalize_array.o normalize_array.asm
; Editor: VS Code
; Link: gcc -m64 -no-pie -o learn.out fill_random_array.o normalize_array.o show_array.o executive.o main.o sort.o isnan.o -std=c2x -Wall -z noexecstack -lm

global normalize_array

segment .data
    ; Define the exponent mask as two 32-bit parts to avoid overflow
    mask_upper dq 0x3ff0000000000000

segment .bss
    align 64
    storedata resb 832
    nice_array resq 100

segment .text
normalize_array:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Preserve important registers                                          |
    ; └────────────────────────────────────────────────────────────────────────┘
    push rbp
    push rbx                     ; Save registers that might be used
    push rcx
    push rdx
    push rdi
    push rsi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    pushf                        ; Save the flags register
    mov     rax, 7
    mov     rdx, 0
    xsave   [storedata]

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Retrieve array address and size, store in designated registers        |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     r15, rdi               
    mov     r14, rsi                

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Initialize loop counter                                              |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     r13, 0                  

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Check if the array has been fully normalized                         |
    ; └────────────────────────────────────────────────────────────────────────┘
check_progress:
    cmp r13, r14                 
    jl process_normalization 

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | All elements normalized, exit the function                           |
    ; └────────────────────────────────────────────────────────────────────────┘
    jmp finish                    

process_normalization:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Load the current value from the array into xmm10                      |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd   xmm15, [r15 + r13 * 8]

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Backup the value into stack memory for manipulation                   |
    ; └────────────────────────────────────────────────────────────────────────┘
    push    qword 0                
    movsd   [rsp], xmm15            
    pop     r12                       

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Isolate the exponent and normalize the number to range 1.0 to 2.0    |
    ; └────────────────────────────────────────────────────────────────────────┘
    shl     r12, 12
    shr     r12, 12
    mov     rax, r12
    mov     rax, [mask_upper]      
    or      r12, rax              

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Store the normalized value back into xmm10                           |
    ; └────────────────────────────────────────────────────────────────────────┘
    push    r12                      
    movsd   xmm15, [rsp] 
    pop     r12            

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Place the normalized value back into the array at index r13          |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd   [r15 + r13 * 8], xmm15

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Increment counter and loop back to check if all elements are processed|
    ; └────────────────────────────────────────────────────────────────────────┘
    inc     r13                 
    jmp     check_progress     

finish:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Restore original registers and flags                                 |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 7
    mov     rdx, 0
    xrstor  [storedata]
    popf                            ; Restore flags
    pop r15                         ; Restore r15 (original array pointer)
    pop r14                         ; Restore r14 (array size)
    pop r13                         ; Restore r13 (loop counter)
    pop r12                         ; Restore r12 (temporary register)
    pop r11                         ; Restore r11
    pop r10                         ; Restore r10
    pop r9                          ; Restore r9
    pop r8                          ; Restore r8
    pop rsi                         ; Restore rsi
    pop rdi                         ; Restore rdi
    pop rdx                         ; Restore rdx
    pop rcx                         ; Restore rcx
    pop rbx                         ; Restore rbx
    pop rbp                         ; Restore rbp to the base of the activation record of the caller program

    ret                             ; Return from the function
    ; End of normalize_array
