#!/bin/bash
# Context: This bash file is part of the first homework assignment 'Assignment 1'

# Author: Jonathan Soo
# Date of last update: January 26, 2025
# Program name: Assignment 1
# Purpose: The manager of this program

#Delete some un-needed files if they exist.
rm *.out

echo "Assemble the x86 file triangle.asm, output object file triangle.o"
nasm -f elf64 triangle.asm -o triangle.o

echo "Compile gemoetry.cpp"
gcc -c -m64 -Wall -fno-pie -no-pie -o geometry.o geometry.c

echo "Link the two object files manager.o and hello.o, output executable file learn.out"
gcc -m64 -Wall -fno-pie -no-pie -z noexecstack -lm -o learn.out triangle.o geometry.o

echo "Next the program "Hello Word" will run"
./learn.out