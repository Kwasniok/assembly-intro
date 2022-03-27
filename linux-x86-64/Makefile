
# disable built-in rules since costume rules are defined
# and this results in nicer error messages
# (missing rule instead of failing wrong rule)
MAKEFLAGS += --no-builtin-rules

# paths
# path to all source files
SRC=src
# path to all binary and build files (eg. object files)
BIN=bin

# linker
LD=ld
LD_FLAGS=
# assembler
AS=nasm
# -F stabs for debugging
AS_FLAGS=-f elf64 -F dwarf -g
# c linker
LD_C=gcc
# no PIE and -g for debugging
LD_C_FLAGS=-no-pie -fno-pie -g


# all base directories
BASE_DIRS=$(SRC) $(BIN)


# pure assembly targets
as_targets = first syscall_000_read syscall_001_write syscall_060_exit \
		  example_hello example_triangle example_stack_frame
as_sources = $(addprefix $(SRC)/, $(as_targets))
as_objects = $(addprefix $(BIN)/, $(addsuffix .o, $(as_targets)))
as_bins    = $(addprefix $(BIN)/, $(as_targets))
# mark object files as intermediate
.INTERMEDIATE: $(as_objects)

# assembly with stdc calls
as_c_targets = example_libc example_printf example_counter example_fib example_print_args example_packed_byte_add
as_c_sources = $(addprefix $(SRC)/, $(as_targets))
as_c_objects = $(addprefix $(BIN)/, $(addsuffix .o, $(as_c_targets)))
as_c_bins    = $(addprefix $(BIN)/, $(as_c_targets))
.INTERMEDIATE: $(as_c_objects)

# c code with assembly calls
c_as_targets = example_asm_from_c example_float_sum
c_as_sources = $(addprefix $(SRC)/, $(c_as_targets))
c_as_objects = $(addprefix $(BIN)/, $(addsuffix .o, $(c_as_targets)))
c_as_bins    = $(addprefix $(BIN)/, $(c_as_targets))
.INTERMEDIATE: $(c_as_objects)


# decalre all targets as phony
.PHONY: $(as_targets) $(as_c_targets) $(c_as_targets)

# default target makes all targets
.DEFAULT_GOAL=all
.PHONY: all
all: $(as_targets) $(as_c_targets) $(c_as_targets)

# remove all intermediates
.PHONY: clean
clean:
	rm -f $(as_objects) $(as_c_objects) $(c_as_objects)


# pure assembly rules
# note: $@ = current target
# note: $* = deduced stem (aka whatever % is)
$(as_targets): %: $(BIN)/%
$(as_bins): $(BIN)/%: $(BIN)/%.o
	$(LD) $(BIN)/$*.o -o $@ $(LD_FLAGS)
$(as_objects): $(BIN)/%.o: $(SRC)/%.asm
	$(AS) $(SRC)/$*.asm -o $@ $(AS_FLAGS)

# assembly and stclib rules
$(as_c_targets): %: $(BIN)/%
$(as_c_bins): $(BIN)/%: $(BIN)/%.o
	$(LD_C) $(BIN)/$*.o -o $@ $(LD_C_FLAGS)
$(as_c_objects): $(BIN)/%.o: $(SRC)/%.asm
	$(AS) $(SRC)/$*.asm -o $@ $(AS_FLAGS)

# assembly embedded in c rules
$(c_as_targets): %: $(BIN)/%
$(c_as_bins): $(BIN)/%: $(SRC)/%.c $(BIN)/%.o
	$(LD_C) $(SRC)/$*.c $(BIN)/$*.o -o $@ $(LD_C_FLAGS)
$(c_as_objects): $(BIN)/%.o: $(SRC)/%.asm
	$(AS) $(SRC)/$*.asm -o $@ $(AS_FLAGS)


# ensure the directories exist
$(info $(shell mkdir -p $(BASE_DIRS)))
