global triangle
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern input_array
segment .data
    array_line1 db "This program will manage your array of 64-bit floats", 10, 0
    array_line2 db "For the array enter a sequence of 64-bit floats separated by white space", 10, 0 
    array_line3 db "After the last input press enter following by Control+D:", 10, 0

segment .bss
  
segment .text
    global manager
manager:
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


    ;Prompt the user for their last name
    mov     rax, 0
    mov     rdi, array_line1
    call    printf

    mov     rax, 0
    mov     rdi, array_line2
    call    printf

    mov     rax, 0
    mov     rdi, array_line3
    call    printf



     ; Restore the general purpose registers
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