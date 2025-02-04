
#include <stdio.h>

extern double triangle();
int main() {
    printf("Welcome to the Triangle program maintained by Juan Diaz.\n");
    printf("If errors are discovered please report them to Juan Diaz at juan@columbia.com  for a quick fix.  At Columbia Software the customer comes first.\n");
    
    // triangle.asm
    double result = triangle();
    printf("The main function received this number %.9f and plans to keep it until needed\n", result);
    printf("An integer zero will be returned to the operating system. Bye.\n");
    return 0;
}
