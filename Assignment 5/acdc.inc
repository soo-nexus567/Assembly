%macro strlen 0
    ; Prologue
    back_register
    xor     rax, rax        
    mov     rbx, rdi
    xor     rcx, rcx

%%find_null:
    cmp     byte [rbx + rcx], 0
    je      %%done
    inc     rcx
    jmp     %%find_null

%%done:
    mov     rax, rcx        ; Result in RAX

    ; Epilogue
    restore_registers
%endmacro
%macro showfloat 0
    push rbp
    mov  rbp, rsp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    pushf

    ; Get the float in xmm0 (Assuming the float to be printed is in xmm0)
    sub rsp, 32             ; Reserve space for the string buffer
    mov rbx, rsp            ; rbx will point to the start of the buffer
    mov r8, rbx             ; r8 will point to the current position in the buffer

    ; Separate the integer part and fractional part
    ; Convert the float to an integer
    cvttsd2si rax, xmm0     ; Convert the integer part of the float to rax
    mov rsi, rax            ; Copy integer part into rsi for later use
    
    ; Handle integer part (convert integer to string)
    mov rcx, 10             ; Set divisor to 10 for decimal digits

%%convert_integer:
    xor rdx, rdx            ; Clear rdx before dividing
    div rcx                 ; Divide rax by 10 (quotient in rax, remainder in rdx)
    add dl, '0'             ; Convert remainder to ASCII ('0' is 0x30 in ASCII)
    mov [r8], dl            ; Store the ASCII character in the buffer
    inc r8                  ; Move buffer pointer
    test rax, rax           ; If quotient is zero, we are done
    jnz %%convert_integer

    ; Handle the fractional part (convert fractional part of the float to string)
    ; Move the fractional part into xmm1
    movsd xmm1, xmm0
    subsd xmm1, xmm0        ; xmm1 now contains just the fractional part

    ; Multiply fractional part by 10^6 (6 digits of precision)
    mov rdi, 100000000        ; 10^6
    mulsd xmm1, xmm1        ; xmm1 = xmm1 * 10^6 (to handle precision)
    cvttsd2si rax, xmm1     ; Convert fractional part to integer (now in rax)

    ; Convert the fractional part to string
    mov rsi, rax            ; Copy the fractional part into rsi

%%convert_fraction:
    xor rdx, rdx            ; Clear rdx before dividing
    div rcx                 ; Divide rax by 10 (quotient in rax, remainder in rdx)
    add dl, '0'             ; Convert remainder to ASCII ('0' is 0x30 in ASCII)
    mov [r8], dl            ; Store the ASCII character in the buffer
    inc r8                  ; Move buffer pointer
    test rax, rax           ; If quotient is zero, we are done
    jnz %%convert_fraction

    ; Now append a decimal point between the integer and fractional parts
    mov byte [r8], '.'      ; Append a decimal point
    inc r8                  ; Move buffer pointer to next position

    ; Output the string (integer + fractional part)
    mov rsi, rbx            ; rsi points to the start of the string
    sub rsi, r8             ; rsi points to the length of the string
    mov rdi, 1              ; File descriptor 1 (stdout)
    mov rdx, rsi            ; Length of the string
    mov rax, 1              ; syscall number for sys_write
    syscall                 ; Print the string

    ; Restore registers
    popf
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
%endmacro
%macro showstring 0
    push rbp
    mov  rbp, rsp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    pushf

    strlen               ; Use the macro instead of call strlen

    mov rdx, rax        ; rdx = length of string
    cmp rsi, rdx        ; Check if rsi is greater than rdx (i.e., valid range)
    jg %%nothingtooutput ; If rsi is greater than rdx, skip the printing
    cmp rsi, 0          ; Check if rsi is less than 0
    jge %%outputstring  ; If rsi >= 0, proceed to output
    mov rsi, 0          ; If rsi < 0, reset rsi to 0

