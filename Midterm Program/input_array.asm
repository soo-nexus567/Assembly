global input_array
extern scanf
extern printf
extern atoi

segment .data
    format_string db "%s", 0
    prompt_tryagain db "That ain't no integer, try again", 10, 0
    invalid_input_msg db "Invalid input, please enter a valid integer.", 10, 0

segment .bss
    align 64
    storedata resb 832

segment .text
input_array:
    ; Back up GPRs
    push    rbp
    mov     rbp, rsp
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

    ; Save all the floating-point numbers
    mov     rax, 7
    mov     rdx, 0
    xsave   [storedata]

    mov     r13, rdi    ; r13 contains the array
    mov     r14, rsi    ; r14 contains the max size
    mov     r15, 0      ; r15 is the index of the loop
    sub     rsp, 1024   ; Create a 1024 bits temporary space on the stack

begin:
    ; Get user input (scan a string)
    mov     rax, 0
    mov     rdi, format_string
    mov     rsi, rsp            ; Store user input on the stack
    call    scanf

    ; Check if the input is a Ctrl-D (EOF), which means no more input
    cdqe
    cmp     rax, -1
    je      exit                ; Exit if EOF is detected

    ; Validate input with isinteger function
    mov     rdi, rsp            ; rdi = pointer to input string
    call    isinteger           ; Call isinteger to validate the input

    ; If isinteger returns 0, it's an invalid input
    test    eax, eax            ; Check if eax is 0 (invalid input)
    jz      invalid_input       ; Jump to invalid_input if eax is 0

    ; Convert string to integer using atoi
    mov     rdi, rsp            ; rdi = pointer to input string
    call    atoi                ; Call atoi to convert string to integer
    
    ; Store the result in the array
    mov     [r13 + r15 * 4], eax ; Store integer in the array (4 bytes per integer)

    ; Increase r15 (array index), repeat the loop if r15 is less than the max size
    inc     r15
    cmp     r15, r14
    jl      begin

    ; Jump to exit if array is full
    jmp     exit      

invalid_input:
    ; Print the invalid input message
    mov     rdi, invalid_input_msg
    call    printf
    jmp     begin               ; Prompt the user again

exit:
    ; Clean up stack space used for temporary data
    add     rsp, 1024

    ; Restore all the registers
    mov     rax, r15          ; Return the number of integers read

    ; Restore original values of the GPRs
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
    pop     rbp

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



global isinteger

segment .data
   ; This segment is empty, as the data is handled through the function

segment .bss
   ; This segment is empty, as the data is handled through the function

segment .text
isinteger:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rdi
    push    rsi

    mov     r13, rdi         ; r13 = pointer to input string
    xor     r14, r14         ; r14 = index (set to 0)

    movzx   rbx, byte [r13]  ; Load first character
    test    rbx, rbx         ; Check if empty string (null byte at start)
    jz      not_integer

    ; Check for optional '+' or '-' sign
    cmp     bl, '+'         
    je      check_first_digit
    cmp     bl, '-'
    je      check_first_digit

digit_loop:
    movzx   rbx, byte [r13 + r14]  ; Load current character
    test    rbx, rbx               ; Check if null terminator (end of string)
    jz      valid_integer

    cmp     bl, '0'                ; Check if character is below '0'
    jl      not_integer
    cmp     bl, '9'                ; Check if character is above '9'
    jg      not_integer

    inc     r14                    ; Move to next character
    jmp     digit_loop             ; Repeat for next character

check_first_digit:
    inc     r14                    ; Move past '+' or '-' sign
    movzx   rbx, byte [r13 + r14]  ; Load next character
    test    rbx, rbx               ; Check if string is empty after sign
    jz      not_integer
    jmp     digit_loop             ; Continue checking digits

valid_integer:
    mov     rax, 1                 ; Return 1 (valid integer)
    jmp     end_function

not_integer:
    xor     rax, rax               ; Return 0 (not an integer)

end_function:
    pop     rsi
    pop     rdi
    pop     rbx
    pop     rbp
    ret








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