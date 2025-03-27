global show_array
extern printf

segment .data
    prompt db "IEEE754		      Scientific Decimal", 10, 0
    msg_ieee db "%p", 0
    msg_sci  db "    %.13e", 10, 0          ; Format string for scientific decimal output
    fmt_debug db "%p", 10, 0

segment .text
show_array:
    ; 15 pushes to preserve registers
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

    mov     r15, rdi                ; Store the array pointer into r15
    mov     r14, rsi                ; Store the count of the array into r14
    mov     r13, 0                  ; Set r13 as the counter
    
    mov rax, 0
    mov rdi, prompt
    call printf
begin:
    ; Load the double value from the array
    ; movsd   xmm0, [r15 + r13 * 8]   ; Load the double at index r13 into xmm0
    ; mov     rdi, fmt_debug           ; Assuming fmt_debug is "%p\n" to print the memory address
    ; mov     rsi, [r15 + r13 * 8]     ; Load the address of the current value
    ; call    printf                   ; Print the memory address of the value being accessed
    ; Print IEEE754 format (64-bit hex)
    mov     rdi, msg_ieee           ; Set format for hex output
    mov   rsi, [r15 + r13 * 8]                ; Move the 64-bit value to rsi for printf
    call    printf                  ; Print the IEEE754 format

    mov rdi, msg_sci
    movsd xmm0, [r15+ r13 *8]
    call printf

    ; Increase the loop counter. Check if the counter >= the count of the array.
    ; If it is, return. If it is not, jump back to the beginning
    inc     r13
    cmp     r13, r14
    jge     exit
    jmp     begin

exit:
    ; Restore registers
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
