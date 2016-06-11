all: 
	flex lex.l
	bison -y -d syntax.y
	g++ -std=c++11 lex.yy.c y.tab.c

exec: all
	./a.out

java:
	javac test.java
	javap -c test.class

error: 
	bison --verbose syntax.y

custom:
	flex lex.l
	bison -y -d syntax.y
	echo "#include <vector> \nusing namespace std;" | cat - y.tab.h > temp && mv temp y.tab.h
	g++ -std=c++11 lex.yy.c y.tab.c

jasmine:
	java -jar ./jasmin-1.1/jasmin.jar "$1"

jasmine_temp:
	java -jar ./jasmin-1.1/jasmin.jar output.j

exec_jasm: exec jasmine_temp