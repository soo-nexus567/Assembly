#!/bin/bash
rm *.out

# Assemble and link the program
gcc -c -o driver.o driver.c
nasm -f elf64 -o manager.o manager.asm

# Link the object files with the C runtime
gcc -m64 -no-pie -o learn.out driver.o manager.o -std=c2x -Wall -z noexecstack -lm
# Next the program will run
./learn.out