#!/bin/bash
rm *.out

# Assemble the x86 file triangle.asm, output object file triangle.o
nasm -f elf64 -l manager.lis -o manager.o manager.asm
nasm -f elf64 -o huron.o huron.asm
nasm -f elf64 -l istriangle.lis -o istriangle.o istriangle.asm
# Compile geometry.c
gcc -c -m64 -Wall -fno-pie -no-pie -o triangle.o triangle.c -lm

# Link the two object files triangle.o and geometry.o, output executable file learn.out
gcc -m64 -no-pie -o learn.out manager.o huron.o istriangle.o triangle.o -std=c2x -Wall -z noexecstack -lm && echo "Linking successful" || echo "Linking failed"
# Next the program will run
./learn.out