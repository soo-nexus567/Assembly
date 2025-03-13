
#!/bin/bash#======================================================================|  
# Author information                                                   |  
# Author Name    : Jonathan Soo                                        |  
# Author Email   : jonathansoo07@csu.fullerton.edu                     |  
# Author Section : 240-11                                              |  
# Author CWID    : 884776980                                           |
# Date:     March 11, 2025                                             |  
rm *.out

# Assemble the x86 file triangle.asm, output object file triangle.o
nasm -f elf64 -g -F dwarf manager.asm && ld -no-pie -o manager manager.o
ld -o manger manager.o
nasm -f elf64 -o huron.o huron.asm
nasm -f elf64 -o istriangle.o istriangle.asm
# Compile geometry.c
gcc -c -m64 -Wall -no-pie -g -o triangle.o triangle.c -lm

# Link the two object files triangle.o and geometry.o, output executable file learn.out
gcc -m64 -no-pie -o learn.out manager.o huron.o istriangle.o triangle.o -std=c2x -Wall -z noexecstack -lm
# Next the program will run
./learn.out