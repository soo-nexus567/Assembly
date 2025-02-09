//Copyright Info
//  "Assignment 1" is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  "Assignment 1" is distributed in the hope that it will be useful,
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
//  Program name: Assignment 1
//  Copyright (C) <2025> <Jonathan Soo>
//  Programming languages: One modules in C and one module in X86-64
//  Date program began:     2025-Jan-27
//  Date program completed: 2025-Feb-07
//  Date comments upgraded: 2025-Feb-08
//  Files in this program: geometry.c, triangle.asm, r.sh
//  Status: Complete.  No errors found after extensive testing.
//
//This file
//   File name: geometry.c
//   Language: C
//   Assemble: gcc -c -m64 -Wall -fno-pie -no-pie -o geometry.o geometry.c -lm
//   Editor: VS Code
//   Link: gcc -m64 -Wall -fno-pie -no-pie -z noexecstack -o learn.out triangle.o geometry.o -lm 
#include <stdio.h>

extern double triangle();
int main() {
    printf("Welcome to the Triangle program maintained by Jonathan Soo.\n");
    printf(
         "If errors are discovered please report them to Jonathan Soo at "
         "jonathansoo07@csu.fullerton.edu for a quick fix. At Columbia Software the customer "
         "comes first.\n\n");
    
    // triangle.asm
    double result = triangle();
    printf(
         "\nThe main function received this number %.9f and plans to keep it until "
         "needed.\n", 
         result);
    printf("An integer zero will be returned to the operating system. Bye.\n");
    return 0;
}
