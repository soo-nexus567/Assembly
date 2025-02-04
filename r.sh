#!/bin/bash
# Context: This bash file is part of the first homework assignment 'Assignment 1'

# Author: Jonathan Soo
# Date of last update: January 26, 2025
# Program name: Assignment 1
# Purpose: The manager of this program

#Delete some un-needed files if they exist.
# Delete some un-needed files if they exist.
rm *.out

# Assemble the x86 file triangle.asm, output object file triangle.o
echo "Assemble the x86 file triangle.asm, output object file triangle.o"
nasm -f elf64 triangle.asm -o triangle.o

# Compile geometry.c
echo "Compile geometry.c"
gcc -c -m64 -Wall -fno-pie -no-pie -o geometry.o geometry.c -lm

# Link the two object files triangle.o and geometry.o, output executable file learn.out
echo "Link the two object files triangle.o and geometry.o, output executable file learn.out"
gcc -m64 -Wall -fno-pie -no-pie -z noexecstack -o learn.out triangle.o geometry.o -lm 

# Next the program will run
echo "Next the program will run"
./learn.out