rm *.out

nasm -f elf64 -o executive.o executive.asm
nasm -f elf64 -o fill_random_array.o fill_random_array.asm
nasm -f elf64 -o show_array.o show_array.asm
gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c

gcc -m64 -no-pie -o learn.out fill_random_array.o show_array.o executive.o main.o -std=c2x -Wall -z noexecstack -lm

chmod +x r.sh
./learn.out