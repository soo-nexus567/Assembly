global input_array
    extern printf
    extern scanf
    extern isfloat
    extern atof
    
 
segment .data
    format_string db "%s", 0
    prompt_tryagain db "Invalid Input", 10, 0

segment .bss
    align 64
    storedata resb 832
segment .text
    global input_array
input_array:
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
    mov rax, 7
    mov rdx, 0
    xsave [storedata]

    mov r13, rdi
    mov r14, rsi
    mov r15, 0
    sub rsp, 1024
begin:
    mov rax, 0 
    
    mov rdi, format_string
    mov rsi, rsp
    call scanf

    cdqe
    cmp rax, -1
    je exit

    ; mov rax, 0
    ; mov rdi, rsp
    ; call isfloat
    ; cmp rax, 0
    ; je tryagain

    mov rax, 0
    mov rdi, rsp
    call atof

    movsd [r13+r15 * 8], xmm0
    
    inc r15
    cmp r15, r14
    jl begin

    jmp exit

tryagain:
    mov rax, 0
    mov rdi, prompt_tryagain
    call printf
    jmp begin

exit:
    add rsp, 1024

    mov rax, 7
    mov rdx, 0
    xrstor [storedata]

    mov rax, r15




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