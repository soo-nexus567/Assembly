max_array_count equ 15
global manager
    extern printf
    extern input_array
    extern output_array
    extern sum
    extern sort_array
    extern fgets
    extern strlen
    extern stdin
    extern atof
    extern hsum
segment .data
    array_line1 db "This program will manage your array of 64-bit floats", 10, 0
    array_line2 db "For the array enter a sequence of 64-bit floats separated by white space", 10, 0 
    array_line3 db "After the last input press enter following by Control+D:", 10, 0
    msg_array_output db "These number were recieved in this array is: ", 10, 0
    msg_array_sum  db "The sum is %f", 10, 0
    msg_array_mean db "The arithmetic mean of the numbers in the array is %f", 10, 0
    msg_array_sort db "This is the array after the sort process completed:", 10, 0
    fmt_int db "%f", 10, 0
    results dq 0.0
    sum_num dq 0.0
segment .bss
    align 64
    storedata resb 832
    nice_array resq max_array_count
    harmatic_sum resq 1

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

    mov     rax, 7
    mov     rdx, 0
    xsave   [storedata]
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
    mov     rsi, max_array_count
    call    input_array
    mov     r15, rax    

    mov rax, 0
    mov rdi, msg_array_output
    call printf

    mov rdi, nice_array
    mov rsi, r15
    call output_array

    mov rdi, nice_array
    mov rsi, r15
    call hsum
    movsd [harmatic_sum], xmm0
    mov     rax, 1 
    mov     rdi, msg_array_sum 
    mov     rsi, harmatic_sum
    call    printf

    mov     rax, 7
    mov     rdx, 0
    xrstor  [storedata]

    movsd xmm0, [harmatic_sum]
    movsd xmm0, xmm0
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