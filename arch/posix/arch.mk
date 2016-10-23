arch_objs += \
    panic.o     \
    boot.o      \
    mutex.o     \
    printchar.o \
    interrupt.o \
    x86.o       \
    thread.o

LD := ld
override CFLAGS += -DARCH_POSIX -ggdb3 -Os
override CXXFLAGS += -DARCH_POSIX -ggdb3 -Os

ifeq ($(shell uname -s), Linux)
override CFLAGS += -pthread
endif

ifeq ($(shell uname -s), Darwin)
CC  := gcc-6
CXX := g++-6
endif

override CPPFLAGS += -I$(arch_dir)

$(TARGET_FILE): $(objs)
	$(CMDECHO) CC $@
	$(CC) $(CFLAGS) -o $@ $(objs)

.PHONY: run
run:
	PYTHONPATH=$(makefile_dir) ./tools/run ./$(TARGET_FILE)
