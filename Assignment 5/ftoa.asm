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
;  Caluculate 

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
;   File name: ftoa.asm
;   Language: x86-64
;   Assemble: nasm -f elf64 -o ftoa.o ftoa.asm
;   Editor: VS Code
;   Link: ld  -o learn.out faraday.o edison.o tesla.o ftoa.o -g -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

section .data
    ten           dq 10.0
    ten_pow_6     dq 1000000.0
    rounding_bias dq 0.5

section .text
global ftoa

ftoa:
; ┌────────────────────────────────────────────────────────────┐
; │ Preserve destination buffer pointer in r12                 │
; │ Clear digit index r13                                      │
; └────────────────────────────────────────────────────────────┘
    mov     r12, rdi
    xor     r13, r13

; ┌────────────────────────────────────────────────────────────┐
; │ Copy input float to xmm3, round it, and convert to integer │
; └────────────────────────────────────────────────────────────┘
    movsd   xmm1, xmm0 
    roundsd xmm3, xmm1, 1
    cvttsd2si rax, xmm3 

; ┌────────────────────────────────────────────────────────────┐
; │ Convert integer part to ASCII characters                   │
; └────────────────────────────────────────────────────────────┘
    xor     rcx, rcx
    mov     rbx, rax
    cmp     rbx, 0
    jne     .int_convert

; ┌────────────────────────────────────────────────────────────┐
; │ Special case: integer part is 0                            │
; └────────────────────────────────────────────────────────────┘
    mov     byte [r12 + r13], '0'
    inc     r13
    jmp     .after_int_convert

.int_convert:
.push_loop:
    xor     rdx, rdx
    mov     rax, rbx
    mov     r15, 10
    div     r15
    push    rdx
    inc     rcx
    mov     rbx, rax
    cmp     rbx, 0
    jne     .push_loop

.pop_loop:
    pop     rax
    add     al, '0'
    mov     [r12 + r13], al
    inc     r13
    loop    .pop_loop

.after_int_convert:
; ┌────────────────────────────────────────────────────────────┐
; │ Add decimal point to the string                            │
; └────────────────────────────────────────────────────────────┘
    mov     byte [r12 + r13], '.'
    inc     r13

; ┌────────────────────────────────────────────────────────────┐
; │ Compute fractional part: isolate it and scale to 6 digits  │
; │ Apply rounding bias before conversion to integer           │
; └────────────────────────────────────────────────────────────┘
    movsd   xmm2, xmm1
    subsd   xmm2, xmm3
    mulsd   xmm2, [ten_pow_6]
    addsd   xmm2, [rounding_bias]
    cvttsd2si rax, xmm2

; ┌────────────────────────────────────────────────────────────┐
; │ Convert 6-digit fractional part to ASCII characters        │
; └────────────────────────────────────────────────────────────┘
    mov     rcx, 6
    mov     rbx, rax
.frac_digits:
    xor     rdx, rdx
    mov     rax, rbx
    mov     r15, 10
    div     r15
    push    rdx
    mov     rbx, rax
    loop    .frac_digits

    mov     rcx, 6
.pop_frac:
    pop     rax
    add     al, '0'
    mov     [r12 + r13], al
    inc     r13
    loop    .pop_frac

; ┌────────────────────────────────────────────────────────────┐
; │ Null-terminate the result string and return pointer        │
; └────────────────────────────────────────────────────────────┘
    mov     byte [r12 + r13], 0
    mov     rax, r12
    ret
