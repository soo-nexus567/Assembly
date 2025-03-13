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
; Author Name    : Jonathan Soo                                        |  
; Author Email   : jonathansoo07@csu.fullerton.edu                     |  
; Author Section : 240-11                                              |  
; Author CWID    : 884776980                                           |  
;======================================================================|  
; Purpose:                                                             |  
; - Calculate the third side of a triangle using floating-point math.  |  
; - Get input from user and output results using C functions.          |  
;======================================================================|  
; Program Name      : Assignment 3                                     |  
; Copyright (C)     : 2025, Jonathan Soo                               |  
; Programming Lang. : One module in C and one module in x86-64 ASM     |  
; Start Date        : 2025-Mar-05                                      |  
; Completion Date   : 2025-Mar-08                                      |  
; Last Comment Edit : 2025-Mar-08                                      |  
; Files Included    : huron.asm, istriangle.asm, manager.asm,          |  
;                     main.c, r.sh                                     |  
; Status           : Complete (No errors found after extensive testing)|  
;======================================================================|  
; File Name  : huron.asm                                               |  
; Language   : x86-64 Assembly                                         |  
; Assemble   : nasm -f elf64 -o huron.o huron.asm                      |  
; Editor     : VS Code                                                 |  
; Link       : gcc -m64 -no-pie -o learn.out manager.o huron.o         | 
;              istriangle.o triangle.o -std=c2x -Wall -z noexecstack -lm 
;======================================================================|  


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
    part_a resq 1
    part_b resq 1
    part_c resq 1
    area resq 1
    
section .text
    global huron
    %include "triangle.inc"
huron:
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Save the base pointer                                  │
    ; └────────────────────────────────────────────────────────┘
    back_register

    ; ┌──────────────────────────────────────────────────────────┐
    ; │ Load the sides into xmm registers (using xmm15 to xmm10) │
    ; └──────────────────────────────────────────────────────────┘
    movsd   xmm15, [rdi]   
    movsd   xmm14, [rsi]     
    movsd   xmm13, [rdx]       

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Calculate the semi-perimeter: s = (a + b + c) / 2      │
    ; └────────────────────────────────────────────────────────┘
    addsd   xmm15, xmm14 
    addsd   xmm15, xmm13   
    movsd   xmm12, [constant] 
    divsd   xmm15, xmm12 

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Store the semi-perimeter                               │
    ; └────────────────────────────────────────────────────────┘
    movsd   [semi_perimeter], xmm15

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Calculate the area using Heron's formula:              │
    ; │ A = sqrt(s * (s - a) * (s - b) * (s - c))              │
    ; └────────────────────────────────────────────────────────┘

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Calculate (s - side_a), (s - side_b), (s - side_c)     │
    ; └────────────────────────────────────────────────────────┘
    movsd   xmm10, [semi_perimeter]     
    subsd   xmm10, [rdi]  ; xmm10 = (s - side_a)

    movsd   xmm11, [semi_perimeter] 
    subsd   xmm11, [rsi]  ; xmm11 = (s - side_b)

    movsd   xmm9, [semi_perimeter] 
    subsd   xmm9, [rdx]  ; xmm9 = (s - side_c)

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Compute s * (s - a) * (s - b) * (s - c)                │
    ; └────────────────────────────────────────────────────────┘
    mulsd   xmm15, xmm10  
    mulsd   xmm15, xmm11  
    mulsd   xmm15, xmm9 

    ; ┌─────────────────────────────────────────────────────────┐
    ; │ Calculate the square root of the result to get the area │
    ; └─────────────────────────────────────────────────────────┘
    sqrtsd  xmm15, xmm15     

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Store the result in the area variable                  │
    ; └────────────────────────────────────────────────────────┘
    movsd   [area], xmm15        
    movsd xmm0, xmm15

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Restore the original values to the GPRs and return     │
    ; └────────────────────────────────────────────────────────┘
    restore_registers
    ret