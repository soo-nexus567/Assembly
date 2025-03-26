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
; File Name  : electricy.asm                                           |  
; Language   : x86-64 with Linux Synatax                               |  
; Assemble   : nasm -f elf64 -o electricy.o electricy.asm              |   
; Editor     : VS Code                                                 |  
; Link       : gcc -m64 -no-pie -o learn.out current.o electricy.o     |     
;              main.o -std=c2x -Wall -z noexecstack -lm                |
;                                                                      |
;======================================================================|  
global electricy
    extern printf
    extern input_array
    extern output_array
    extern sum
    extern sort_array
    extern fgets
    extern strlen
    extern scanf
    extern stdin
    extern atof
    extern hsum
    extern current
segment .data
    welcome db "Welcome to West Beach Electric Company.", 10, 0
    maintained db "This software is maintained by Jonathan Soo.", 10, 0
    electric_force db "Please enter the electric force in the circuit (volts): ", 0
    resistance_1 db "Please enter the resistance in circuit number 1 (ohms): ", 0
    resistance_2 db "Please enter the resistance in circuit number 2 (ohms): ", 0
    resistance_3 db "Please enter the resistance in circuit number 3 (ohms): ", 0
    current_1 db "The current on circuit #1 is %.5f amps.", 10, 0
    current_2 db "The current on circuit #2 is %.5f amps.", 10, 0
    current_3 db "The current on circuit #3 is %.5f amps.", 10, 0
    total_current db "The total current is %.5f amps", 10, 0
    thank_you db "Thank you", 10, 0
    one_float db "%lf", 0
    new_line dq 10
    l1 dq 0.0
    l2 dq 0.0
    l3 dq 0.0
    results dq 0.0
segment .bss
    r1 resq 1
    r2 resq 1
    r3 resq 1
    ef resq 1

segment .text
    global electricy
electricy:
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

 
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Saying welcome to the user                                             |
    ; └────────────────────────────────────────────────────────────────────────┘
       mov rax, 0
    mov rdi, welcome
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Saying who maintained the program                                      |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rax, 0
    mov rdi, maintained
    call printf 
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Prompt for user input for electronic force                             |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rax, 0
    mov rdi, electric_force
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Getting user input and storing that in ef                              |
    ; └────────────────────────────────────────────────────────────────────────┘
    sub     rsp, 16
    mov     rdi, one_float
    mov     rsi, rsp
    call    scanf
    movsd   xmm7, [rsp]
    movsd   [ef], xmm7
    add     rsp, 16
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Prompt for user input for resistance                                   |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rax, 0
    mov rdi, resistance_1
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Getting user input and storing that in r1                              |
    ; └────────────────────────────────────────────────────────────────────────┘
    sub rsp, 16
    mov rdi, one_float
    mov rsi, rsp
    call scanf
    movsd xmm7, [rsp]
    movsd [r1], xmm7
    add rsp, 16
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Prompt for user input for resistance                                   |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rax, 0
    mov rdi, resistance_2
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Getting user input and storing that in r2                              |
    ; └────────────────────────────────────────────────────────────────────────┘
    sub     rsp, 16
    mov     rdi, one_float
    mov     rsi, rsp
    call    scanf
    movsd   xmm9, [rsp]
    movsd   [r2], xmm9
    add     rsp, 16
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Prompt for user input for resistance                                   |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rax, 0
    mov rdi, resistance_3
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Getting user input and storing that in r3                              |
    ; └────────────────────────────────────────────────────────────────────────┘
    sub     rsp, 16
    mov     rdi, one_float
    mov     rsi, rsp
    add     rdx, 8
    call    scanf
    movsd   xmm10, qword [rsp]
    movsd [r3], xmm10
    add  rsp, 16
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Print the thank you to the user                                        |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rax, 0
    mov rdi, thank_you
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Calculating current                                                    |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd   xmm11, [ef]
    movsd   xmm12, [r1]
    divsd   xmm11, xmm12
    movsd   [l1], xmm11
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Calculating current                                                    |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd   xmm13, [ef]
    movsd   xmm14, [r2]
    divsd   xmm13, xmm14
    movsd   [l2], xmm13
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Calculating current                                                    |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd   xmm10, [ef]
    movsd   xmm11, [r3]
    divsd   xmm10, xmm11
    movsd   [l3], xmm10
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Output the current 1 by the 5th decimal place                           |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rax, 1
    mov rdi, current_1
    movsd   xmm0, [l1]
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Output the current 2 by the 5th decimal place                           |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rax, 1
    mov rdi, current_2
    movsd   xmm0, [l2] 
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Output the current 3 by the 5th decimal place                           |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rax, 1
    mov rdi, current_3
    movsd   xmm0, [l3]
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Pssing the 3 current values and passing it to current to get the total |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov rdi, l1
    mov rsi, l2
    mov rdx, l3
    call current 
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Print the total current                                                |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd [results], xmm0
    mov rax, 1
    mov rdi, total_current
    movsd xmm0, [results]
    call printf
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Return value                                                           |
    ; └────────────────────────────────────────────────────────────────────────┘
    movsd xmm0, [results]

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