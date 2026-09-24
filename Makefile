# Here we go again
CC = gcc

COMMON_CFLAGS = -Wall -Wextra -std=c11
DEBUG_CFLAGS := $(COMMON_CFLAGS) -g3 -O0 -fno-omit-frame-pointer
CFLAGS := $(COMMON_CFLAGS) -O2 -DNDEBUG

SRCS = $(wildcard src/*.c)
DEBUG_OBJS = $(patsubst %.c,build/debug/%.o,$(SRCS))
OBJS = $(patsubst %.c,build/release/%.o,$(SRCS))

TARGET = matrix-mult-c

LDFLAGS =
LDLIBS =

# default target
.PHONY: all release debug
all: release
release: build/release/$(TARGET)
debug: build/debug/$(TARGET)

# debug
build/debug/$(TARGET): $(DEBUG_OBJS)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

build/debug/%.o: %.c
	$(CC) $(DEBUG_CFLAGS) -MMD -MP -c $< -o $@


# compile
build/release/$(TARGET): $(OBJS)
	@mkdir -p $(@D)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

build/release/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

# clean
.PHONY: clean
clean:
	rm -rf build $(TARGET)

# format
.PHONY: format
format:
	@echo "Formatting SRCS: $(SRCS)"
	clang-format -i $(SRCS)
