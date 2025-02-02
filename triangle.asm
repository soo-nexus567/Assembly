;External C++ functions
global triangle
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern stdin
    extern input_array
segment .data
    last_name db "Please enter your last name: ", 0
    title_name db "Please enter your title (Mr, Ms, Nurse, Engineer, etc): ", 0
    sides_num db "Please enter the sides of your triangle separated by ws: ", 0
    output_two_float db "The two numbers are %5.3lf and %5.3lf.",10,0
    two_float db "%lf %lf",0
segment .bss
    name resb 50
    title resb 25
segment .text
triangle:
    push    rbp 
    mov     rbp,rsp 
    push    rdi 
    push    rsi 
    push    rdx 
    push    rcx 
    push    r8 
    push    r9 
    push    r10 
    push    r11 
    push    r12 
    push    r13 
    push    r14 
    push    r15 
    push    rbx                     
    pushf   

    ;Ask for input lastname
    mov rax, 0
    mov rdi, last_name
    call printf

    ; Enter username
    mov rax, 0
    mov rdi, name
    mov rsi, 50
    mov rdx, [stdin]
    call fgets

    ;Remove newline character from the user's input when the player hit Enter
    mov rdi, name
    call strlen
    mov    [name + rax - 1], byte 0 
    ;Ask for title
    mov rax, 0
    mov rdi, title_name
    call printf

    ; Enter title
    mov rax, 0
    mov rdi, title
    mov rsi, 25
    mov rdx, [stdin]
    call fgets

    ; Enter sides
    mov rax, 0
    mov rdi, sides_num
    call printf
    pop rax

    push qword 99
    ;Ask for sides
    push qword -1
    push qword -2
    mov rax, 0
    mov rdi, two_float
    mov rsi, rsp
    mov rdx, rsp
    add rdx, 8
    call scanf

    movsd xmm12, [rsp]
    movsd xmm13, [rsp+8]
    pop rax
    pop rax

    ;Display 2 float numbers
    mov rax, 2
    mov rdi, output_two_float
    movsd xmm0, xmm12
    movsd xmm1, xmm13
    call printf

    popf 
    pop     rbp
    pop     rbx 
    pop     r15 
    pop     r14 
    pop     r13 
    pop     r12 
    pop     r11 
    pop     r10 
    pop     r9 
    pop     r8 
    pop     rcx 
    pop     rdx 
    pop     rsi 
    pop     rdi 

    ret