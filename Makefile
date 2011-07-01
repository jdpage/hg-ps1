.PHONY: all clean

all: hg-ps1

hg-ps1: hg-ps1.o
	gcc -O3 -o hg-ps1 hg-ps1.o

hg-ps1.o: hg-ps1.c
	gcc -c hg-ps1.c

clean:
	rm -f *.o hg-ps1
