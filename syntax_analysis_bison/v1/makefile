scanner: scanner.l scanner.y
	bison -d scanner.y
	flex scanner.l
	gcc -o $@ scanner.tab.c lex.yy.c -lfl
