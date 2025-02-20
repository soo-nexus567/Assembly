global triangle
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern input_array
    array_size equ 12
segment .data
    array_line1 db "This program will manage your array of 64-bit floats", 10, 0
    array_line2 db "For the array enter a sequence of 64-bit floats separated by white space", 10, 0 
    array_line3 db "After the last input press enter following by Control+D:", 10, 0
    output_count db "Array ount is %lu", 10, 0

segment .bss
    align 64
    storedata resb 832
    nice_array resq array_size
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

    mov rax, 7
    mov rdx, 0
    xsave [storedata]
    
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

    mov     rdi, nice_array
    mov     rsi, array_size
    call    input_array
    mov     r15, rax

    mov     rax, 0
    mov     rdi, output_count
    mov     rsi, r15
    call    printf

    mov     rax, 7
    mov     rdx, 0
    xrstor  [storedata]

    mov     rax, r15


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