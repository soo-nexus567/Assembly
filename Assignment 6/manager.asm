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
global manager
    extern scanf
    extern printf
    extern atof
    extern stdin
    extern fgets
    extern strlen
    extern gettime
    extern atof
array_size equ 15
null equ 0
true equ -1
false equ 0
segment .data
    time db "The present time on the clock is %ld tics", 10, 10,  0
    prompt db "Enter float numbers positive or negative separated by ws. Terminate with control+d", 10, 0
    prompt_tryagain db "Error input try again", 10, 0
    invalid db "These inputs have been tested and they are not the sides of a valid triangle.", 10,10, 0
    sum_prompt db "The sum of these numbers is %.2f", 0
    finalclock db 10, "The total time to perform the additions in the ALU was %ld tics.", 10, 0
    average_tick db "That is an average of %lf tics per each addition.", 10, 0
    elapsedTics db "The elapsed time was tics, which equals %.1f ns.", 10, 10, 0
    cpu_freq_prompt db "CPU %lf ghz", 10, 0
    msg_number db "%d ", 0      ; Format string for printing integers
    newline db 10, 0   
    negative_one dq -1.0
    timespec:
    dq 0          ; seconds
    dq 100000000          ; nanoseconds
    ghz_msg db "CPU clock speed is approximately: %.2f GHz", 10, 0
    one_thousand: dq 10.0

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
    total resq 1
    difference resq 1
    average_ticks resq 1
    cpufreq resq 1
segment .text
    global manager
    %include "triangle.inc"
manager:
    back_register
    mov     rax, 7
    mov     rdx, 0
    xsave   [storedata]
    mov rax, 0
    call gettime                    ; Call gettime function to get current cpu tics.
    mov r14, rax

    mov rax, 0
    mov rdi, time
    mov rsi, r14
    call printf

    mov rax, 0
    mov rdi, prompt
    call printf

 ; Get user input
    mov     rdi, nice_array
    mov     rsi, array_size
    call    input_array
    mov     r15, rax                  ; r15 = array length
    ; Start time    
    call gettime
    mov     r14, rax                  ; r14 = start time

    ; Run the sum
    mov     rdi, nice_array
    mov     rsi, r15
    call    total_array
    movsd   [total], xmm0            ; Save harmonic sum
     mov rax, 1
    movsd   xmm0, [total]
    mov     rdi, sum_prompt
    mov     rsi, total
    call    printf
    
    call gettime    
    mov     r13, rax                  ; r13 = end time

     ; Calculate elapsed ticks
    mov     rax, r13
    sub     rax, r14
    mov     [difference], rax

    mov     rsi, [difference]
    mov     rdi, finalclock
    mov     rax, 0
    call    printf
    ; End time

    ; Compute average ticks per addition
    xor     rdx, rdx
    mov     rcx, r15                 ; rcx = array length
    div     rcx                      ; rax = total ticks / array length
    mov     [average_ticks], rax

    ; Convert to float
    cvtsi2sd xmm0, rax
    movsd xmm10, xmm0

    ; Print average
    mov     rdi, average_tick
    mov     eax, 1                   ; xmm0 used
    call    printf
   
    call clock_speed          ; xmm0 now holds CPU frequency, like 2.70
    movsd xmm11, xmm0         ; save it
    cvtsi2sd xmm10, rax          ; Convert ticks to float
    movsd   xmm1, qword [one_thousand]  ; xmm1 = 1000.0
    divsd   xmm1, xmm11                  ; xmm1 = 1000 / frequency
    movsd xmm0, xmm1
    mov rdi, elapsedTics            ; "The elapsed time was %ld tics, which equals %lf seconds."                ; Pass Final clock time minus Initial clock time.
    mov     eax, 1                ; using 1 vector register
    call    printf              ; Pass total seconds elapsed to calculate Harmonic Sum.     
    
    mov     rax, 7
    mov     rdx, 0
    xrstor  [storedata]
    restore_registers
    ret
output_array:
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

    mov r15, rdi                   ; r15 contains the array (pointer to the array)
    mov r14, rsi                   ; r14 contains the array size (number of elements)
    mov r13, 0                     ; r13 is the counter/index for the array
    xor rcx, rcx                   ; Clear rcx (not needed anymore)

begin3:
    cmp     r13, r14                ; Check if counter >= array size
    jge     exit                    ; If yes, exit loop

    mov     rax, [r15 + r13 * 4]    ; Load the integer (4 bytes) from the array (assuming integers are 4 bytes)
    mov     rdi, msg_number         ; Load format string for integers
    mov     rsi, rax                ; Set the integer to be printed in rsi
    mov     rax, 1                  ; Indicate one argument for printf
    call    printf                  ; Print the integer

    inc     r13                     ; Increment the counter
    jmp     begin                    ; Repeat the loop

exit3:
    mov rdi, newline                ; Print newline at the end
    call printf

    ; Restore the registers
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

    ret
input_array:
    ; Backup all general-purpose and floating-point registers
    back_register
    mov     rax, 7
    mov     rdx, 0
    xsave   [storedata]

    mov     r13, rdi        ; r13 = pointer to destination float array
    mov     r14, rsi        ; r14 = number of expected floats
    xor     r15, r15        ; r15 = valid input counter
    sub     rsp, 1024       ; temporary buffer on stack (512 bytes per line input)

