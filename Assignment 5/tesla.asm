;Copyright Info
;  "Assignment 5" is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.

;  "Assignment 5" is distributed in the hope that it will be useful,
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
;  Program name: Assignment 5
;  Copyright (C) <2025> <Jonathan Soo>
;  Programming languages: Several modules in x86-64
;  Date program began:     2025-April-12
;  Date program completed: 2025-April-12
;  Date comments upgraded: 2025-April-12
;  Files in this program: acdc.inc edison.asm, faraday.asm, ftoa.asm, tesla.asm. r.sh
;  Status: Complete.  No errors found after extensive testing.
;
;This file
;   File name: tesla.asm
;   Language: x86-64
;   Assemble: nasm -f elf64 -o tesla.o tesla.asm
;   Editor: VS Code
;   Link: ld  -o learn.out faraday.o edison.o tesla.o ftoa.o -g -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

global tesla
section .data
    constant dq 1.0

section .bss
    r1 resq 1
    r2 resq 1
    r3 resq 1

segment .text
    global tesla
    %include "acdc.inc" 
tesla:
    push    rbp                     ; Backup rbp
    mov     rbp,rsp                 ; The base pointer now points to top of stack
    push    rdi                     ; Backup rdi
    push    rsi                     ; Backup rsi
    push    rdx                     ; Backup rdx
    push    rcx                     ; Backup rcx
    push    r8                      ; Backup r8
    push    r9                      ; Backup r9
    push    r10                     ; Backup r10
    push    r11                     ; Backup r11
    push    r12                     ; Backup r12
    push    r13                     ; Backup r13
    push    r14                     ; Backup r14
    push    r15                     ; Backup r15
    push    rbx                     ; Backup rbx
    pushf                           ; Backup rflags

       ; xmm4 = 1 / R1
    movsd xmm0, qword [rdi]      ; load R1
    movsd xmm1, qword [constant] ; load 1.0
    divsd xmm1, xmm0             ; xmm1 = 1 / R1

    ; xmm5 = 1 / R2
    movsd xmm0, qword [rsi]      
    movsd xmm2, qword [constant] 
    divsd xmm2, xmm0             ; xmm2 = 1 / R2

    ; xmm6 = 1 / R3
    movsd xmm0, qword [rdx]      
    movsd xmm3, qword [constant] 
    divsd xmm3, xmm0             ; xmm3 = 1 / R3

    ; Add reciprocals
    addsd xmm1, xmm2             ; xmm1 = (1/R1 + 1/R2)
    addsd xmm1, xmm3             ; xmm1 = (1/R1 + 1/R2 + 1/R3)

    ; Final inversion
    movsd xmm0, qword [constant] 
    divsd xmm0, xmm1             ; xmm0 = 1 / (1/R1 + 1/R2 + 1/R3)

    ; No need for "movsd xmm0, xmm0" here. Just return the result in xmm0.

    popf                            ; Restore rflags
    pop     rbx                     ; Restore rbx
    pop     r15                     ; Restore r15
    pop     r14                     ; Restore r14
    pop     r13                     ; Restore r13
    pop     r12                     ; Restore r12
    pop     r11                     ; Restore r11
    pop     r10                     ; Restore r10
    pop     r9                      ; Restore r9
    pop     r8                      ; Restore r8
    pop     rcx                     ; Restore rcx
    pop     rdx                     ; Restore rdx
    pop     rsi                     ; Restore rsi
    pop     rdi                     ; Restore rdi
    pop     rbp                     ; Restore rbp

    ret                             ; Return from the function
