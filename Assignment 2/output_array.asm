global output_array
    extern printf
segment .data
    msg_number db "%f ", 0
    newline db 10, 0
segment .bss

segment .text

output_array:
    push    rbp                     ; Backup rbp
    mov     rbp,rsp                 ; The base pointer now points to top of stack
    push    rdi                     ; Backup rdi
    push    rsi                     ; Backup rsi
    push    rdx                     ; Backup rdx
    push    rcx                     ; Backup rcx
    push    r8                      ; Backup r8
    push    r9                      ; Backup r9
    push    r10                     ; Backup r10
    push    r11                     ; Backup r11
    push    r12                     ; Backup r12
    push    r13                     ; Backup r13
    push    r14                     ; Backup r14
    push    r15                     ; Backup r15
    push    rbx                     ; Backup rbx
    pushf                           ; Backup rflags

    mov r15, rdi
    mov r14, rsi
    mov r13, 0

begin:
    cmp     r13, r14             ; Check if counter >= array size
    jge     exit                 ; If yes, exit loop

    movq    xmm0, [r15 + r13 * 8] ; Load double-precision float
    mov     rdi, msg_number      ; Load format string
    mov     rax, 1               ; Indicate one float argument for printf
    call    printf               ; Print float
    inc     r13                  ; Increment loop counter
    jmp     begin                ; Loop
exit:
    mov rdi, newline
    call printf
    ;15 pop
    popf                            ; Restore rflags
    pop     rbx                     ; Restore rbx
    pop     r15                     ; Restore r15
    pop     r14                     ; Restore r14
    pop     r13                     ; Restore r13
    pop     r12                     ; Restore r12
    pop     r11                     ; Restore r11
    pop     r10                     ; Restore r10
    pop     r9                      ; Restore r9
    pop     r8                      ; Restore r8
    pop     rcx                     ; Restore rcx
    pop     rdx                     ; Restore rdx
    pop     rsi                     ; Restore rsi
    pop     rdi                     ; Restore rdi
    pop     rbp                     ; Restore rbp

    ret