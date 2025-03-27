rm *.out

nasm -f elf64 -o executive.o executive.asm
nasm -f elf64 -l isnan.lis -o isnan.o isnan.asm
nasm -f elf64 -o fill_random_array.o fill_random_array.asm
nasm -f elf64 -o show_array.o show_array.asm
nasm -f elf64 -o normalize_array.o normalize_array.asm
gcc  -m64 -Wall -no-pie -o main.o -std=c2x -c main.c
gcc -c -m64 -Wall -fno-pie -no-pie -o sort.o sort.c

gcc -m64 -no-pie -o learn.out fill_random_array.o normalize_array.o show_array.o executive.o main.o sort.o isnan.o -std=c2x -Wall -z noexecstack -lm

chmod +x r.sh
./learn.out