%%outputstring:
    ; Check if rsi is negative and adjust the starting index
    cmp rsi, 0          ; If rsi is negative, stop the macro without printing
    jl %%nothingtooutput ; If rsi < 0, nothing will be output

    add rdi, rsi        ; rdi = rdi + rsi (move to starting index)
    sub rdx, rsi        ; rdx = length - rsi (remaining length to print)
    mov rsi, rdi        ; rsi = rdi (set destination to rdi)
    mov rax, 1          ; syscall number for write
    mov rdi, 1          ; file descriptor for stdout
    syscall
    mov rax, 0          ; Clear rax to prepare for return
    jmp %%restore

%%nothingtooutput:
    mov rax, 1          ; No output if rsi is negative or invalid
    jmp %%restore

%%restore:
    popf
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
%endmacro

%macro read_string 1
    mov     rbx, %1
    mov     r12, 0
    push    rbx

%%read_loop:
    mov     rax, system_read
    mov     rdi, Stdin
    mov     rsi, rsp
    mov     rdx, 1
    syscall

    mov     al, byte [rsp]
    cmp     al, Line_feed
    je      %%end_read

    inc     r12
    cmp     r12, Numeric_string_array_size
    jge     %%skip_store

    mov     byte [rbx], al
    inc     rbx

%%skip_store:
    jmp     %%read_loop

%%end_read:
    mov     byte [rbx], Null
    pop     rax
%endmacro

%macro backup_compnents 1
;This macro backs up all registers except GPRs to an array specified in parameter %1
   mov rax,7
   mov rdx,0
   xsave [%1]
%endmacro
%macro restore_components 1
   mov rax,7
   mov rdx,0
   xrstor [%1]
%endmacro
%macro back_register 0    ;ar = activation record
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
%endmacro

%macro restore_registers 0
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
%endmacro
%macro read_float 1
    ; %1 = Destination memory location for final float value

    mov rbx, %1              ; Where to store the string
    push rbx                 ; Save for later restore

    ; Clear all working registers
    mov r10, 0              ; Decimal flag
    mov r11, 0              ; Negative flag
    mov r12, 0               ; Char counter
    mov r13, 0               ; Fractional accumulator
    mov r14, 0               ; Integer accumulator
    mov r15, 1               ; Divisor multiplier for fraction

%%input_loop:
    mov rax, 0               ; sys_read
    mov rdi, 0               ; Stdin
    lea rsi, [rsp]           ; Temp storage
    mov rdx, 1               ; Read 1 byte
    syscall

    mov al, byte [rsp]      ; Load character
    cmp al, 10              ; Enter key (LF)
    je %%done_input

    cmp al, '-'             ; Negative sign?
    je %%handle_negative

    cmp al, '.'             ; Decimal point?
    je %%handle_decimal

    cmp al, '0'             
    jb %%skip_char
    cmp al, '9'
    ja %%skip_char

    sub al, '0'             ; Convert ASCII to int
    movzx rcx, al

    cmp r10b, 0
    je %%int_part           ; Before decimal

    ; Fraction part
    imul r13, r13, 10
    add r13, rcx
    imul r15, r15, 10
    jmp %%store_char

%%int_part:
    imul r14, r14, 10
    add r14, rcx
    jmp %%store_char

%%handle_negative:
    cmp r12, 0              ; Only first char
    jne %%skip_char
    mov r11b, 1             ; Set negative flag
    jmp %%store_char

%%handle_decimal:
    cmp r10b, 0
    jne %%skip_char         ; Only allow once
    mov r10b, 1
    jmp %%store_char

%%store_char:
    mov byte [rbx], al      ; Store input char exactly
    inc rbx
    inc r12
    jmp %%input_loop

%%skip_char:
    inc r12
    jmp %%input_loop

%%done_input:
    mov byte [rbx], 0       ; Null-terminate string

    ; Convert int part to float
    cvtsi2sd xmm0, r14

    ; Fraction exists?
    cmp r10b, 0
    je %%maybe_apply_sign

    cvtsi2sd xmm1, r13
    mov rax, r15
    cvtsi2sd xmm2, rax
    divsd xmm1, xmm2
    addsd xmm0, xmm1