.loop_inputs:
    ; Get input string with fgets
    mov     rax, 0
    mov     rdi, rsp        ; buffer
    mov     rsi, 512        ; size
    mov     rdx, [stdin]    ; stdin FILE pointer
    call    fgets

    test    rax, rax        ; check for EOF
    je      .end_loop

    ; Strip newline character
    mov     rdi, rsp
    call    strlen
    mov     rbx, rax
    dec     rbx
    mov     byte [rdi + rbx], 0

    ; Check if input is a valid float
    mov     rdi, rsp
    call    isfloat
    test    rax, rax
    je      .invalid_input

    ; Convert string to float
    mov     rdi, rsp
    call    atof
    movsd   xmm15, xmm0

    ; Store in array or FIFO
    cmp     r15, r14
    jl      .store_in_array

    ; FIFO buffer for extra values
    mov     rdi, extra_buffer
    mov     rcx, [buffer_index]
    movsd   [rdi + rcx * 8], xmm15
    inc     rcx
    mov     [buffer_index], rcx
    jmp     .loop_inputs

.store_in_array:
    movsd   [r13 + r15 * 8], xmm15
    inc     r15
    cmp     r15, r14
    jl      .loop_inputs
    jmp     .end_loop

.invalid_input:
    mov     rdi, prompt_tryagain
    call    printf
    jmp     .loop_inputs

.end_loop:
    add     rsp, 1024

    ; Restore floating-point registers
    mov     rax, 7
    mov     rdx, 0
    xrstor  [storedata]

    ; Return count of valid inputs
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


; Program name: "Program Name". A short description of the purpose of the program
; Copyright (C) <2023>  <Your Name>

; This file is part of the software program "Program Name".

; "Program Name" is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; "Program Name" is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>. 

; Author information
;   Author name : Code Goblin
;   Author email: instalock_caitlyn@bronze2.botlane
;   Author section: 240-99
;   Author CWID : 000000000

; For research purpose only. Please don't copy word for word. Avoid academic dishonesty. 


segment .data
    debug db "debug = %lf",10,0
    one_point_o dq 1.0              ; Define an array of qword, with the first cell storing 1.0

segment .text
total_array:
   ;15 pushes
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
    mov r15, rdi
    mov r14, rsi
    mov r13, 0
    pxor xmm0, xmm0
begin:
    cmp     r13, r14             ; Check if counter >= array size
    jge     exit
    
    movsd xmm1, [r15+r13 * 8]
    addsd xmm0, xmm1
    inc     r13                  ; Increment loop counter
    jmp     begin                ; Loop

exit:
    ; Set the accumulator as the return before returning
    ;15 pop
    movsd xmm0, xmm0
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

    ret
;Program Name        : Clock Speed
;Programming Language: x86 Assembly
;Program Description : This file contains the function clock_speed, which 
;                      parses information from cpuid to obtain the base clock speed
;                      of the users processor and returns it as a float in xmm0
;
;Author              : Aaron Lieberman
;Email               : AaronLieberman@csu.fullerton.edu
;Institution         : California State University, Fullerton
;
;Copyright (C) 2020 Aaron Lieberman
;This program is free software: you can redistribute
;it and/or modify it under the terms of the GNU General Public License
;version 3 as published by the Free Software Foundation. This program is
;distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
;without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A
;PARTICULAR PURPOSE. See the GNU General Public License for more details.
;A copy of the GNU General Public License v3 is available here:
;<https://www.gnu.org/licenses/>.



clock_speed:
    ; Save registers
    push rbp
    mov rbp, rsp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    ; ┌─────────────────────────────────────┐
    ; │ Read timestamp counter before sleep │
    ; └─────────────────────────────────────┘
    rdtsc
    shl rdx, 32
    or rax, rdx
    mov r8, rax       ; r8 = TSC start

    ; ┌────────────────────────────┐
    ; │ Sleep for 1 second         │
    ; └────────────────────────────┘
    lea rdi, [rel timespec]
    xor rsi, rsi
    call nanosleep_inline

    ; ┌────────────────────────────────────┐
    ; │ Read timestamp counter after sleep │
    ; └────────────────────────────────────┘
    rdtsc
    shl rdx, 32
    or rax, rdx
    mov r9, rax       ; r9 = TSC end

    ; ┌─────────────────────────────────────┐
    ; │ Subtract to get cycles in 1 second │
    ; └─────────────────────────────────────┘
    sub r9, r8        ; r9 = cycles in 1 sec

    ; ┌────────────────────────────────────┐
    ; │ Convert to double (GHz) and print  │
    ; └────────────────────────────────────┘
    cvtsi2sd xmm0, r9         ; Convert to double
    mov rax, 1000000000       ; 1e9
    cvtsi2sd xmm1, rax
    divsd xmm0, xmm1          ; cycles / 1e9 = GHz


    ; Restore registers
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    ret

nanosleep_inline:
    push    rdi
    push    rsi
    push    rax

    mov     rax, 35                  ; syscall: nanosleep
    lea     rdi, [rel timespec]      ; pointer to timespec struct
    xor     rsi, rsi                 ; rsi = NULL (don’t care about remaining time)
    syscall

    pop     rax
    pop     rsi
    pop     rdi
    ret