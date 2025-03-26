#======================================================================|  
# Author information                                                   |  
# Author Name    : Jonathan Soo                                        |  
# Author Email   : jonathansoo07@csu.fullerton.edu                     |  
# Author Section : 240-11                                              |  
# Author CWID    : 884776980                                           |
# Date:     March 11, 2025                                             |  
#!/bin/bash
rm *.out

# Assemble the x86 file triangle.asm, output object file triangle.o
nasm -f elf64 -o electricy.o electricy.asm
nasm -f elf64 -o current.o current.asm
# Compile geoetry.c
gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c

# Link the two object files triangle.o and geometry.o, output executable file learn.out
gcc -m64 -no-pie -o learn.out current.o electricy.o main.o -std=c2x -Wall -z noexecstack -lm

# Next the program will run
chmod +x r.sh
./learn.out