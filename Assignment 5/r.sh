# Date:     March 11, 2025                                             |  
rm -f *.out

# Assemble the x86 file triangle.asm, output object file triangle.o

nasm -f elf64 edison.asm -o edison.o
nasm -f elf64 faraday.asm -o faraday.o
nasm -f elf64 tesla.asm -o tesla.o 
nasm -f elf64 -o ftoa.o ftoa.asm

# Link the two object files triangle.o and geometry.o, output executable file learn.out
ld  -o learn.out faraday.o edison.o tesla.o  ftoa.o -g -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
# Next the program will run
chmod +x learn.out
./learn.out