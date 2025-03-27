#include <stdbool.h>
#include <stdio.h>

// An optimized version of Bubble Sort

void swap_array(long *arr1, long *arr2) {
    double temp;
    
    // Swap the elements at arr1 and arr2
    temp = *arr1;
    *arr1 = *arr2;
    *arr2 = temp;
}
void bubbleSort(long *arr, int n)
{
    int i, j;
    bool swapped;
    for (i = 0; i < n - 1; i++)
    {
        swapped = false;
        for (j = 0; j < n - i - 1; j++)
        {
            if (arr[j] > arr[j + 1])
            {
                swap_array(&arr[j], &arr[j + 1]);
                swapped = true;
            }
        }

        // If no two elements were swapped by inner loop,
        // then break
        if (swapped == false)
            break;
    }
}
// Manager called the sort function through here
void sort_array(long *array, int count)
{
    bubbleSort(array, count);
}