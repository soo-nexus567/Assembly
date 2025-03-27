#include <stdio.h>
extern char* executive();
int main() {
    printf("Welcome to Random Products, LLC.\n");
    printf("This software is maintained by Jonathan Soo\n");
    char* results = executive();
    printf("Oh, %s. We hope you enjoyed you arrays. Do come again.\n", results);
    printf("A zero wil lbe returned to the operation system\n");
    return 0; 
}