# Here we go again
CC = gcc
CFLAGS = -Wall -Wextra -std=c11

DEBUG_CFLAGS := $(CFLAGS) -g3 -O0 -fno-omit-frame-pointer

SOURCES = $(wildcard src/*.c)
OBJECTS = $(SOURCES:src/%.c=build/%.o)

# compile
TARGET = bin/matrix-mult-c
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@

build/%.o: src/%.c
	@mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -rf build $(TARGET)

.PHONY: format
format:
	@echo "Formatting sources: $(SOURCES)"
	clang-format -i $(SOURCES)
