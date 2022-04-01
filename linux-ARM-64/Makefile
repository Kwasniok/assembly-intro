
# disable built-in rules since costume rules are defined
# and this results in nicer error messages
# (missing rule instead of failing wrong rule)
MAKEFLAGS += --no-builtin-rules

BIN=bin
SRC=src

LD=ld
LD_FLAGS= -g
AS=as
AS_FLAGS= -ggdb

# default target makes all targets
.DEFAULT_GOAL=all
.PHONY: all
all: first

pure_s_targets=first
pure_s_sources=$(addprefix $(SRC)/, $(addsuffix .s, $(pure_s_targets)))
pure_s_objects=$(addprefix $(BIN)/, $(addsuffix .o, $(pure_s_targets)))
pure_s_bins   =$(addprefix $(BIN)/, $(pure_s_targets))

.INTERMEDIATE: $(pure_s_objects)

$(pure_s_targets): %: $(BIN)/%
$(pure_s_bins): $(BIN)/%: $(BIN)/%.o
	$(LD) -o $@ $(LD_FLAGS) $(BIN)/$*.o
$(pure_s_objects): $(BIN)/%.o: $(SRC)/%.s
	$(AS) -o $@ $(AS_FLAGS) $(SRC)/$*.s

