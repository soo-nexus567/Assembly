global manger
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern stdin
    extern input_array
    extern huron
    extern isfloat
    extern istriangle
    extern atof
segment .data
    format_string db "%lf", 0
    sides_num db "Please enter the sides of your triangle separated by ws: ", 0
    thank_you db "Thank you", 10, 0
    valid_input db "These input have been tested and they are sides of a valid triangle", 10, 0
    huron_applied db "The Huron formula will be applied to find the area", 10, 0
    invalid_msg db "Invalid input. Try again.", 10, 0
    three_float db "%lf %lf %lf", 0
    one_float db "Results %lf", 10, 0
    results dq 0.0
    result_format db "Area: %lf", 10, 0
    constant dq 2.0
segment .bss
    input_buffer resb 64           ; Reserve space for input buffer
    semi_perimeter resq 1
    side_a resq 1
    side_b resq 1
    side_c resq 1
    part_a resq 1
    part_b resq 1
    part_c resq 1
    area resq 1                   ; Reserve space for the area result
segment .text
    global manger
manger:
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

    ; Initialize registers for the input process
    mov r13, 0                      ; Counter for number of inputs
    mov r14, 3                      ; We need 3 sides of the triangle

    ; Ask for triangle sides
    mov rdi, sides_num
    call printf

input_loop:
    cmp r13, r14                    ; Check if 3 sides have been entered
    jge done

    ; Prompt user for input
    mov rdi, format_string
    mov rsi, input_buffer           ; Pass the buffer to store input
    call scanf

    ; Check if scanf failed
    cmp rax, -1
    je done

    ; Check if input is a valid float using isfloat
    mov rdi, input_buffer           ; Pass input buffer to isfloat
    call isfloat
    cmp rax, 0                      ; If not a valid float, go to invalid_input
    je invalid_input

    ; Convert string to float using atof
    mov rdi, input_buffer           ; Pass input buffer to atof
    call atof
    movsd [side_a + r13*8], xmm0    ; Store the input value in the corresponding side variable

    inc r13                          ; Increment input counter
    jmp input_loop

invalid_input:
    mov rdi, invalid_msg
    call printf
    jmp input_loop

done:
    ; All inputs are gathered, now validate if it's a valid triangle
    mov rdi, [side_a]               ; First side
    mov rsi, [side_b]               ; Second side
    mov rdx, [side_c]               ; Third side
    call istriangle                 ; Check if the sides form a valid triangle

    ; Cleanup and return
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
    mov rax, 0
    ret