cc main.c ./src/*.c -O1 -o sandwich -Wall -std=c99 -Wno-missing-braces -I include/ -L lib/ -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
./sandwich