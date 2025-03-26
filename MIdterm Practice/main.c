
//======================================================================|  
// Copyright Info                                                       |  
// "Midterm Program" is free software: you can redistribute it and modify  
// it under the terms of the GNU General Public License as published by |  
// the Free Software Foundation, either version 3 of the License, or    |  
// (at your option) any later version.                                  |  
//                                                                      |  
// "Midterm Program" is distributed in the hope that it will be useful, |  
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
// Program Name      : Midterm Program                                  |  
// Copyright (C)     : 2025, Jonathan Soo                               |  
// Programming Lang. : One module in C and one in x86-64                |  
// Date program began: 2025-Mar-011                                     |  
// Date program completed: 2025-Mar-011                                 |  
// Date comments upgraded: 2025-Mar-011                                 |  
// Files in this program: huron.asm, input_array.asm, manager.asm,      |  
//                        output_array.asm main.c, r.sh                 |  
// Status: Complete. No errors found after testing.                     |  
//======================================================================|  
// This file                                                            |  
// File Name  : main.c                                                  |  
// Language   : C                                                       |  
// Assemble   : gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c    |   
// Editor     : VS Code                                                 |  
// Link       : gcc -m64 -no-pie -o learn.out current.o electricy.o     |     
//              main.o -std=c2x -Wall -z noexecstack -lm                |
//                                                                      |
//======================================================================|  

#include <stdio.h>
extern double electricy();
int main() {
    double total_current = electricy();
    printf("The main received this number %.5f and will keep it for later.\n", total_current);
    printf("A zero will be returned to the operating system. Bye\n");
    return 0;
}