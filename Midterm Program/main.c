#include <stdio.h>
extern double manager();
int main() {
    printf("Hello user.\n");
    double area = manager();
    printf("A zero will return to the aperating system\n");
    return 0; 
}