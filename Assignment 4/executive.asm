global executive
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern stdin
    extern fill_random_array
    extern show_array
segment .data
    prompt_name db "Please enter your name: ", 0
    prompt_title db "Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc): ", 0
    prompt_float db "This program will generate 64-bit IEEE float numbers.", 10, "How many numbers do you want. Today’s limit is 100 per customer ", 0
    promt_stored db "Your numbers have been stored in an array. Here is that array."
    greeting db "Nice to meet you %s %s", 10, 0
    one_string db "%s", 0
    one_integer db "%d", 0
segment .bss
    align 64
    name resb 50
    title resb 50
    size_array resq 1
    storedata resb 832
    nice_array resq 100
segment .text
    global executive
executive:
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
    mov rax, 0
    mov rdi, prompt_name
    call printf

    sub rsp, 16
    mov rdi, one_string
    mov rsi, rsp
    call scanf
    movsd xmm7, [rsp]
    movsd [name], xmm7
    add rsp, 16

    mov rax, 0
    mov rdi, prompt_title
    call printf

    sub rsp, 16
    mov rdi, one_string
    mov rsi, rsp
    call scanf
    movsd xmm8, [rsp]
    movsd [title], xmm8
    add rsp, 16
    
    mov rax, 2
    mov rdi, greeting
    mov rsi, title
    mov rdx, name
    call printf

    mov rax, 0
    mov rdi, prompt_float
    call printf

    sub rsp, 16
    mov rdi, one_integer
    mov rsi, rsp
    call scanf
    movsd xmm9, [rsp]
    movsd [size_array], xmm9
    add rsp, 16

    mov rdi, nice_array
    mov rsi, size_array
    call fill_random_array
    mov r15, rax

    mov rdi, nice_array
    mov rsi, r15
    call show_array

    

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

