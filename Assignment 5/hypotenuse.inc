;Information: This include file was first created to accompany the program Pythagoras.
;The Pythagoras program computes the length of the hypotenuse of a right triangle given the 
;lengths of the two sides.



;This is an include file for the program Pythagoras.   File name: hypotenuse.inc

;=====Declarations =======================================================================
;These declarations are global to all the macros in this include file "hypotenuse.inc".

presentform db "These were received by the macro presentstack: %ld  %ld  %ld",10,0

stackheadformat db "Stack Dump # %d:  ", 
                db "rbp = %016lx rsp = %016lx", 10, 
                db "Offset    Address           Value", 10, 0
;Notice how to continue a long string on the next line.

stacklineformat db "%+5d  %016lx  %016lx", 10, 0


;====== Macro receiving integer values =================================

;Macro computes the area of a right triangle
%macro area_integer 3
  ;%1 = length of side 1 as unsigned int
  ;%2 = length of side 2 as unsigned int
  ;%3 = computed area
  ;All values in this macro are unsigned integers
  mov rax, %1
  mov rbx, %2
  mul rbx
  mov rbx,2
  div rbx
  mov %3,rax    ;Returning the computed value to the caller.
%endmacro

;===== End of macro receiving integer values =========================================================




;===== Begin Macro receiving float values ============================================================

;Macro computes the area of a right triangle using float numbers
%macro area_float 3
   ;%1=length of side 1 as qword float
   ;%2=length of side 2 as qword float
   ;%3=computed area
  movsd xmm13,%1
  mulsd xmm13,%2       ;xmm13=product of two sides
  mov rbx,2            ;I hope rbx is not in use somewhere else
  cvtsi2sd xmm14,rbx
  divsd xmm13,xmm14    ;divide product by 2 
  movsd %3,xmm13
%endmacro

;===== End of macro receiving float values ==============================================================






;===== Other macros =======================================================================================

%macro backup_compnents 1
;This macro backs up all registers except GPRs to an array specified in parameter %1
   mov rax,7
   mov rdx,0
   xsave [%1]
%endmacro


;Macro that backs up all the GPRs
%macro create_ar 0    ;ar = activation record
   push rbp
   mov rbp, rsp
   push rbx
   push rcx
   push rdx
   push rdi
   push rsi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   pushf
%endmacro


;Macro that displays a region of memory near the top of the stack
%macro presentstack 3
   ;This macro should have been named showstack.
   ;Three parameters are passed to this macro: %1,%2,%3
       ;%1 = identifying integer
       ;%2 = # of qwords outside of stack
       ;%3 = # of qwords inside of stack
   mov rax,0
   mov rdi,presentform
   mov rsi,%1
   mov rdx,%2
   mov rcx,%3
   call printf
   ;===== Begin code to show the stack ===============================
   ;Set up the dump stack header
   mov qword rdi, stackheadformat                 ;The format of the header
   mov qword rsi, %1                              ;Arbitrary number passed in from caller
   mov qword rdx, rbp                             ;Back pointer
   mov qword rcx, rsp                             ;Top of stack point
   mov qword rax, 0                               ;rax=0 signals to printf that no xmm registers are used.
   call printf

   ;Set up conditions for entering a loop
   mov r13,%3                                     ;%3 = number of qwords inside the stack
mov r14,%2                                        ;%2 = number of qwords outside the stack
neg r14                                           ;r14 is now negative or zero

;Setup rbx as offset number that will appear in the first column of output.
mov rax, %3
mov r12, 8                                        ;Temporarily store 8 in r12
mul r12                                           ;Multiply rax by 8 bytes per qword
mov rbx, rax                                      ;Save the product in rbx (column 1 of output)

;;mov r12, rbp     ;old
mov r12, rsp
add r12, rbx                                      ;Give r12 the first address to be display in column 2 of the output.

beginloop:

;===== Prepare to output one line of the body of the stack dump ==========================
mov rdi, stacklineformat                          ;Format for offset, address, and quadword value
mov rsi, rbx                                      ;rbx stores the offset value
mov rdx, r12                                      ;r12 stores the address to be displayed
;mov rcx, [rdx]   ;;old                                 ;rcx receives the contents of memory at rbp+40
mov rcx, [r12]
mov rax, 0                                        ;No SSE registers will be outputted
call printf

;===== Advance the variables 8 bytes in the direction of small addresses =================
sub rbx, 8                                        ;rbx stores column 1, which is the offset value
sub r12, 8                                        ;r12 stores column 2, which is the address value
dec r13                                           ;r13 is loop counter; it decrements from high value to low (possibly negative) value

;===== Check for loop termination condition ==============================================
cmp r13, r14                                      ;Compare loop variable r13 with terminating value r14
jge beginloop                                     ;If r13 >= r14 then continue to iterate

%endmacro ;presentstack



;===== macro restore_components ==========================================================
%macro restore_components 1
   mov rax,7
   mov rdx,0
   xrstor [%1]
%endmacro



;===== macro delete activation record ====================================================
%macro delete_ar 0
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp
%endmacro

;FYI: macros do not some features found in functions: no return statements, no data segements, 
;no bss segments.  Common practice is to place declarations in an area near the top of the 
;include file.   Any macro in the include file may reference a declaration placed in the include
;file.   There appears to be no standard name for the class of file like the one you are reading
;now.  "Include file" seems to be a suitable name.  Another possible name could be "library of 
;macros".

;End of this include file