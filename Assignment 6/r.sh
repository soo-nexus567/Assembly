
#!/bin/bash#======================================================================|  
# Author information                                                   |  
# Author Name    : Jonathan Soo                                        |  
# Author Email   : jonathansoo07@csu.fullerton.edu                     |  
# Author Section : 240-11                                              |  
# Author CWID    : 884776980                                           |
# Date:     March 11, 2025                                             |  
rm *.out

# Assemble the x86 file triangle.asm, output object file triangle.o
nasm -f elf64 -o manager.o manager.asm
nasm -f elf64 -o read_clock.o read_clock.asm
# Compile geometry.c
gcc -c -m64 -Wall -fno-pie -no-pie main.c -o main.o -lm


# Link the two object files triangle.o and geometry.o, output executable file learn.out
gcc -m64 -no-pie -o learn.out manager.o read_clock.o main.o -std=c2x -Wall -z noexecstack -lm
# Next the program will run
./learn.out