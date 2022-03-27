
.PHONY: build
build: bin/main

.PHONY: clean
clean:
	rm -f bin/main src/main.o

bin/main: bin src/main.o
	ld -macosx_version_min 10.7.0 -arch i386 -no_pie -o bin/main src/main.o

src/main.o: src/main.asm src/os.asm src/io.asm src/syscall.asm src/str.asm
	cd src; nasm -f macho -o main.o main.asm

bin:
	mkdir -p bin
