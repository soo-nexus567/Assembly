;======================================================================|  
; Copyright Info                                                       |  
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
; File Name  : manager.asm                                             |  
; Language   : x86-64                                                  |  
; Assemble   : nasm -f elf64 -o manager.o manager.asm                  |  
; Editor     : VS Code                                                 |  
; Link       : gcc -m64 -no-pie -o learn.out manager.o huron.o         | 
;              istriangle.o triangle.o -std=c2x -Wall -z noexecstack -lm 
;======================================================================|  
global _start
_start:
global manager

    extern scanf
    extern printf
    extern atof
    extern huron
    extern istriangle
    extern stdin
    extern fgets
    extern strlen
array_size equ 12
null equ 0
true equ -1
false equ 0

segment .data
    greetings db "Happy Anniversary", 10, 0
    valid_input db "These inputs have been tested and they are sides of a valid triangle.", 10, 10,  0
    huron_applied db "The Huron formula will be applied to find the area.", 10, 10, 0
    huron_area db "The area is %.2f sq units. This number will be returned to the caller module.", 10, 10, 0
    format_string db "%s", 0
    format_string1 db "%f", 0
    prompt_tryagain db "Error input try again", 10, 0
    three_inputs db "These inputs have been tested and they are not the sides of a valid triangle.", 10,10, 0
    invalid db "These inputs have been tested and they are not the sides of a valid triangle.", 10,10, 0
    thank_you db "Thank you", 10,10,  0
    results dq 0.0
    negative_one dq -1.0
segment .bss
    align 64
    storedata resb 832
    nice_array resq array_size
    side_a resq 1
    side_b resq 1
    side_c resq 1
    area resq 1
    extra_buffer resq 10  ; Reserve space for 10 extra floats (can be adjusted as needed)
    buffer_index resq 1   ; Store the current position in the buffer
segment .text
    global manager
    %include "triangle.inc"
manager:
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Back up General Purpose Registers (GPRs)               │
    ; └────────────────────────────────────────────────────────┘
    back_register

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Save all the floating-point numbers and print info     │
    ; └────────────────────────────────────────────────────────┘
    backup_compnents storedata
    print_info

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Prompt the input instruction                           │
    ; └────────────────────────────────────────────────────────┘
    
    mov     rax, 0
    mov     rdi, greetings
    call    printf

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Give the inputs to input_array where they are stored   │
    ; │ in an array (nice_array)                               │
    ; └────────────────────────────────────────────────────────┘
    mov     rdi, nice_array
    mov     rsi, array_size
    call    input_array
    mov     r15, rax

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Check if there are 3 inputs                            │
    ; │ If not, exit and prompt user to re-run the program     │
    ; └────────────────────────────────────────────────────────┘
    cmp     r15, 3
    jg      no_triangle
    
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Store the elements of the array in separate variables  │
    ; └────────────────────────────────────────────────────────┘
    movsd   xmm15, [nice_array]  
    movsd   [side_a], xmm15   

    movsd   xmm14, [nice_array+8]  
    movsd   [side_b], xmm14   

    movsd   xmm13, [nice_array+16]  
    movsd   [side_c], xmm13   

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Print thank you message                                │
    ; └────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, thank_you
    call    printf
    
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Validate the sides given using istriangle              │
    ; └────────────────────────────────────────────────────────┘
    mov     rdi, side_a
    mov     rsi, side_b
    mov     rdx, side_c
    call    istriangle

    ; ┌────────────────────────────────────────────────────────┐
    ; │ If istriangle returns -1, exit the program             │
    ; └────────────────────────────────────────────────────────┘
    cmp     rax, -1
    je      no_triangle
    
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Print valid input message                              │
    ; └────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, valid_input
    call    printf

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Notify user that Heron's formula will be applied       │
    ; └────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, huron_applied
    call    printf

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Give validated inputs to huron to calculate area       │
    ; └────────────────────────────────────────────────────────┘
    mov     rdi, side_a
    mov     rsi, side_b
    mov     rdx, side_c
    call    huron
    movsd   [area], xmm0

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Print the calculated area from huron function          │
    ; └────────────────────────────────────────────────────────┘
    mov     rdi, huron_area  
    mov     rsi, area 
    mov     rax, 1                   
    call    printf 

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Restore floating-point numbers                         │
    ; └────────────────────────────────────────────────────────┘
    restore_components storedata
    mov     rax, r15
    movsd   xmm0, [area]

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Restore GPRs and return                                │
    ; └────────────────────────────────────────────────────────┘
    restore_registers
    mov rax, 60         ; syscall number for exit (60)
    xor rdi, rdi        ; exit status 0
    syscall
    ret

