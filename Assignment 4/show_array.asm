;Copyright Info
;  "Assignment 4" is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.

;  "Assignment 4" is distributed in the hope that it will be useful,
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
;  Program name: Assignment 4
;  Copyright (C) <2025> <Jonathan Soo>
;  Programming languages: Several modules in x86-64 and two in C
;  Date program began:     2025-March-25
;  Date program completed: 2025-March-26
;  Date comments upgraded: 2025-March-27
;  Files in this program: executive.asm, fill_random_array.asm, isnan.asm, main.c, sort.c, normalize_array.asm, show_array.asm, r.sh
;  Status: Complete.  No errors found after extensive testing.
;
;This file
;   File name: show_array.asm
;   Language: x86-64
;   Assemble: nasm -f elf64 -o show_array.o show_array.asm
;   Editor: VS Code
;   Link: gcc -m64 -no-pie -o learn.out fill_random_array.o normalize_array.o show_array.o executive.o main.o sort.o isnan.o -std=c2x -Wall -z noexecstack -lm
global show_array
extern printf

segment .data
    prompt db "IEEE754		      Scientific Decimal", 10, 0
    msg_ieee db "%p", 0
    msg_sci  db "    %.13e", 10, 0          
    fmt_debug db "%p", 10, 0

segment .text
show_array:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | 15 pushes to preserve registers before beginning the function          |
    ; └────────────────────────────────────────────────────────────────────────┘
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

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Set up registers for array processing (r15 holds array, r14 holds size)|
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     r15, rdi                  
    mov     r14, rsi              
    mov     r13, 0                    
    
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Prompt for array display                                             |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, prompt              
    call    printf

begin:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Load the double at index r13 into xmm0 and print its memory address    |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rdi, msg_ieee  
    mov     rsi, [r15 + r13 * 8]      
    call    printf                    

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Print the value in IEEE754 format (64-bit hex)                         |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rdi, msg_sci              
    movsd   xmm0, [r15 + r13 * 8]    
    call    printf                       

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Increase the loop counter and check if all array elements have been processed |
    ; └────────────────────────────────────────────────────────────────────────┘
    inc     r13                       
    cmp     r13, r14                  
    jge     exit             
    jmp     begin                      

exit:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Restore registers before returning from the function                  |
    ; └────────────────────────────────────────────────────────────────────────┘
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
