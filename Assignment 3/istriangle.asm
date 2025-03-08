;Copyright Info
;  "Assignment 1" is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.

;  "Assignment 1" is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
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
;  Program name: Assignment 1
;  Copyright (C) <2025> <Jonathan Soo>
;  Programming languages: One modules in C and one module in X86
;  Date program began:     2025-Mar-05
;  Date program completed: 2025-Feb-07
;  Date comments upgraded: 2025-Feb-08
;  Files in this program: geometry.c, triangle.asm, r.sh
;  Status: Complete.  No errors found after extensive testing.
;
;This file
;   File name: triangle.asm
;   Language: X86-64 with Linux Syntax
;   Assemble: nasm -f elf64 triangle.asm -o triangle.o
;   Editor: VS Code
;   Link: gcc -m64 -Wall -fno-pie -no-pie -z noexecstack -o learn.out triangle.o geometry.o -lm 

global manger
    extern printf
segment .data
    invalid_triangle_msg db "These sides do not form a valid triangle.", 10, 0
    valid_triangle_msg db "The sides form a valid triangle.", 10, 0
segment .bss
    ; Temporary input buffer
segment .text
    global istriangle
istriangle:
    ; Save the base pointer
    push    rbp
    mov     rbp, rsp

    ; Save the general purpose registers
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

    ; Check if any side is non-positive
    movsd xmm0, [rdi]           ; Load side 1 into xmm0
    movsd xmm1, [rsi]           ; Load side 2 into xmm1
    movsd xmm2, [rdx]           ; Load side 3 into xmm2
    xorpd xmm3, xmm3            ; Set xmm3 to 0 (for comparison with 0)

    ; Check if any side <= 0
    comisd xmm0, xmm3         ; Compare side 1 with 0
    jbe invalid_triangle

    comisd xmm1, xmm3         ; Compare side 2 with 0
    jbe invalid_triangle

    comisd xmm2, xmm3         ; Compare side 3 with 0
    jbe invalid_triangle

    ; Check triangle inequality: side1 + side2 > side3
    movsd xmm0, [rdi]           ; side1
    addsd xmm0, xmm1            ; side1 + side2
    comisd xmm0, xmm2           ; Compare (side1 + side2) with side3
    jbe invalid_triangle

    ; Check: side1 + side3 > side2
    movsd xmm0, [rdi]           ; side1
    addsd xmm0, xmm2            ; side1 + side3
    comisd xmm0, xmm1           ; Compare (side1 + side3) with side2
    jbe invalid_triangle

    ; Check: side2 + side3 > side1
    movsd xmm0, [rsi]           ; side2
    addsd xmm0, xmm2            ; side2 + side3
    comisd xmm0, xmm1           ; Compare (side2 + side3) with side1
    jbe invalid_triangle

    mov rax, 1
    ; If all checks pass, the triangle is valid
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

    ; Restore the base pointer
    pop     rbp
    ret
invalid_triangle:
    mov rax, -1
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

    ; Restore the base pointer
    pop     rbp
    ret