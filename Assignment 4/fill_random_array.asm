global fill_random_array
extern printf
extern scanf
extern fgets
extern strlen
extern cos
extern stdin
extern input_array

segment .data
    fmt_failed db "RDRAND failed. Retrying...", 10, 0  ; Debug message when rdrand fails
    fmt_rax db "RDRAND value: %llx", 10, 0              ; Format string for printing the value in rax
    fmt_float db "Random double: %lf", 10, 0             ; Format string for printing a float

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

    ; Ensure we don't generate more than 100 random numbers
    cmp     r14, 6               ; Check if the value in rsi exceeds 100
    jg      set_max_size           ; If rsi > 100, set it to 100

    ; If rsi <= 100, continue as normal
    mov     r14, rsi               ; Set r14 to rsi (number of random floats to generate)
    jmp     generate_random_floats ; Jump to generating the floats

set_max_size:
    mov     r14, 6               ; Set the number of elements to 100 if rsi > 100

generate_random_floats:
    ; Generate random numbers and store them in nice_array
    mov     rbx, r14               ; Set rbx to the number of floats to generate (r14)
    
generate_loop:
    ; Generate a random number and store it in the nice_array
    rdrand  rax                    ; Generate a random 64-bit integer
    jc      store_float            ; If the random number is successfully generated, store it
    
    ; Print a message or value to see if rdrand keeps failing
    mov rdi, fmt_failed
    call printf

    ; Print the raw value in rax to check randomness
    mov rdi, fmt_rax               ; Assuming fmt_rax is the format string "%llx\n"
    mov rsi, rax
    call printf

    ; Retry rdrand if it fails
    jmp     generate_loop          ; Retry if rdrand failed

store_float:
    ; Print the raw value to verify the number being stored
    mov rdi, fmt_float
    mov rsi, rax                   ; Print the random number directly
    call printf

    ; Convert the integer in rax to a double-precision float (xmm0)
    cvtsi2sd xmm0, rax             ; Convert 64-bit integer in rax to double-precision float (xmm0)

    ; Store the double in nice_array (64-bit IEEE 754)
    movsd   [r13 + r15 * 8], xmm0  ; Store the float in nice_array
    inc     r15                     ; Increment the counter
    dec     rbx                     ; Decrease the remaining count
    jnz     generate_loop           ; Repeat until we have generated the required number of floats

    jmp end_loop

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
    pop     r9                      ; Restore r
