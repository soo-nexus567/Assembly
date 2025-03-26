global show_array
extern printf
segment .data
    msg_ieee db "0x%016llX", 0     ; Format string for IEEE 754 representation (64-bit hex)
    msg_scientific db "%e", 0       ; Format string for scientific notation (float)
    newline db 10, 0                ; Newline character for output
segment .bss

segment .text

show_array:
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

    mov r15, rdi                   ; r15 contains the array (pointer to the array)
    mov r14, rsi                   ; r14 contains the array size (number of elements)
    mov r13, 0                     ; r13 is the counter/index for the array
    xor rcx, rcx                   ; Clear rcx (not needed anymore)

begin:
    cmp     r13, r14                ; Check if counter >= array size
    jge     exit                    ; If yes, exit loop

    mov     rax, 1                  ; Indicate one argument for printf
    ; Print IEEE 754 representation (64-bit hex)
    mov     rdi, msg_ieee           ; Load format string for IEEE 754 hex
    movsd   xmm0, [r15 + r13 * 8]   ; Load the float (8 bytes) from the array
    call    printf                  ; Print the IEEE 754 hex value

    ; mov     rax, 1                  ; Indicate one argument for printf
    ; ; Print the scientific notation of the float
    ; mov     rdi, msg_scientific     ; Load format string for scientific notation
    ; movsd   xmm0, xmm0
    ; call    printf                  ; Print the scientific decimal value

    mov     rdi, newline            ; Print newline at the end of each number
    call    printf

    inc     r13                     ; Increment the counter
    jmp     begin                    ; Repeat the loop

exit:
    ; Restore the registers
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