%%maybe_apply_sign:
    cmp r11, 1
    jne %%store_result

    xorpd xmm3, xmm3
    subsd xmm3, xmm0
    movaps xmm0, xmm3

%%store_result:
    movsd qword [%1], xmm0
    pop rbx
%endmacro
%macro output_float 1
    ; %1 = address of float to print
    ; rdi, rsi, xmm0 might be clobbered

    mov rax, 1               ; sys_write for newline fallback
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1

    movsd xmm0, qword [%1]   ; Load float
    mov rdi, float_format    ; format string
    mov rax, 1               ; printf float
    call printf
%endmacro
%macro ftoa1 0
    ; Initialize the processing floating-point register
    movsd    xmm1, xmm0         ; Copy the input to xmm1 for processing
    xor      rbx, rbx           ; Clear the sign flag (0 = positive)
    mov      rsi, rdi           ; rsi = string buffer pointer
    xor      rcx, rcx           ; String index (0)
    
    ; Sign check (negative numbers)
    movsd    xmm2, xmm0         ; Copy original input to xmm2 for comparison
    comisd   xmm2, [zero]       ; Compare xmm2 with 0.0
    jb       %%neg_sign          ; Jump if less than 0 (negative)
    
    ; If positive, continue
    jmp      %%abs_val           ; Skip to absolute value handling

%%neg_sign:
    ; If the number is negative, set the sign flag and store '-'
    mov      byte [rsi], '-'     ; Store '-' at the start of the string
    inc      rcx                 ; Increment string index for next character
    xor      rbx, rbx           ; Reset the sign flag, to be used for absolute value
    negsd    xmm1, xmm0         ; Negate the number for further processing
    jmp      %%abs_val           ; Proceed to absolute value

%%abs_val:
    ; Convert integral part
    ; Use floor to get the integer part
    roundsd  xmm3, xmm1, 1      ; Round down to the nearest integer
    cvtsd2si rax, xmm3          ; Convert to integer (rax = integer part)
    
    ; Push integral digits to stack
    %%convert_integral:
        xor      rdx, rdx       ; Clear rdx (remainder)
        div      rdx:rax, 10    ; Divide rax by 10, remainder in rdx
        add      dl, '0'        ; Convert to ASCII (remainder in dl)
        push     rdx            ; Push digit onto stack
        inc      rcx            ; Increment digit counter
        test     rax, rax       ; Check if quotient is 0
        jnz      %%convert_integral ; Continue until rax is 0

    ; Build integral part in the string
    %%build_integral:
        pop      rdx            ; Pop a digit from the stack
        mov      [rsi], dl      ; Store the digit as ASCII
        inc      rsi            ; Move to the next position
        loop     %%build_integral ; Continue for all digits

    ; Append decimal point '.'
    mov      byte [rsi], '.'
    inc      rsi

    ; Convert fractional part
    movsd    xmm2, xmm1         ; Copy original number
    subsd    xmm2, xmm3         ; Subtract the integral part (xmm2 = fractional part)
    movsd    xmm3, [ten]        ; Load 10.0 for multiplying fractional part
    %%convert_fractional:
        mulsd    xmm2, xmm3     ; Multiply fraction by 10
        cvtsd2si r9, xmm2      ; Convert to integer (r9 = fractional digit)
        add      r9, '0'        ; Convert to ASCII
        mov      [rsi], r9b     ; Store fractional digit as ASCII
        inc      rsi            ; Increment string index
        subsd    xmm2, r9       ; Subtract the integer part from the fraction
        test     xmm2, xmm2     ; Check if fraction is close to 0
        jnz      %%convert_fractional ; Continue if there's more fraction

        ; Null terminate the string
        mov      byte [rsi], 0
%endmacro