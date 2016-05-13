%{
#include<stdio.h>
#include<unistd.h>
#define GetCurrentDir getcwd
extern  int yylex();
//extern  int yyparse();
extern  FILE *yyin;
void yyerror(const char * s);
#define TRUE 1
#define FALSE 0
extern int lineCounter;
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

%% 
method_body: 
	{printf("arrived at method body \n");}
	statement_list
	;
statement_list: 
	statement 
	| statement_list statement
	;
statement: 
	declaration
	| if
	| while
	| {printf("assignment\n");} assignment
	;
declaration: 
	{printf("declaration\n");} primitive_type IDENTIFIER SEMI_COLON
	;
primitive_type: 
	INT_WORD 
	| FLOAT_WORD {printf("lola\n");}
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
	do{
		yyparse();
	}while(!feof(yyin));
	getchar();
}

void yyerror(const char * s)
{
	printf("error@%d: %s\n",lineCounter, s);
}