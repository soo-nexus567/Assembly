;======================================================================|  
; Copyright Info                                                       |  
; "Midterm Program" is free software: you can redistribute it and modify  
; it under the terms of the GNU General Public License as published by |  
; the Free Software Foundation, either version 3 of the License, or    |  
; (at your option) any later version.                                  |  
;                                                                      |  
; "Midterm Program" is distributed in the hope that it will be useful, |  
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
; Program Name      : Midterm Program                                  |  
; Copyright (C)     : 2025, Jonathan Soo                               |  
; Programming Lang. : One module in C and one in x86-64                |  
; Date program began: 2025-Mar-11                                      |  
; Date program completed: 2025-Mar-11                                  |  
; Date comments upgraded: 2025-Mar-11                                  |  
; Files in this program: huron.asm, input_array.asm, manager.asm,      |  
;                        output_array.asm main.c, r.sh                 |  
; Status: Complete. No errors found after testing.                     |  
;======================================================================|  
; This file                                                            |  
; File Name  : current.asm                                             |  
; Language   : x86-64 with Linux Synatax                               |  
; Assemble   : nasm -f elf64 -o current.o current.asm                  |   
; Editor     : VS Code                                                 |  
; Link       : gcc -m64 -no-pie -o learn.out current.o electricy.o     |     
;              main.o -std=c2x -Wall -z noexecstack -lm                |
;                                                                      |
;======================================================================|  
global current

extern printf

segment .data
segment .bss

segment .text
    global current
current:
    ; Backup registers
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

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Store the parameter values                                             |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd   xmm4, [rdi]
    movsd   xmm5, [rsi]
    movsd   xmm6, [rdx]

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Perform float addition                                                 |
    ; └────────────────────────────────────────────────────────────────────────┘
    addsd   xmm4, xmm5
    addsd   xmm4, xmm6 

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Return value                                                           |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd   xmm0, xmm4
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