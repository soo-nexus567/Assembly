global output_array
    extern manager
segment .data
    format_string db "The driver has received this number %lu and will simply keep it", 0 
segment .bss
    align 64
    storedata resb 832
segment .text
    global output_array
output_array:
    mov rdi, 

