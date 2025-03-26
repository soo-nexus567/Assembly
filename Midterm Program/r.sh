#!/bin/bash
rm *.out

# Assemble the x86 file triangle.asm, output object file triangle.o
nasm -f elf64 -o manager.o manager.asm
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
nasm -f elf64 -o output_array.o output_array.asm
# Compile geometry.c
gcc -c -m64 -Wall -fno-pie -no-pie -o main.o main.c -lm

# Link the two object files triangle.o and geometry.o, output executable file learn.out
gcc -m64 -no-pie -o learn.out input_array.o output_array.o manager.o main.o -std=c2x -Wall -z noexecstack -lm
# Next the program will run
./learn.out