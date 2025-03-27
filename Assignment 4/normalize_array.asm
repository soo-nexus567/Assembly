global normalize_array

segment .data                 ;Place initialized data here

segment .bss      ;Declare pointers to un-initialized space in this segment.

segment .text
normalize_array:

    ;backup GPRs
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

    ;obtain array address and size and store in nonvolatile registers
    mov r15, rdi ;our array
    mov r14, rsi ;number of values 

    ;set counter to 0 to keep track of all the numbers that have already been normalized
    mov r13, 0

    ; Find the maximum value in the array
    mov r12, 0         ; Start loop counter
    movsd xmm0, [r15]  ; Assume first element is max

find_max:
    cmp r12, r14
    jge check_capacity  ; If counter >= size, move to normalization
    movsd xmm1, [r15+r12*8]
    comisd xmm0, xmm1  ; Compare current max with next element
    jb update_max      ; If xmm1 is larger, update max
    jmp continue_max

update_max:
    movsd xmm0, xmm1   ; Update max value

continue_max:
    inc r12
    jmp find_max

    ;check if all values in the array have been normalized
check_capacity:
    cmp r13, r14
    jl is_less

    ;if all numbers have been normalized, jump to exit the function
    jmp exit

    ;jump here if array hasnt been fully normalized to continue normalizing
is_less:

    ;mov number from array onto the stack and into r12 to change the stored exp to 3ff to make the value in between 1 and 2
    movsd xmm15, [r15+r13*8]
    push qword 0
    movsd [rsp], xmm15
    pop r12
    shl r12, 12
    shr r12, 12
    mov rax, 0x3ff0000000000000
    or r12, rax

    ;push the normalized number into xmm15 register from r12
    push r12
    movsd xmm15, [rsp]
    pop r12

    ;move the now normalized number from xmm15 back into the array
    movsd [r15+r13*8], xmm15
    
    ;increase the counter for how many numbers in array have been normalized then jump to check again if all numbers are normalized
    inc r13
    jmp check_capacity

    ;exit the function
    exit:
    ;Restore the GPRs
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
    pop rbp   ;Restore rbp to the base of the activation record of the caller program
    ret
    ;End of the function normalize_array ====================================================================
