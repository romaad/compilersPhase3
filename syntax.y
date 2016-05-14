%{
#include <fstream>
#include <iostream>
#include <map>

#include <stdio.h>
#include <unistd.h>
#define GetCurrentDir getcwd

using namespace std;

extern  int yylex();
//extern  int yyparse();
extern  FILE *yyin;
void yyerror(const char * s);
extern int lineCounter;

#define TRUE 1
#define FALSE 0


ofstream fout("output.j");	/* file for writing output */
void generateHeader(void);	/* generate useless header for class to be able to compile the code*/
void generateFooter(void);	/* generate useless header for class to be able to compile the code*/

int varaiblesNum = 2; 	/* new variable will be issued this number, java starts with 2 */

void printLineNumber(int num)
{
	fout<<".line "<<num<<endl;
}

%}

%start method_body

%union{
	int ival;
	float fval;
	int bval;
	char * idval;
	char * aopval;
	char * ropval;
	char * bopval;
}

%token <ival> INT
%token <fval> FLOAT
%token <bval> BOOL
%token <idval> IDENTIFIER
%token <aopval> ARITH_OP
%token <aopval> RELA_OP
%token <aopval> BOOL_OP

%token IF_WORD
%token ELSE_WORD
%token WHILE_WORD
%token FOR_WORD

%token INT_WORD
%token FLOAT_WORD
%token BOOLEAN_WORD

%token SEMI_COLON
%token EQUALS

%token LEFT_BRACKET
%token RIGHT_BRACKET
%token LEFT_BRACKET_CURLY
%token RIGHT_BRACKET_CURLY

%token SYSTEM_OUT

%% 
method_body: 
	{generateHeader();}
	statement_list
	{generateFooter();}
	;
statement_list: 
	statement 
	| statement_list statement {cout<<" arrived here"<<endl;}
	;
statement: 
	declaration
	| if
	| while
	| assignment	{cout<<"assign"<<endl;}
	| system_print
	;
declaration: 
	primitive_type IDENTIFIER SEMI_COLON /* implement multi-variable declaration */
	;
primitive_type: 
	INT_WORD 
	| FLOAT_WORD
	;
if: 
	IF_WORD LEFT_BRACKET expression RIGHT_BRACKET LEFT_BRACKET_CURLY statement RIGHT_BRACKET_CURLY ELSE_WORD LEFT_BRACKET_CURLY statement RIGHT_BRACKET_CURLY
	;
while: 
	WHILE_WORD LEFT_BRACKET expression RIGHT_BRACKET LEFT_BRACKET_CURLY statement RIGHT_BRACKET_CURLY
	;
assignment: 
	IDENTIFIER EQUALS expression SEMI_COLON
	;
expression: 
	FLOAT
	| INT
	| BOOL
	| expression ARITH_OP expression
	| expression BOOL_OP expression
	| expression RELA_OP expression
	| IDENTIFIER
	| LEFT_BRACKET expression RIGHT_BRACKET
	;
system_print:
	SYSTEM_OUT LEFT_BRACKET expression RIGHT_BRACKET SEMI_COLON
%%

main ()
{
	FILE *myfile = fopen("input_code.txt", "r");
	if (!myfile) {
		printf("I can't open input code file!\n");
		char cCurrentPath[200];
		 if (!GetCurrentDir(cCurrentPath, sizeof(cCurrentPath)))
		     {
		     return -1;
		     }
		printf("%s\n",cCurrentPath);  
				getchar();

		return -1;

	}
	yyin = myfile;
	yyparse();
	//getchar();
}

void yyerror(const char * s)
{
	printf("error@%d: %s\n",lineCounter, s);
}

void generateHeader()
{
	fout<<".class test\n.super java/lang/Object"<<endl; //code for defining class
	fout<<".method public static main([java/lang/String)V"<<endl;
}

void generateFooter()
{
	fout<<".end method"<<endl;
}