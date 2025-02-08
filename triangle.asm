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
;  Date program began:     2025-Jan-27
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

global triangle
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern stdin
    extern input_array
segment .data
    last_name db "Please enter your last name: ", 0
    title_name db "Please enter your title (Mr, Ms, Nurse, Engineer, etc): ", 0
    sides_num db "Please enter the sides of your triangle separated by ws: ", 0
    angle_num db "Please enter the size in degrees of the angle between those sides: ",0
    final_name db "Please enjoy your triangles %s %s", 0
    two_float db "%lf %lf",0
    one_float db "%lf", 0
    third_side db "The length of the third side is %.9f units.", 10, 0
    pi_over_180 dq 0.017453292519943295
    constant dq 2.0
    results dq 0.0
segment .bss
    name resb 50
    title resb 25
    side_a resq 1
    side_b resq 1
    part_b resq 1
    part_a resq 1
    cosine resq 1
segment .text
    global triangle
triangle:
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

    ;Prompt the user for their last name
    mov     rax, 0
    mov     rdi, last_name
    call    printf

    ; Stores the user's input in name
    mov     rax, 0
    mov     rdi, name
    mov     rsi, 50
    mov     rdx, [stdin]
    call    fgets

    ;Prompt the user for their title
    mov     rax, 0
    mov     rdi, title_name
    call    printf

    ; Stores the user's input in title
    mov     rax, 0
    mov     rdi, title
    mov     rsi, 25
    mov     rdx, [stdin]
    call    fgets

    ;Remove newline character from the user's input when the player hit Enter
    mov     rdi, title
    call    strlen
    mov     rbx, rax
    dec     rbx
    mov     byte [title + rbx], 0 

    ;Prompt the user for siddes seperated by ws
    mov     rax, 0
    mov     rdi, sides_num
    call    printf

    ;Store the user's input for the two sides
    sub     rsp, 16
    mov     rdi, two_float
    mov     rsi, rsp
    mov     rdx, rsp
    add     rdx, 8
    call    scanf
    
    ;Square the first side
    movsd   xmm8, qword [rsp]
    movsd   [side_a], xmm8 
    mulsd   xmm8, xmm8

    ;Square the second side
    movsd   xmm9, qword [rsp+8]
    movsd   [side_b], xmm9
    mulsd   xmm9, xmm9
    
    ; Calulate part_b -> side_a^2 + side_b^2
    addsd   xmm8, xmm9
    movsd   [part_a], xmm8
    add     rsp, 16

    ;Prompt the user for thhe angle
    movsd xmm0, qword[angle_num]
    mov     rax, 0
    mov     rdi, angle_num
    call    printf    

    ; Store the angle in one_float
    sub     rsp, 16
    mov     rax, 0
    mov     rdi, one_float
    mov     rsi, rsp
    call    scanf

    ; Calculate Cosine of the angle
    movsd   xmm0, qword [rsp]
    add     rsp, 16
    mulsd   xmm0, qword [pi_over_180]
    call    cos
    movsd   [cosine], xmm0

    ; Calculate part_a -> 2(side_a)(side_b)(cos(angle))
    movsd   xmm10, [side_a] 
    mulsd   xmm10, [constant]
    mulsd   xmm10,  [side_b]
    movsd   xmm11, [cosine]
    mulsd   xmm10, xmm11
    movsd   [part_b], xmm10

    ;Square root everything and calculate the third side -> radical(part_a - part_b) 
    movsd   xmm12, [part_a] 
    subsd   xmm12, [part_b]
    sqrtsd  xmm12, xmm12
    movsd  [results], xmm12
    
    ; Store the third side of the triangle in results
    movsd xmm0,  [results]
    mov     rdi , third_side
    mov     rax, 1
    call    printf
    
    ;Print the name -> Please enjoy your triangle <title> <name>
    sub     rsp, 16
    mov     rbp, rsp
    mov     rdi , final_name
    mov     rsi, title
    mov     rdx, name
    call    printf
    add     rsp, 16
    
    ;Return Value
    movsd xmm0, [results]
    
    ; Restore the general purpose registers
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