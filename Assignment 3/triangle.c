//======================================================================|  
// Copyright Info                                                       |  
// "Assignment 3" is free software: you can redistribute it and modify  |  
// it under the terms of the GNU General Public License as published by |  
// the Free Software Foundation, either version 3 of the License, or    |  
// (at your option) any later version.                                  |  
//                                                                      |  
// "Assignment 3" is distributed in the hope that it will be useful,    |  
// but WITHOUT ANY WARRANTY; without even the implied warranty of       |  
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU     |  
// General Public License for more details.                             |  
//                                                                      |  
// You should have received a copy of the GNU General Public License    |  
// along with this program. If not, see <https://www.gnu.org/licenses/>.|  
//======================================================================|  
// Author information                                                   |  
// Author Name    : Jonathan Soo                                        |  
// Author Email   : jonathansoo07@csu.fullerton.edu                     |  
// Author Section : 240-11                                              |  
// Author CWID    : 884776980                                           |  
//======================================================================|  
// Purpose                                                              |  
// Calculate the third side of a triangle using floating-point          |  
// arithmetic. Get input from user and output using C functions.        |  
//======================================================================|  
// Program information                                                  |  
// Program Name      : Assignment 3                                     |  
// Copyright (C)     : 2025, Jonathan Soo                               |  
// Programming Lang. : One module in C and one in x86-64                |  
// Date program began: 2025-Mar-05                                      |  
// Date program completed: 2025-Mar-08                                  |  
// Date comments upgraded: 2025-Mar-08                                  |  
// Files in this program: huron.asm, istriangle.asm, manager.asm,       |  
//                        main.c, r.sh                                  |  
// Status: Complete. No errors found after testing.                     |  
//======================================================================|  
// This file                                                            |  
// File Name  : triangle.c                                              |  
// Language   : C                                                       |  
// Assemble   : gcc -c -m64 -Wall -fno-pie -no-pie -o                   |    
//              triangle.o triangle.c -lm                               |             
// Editor     : VS Code                                                 |  
// Link       : gcc -m64 -no-pie -o learn.out manager.o huron.o         |  
//              istriangle.o triangle.o -std=c2x -Wall -z noexecstack -lm     
//======================================================================|  
#include <stdio.h>
// extern double manager();
int main() {
    char greeting [] = "Happy Anniversary";
    // printf("%s", greeting);

    // printf("Welcome to Huron's Triangle. We take care of all your triangle needs.\n");
    // printf("Please enter your name: ");
    // scanf("%99[^\n]%*c", name);
    // double area = manager();
    // if (area == -1){
    //     printf("Thank you %s. Your patronage is appreciated.\n\n", name);
    //     printf("The main function has received this number %.1f, and will keep it for a while.\n\n", area);
    //     printf("A -1 will return to the aperating system\n\n");
    //     return -1;
    // } else{
    //     printf("The main function has received this number %.2f, and will keep it for a while.\n\n", area);
    // }
    // printf("Thank you %s. Your patronage is appreciated.\n\n", name);
    // printf("A zero will not return to the aperating system\n");
    return 1; 
}