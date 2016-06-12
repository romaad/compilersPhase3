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

custom_run: all
	./a.out test5
	java -jar ./jasmin-1.1/jasmin.jar output.j
	java test

jasmine:
	java -jar ./jasmin-1.1/jasmin.jar "$1"

jasmine_temp:
	java -jar ./jasmin-1.1/jasmin.jar output.j

run:
	java test

exec_jasm: exec jasmine_temp run