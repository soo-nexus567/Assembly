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
;   File name: edison.asm
;   Language: x86-64
;   Assemble: nasm -f elf64 -o edison.o edison.asm
;   Editor: VS Code
;   Link: ld  -o learn.out faraday.o edison.o tesla.o ftoa.o -g -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

global edison
    extern printf
    extern tesla
    extern ftoa
Stdin                equ 0
Stdout               equ 1
Stderror             equ 2

system_read          equ 0
system_write         equ 1
system_terminate     equ 60

Null                 equ 0
Exit_with_success    equ 0
Line_feed            equ 10
Numeric_string_array_size equ 32
array_size equ 12
section .data
    prompt_name db "Please enter your full name: ", 0
    prompt_proffession db "Please enter the career path you are following: ", 0
    prompt_resistance db "Your circuit has 3 sub-circuits.", 10, "Please enter the resistance in ohms on each of the three sub-circuits separated by ws.", 10, 0
    float_fmt db "Float: %f", 0   ; Format string for floats
    thank_you db "Thank you.", 10, 0
    total_resistance db "The total resistance of the full circuit is computed to be ", 0
    ohms db " ohms.", 10, 0
    emf_constant db "EMF is constant on every branch of any circuit.", 10, 0
    prompt_emf db "Please enter the EMF of this circuit in volts: ", 0
    current_flowing db "The current flowing in this circuit has been computed: ", 0
    amps db " amps.", 10, 10, 0
    thank_you_no_newline db "Thank you ", 0
    using db " for using the program Electriciy.", 10, 0
    bad_resistance db "Invalid input. Resistance must be greater than 0.0. Try again.", 10, 0
    negative db "Negative values are not allowed. Please enter a valid positive value.", 10, 0 
    thank_you_career db "Thank you. We appreciate all ", 0
    s db "s", 10, 10, 0
    period db ".", 10, 0
    newline db 10, 0
    ;  prompt db "Enter a float: ", 0 
    result db 100
    side_a dq 0.0
    side_b dq 0.0
    side_c dq 0.0 ; Format string for printf ("Value: <value>\n") 
    zero   dq 0.0 
    emf dq 0.0
    ten dq 10.0
    fmt db "%s", 10, 0
    test_float dq 1.23456
    total_reistance dq 0.0
    total_reistance_float dq 0.0
    precision6  dq 1000000.0 
    precision8 dq  100000000.0
section .bss
    name resb 50
    proffession resb 50
    floatstr resb 832
    current resb 50
    output_string        resb Numeric_string_array_size
    side_af resq 1
    input_float_string resq 1
    

segment .text
    global edison
    %include "acdc.inc" 
