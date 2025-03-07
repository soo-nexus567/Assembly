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

global huron
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern stdin
    extern input_array
segment .data
    results dq 0.0
    constant dq 2.0
segment .bss
    semi_perimeter resq 1
    side_a resq 1
    side_b resq 1
    side_c resq 1
    part_a resq 1
    part_b resq 1
    part_c resq 1
huron:
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
    mov r15, rdi
    mov r14, rsi
    mov r13, rcx

    movsd xmm8, qword [r15]
    movsd xmm9, qword [r14]
    movsd xmm10, qword [r13]

    movsd [side_a], xmm8
    movsd [side_b], xmm9
    movsd [side_c], xmm10
    movsd xmm11, [constant]
    addsd xmm8, xmm9
    addsd xmm8, xmm10
    divsd xmm8, xmm11
    movsd [semi_perimeter], xmm8

    movsd xmm12, [semi_perimeter]
    subsd xmm12, xmm8

    movsd xmm13, [semi_perimeter]
    subsd xmm13, xmm9

    movsd xmm14, [semi_perimeter]
    subsd xmm14, xmm10

    movsd xmm15, [semi_perimeter]
    mulsd xmm12, xmm13
    mulsd xmm12, xmm14
    mulsd xmm12, xmm15

    sqrtsd xmm12, xmm12
    movsd [results], xmm12
    
    mov rax, 0
    mov rdi, area
    mov rsi, results 
    call printf

    ; Restore the general purpose registers
    movsd [results], xmm0
    movsd xmm0, xmm0
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