; ┌────────────────────────────────────────────────────────┐
; │ More than three inputs handler                         │
; └────────────────────────────────────────────────────────┘
more_than_three:
    mov     rax, 0
    mov     rdi, three_inputs
    call    printf
    jmp     end_loop

; ┌────────────────────────────────────────────────────────┐
; │ Input handling function                                │
; └────────────────────────────────────────────────────────┘
input_array:
    back_register
    backup_compnents storedata

    mov     r13, rdi     ; Pointer to the array where valid floats are stored
    mov     r14, rsi     ; Number of floats expected
    mov     r15, 0       ; Counter for valid floats
    sub     rsp, 1024    ; Allocate buffer space on the stack

loop_inputs:
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Use fgets to get user input                            │
    ; └────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, rsp
    mov     rsi, 512
    mov     rdx, [stdin]
    call    fgets
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Check if user pressed Control+D                        │
    ; └────────────────────────────────────────────────────────┘
    cdqe
    cmp     rax, 0
    je      end_loop
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Get rid of newline character after every line          │
    ; └────────────────────────────────────────────────────────┘
    mov     rdi, rsp
    call    strlen
    mov     rbx, rax
    dec     rbx
    mov     byte [rdi + rbx], 0x00 
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Check if the input is a valid float                    │
    ; └────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, rsp
    call    isfloat
    cmp     rax, 0
    je      invalid_input
    ; ┌────────────────────────────────────────────────────────┐
    ; │ Convert input into a float using atof                  │
    ; └────────────────────────────────────────────────────────┘
    mov     rax, 0
    mov     rdi, rsp
    call    atof
    movsd   xmm15, xmm0   

    cmp     r15, r14
    jl      store_in_array 

    ; ┌────────────────────────────────────────────────────────┐
    ; │ Store excess floats in FIFO buffer                     │
    ; └────────────────────────────────────────────────────────┘
    mov     rdi, extra_buffer
    mov     rcx, [buffer_index] 
    movsd   [rdi + rcx * 8], xmm15
    inc     rcx
    mov     [buffer_index], rcx
    jmp     loop_inputs

store_in_array:
    movsd   [r13 + r15 * 8], xmm15
    inc     r15
    cmp     r15, r14
    jl      loop_inputs

    jmp     end_loop

invalid_input:
    mov     rax, 0
    mov     rdi, prompt_tryagain
    call    printf
    jmp     loop_inputs

end_loop:
    add     rsp, 1024
    restore_components storedata
    mov     rax, r15
    restore_registers
    ret

; ┌────────────────────────────────────────────────────────┐
; │ No valid triangle handler                             │
; └────────────────────────────────────────────────────────┘
no_triangle:
    mov     rax, 0
    mov     rdi, invalid
    call    printf
    movsd   xmm0, [negative_one]
    restore_registers
    ret
;****************************************************************************************************************************
;Program name: "isfloat".  This a library function contained in a single file.  The function receives a null-terminated     *
;array of char and either verifies that the array can be converted to a 64-bit float or denies that such a conversion is    *
;possible.  Copyright (C) 2022 Floyd Holliday.                                                                              *
;                                                                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public   *
;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be   *
;useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.*
;See the GNU Lesser General Public License for more details. A copy of the GNU General Public License v3 is available here: *
;<https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;  Author phone (wired phone in CS building): (657)278-7021
;
;Status
;  This software is not an application program, but rather it is a single function licensed for use by other applications.
;  This function can be embedded within both FOSS programs and in proprietary programs as permitted by the LGPL.

