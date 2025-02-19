#!/bin/bash
rm *.out

# Assemble the x86 file triangle.asm, output object file triangle.o
nasm -f elf64 triangle.asm -o triangle.o

# Compile geometry.c
gcc -c -m64 -Wall -fno-pie -no-pie -o geometry.o geometry.c -lm

# Link the two object files triangle.o and geometry.o, output executable file learn.out
gcc -m64 -Wall -fno-pie -no-pie -z noexecstack -o learn.out triangle.o geometry.o -lm 

# Next the program will run
./learn.out