
# disable built-in rules since costume rules are defined
# and this results in nicer error messages
# (missing rule instead of failing wrong rule)
MAKEFLAGS += --no-builtin-rules

LD=ld
LD_FLAGS= -g
AS=as
AS_FLAGS= -ggdb

.PHONY: all
all: first

.INTERMEDIATE: first.o

first: first.o
	$(LD) -o first $(LD_FLAGS) first.o

first.o: first.s
	$(AS) -o first.o $(AS_FLAGS) first.s

