#/bin/bash
# Context: This bash file is part of the first homework assignment 'Assignment 1'

# Author: Jonathan Soo
# Date of last update: January 26, 2025
# Program name: Assignment 1
# Purpose: The manager of this program

#Delete some un-needed files if they exist.
rm *.o
rm *.out

echo "Compile gemoetry.cpp"
gcc -c Wall -m64 -no-pie  geometry.cpp -std=c++2a -o ar1.o
