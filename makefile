all: 
	flex lex.l
	bison -y -d syntax.y
	g++ -std=c++11 lex.yy.c y.tab.c

exec: all
	./a.out

java:
	javac test.java
	javap -c test.class