;Function information
;  Function name: isfloat
;  Programming language: X86 assembly in Intel syntax.
;  Date development began:  2022-Feb-28
;  Date version 1.0 finished: 2022-Mar-03
;  Files of this function: isfloat.asm
;  System requirements: an X86 platform with nasm installed o other compatible assembler.
;  Know issues: <now in testing phase>
;  Assembler used for testing: Nasm version 2.14.02
;  Prototype: bool isfloat(char *);
;
;Purpose
;  This function wil accept a string (array of char) and verify that it can be converted to a corresponding 64-bit 
;  float number or not converted to a float number.
;
;Translation information
;  Assemble: nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm
;
;Software design document:
;  An Execution flow chart accompanies this function.  That document will provide a better understanding of the 
;  algorithm used in the isfloat function than a direct reading of the source code of the function.

;========= Begin source code ====================================================================================
;Declaration area

global isfloat

null equ 0
true equ -1
false equ 0

segment .data
   ;This segment is empty

segment .bss
   ;This segment is empty

segment .text
isfloat:

;Block that backs up almost all GPRs
;Back up the general purpose registers for the sole purpose of protecting the data of the caller.
push rbp                                          ;Backup rbp
mov  rbp,rsp                                      ;The base pointer now points to top of stack
push rdi                                          ;Backup rdi
push rsi                                          ;Backup rsi
push rdx                                          ;Backup rdx
push rcx                                          ;Backup rcx
push r8                                           ;Backup r8
push r9                                           ;Backup r9
push r10                                          ;Backup r10
push r11                                          ;Backup r11
push r12                                          ;Backup r12
push r13                                          ;Backup r13
push r14                                          ;Backup r14
push r15                                          ;Backup r15
push rbx                                          ;Backup rbx
pushf                                             ;Backup rflags


;Make a copy of the passed in array of ascii values
mov r13, rdi                                      ;r13 is the array of char

;Let r14 be an index of the array r13.  Initialize to integer 0
xor r14, r14

;Check for leading plus or minus signs
cmp byte [r13],'+'
je increment_index
cmp byte[r13],'-'
jne continue_validation
increment_index:
inc r14

continue_validation:

;Block: loop to validate chars before the decimal point
loop_before_point:
   mov rax,0
   xor rdi,rdi                ;Zero out rdi
   mov dil,byte [r13+1*r14]   ;dil is the low byte in the register rdi; reference Jorgensen, p. 10
   call is_digit
   cmp rax,false
   je is_it_radix_point
   inc r14
   jmp loop_before_point
;End of loop checking chars before the point is encountered.

is_it_radix_point:

;Is the next value of the array a genuine radix point?
cmp byte[r13+1*r14],'.'
    jne return_false

;A point has been found, therefore, begin a loop to process remaining digits.
start_loop_after_finding_a_point:
    inc r14
    mov rax,0
    xor rdi,rdi
    mov dil,byte[r13+1*r14]
    call is_digit
    cmp rax,false
    jne start_loop_after_finding_a_point
;End of loop processing valid digits after passing the one decimal point.

;Something other than a digit has been found.  
;It should be null at the end of the string.
cmp byte [r13+1*r14],null
jne return_false
mov rax,true
jmp restore_gpr_registers
    
return_false:
mov rax,false

restore_gpr_registers:
popf                                    ;Restore rflags
pop rbx                                 ;Restore rbx
pop r15                                 ;Restore r15
pop r14                                 ;Restore r14
pop r13                                 ;Restore r13
pop r12                                 ;Restore r12
pop r11                                 ;Restore r11
pop r10                                 ;Restore r10
pop r9                                  ;Restore r9
pop r8                                  ;Restore r8
pop rcx                                 ;Restore rcx
pop rdx                                 ;Restore rdx
pop rsi                                 ;Restore rsi
pop rdi                                 ;Restore rdi
pop rbp                                 ;Restore rbp

ret                                     ;Pop the integer stack and jump to the address represented by the popped value.











;========= Begin function is_digit ==================================================================================