edison:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Prompt user to enter full name                       │
    ; └──────────────────────────────────────────────────────┘
    mov        rdi, prompt_name
    mov        rsi, 0
    showstring
    read_string name

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Prompt user to enter career path                     │
    ; └──────────────────────────────────────────────────────┘
    mov        rdi, prompt_proffession
    mov        rsi, 0
    showstring
    read_string proffession
    ; ┌──────────────────────────────────────────────────────┐
    ; │Say we love all people in that profession             │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, thank_you_career
    mov rsi, 0
    showstring
    ; ┌──────────────────────────────────────────────────────┐
    ; │Call lowercase on the proffession and print that      │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, proffession
    call to_lowercase
    mov rdi, proffession
    mov rsi, 0
    showstring
    ; ┌──────────────────────────────────────────────────────┐
    ; │Make it plural                                        │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, s
    mov rsi, 0
    showstring

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Prompt for resistances of three sub-circuits         │
    ; └──────────────────────────────────────────────────────┘
    mov        rdi, prompt_resistance
    mov        rsi, 0
    showstring

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Validate and read resistance for side_a              │
    ; └──────────────────────────────────────────────────────┘
    .get_side_a:
    read_float side_a
    movsd xmm1, [side_a]
    pxor xmm0, xmm0
    ucomisd xmm1, xmm0
    jl .side_a_negative
    jle .side_a_invalid
    jmp .side_a_valid

    .side_a_negative:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Show error if side_a is negative                     │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, negative
    mov rsi, 0
    showstring
    jmp .get_side_a

    .side_a_invalid:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Show error if side_a is zero or invalid              │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, bad_resistance
    mov rsi, 0
    showstring
    jmp .get_side_a

    .side_a_valid:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Valid side_a input, continue                         │
    ; └──────────────────────────────────────────────────────┘

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Validate and read resistance for side_b              │
    ; └──────────────────────────────────────────────────────┘
    .get_side_b:
    read_float side_b
    movsd xmm1, [side_b]
    pxor xmm0, xmm0
    ucomisd xmm1, xmm0
    jl .side_b_negative
    jle .side_b_invalid
    jmp .side_b_valid

    .side_b_negative:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Show error if side_b is negative                     │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, negative
    mov rsi, 0
    showstring
    jmp .get_side_b

    .side_b_invalid:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Show error if side_b is zero or invalid              │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, bad_resistance
    mov rsi, 0
    showstring
    jmp .get_side_b

    .side_b_valid:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Valid side_b input, continue                         │
    ; └──────────────────────────────────────────────────────┘

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Validate and read resistance for side_c              │
    ; └──────────────────────────────────────────────────────┘
    .get_side_c:
    read_float side_c
    movsd xmm1, [side_c]
    pxor xmm0, xmm0
    ucomisd xmm1, xmm0
    jl .side_c_negative
    jle .side_c_invalid
    jmp .side_c_valid

    .side_c_negative:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Show error if side_c is negative                     │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, negative
    mov rsi, 0
    showstring
    jmp .get_side_c

    .side_c_invalid:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Show error if side_c is zero or invalid              │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, bad_resistance
    mov rsi, 0
    showstring
    jmp .get_side_c

    .side_c_valid:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ All resistances validated, thank the user            │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, thank_you
    mov rsi, 0
    showstring

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Compute total resistance using tesla                 │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, side_a
    mov rsi, side_b
    mov rdx, side_c
    call tesla

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Store and convert total resistance to ASCII string   │
    ; └──────────────────────────────────────────────────────┘
    movsd [total_reistance_float], xmm0
    movsd [total_reistance], xmm0
    movsd xmm0, qword [total_reistance]
    lea rdi, [floatstr]
    movsd xmm1, [precision6]
    call ftoa

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Display total resistance to user                     │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, total_resistance
    mov rsi, 0
    showstring
    mov rdi, floatstr
    mov rsi, 0
    showstring
    mov rdi, ohms
    mov rsi, 0
    showstring
    mov rdi, newline
    mov rsi, 0
    showstring

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Show EMF statement and prompt user for EMF           │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, emf_constant
    mov rsi, 0
    showstring
    mov rdi, prompt_emf
    mov rsi, 0
    showstring
    read_float emf

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Display thank you message                            │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, thank_you
    mov rsi, 0
    showstring
    mov rdi, newline
    mov rsi, 0
    showstring

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Calculate current using Ohm’s Law: I = V / R         │
    ; └──────────────────────────────────────────────────────┘
    movsd xmm8, [total_reistance_float]
    movsd xmm9, [emf]
    divsd xmm9, xmm8
    movsd xmm0, xmm9
    lea rdi, [current]
    movsd xmm1, [precision6]
    call ftoa

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Display calculated current                           │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, current_flowing
    mov rsi, 0
    showstring
    mov rdi, current
    mov rsi, 0
    showstring
    mov rdi, amps
    mov rsi, 0
    showstring

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Final personalized thank-you message                 │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, thank_you_no_newline
    mov rsi, 0
    showstring
    mov rdi, name
    mov rsi, 0
    showstring
    mov rdi, using
    mov rsi, 0
    showstring

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Return the final current value in xmm0               │
    ; └──────────────────────────────────────────────────────┘
    movsd xmm0, [current]

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Return from edison                                   │
    ; └──────────────────────────────────────────────────────┘
    ret
; Function to convert string to lowercase
to_lowercase:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Load address of the profession string                │
    ; └──────────────────────────────────────────────────────┘
    mov rdi, proffession  ; Load address of the string into rdi

lower_loop:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Load the current character from the string           │
    ; └──────────────────────────────────────────────────────┘
    mov al, byte [rdi]     
    
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Check if the current character is the null terminator│
    ; │ (end of string)                                      │
    ; └──────────────────────────────────────────────────────┘
    cmp al, 0              
    jz lower_done        

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Check if the character is an uppercase letter (A-Z) │
    ; └──────────────────────────────────────────────────────┘
    cmp al, 'A'       
    jl skip_lower         
    cmp al, 'Z'            
    jg skip_lower          

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Convert the uppercase letter to lowercase by adding  │
    ; │ 32                                                   │
    ; └──────────────────────────────────────────────────────┘
    add al, 32        

    ; ┌──────────────────────────────────────────────────────┐
    ; │ Store the lowercase character back into the string   │
    ; └──────────────────────────────────────────────────────┘
    mov byte [rdi], al    

skip_lower:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ Move to the next character in the string             │
    ; └──────────────────────────────────────────────────────┘
    inc rdi    
    jmp lower_loop      

lower_done:
    ; ┌──────────────────────────────────────────────────────┐
    ; │ End of function, return control to the caller        │
    ; └──────────────────────────────────────────────────────┘
    ret     
