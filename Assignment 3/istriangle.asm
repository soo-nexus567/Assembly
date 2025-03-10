;======================================================================|  
; Copyright info                                                       |  
; "Assignment 3" is free software: you can redistribute it and modify  |  
; it under the terms of the GNU General Public License as published by |  
; the Free Software Foundation, either version 3 of the License, or    |  
; (at your option) any later version.                                  |  
;                                                                      |  
; "Assignment 3" is distributed in the hope that it will be useful,    |  
; but WITHOUT ANY WARRANTY; without even the implied warranty of       |  
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU     |  
; General Public License for more details.                             |  
;                                                                      |  
; You should have received a copy of the GNU General Public License    |  
; along with this program. If not, see <https://www.gnu.org/licenses/>.|  
;======================================================================|  
; Author information                                                   |  
; Author Name    : Jonathan Soo                                        |  
; Author Email   : jonathansoo07@csu.fullerton.edu                     |  
; Author Section : 240-11                                              |  
; Author CWID    : 884776980                                           |  
;======================================================================|  
; Purpose                                                              |  
; Calculate the third side of a triangle using floating-point          |  
; arithmetic. Get input from user and output using C functions.        |  
;======================================================================|  
; Program information                                                  |  
; Program Name      : Assignment 3                                     |  
; Copyright (C)     : 2025, Jonathan Soo                               |  
; Programming Lang. : One module in C and one in x86-64                |  
; Date program began: 2025-Mar-05                                      |  
; Date program completed: 2025-Mar-08                                  |  
; Date comments upgraded: 2025-Mar-08                                  |  
; Files in this program: huron.asm, istriangle.asm, manager.asm,       |  
;                        main.c, r.sh                                  |  
; Status: Complete. No errors found after testing.                     |  
;======================================================================|  
; This file                                                            |  
; File Name  : istriangle.asm                                          |  
; Language   : x86-64                                                  |  
; Assemble   : nasm -f elf64 -l istriangle.lis -o istriangle.o         |   
;              istriangle.asm                                          |  
; Editor     : VS Code                                                 |  
; Link       : gcc -m64 -no-pie -o learn.out manager.o huron.o         |   
;              istriangle.o main.o -std=c2x -Wall -z noexecstack -lm   |  
;======================================================================|  


global manger
extern printf

segment .data
    invalid_triangle_msg db "These sides do not form a valid triangle.", 10, 0
    valid_triangle_msg db "The sides form a valid triangle.", 10, 0

segment .bss

segment .text
    global istriangle
    %include "triangle.inc"

istriangle:
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Save the base pointer                                  │
    ; └────────────────────────────────────────────────────────┘
    back_register

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Load sides into non-volatile registers                 │
    ; └────────────────────────────────────────────────────────┘
    movsd xmm4, [rdi]       
    movsd xmm5, [rsi]
    movsd xmm6, [rdx]
    xorpd xmm7, xmm7  ; xmm7 = 0.0

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Check if any side <= 0                                 │
    ; └────────────────────────────────────────────────────────┘
    comisd xmm4, xmm7
    jbe invalid_triangle

    comisd xmm5, xmm7
    jbe invalid_triangle

    comisd xmm6, xmm7
    jbe invalid_triangle

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Check triangle inequality: side1 + side2 > side3       │
    ; └────────────────────────────────────────────────────────┘
    movsd xmm4, [rdi]
    addsd xmm4, xmm5
    comisd xmm4, xmm6
    jbe invalid_triangle

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Check: side1 + side3 > side2                           │
    ; └────────────────────────────────────────────────────────┘
    movsd xmm4, [rdi]
    addsd xmm4, xmm6
    comisd xmm4, xmm5
    jbe invalid_triangle

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Check: side2 + side3 > side1                           │
    ; └────────────────────────────────────────────────────────┘
    movsd xmm4, [rsi]
    addsd xmm4, xmm6
    comisd xmm4, xmm7
    jbe invalid_triangle

    ; ┌────────────────────────────────────────────────────────┐
    ; │ If all checks pass, return 1 (valid triangle)          │
    ; └────────────────────────────────────────────────────────┘
    mov rax, 1
    restore_registers
    ret

invalid_triangle:
    ; ┌────────────────────────────────────────────────────────┐
    ; │ If the triangle is not valid, return -1                │
    ; │ This value will be checked in manager                  │
    ; └────────────────────────────────────────────────────────┘
    mov rax, -1
    restore_registers
    ret