all: 
	flex lex.l
	bison -y -d syntax.y
	g++ lex.yy.c y.tab.c