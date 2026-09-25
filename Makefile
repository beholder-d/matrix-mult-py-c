# Here we go again
CC = gcc

TARGET = matrix-mult
COMMON_CFLAGS := -Wall -Wextra -std=c11

LDFLAGS =
LDLIBS =

MAIN_C := src/main.c
SRCS := $(wildcard src/*.c)
HS := $(wildcard src/*.h)

LIB_RELEASE_SRCS := $(filter-out $(MAIN_C), $(SRCS))
LIB_RELEASE_OBJS := $(patsubst %.c,build/lib-release/%.o,$(LIB_RELEASE_SRCS))
LIB_RELEASE_CFLAGS := $(COMMON_CFLAGS) -fPIC -c
LIB_RELEASE_LDFLAGS = -shared

LIB_DEBUG_OBJS := $(subst /lib-release/,/lib-debug/,$(LIB_RELEASE_OBJS))
LIB_DEBUG_CFLAGS := $(COMMON_CFLAGS) -fPIC -c -g3 -O0 -fno-omit-frame-pointer
LIB_DEBUG_LDFLAGS = -shared

RELEASE_OBJS := $(patsubst %.c,build/release/%.o,$(MAIN_C))
RELEASE_CFLAGS := $(COMMON_CFLAGS) -O2 -DNDEBUG
RELEASE_LDFLAGS = -L./build/lib-release/ -l$(TARGET)

DEBUG_OBJS := $(subst /release/,/debug/,$(RELEASE_OBJS))
DEBUG_CFLAGS := $(COMMON_CFLAGS) -g3 -O0 -fno-omit-frame-pointer
DEBUG_LDFLAGS := $(subst /lib-release/,/lib-debug/,$(RELEASE_LDFLAGS))

# default target
.PHONY: all lib-release release lib-debug debug
all: release

lib-release: build/lib-release/lib$(TARGET).so
release: lib-release build/release/$(TARGET)

lib-debug: build/lib-debug/lib$(TARGET).so
debug: lib-debug build/debug/$(TARGET)

# compile lib
build/lib-release/lib$(TARGET).so: $(LIB_RELEASE_OBJS)
	@echo " -   link lib release for $@"
	@mkdir -p $(@D)
	$(CC) $(LDFLAGS) $(LIB_RELEASE_LDFLAGS) $^ $(LDLIBS) -o $@

build/lib-release/%.o: %.c
	@echo " -   compile lib release for $@"
	@mkdir -p $(@D)
	$(CC) $(LIB_RELEASE_CFLAGS) $< -o $@

# compile release
build/release/$(TARGET): $(RELEASE_OBJS)
	@echo " -   link release for $@"
	@mkdir -p $(@D)
	$(CC) $(LDFLAGS) $(RELEASE_LDFLAGS) $^ $(LDLIBS) -o $@

build/release/%.o: %.c
	@echo " -   compile release for $@"
	@mkdir -p $(@D)
	$(CC) $(RELEASE_CFLAGS) -c $< -o $@

# compile debug lib
build/lib-debug/lib$(TARGET).so: $(LIB_DEBUG_OBJS)
	@echo " -   link lib debug for $@"
	@mkdir -p $(@D)
	$(CC) $(LDFLAGS) $(LIB_DEBUG_LDFLAGS) $^ $(LDLIBS) -o $@

build/lib-debug/%.o: %.c
	@echo " -   compile lib debug for $@"
	@mkdir -p $(@D)
	$(CC) $(LIB_DEBUG_CFLAGS) $< -o $@

# compile debug
build/debug/$(TARGET): $(DEBUG_OBJS)
	@echo " -   link debug for $@"
	@mkdir -p $(@D)
	$(CC) $(LDFLAGS) $(DEBUG_LDFLAGS) $^ $(LDLIBS) -o $@

build/debug/%.o: %.c
	@echo " -   compile debug for $@"
	@mkdir -p $(@D)
	$(CC) $(DEBUG_CFLAGS) -c $< -o $@

# clean
.PHONY: clean
clean:
	rm -rf build/*

# format
.PHONY: format
format:
	@echo "Formatting sources"
	clang-format -i $(SRCS) $(HS)
