
;External C++ functions
global triangle
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cosf
    
    extern stdin
    extern input_array
segment .data
    last_name db "Please enter your last name: ", 0
    title_name db "Please enter your title (Mr, Ms, Nurse, Engineer, etc): ", 0
    sides_num db "Please enter the sides of your triangle separated by ws: ", 0
    angle_num db "Please enter the size in degrees of the angle between those sides: ",0
    final_name db "Please enjoy your triangles %s %s", 0
    float_format db "%lf", 10, 0
    two_float db "%lf %lf",0
    one_float db "%lf", 0
    fmt db "The length of the third side is %.9f units.", 10, 0
    pi_over_180 dq 0.017453292519943295
    constant dq 2.0
    results dq 0.0
segment .bss
    name resb 50
    title resb 25
    side_a resq 1
    side_b resq 1
    part_b resq 1
    part_a resq 1
    cosine resq 1
segment .text
    global triangle
triangle:
    push    rbp               ; Save old base pointer
    mov     rbp, rsp          ; Establish new base pointer
    push    rbx               ; Only save registers that need preserving
    push    r12
    push    r13
    push    r14
    push    r15
    sub     rsp, 32 
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

    mov rdi, title
    call strlen
    mov rbx, rax
    dec rbx
    mov byte [title + rbx], 0 

    ; Enter sides
    mov rax, 0
    mov rdi, sides_num
    call printf

    sub rsp, 16
    ;Ask for sides
    mov rdi, two_float
    mov rsi, rsp
    mov rdx, rsp
    add rdx, 8
    call scanf

    movsd xmm4, qword [rsp]
    movsd [side_a], xmm4 
    mulsd xmm4, xmm4

    movsd xmm3, qword [rsp+8]
    movsd [side_b], xmm3
    mulsd xmm3, xmm3
    
    addsd xmm4, xmm3
    movsd [part_a], xmm4
    add rsp, 16
    

    ;Display part_a

   ; Enter the angle and calculate cosine
    mov rax, 0
    mov rdi, angle_num
    call printf    

    sub rsp, 16
    mov rax, 0
    mov rdi, one_float
    mov rsi, rsp
    call scanf

    movsd xmm0, qword [rsp]
    add rsp, 16

    mulsd xmm0, qword [pi_over_180]

    call cosf
    movsd [cosine], xmm0
    ;C the third side
    movsd xmm0, qword [side_a] 
    mulsd xmm0, qword [constant]
    mulsd xmm0, qword [side_b]
    movsd xmm1, qword [cosine]
    mulsd xmm0, xmm1
    movsd [part_b], xmm0

    movsd xmm0, qword [part_a] 
    subsd xmm0, qword [part_b]
    sqrtsd xmm0, xmm0
    movsd qword [results], xmm0
    
    mov rdi , fmt
    movq xmm0, qword [results]
    call printf
    
    sub rsp, 16
    mov rbp, rsp
    mov rdi , final_name
    mov rsi, title
    mov rdx, name
    call printf

    add rsp, 16
    
    movsd xmm0, qword [results]
    
    popf
    add     rsp, 32           ; Restore stack (if allocated earlier)
    pop     r15               ; Restore preserved registers
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp               ; Restore base pointer
    ret                       ; Return to caller