;****************************************************************************************************************************
;Program name: "is_digit".  This a library function contained in a single file.  The function receives a char parameter.  It*
;returns true if that parameter is the ascii value of a decimal digit and returns false in all other cases.                  *
;Copyright (C) 2022 Floyd Holliday.                                                                                         *
;                                                                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public   *
;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be   *
;useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.*
;See the GNU Lesser General Public License for more details. A copy of the GNU General Public License v3 is available here: *
;<https:;www.gnu.org/licenses/>.                                                                                            *
;****************************************************************************************************************************
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;  Author phone (wired phone in CS building): (657)278-7021
;
;Status
;  This software is not an application program, but rather it is a single function licensed for use by other applications.
;  This function can be embedded within both FOSS programs and in proprietary programs as permitted by the LGPL.

;Function information
;  Function name: is_digit
;  Name selection.  This function is named is_digit to avoid confusion with an existing library function named isdigit.
;  Programming language: X86 assembly in Intel syntax.
;  Date development began:  2022-Feb-28
;  Date version 1.0 finished: 2022-Feb 28
;  Files of this function: currently is_digit is an auxillary function of isfloat, and as such does not occupy its own file.
;  System requirements: an X86 platform with nasm installed or other compatible assembler.
;  Known issues: none
;  Assembler used for testing: Nasm version 2.14.02
;  Prototype: bool is_digit(char);
;
;Purpose
;  This function wil accept a single char as input parameter and determine if that parameter represents a decimal digit. 
;
;Translation information if this function occupied its own file.  Currently the function is_digit resides in the same 
;same file as isfloat and therefore, will be assembled when isfloat is assembled.
;  Assemble: nasm -f elf64 -l is_digit.lis -o is_digit.o is_digit.asm
;
;Software design document:
;  An Execution flow chart accompanies this function.  That document will provide a better understanding of the 
;  algorithm used in the isfloat function than a direct reading of the source code of the function.

;========= Begin source code ====================================================================================
;Declaration area
true equ -1
false equ 0
ascii_value_of_zero equ 0x30
ascii_value_of_nine equ 0x39

segment .data
   ;This segment is empty

segment .bss
   ;This segment is empty

segment .text
is_digit:

;Block that backs up almost all GPRs
;Back up the general purpose registers for the sole purpose of protecting the data of the caller.
push rbp                                          ;Backup rbp
mov  rbp,rsp                                      ;The base pointer now points to top of stack
push rdi                                          ;Backup rdi
push rsi                                          ;Backup rsi
push rdx                                          ;Backup rdx
push rcx                                          ;Backup rcx
push r8                                           ;Backup r8
push r9                                           ;Backup r9
push r10                                          ;Backup r10
push r11                                          ;Backup r11
push r12                                          ;Backup r12
push r13                                          ;Backup r13
push r14                                          ;Backup r14
push r15                                          ;Backup r15
push rbx                                          ;Backup rbx
pushf                                             ;Backup rflags

;Make a copy of the passed in array of ascii values.
;Note that only the low one-byte of rdi is important for this function is_digit.
;Nevertheless, we copy the entire 8-byte register.
mov r13,0
mov r13b,dil     ;Copy the low byte of rdi to the low byte of r13.  The other bytes of rdi are all zeros.

;Block to test if value in r13 >= ascii(0)
cmp r13,ascii_value_of_zero
jl is_digit.return_false

;Block to test if value in r13 <= ascii(9)
cmp r13,ascii_value_of_nine
jg is_digit.return_false

;Return true
xor rax,rax  ;Set rax to zero
mov rax,true
jmp is_digit.restore_gpr_registers

is_digit.return_false:
xor rax,rax  ;Set rax to zero
mov rax,false

is_digit.restore_gpr_registers:
;Restore all general purpose registers to their original values
popf                                    ;Restore rflags
pop rbx                                 ;Restore rbx
pop r15                                 ;Restore r15
pop r14                                 ;Restore r14
pop r13                                 ;Restore r13
pop r12                                 ;Restore r12
pop r11                                 ;Restore r11
pop r10                                 ;Restore r10
pop r9                                  ;Restore r9
pop r8                                  ;Restore r8
pop rcx                                 ;Restore rcx
pop rdx                                 ;Restore rdx
pop rsi                                 ;Restore rsi
pop rdi                                 ;Restore rdi
pop rbp                                 ;Restore rbp

ret                                     ;Pop the integer stack and jump to the address represented by the popped value.