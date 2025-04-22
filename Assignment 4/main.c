//Copyright Info
//  "Assignment 4" is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  "Assignment 4" is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY// without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//Author information
//  Author name: Jonathan Soo
//  Author email: jonathansoo07@csu.fullerton.edu
//  Author section: 240-11
//  Author CWID : 884776980
//Purpose
//  Calculate the third side of a triangle using float-point arthmetic
//  Get input from user and ouput using C functions

//Program information
//  Program name: Assignment 4
//  Copyright (C) <2025> <Jonathan Soo>
//  Programming languages: Several modules in x86-64 and two in C
//  Date program began:     2025-March-25
//  Date program completed: 2025-March-26
//  Date comments upgraded: 2025-March-27
//  Files in this program: executive.asm, fill_random_array.asm, isnan.asm, main.c, sort.c, normalize_array.asm, show_array.asm, r.sh
//  Status: Complete.  No errors found after extensive testing.
//
//This file
//   File name: main.c
//   Language: C
//   Assemble: gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c
//   Editor: VS Code
//   Link: gcc -m64 -no-pie -o learn.out fill_random_array.o normalize_array.o show_array.o executive.o main.o sort.o isnan.o -std=c2x -Wall -z noexecstack -lm
#include <stdio.h>
extern char* executive();
int main() {
    printf("Welcome to Random Products, LLC.\n");
    printf("This software is maintained by Jonathan Soo\n");
    char* results = executive();
    printf("Oh, %s. We hope you enjoyed you arrays. Do come again.\n", results);
    printf("A zero will be returned to the operation system\n");
    return 0; 
}