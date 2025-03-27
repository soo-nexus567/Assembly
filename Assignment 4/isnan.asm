;****************************************************************************************************************************
; Program name: Identify Nans.  This is a driver function used for testing the library function isnan.  This function sets  *
; up a call to isnan.  The user can easily verify the correctness of isnan by visual inspection.                            *
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public  *
; License (LGPL3) version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it  *
; will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR*
; PURPOSE.  See the GNU Lesser General Public License for more details.  A copy of the GNU Lesser Public License v3 is      *
; available here: <https://www.gnu.org/licenses/>.                                                                          *
;****************************************************************************************************************************
; Programmer's name: F. Holliday
; Email: holliday@fullerton.edu
; Function name: isnan

; Purpose:  This is a library function.  This function, isnan, will determine if an IEEE float number is a nan or not a nan.

;This implementation of the isnan algorithm is intended to be the simplest and minimalist
;implementation possible.

;Prototype:   long isnan(double floatnumber);

global isnan
    extern printf
segment .data
   ;Empty
   prompt db "HEllo", 10, 0

segment .bss
    ;Empty

segment .txt
isnan:
;Back up the GPRs (General Purpose Registers)
push rbp
mov rbp, rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
pushf
mov rax, 0
mov rdi, prompt
call printf
; ;Copy the incoming parameter to a GPR
; push qword 0
; movsd [rdi],xmm0
; pop r8

; ;Use shift instructions to isolate the stored exponent in the low end of r8
; shl r8, 1
; shr r8, 53

; ;Is r8 equal to 2047 or not?
; cmp r8,2047
; je it_is_a_nan
; mov rax,0        ;0=false
; jmp next
; it_is_a_nan:
; mov rax, 1       ;1-true
; next:

; ;rax will be returned to the caller

;Restore backed up general registers
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp   ; Restore rbp to the base of the activation record of the caller program
ret