EXEC = Lab6
OBJS = Lab6.o
LIB = ../macros/barnett.a ../macros/stdin.o ../macros/stdout.o

# Compile and link all programs
all: $(EXEC)
	
# Link all programs
$(EXEC): $(OBJS)
	ld -o $(EXEC) $(OBJS) $(LIB)

# Build each object by assembling the assembly file of the same name
%.o: %.s
	as -g -o $@ $<	

# Clear out object files and executables
clean:
	rm -f *.o
