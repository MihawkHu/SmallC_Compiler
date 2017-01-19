scc:lex.yy.o smallc.tab.o intermediate.o inter.o mips.o
	g++ -std=gnu++11 lex.yy.o smallc.tab.o intermediate.o inter.o mips.o -o scc
intermediate.o:intermediate.cpp intermediate.h inter.h SymbolTable.h node.h mips.h
	g++ -std=gnu++11 -c intermediate.cpp
mips.o:mips.cpp mips.h
	g++ -std=gnu++11 -c mips.cpp
inter.o:inter.cpp inter.h
	g++ -std=gnu++11 -c inter.cpp
lex.yy.o:lex.yy.c smallc.tab.h 
	g++ -std=gnu++11 -c lex.yy.c
smallc.tab.o:smallc.tab.c node.h intermediate.h inter.h SymbolTable.h mips.h
	g++ -std=gnu++11 -c smallc.tab.c
smallc.tab.c smallc.tab.h:smallc.y
	bison -d smallc.y
lex.yy.c:smallc.l
	flex smallc.l

clean:
	rm -f *.h.gch *.o *.yy.c *.yy.o *.tab.* InterCode *.s scc 

