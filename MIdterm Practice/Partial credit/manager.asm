; section .data
;     msg db "Happy Birthday Chris Sawyer", 10, 0  ; Message to print
;         newline db 10, 0            ; Newline character for output
; section .bss
;     count resb 1  ; We'll store the loop count here (just for demonstration)

; section .text
;     global manager
;     extern printf

; manager:
;      ; Save the base pointer
;     push    rbp
;     mov     rbp, rsp

;     ; Save the general purpose registers
;     push    rbx
;     push    rcx
;     push    rdx
;     push    rsi
;     push    rdi
;     push    r8 
;     push    r9 
;     push    r10
;     push    r11
;     push    r12
;     push    r13
;     push    r14
;     push    r15
;     pushf

;     ; Initialize loop counter to 0
;     mov r13, 0                     ; r13 is the counter/index for the array
;     xor rcx, rcx                   ; Clear rcx (not needed anymore)

; begin:
;     cmp     r13, 37                ; Check if counter >= array size
;     jge     exit                    ; If yes, exit loopn


;     mov     rdi, msg         ; Load format string for integers
;     mov     rsi, rax                ; Set the integer to be printed in rsi
;     call    printf                  ; Print the integer

;     inc     r13                     ; Increment the counter
;     jmp     begin                    ; Repeat the loop

; exit:
;     mov rdi, newline                ; Print newline at the end
;     call printf
;     popf          
;     pop     r15
;     pop     r14
;     pop     r13
;     pop     r12
;     pop     r11
;     pop     r10
;     pop     r9 
;     pop     r8 
;     pop     rdi
;     pop     rsi
;     pop     rdx
;     pop     rcx
;     pop     rbx

;     ; Restore the base pointer
;     pop     rbp
;     ret
global manager
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern stdin
    extern input_array
segment .data
    last_name db "Please enter your last name: ", 0
    title_name db "Please enter your title (Mr, Ms, Nurse, Engineer, etc): ", 0
    sides_num db "Please enter the sides of your triangle separated by ws: ", 0
    welcome_msg db "Welcome, %s %s", 0
    pi_over_180 dq 0.017453292519943295
    constant dq 2.0
    results dq 0.0
    new_line dq 10
segment .bss
    name resb 50
    title resb 25
    side_a resq 1
    side_b resq 1
    part_b resq 1
    part_a resq 1
    cosine resq 1

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
    mov     rdi, last_name
    call    printf

    ; Stores the user's input in name
    mov     rax, 0
    mov     rdi, name
    mov     rsi, 50
    mov     rdx, [stdin]
    call    fgets

 
    ;Remove newline character from the user's input the name when the player hit Enter
    mov     rdi, name
    call    strlen
    mov     rbx, rax
    dec     rbx
    mov     byte [rdi + rbx], 0x00 

    ;Prompt the user for their title
    mov     rdi, new_line
    call    printf
    mov     rax, 0
    mov     rdi, title_name
    call    printf

    ; Stores the user's input in title
    mov     rax, 0
    mov     rdi, title
    mov     rsi, 25
    mov     rdx, [stdin]
    call    fgets

    mov     rdi, title
    call    strlen
    mov     rbx, rax
    dec     rbx
    mov     byte [rdi + rbx], 0x00 

    mov rdi, new_line
    call printf

    mov     rax, 2 
    mov     rdi, welcome_msg      ; Load address of welcome message prefix
    mov     rsi, title
    mov     rdx, name               ; No floating point arguments
    call    printf                ; Print welcome message
    
    mov rdi, new_line
    call printf
    ; Restore registers in reverse order
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

    ; Restore the base pointer and return
    pop     rbp
    ret