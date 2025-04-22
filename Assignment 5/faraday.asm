
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
;   File name: faraday.asm
;   Language: x86-64
;   Assemble: nasm -f elf64 -o faraday.o faraday.asm
;   Editor: VS Code
;   Link: ld  -o learn.out faraday.o edison.o tesla.o ftoa.o -g -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

global faraday
    extern edison
system_terminate     equ 60

Null                 equ 0
Exit_with_success    equ 0
segment .data   
    hello       db "Welcome to Electricity brought to you by Jonathan Soo.", 0xa, 0
    program     db "This program will compute the resistance current flow in your direct circuit.", 0xa, 0
    driver db 10, "The driver received this number ", 0
    next_semseter db ", and will keep it until next semester.", 10, 0
    zero_returned db "A zero will be returned to the Operating System", 10, 0
segment .bss
    current resb 100
segment .text
    global _start
    %include "acdc.inc" 

_start:
; ┌────────────────────────────────────────────────────────────┐
; │ Display the string "hello"                                 │
; └────────────────────────────────────────────────────────────┘
    mov        rdi, hello              ; The starting address of the string hello is in rdi.
    mov        rsi, 0                  ; 7 is the position within hello where output will begin.
    showstring

; ┌────────────────────────────────────────────────────────────┐
; │ Display the program name or description                    │
; └────────────────────────────────────────────────────────────┘
    mov        rdi, program
    mov        rsi, 0
    showstring

; ┌────────────────────────────────────────────────────────────┐
; │ Call the edison subroutine                                 │
; └────────────────────────────────────────────────────────────┘
    call edison

; ┌────────────────────────────────────────────────────────────┐
; │ Save the current (result from edison) to memory            │
; └────────────────────────────────────────────────────────────┘
    movsd [current], xmm0

; ┌────────────────────────────────────────────────────────────┐
; │ Show string indicating driver message                      │
; └────────────────────────────────────────────────────────────┘
    mov rdi, driver
    mov rsi, 0
    showstring

; ┌────────────────────────────────────────────────────────────┐
; │ Show the calculated current value                          │
; └────────────────────────────────────────────────────────────┘
    mov rdi, current
    mov rsi, 0
    showstring

; ┌────────────────────────────────────────────────────────────┐
; │ Show the "next semester" message                           │
; └────────────────────────────────────────────────────────────┘
    mov rdi, next_semseter
    mov rsi, 0
    showstring

; ┌────────────────────────────────────────────────────────────┐
; │ Exit the program gracefully using syscall                  │
; └────────────────────────────────────────────────────────────┘
    mov rdi, zero_returned
    mov rsi, 0
    showstring 
    mov     rax, system_terminate
    mov     rdi, Exit_with_success
    syscall