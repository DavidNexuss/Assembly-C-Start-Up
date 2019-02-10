CC = gcc
AS = nasm

ASFLAGS = -f elf64
CCFLAGS = -c
COMPILEFLAGS = 

ODIR = obj
BIN  = bin
IDIR = src

PROGRAM_NAME = test
PROGRAM = $(BIN)/$(PROGRAM_NAME)

all: $(ODIR) $(BIN) $(PROGRAM)

$(ODIR):
		mkdir $(ODIR)
$(BIN):
		mkdir $(BIN)

$(ODIR)/s_%.o: $(IDIR)/%.s
	$(AS) $(ASFLAGS) $^ -o $@

$(ODIR)/%.o: $(IDIR)/%.c
	$(CC) $(CCFLAGS) $^ -o $@

S_SOURCES = $(shell find $(IDIR) -type f -name *.s -printf "%f\n")
C_SOURCES = $(shell find $(IDIR) -type f -name *.c -printf "%f\n")

S_OBJECTS = $(patsubst %.s, $(ODIR)/s_%.o,$(S_SOURCES))
C_OBJECTS = $(patsubst %.c, $(ODIR)/%.o,$(C_SOURCES))

$(PROGRAM): $(C_OBJECTS) $(S_OBJECTS)
	$(CC) $(COMPILEFLAGS) $(S_OBJECTS) $(C_OBJECTS) -o $(PROGRAM) 

clean:
	rm -r $(ODIR)
	rm -r $(BIN)
run: all
	./$(PROGRAM)
