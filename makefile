all:
	$(MAKE) grammar
	$(MAKE) lex
	gcc -c compiler/grammar.tab.c compiler/lex.yy.c
	mv *.o compiler
	ar rvs compiler/lexgram.a compiler/grammar/tab/o compiler/lex.yy.o
	g++ -sdtชc++11 -Wall -Wextra compiler/main.c compiler/lex.yy.a
	mv a.exe bin

grammar:
		bison -d compiler/grammar.y
		mv grammar.tab.* compiler
lex:
		flex compiler/lex.l
		mv lex.yy.* compiler