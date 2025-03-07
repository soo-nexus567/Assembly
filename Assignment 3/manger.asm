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
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern stdin
    extern input_array
    extern huron
segment .data
    sides_num db "Please enter the sides of your triangle separated by ws: ", 0
    thank_you db "Thank you", 10, 0
    valid_input db "These input have been tested and they are sides of a valid triangle", 10, 0
    huron_applied db "The Huron formula wil lbe applied to find the area", 10, 0
    three_float db "%lf %lf %lf",0
    one_float db "Results %lf", 10, 0
    results dq 0.0
    result_format db "Area: %lf", 10, 0
    constant dq 2.0
segment .bss
    semi_perimeter resq 1
    side_a resq 1
    side_b resq 1
    side_c resq 1
    part_a resq 1
    part_b resq 1
    part_c resq 1
    area resq 1         ; Reserve space for the area result
segment .text
    global manger
manger:
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
    ;Prompt the user for siddes seperated by ws
    mov     rax, 0
    mov     rdi, sides_num
    call    printf

    ; Prepare to take 3 floating-point inputs for the sides of the triangle
    sub     rsp, 16                ; Align the stack to 16 bytes
    mov     rdi, three_float       ; Format string for scanf
    mov     rsi, side_a            ; First float (side_a)
    mov     rdx, side_b            ; Second float (side_b)
    mov     rcx, side_c            ; Third float (side_c)
    call    scanf                  ; Call scanf to read the values

    mov rdi, side_a
    mov rsi, side_b
    mov rdx, side_c
    call huron
    movsd [area], xmm0
    ; ; Load the sides into xmm registers
    ; movsd   xmm0, [side_a]         ; Load side_a into xmm0
    ; movsd   xmm1, [side_b]         ; Load side_b into xmm1
    ; movsd   xmm2, [side_c]         ; Load side_c into xmm2

    ; ; Calculate the semi-perimeter: s = (a + b + c) / 2
    ; addsd   xmm0, xmm1             ; xmm0 = side_a + side_b
    ; addsd   xmm0, xmm2             ; xmm0 = side_a + side_b + side_c
    ; movsd   xmm3, [constant]   ; Load 2.0 into xmm3 (to divide by 2)
    ; divsd   xmm0, xmm3             ; xmm0 = (side_a + side_b + side_c) / 2

    ; ; Store the semi-perimeter in semi_perimeter variable
    ; movsd   [semi_perimeter], xmm0

    ; ; Now, let's calculate the area using Heron's formula
    ; ; s = semi_perimeter, and we need to calculate the area
    ; ; Area = sqrt(s * (s - side_a) * (s - side_b) * (s - side_c))
    
    ; movsd   xmm0, [semi_perimeter]   ; Load semi-perimeter into xmm0
    ; subsd   xmm0, [side_a]            ; xmm0 = semi_perimeter - side_a
    ; movsd   xmm4, [semi_perimeter]   ; Load semi-perimeter again into xmm4
    ; subsd   xmm4, [side_b]            ; xmm4 = semi_perimeter - side_b
    ; movsd   xmm5, [semi_perimeter]   ; Load semi-perimeter again into xmm5
    ; subsd   xmm5, [side_c]            ; xmm5 = semi_perimeter - side_c

    ; mulsd   xmm0, xmm4               ; xmm0 = (semi_perimeter - side_a) * (semi_perimeter - side_b)
    ; mulsd   xmm0, xmm5               ; xmm0 = (semi_perimeter - side_a) * (semi_perimeter - side_b) * (semi_perimeter - side_c)
    ; sqrtsd  xmm0, xmm0               ; xmm0 = sqrt(xmm0), which is the area

    ; Store the area in the area variable
    mov rax, 0
    mov rdi, thank_you
    call printf

    mov rax, 0
    mov rdi, valid_input
    call printf

    mov rax, 0
    mov rdi, huron_applied
    call printf

    ; Print the area result using printf
    mov     rdi, result_format       ; Format string for printf
    movsd   xmm0, [area]             ; Load the area value into xmm0
    mov     rax, 1                   ; 1 floating-point argument
    call    printf                   ; Call printf to print the area
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