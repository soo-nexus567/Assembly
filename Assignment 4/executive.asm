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
;   File name: fill_random_array.asm
;   Language: x86-64
;   Assemble: nasm -f elf64 -o fill_random_array.o fill_random_array.asm
;   Editor: VS Code
;   Link: gcc -m64 -no-pie -o learn.out fill_random_array.o normalize_array.o show_array.o executive.o main.o sort.o isnan.o -std=c2x -Wall -z noexecstack -lm
global executive
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern stdin
    extern fill_random_array
    extern show_array
    extern atoi
    extern sort_array
    extern normalize_array
segment .data
    prompt_name db "Please enter your name: ", 0
    prompt_title db "Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc): ", 0
    prompt_float db "This program will generate 64-bit IEEE float numbers.", 10, "How many numbers do you want. Today’s limit is 100 per customer ", 0
    prompt_stored db "Your numbers have been stored in an array. Here is that array.", 10, 10, 0
    normalize_prompt db "The array will now be normalized to the range 1.0 to 2.0  Here is the normalized array", 10,10,  0
    sort_prompt db "The array will now be sorted", 10, 10, 0
    greeting db "Nice to meet you %s %s", 10,10, 0
    one_string db "%s", 0
    one_integer db "%d", 0
    error_msg db "Invalid input, please enter a valid integer: ", 10, 0
    out_of_range_msg db "Input must be between 0 and 100. Try Again: ", 0
    goodbye db "Good bye %s. You are welcome any time.", 10, 10, 0
    new_line db 10
array_size equ 100
segment .bss
    align 64
    name resb 50
    title resb 50
    size_array resb 1
    storedata resb 50
    nice_array resq 100
segment .text
    global executive
executive:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Save the base pointer                                                 |
    ; └────────────────────────────────────────────────────────────────────────┘
    push    rbp
    mov     rbp, rsp

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Save the general-purpose registers (GPRs) to preserve their values     |
    ; └────────────────────────────────────────────────────────────────────────┘
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
    ; | Prompt the user for their last name                                    |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, prompt_name
    call    printf

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Get user input for last name and store it in a variable               |
    ; └────────────────────────────────────────────────────────────────────────┘
    sub     rsp, 16
    mov     rdi, one_string
    mov     rsi, rsp
    call    scanf
    movsd   xmm7, [rsp]
    movsd   [name], xmm7
    add     rsp, 16

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Prompt the user for their title                                         |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, prompt_title
    call    printf

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Get user input for title and store it in a variable                   |
    ; └────────────────────────────────────────────────────────────────────────┘
    sub     rsp, 16
    mov     rdi, one_string
    mov     rsi, rsp
    call    scanf
    movsd   xmm8, [rsp]
    movsd   [title], xmm8
    add     rsp, 16
    
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Print greeting message using title and name                           |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 2
    mov     rdi, greeting
    mov     rsi, title
    mov     rdx, name
    call    printf

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Prompt the user to enter a floating-point number                       |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, prompt_float
    call    printf

validate_input:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Subtract space for input storage and prompt the user for input        |
    ; └────────────────────────────────────────────────────────────────────────┘
    sub     rsp, 32            
    mov     rdi, one_string 
    mov     rsi, rsp 
    call    scanf                                                      
    movsd   xmm9, [rsp]
    movsd   [size_array], xmm9                                                

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Convert input to integer and validate its range (0-100)               |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rdi, rsp          
    call    atoi                    
    mov     [size_array], rax    
    cmp     rax, 0              
    jl      out_of_range       
    cmp     rax, 100                
    jg      out_of_range 
    add     rsp, 32     
    jmp     input_valid      

not_an_integer:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Print error message if input is invalid (not an integer)              |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, error_msg
    call    printf      
    add     rsp, 32           
    jmp     validate_input

out_of_range:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Print error message if input is out of range (not between 0 and 100)  |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, out_of_range_msg 
    call    printf
    add     rsp, 32
    jmp     validate_input 

input_valid:
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Proceed with the rest of the program once input is valid              |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rdi, prompt_stored
    call    printf
    mov     rdi, nice_array
    mov     rsi, [size_array]
    call    fill_random_array
    mov     r15, rax

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Show the generated array after filling it with random numbers         |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rdi, nice_array
    mov     rsi, r15
    call    show_array
    
    mov     rdi, new_line
    call    printf
    
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Prompt user to normalize the array values                             |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, normalize_prompt
    call    printf

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Normalize the array and print the result                              |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rdi, nice_array
    mov     rsi, r15
    call    normalize_array

    mov     rdi, nice_array
    mov     rsi, r15
    call    show_array

    mov     rdi, new_line
    call    printf

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Prompt user to sort the array                                         |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, sort_prompt
    call    printf
    
    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Sort the array and display the result                                 |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rdi, nice_array
    mov     rsi, r15
    call    sort_array

    mov     rdi, nice_array
    mov     rsi, r15
    call    show_array

    mov     rdi, new_line
    call    printf

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Print a goodbye message using the user's title                       |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, 1
    mov     rdi, goodbye
    mov     rsi, title
    call    printf

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Clean up and restore registers, then return from the function         |
    ; └────────────────────────────────────────────────────────────────────────┘
    mov     rax, name
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

    ; ┌────────────────────────────────────────────────────────────────────────┐
    ; | Restore the base pointer and return to the caller                     |
    ; └────────────────────────────────────────────────────────────────────────┘
    pop     rbp
    ret
