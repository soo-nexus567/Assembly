global fill_random_array
    extern printf
    extern scanf
    extern fgets
    extern strlen
    extern cos
    extern stdin
    extern input_array
    extern isnan

segment .data
    fmt_failed db "RDRAND failed. Retrying...", 10, 0  ; Debug message when rdrand fails
    fmt_rax db "RDRAND value: %llx", 10, 0              ; Format string for printing the value in rax
    fmt_float db "Random double: %lf", 10, 0             ; Format string for printing a float
    r14_value dq 0
segment .bss
    align 64
    storedata resb 832           ; Space to store saved register state
    nice_array resq 100          ; Space for 100 floats

segment .text
    global fill_random_array

fill_random_array:
    ; Backup registers and save components
    push    rbp                   ; Save the base pointer
    mov     rbp, rsp              ; Set up the new base pointer
    push    rbx                   ; Save registers
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
    pushf                           ; Save flags
    mov rax,7
    mov rdx,0
    xsave [storedata]              ; Save the state of the processor

    mov     r13, rdi               ; r13 holds the pointer to the array for valid floats
    mov     r14, rsi               ; rsi holds the number of random numbers to generate
    mov     r15, 0                 ; Initialize counter for valid floats
    sub     rsp, 1024              ; Allocate space on the stack

    ; If rsi <= 100, continue as normal
    jmp     generate_random_floats ; Jump to generating the floats

set_max_size:
    mov     r14, 100               ; Set the number of elements to 100 if rsi > 100

generate_random_floats:
    mov     rbx, r14               ; Number of floats to generate
    
generate_loop:
    cmp     r15, r14               ; Check if we've generated the required floats
    jge     end_loop               ; If we reached the limit, exit

    rdrand  rax                    ; Generate a random 64-bit integer
    jnc     generate_loop           ; Retry if rdrand fails

    ; Normalize to [0,1) range by dividing by 2^64
    mov     rcx, 0x3DF0000000000000 ; 2^(-64) as an IEEE 754 double
    movq    xmm1, rcx               ; Load into xmm1
    cvtsi2sd xmm0, rax              ; Convert integer to double
    mulsd   xmm0, xmm1              ; Scale it to [0,1)

    ; Check if the number is NaN using ucomisd
    ucomisd xmm0, xmm0              ; NaN check: NaN is always unordered (!= itself)
    jp      generate_loop            ; Jump if NaN (parity flag is set)

    ; Store the float in nice_array
    movsd   [r13 + r15 * 8], xmm0   ; Store result
    inc     r15                     ; Increment count
    jmp     generate_loop           

nan_detected:
    ; Print an error message if NaN is detected
    ; mov     rdi, fmt_nan            ; Assume fmt_nan is "Generated NaN!\n"
    ; call    printf
    jmp     generate_loop           ; Retry generating a new number
end_loop:
    ; Clean up the stack space
    add     rsp, 1024              ; Restore the stack space allocated at the beginning

    ; Restore processor state
    mov rax, 7
    mov rdx, 0
    xrstor [storedata]             ; Restore the saved state of the processor

    ; Return the number of valid floats (r15)
    mov     rax, r15               ; Set the return value to the number of valid floats (r15)

    ; Restore registers
    popf                            ; Restore flags
    pop     r15                     ; Restore r15
    pop     r14                     ; Restore r14
    pop     r13                     ; Restore r13
    pop     r12                     ; Restore r12
    pop     r11                     ; Restore r11
    pop     r10                     ; Restore r10
    pop     r9                      ; Restore r9
    pop     r8                      ; Restore r8
    pop     rdi                     ; Restore rdi
    pop     rsi                     ; Restore rsi
    pop     rdx                     ; Restore rdx
    pop     rcx                     ; Restore rcx
    pop     rbx                     ; Restore rbx

    ; Restore the base pointer and return from the function
    pop     rbp
    ret
