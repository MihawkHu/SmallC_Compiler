LEX=flex
YACC=bison
CC=g++ -std=gnu++11

scc:lex.yy.o smallc.tab.o intermediate.o inter.o mips.o
	$(CC) lex.yy.o smallc.tab.o intermediate.o inter.o mips.o -o scc

intermediate.o:intermediate.cpp intermediate.h inter.h SymbolTable.h node.h mips.h
	$(CC) -c intermediate.cpp

mips.o:mips.cpp mips.h
	$(CC) -c mips.cpp

inter.o:inter.cpp inter.h
	$(CC) -c inter.cpp

lex.yy.o:lex.yy.c smallc.tab.h 
	$(CC) -c lex.yy.c

smallc.tab.o:smallc.tab.c node.h intermediate.h inter.h SymbolTable.h mips.h
	$(CC) -c smallc.tab.c

smallc.tab.c smallc.tab.h:smallc.y
	$(YACC) -d smallc.y

lex.yy.c:smallc.l
	$(LEX) smallc.l

clean:
	@rm -f *.o *.yy.c *.yy.o *.tab.* InterCode MIPSCode.s scc 

