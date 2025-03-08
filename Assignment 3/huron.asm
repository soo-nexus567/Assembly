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
    result_format db "Area: %lf", 10, 0  ; Format
    three_float db "%lf %lf %lf",0
    results dq 0.0
    constant dq 2.0
    fmt db "xmm0: %lf", 10, 0      ; Format string for xmm0
    fmt1 db "xmm1: %lf", 10, 0      ; Format string for xmm1
    fmt2 db "xmm3: %lf", 10, 0      ; Format string for xmm3
segment .bss
    semi_perimeter resq 1
    part_a resq 1
    part_b resq 1
    part_c resq 1
    area resq 1
    
section .text
    global huron
    %include "triangle.inc"
huron:
    ; Save the base pointer
    back_register
   ; Parameters:
    ; rdi -> address of side_a
    ; rsi -> address of side_b
    ; rdx -> address of side_c

    ; Load the sides into xmm registers
    movsd   xmm0, [rdi]         ; Load side_a into xmm0
    movsd   xmm1, [rsi]         ; Load side_b into xmm1
    movsd   xmm2, [rdx]         ; Load side_c into xmm2

    ; Calculate the semi-perimeter: s = (a + b + c) / 2
    addsd   xmm0, xmm1          ; xmm0 = side_a + side_b
    addsd   xmm0, xmm2          ; xmm0 = side_a + side_b + side_c
    movsd   xmm3, [constant]    ; Load 2.0 into xmm3 (to divide by 2)
    divsd   xmm0, xmm3          ; xmm0 = (side_a + side_b + side_c) / 2

    ; Store the semi-perimeter
    movsd   [semi_perimeter], xmm0

    ; Now, calculate the area using Heron's formula
    movsd   xmm0, [semi_perimeter]  ; Load semi-perimeter into xmm0
    subsd   xmm0, [rdi]             ; xmm0 = semi_perimeter - side_a
    movsd   xmm4, [semi_perimeter]  ; Load semi-perimeter again into xmm4
    subsd   xmm4, [rsi]             ; xmm4 = semi_perimeter - side_b
    movsd   xmm5, [semi_perimeter]  ; Load semi-perimeter again into xmm5
    subsd   xmm5, [rdx]             ; xmm5 = semi_perimeter - side_c

    movsd xmm6, [semi_perimeter]
    mulsd   xmm0, xmm4              ; xmm0 = (semi_perimeter - side_a) * (semi_perimeter - side_b)
    mulsd   xmm0, xmm5              ; xmm0 = (semi_perimeter - side_a) * (semi_perimeter - side_b) * (semi_perimeter - side_c)
    mulsd   xmm0, xmm6
    sqrtsd  xmm0, xmm0              ; xmm0 = sqrt(xmm0), which is the area

    ; Store the result in the area variable
    movsd   [area], xmm0



    restore_registers
    ret