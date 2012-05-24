.PHONY: all clean

all: hg-ps1 hgps1

hg-ps1: hg-ps1.o
	gcc -O3 -o hg-ps1 hg-ps1.o

hg-ps1.o: hg-ps1.c
	gcc -c hg-ps1.c

hgps1: hgps1.hs
	ghc -O3 -Wall --make hgps1.hs

clean:
	rm -f *.o hg-ps1 hgps1 *.hi
