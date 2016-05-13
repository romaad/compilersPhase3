%{
	#include "y.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	int lineCounter = 1;
%}
letter  [a-zA-Z]
digit [0-9]
digits {digit}+
id {letter}({letter}|{digit})*
num {digits}
fnum {digits}.{digits}("E"{digits}+)?
relop "=="|"!="|">"|">="|"<"|"<="
boolop "&&"|"&"|"||"|"|"
op "+"|"-"|"*"|"/"|"%"
binary "true"|"false"
%%
"if"	{return IF_WORD;}
"else"	{return ELSE_WORD;}
"while"	{return WHILE_WORD;}
"for"	{return FOR_WORD;}
"int"	{printf("int\n");return INT_WORD;}
"float"	{printf("float\n");return FLOAT_WORD;}
"boolean" {return BOOLEAN_WORD;}
{num}	{printf("num\n");yylval.ival = atoi(yytext); return INT;}
{fnum}	{printf("floa numt\n");yylval.fval = atof(yytext); return FLOAT;}
{op}	{printf("op");yylval.aopval = strdup(yytext); return ARITH_OP;}
{relop} {printf("relop\n");yylval.ropval = strdup(yytext); return RELA_OP;}
{boolop} {printf("boolop\n");yylval.bopval = strdup(yytext); return BOOL_OP;}
{binary} {printf("binary\n");if(!strcmp(yytext,"true")){ yylval.bval = 1;} else { yylval.bval = 0;} return BOOL;}
{id}	{printf("id\n");yylval.idval = strdup(yytext);return IDENTIFIER;}
";" {return SEMI_COLON;}
"=" {return EQUALS;}
"(" { return LEFT_BRACKET;}
")" {return RIGHT_BRACKET;}
"{" {return LEFT_BRACKET_CURLY;}
"}" {return RIGHT_BRACKET_CURLY;}
\n	{++lineCounter;}
%%


int yywrap() {
   // open next reference or source file and start scanning
   return 0;
}

/*
main()
{
	yylex();
}
*/