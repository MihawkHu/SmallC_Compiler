scc: y.tab.c lex.yy.c lex.yy.o y.tab.o
	g++ -o scc y.tab.c 
lex.yy.o: lex.yy.c
	g++ -c lex.yy.c 
y.tab.o: y.tab.c lex.yy.c
	g++ -c y.tab.c 
y.tab.c y.tab.h: smallc.y lex.yy.c
	yacc -v -d smallc.y
lex.yy.c: smallc.l parseTree.h
	flex smallc.l
clean:
	rm -f *.yy.c *.tab.* *.h.gch *.output *.o scc
