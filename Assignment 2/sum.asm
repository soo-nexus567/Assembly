global sum_array
    extern printf
segment .data
    fmt_float db "%lf", 10, 0 
segment .bss
segment .text
    global sum
sum:
    ;15 pushes
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
    pxor xmm0, xmm0
begin:
    cmp     r13, r14             ; Check if counter >= array size
    jge     exit
    
    movsd xmm1, [r15+r13 * 8]
    addsd xmm0, xmm1
    inc     r13                  ; Increment loop counter
    jmp     begin                ; Loop

exit:
    ; Set the accumulator as the return before returning
    ;15 pop
    movsd xmm0, xmm0
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