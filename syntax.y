%{
#include <fstream>
#include <iostream>
#include <map>
#include <cstring>

#include <stdio.h>
#include <unistd.h>


#include "bytecode_inst.h"

#define GetCurrentDir getcwd

using namespace std;

extern  int yylex();
//extern  int yyparse();
extern  FILE *yyin;
void yyerror(const char * s);
extern int lineCounter;

#define TRUE 1
#define FALSE 0
string outfileName ;

ofstream fout("output.j");	/* file for writing output */
void generateHeader(void);	/* generate useless header for class to be able to compile the code*/
void generateFooter(void);	/* generate useless header for class to be able to compile the code*/

int varaiblesNum = 1; 	/* new variable will be issued this number, java starts with 1, 0 is 'this' */
int labelsCount = 0;	/* to generate labels */

typedef enum {INT_T, FLOAT_T, BOOL_T, VOID_T, ERROR_T} type_enum;

map<string, pair<int,type_enum> > symbTab;


void printLineNumber(int num)
{
	fout<<".line "<<num<<endl;
}

void cast (string x, int type_t1);
void arithCast(int from , int to, string op);
void relaCast(string op,char * nTrue, char * nFalse);

bool checkId(string id);
string getOp(string op);
void defineVar(string name, int type);

string genLabel();
//char *strdup (const char *s) throw ();

%}

%start method_body

%union{
	int ival;
	float fval;
	int bval;
	char * idval;
	char * aopval;
	struct {
		int sType;
	} expr_type;
	struct {
		char * nTrue;
		char * nFalse;
	} bexpr_type;
	struct {
		char * next;
	} stmt_type;
	struct {
		char * next;
		char * begin;
	}while_type;
	int sType;
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

%type <sType> primitive_type
%type <expr_type> expression
%type <bexpr_type> b_expression
%type <stmt_type> statement
%type <stmt_type> statement_list
%type <stmt_type> if
%type <while_type> while

%type <bexpr_type> b_expr_temp

%% 
method_body: 
	{	generateHeader();
		$<stmt_type>$.next = "retL";
	}
	statement_list
	{generateFooter();}
	;
statement_list: 
	{
		$<stmt_type>$.next = $<stmt_type>0.next;
	}
	 statement 
	| 
	{
	  	$<stmt_type>$.next = strdup(genLabel().c_str()); 	//generate label for statement and assign it to statement list next
	}
	statement_list 
	{
		$<stmt_type>$.next = $<stmt_type>0.next;
		fout<<$<stmt_type>1.next<<":"<<endl;	//mark statement with statement list next label
	}
	statement 
	;

statement: 
	declaration
	| 
	{
		$<stmt_type>$.next = $<stmt_type>0.next;
	}
	if
	| 
	{
		$<stmt_type>$.next = $<stmt_type>0.next;
	}
	while
	| assignment
	| system_print
	;
declaration: 
	primitive_type IDENTIFIER SEMI_COLON /* implement multi-variable declaration */
	{
		string str($2);
		if($1 == INT_T)
		{
			defineVar(str,INT_T);
		}else if ($1 == FLOAT_T)
		{
			defineVar(str,FLOAT_T);
		}
	}
	;
primitive_type: 
	INT_WORD {$$ = INT_T;}
	| FLOAT_WORD {$$ = FLOAT_T;}
	|BOOLEAN_WORD {$$ = BOOL_T;}
	;
if: 
	{
		$<stmt_type>$.next = $<stmt_type>0.next;
	}
	IF_WORD LEFT_BRACKET 
	{
		$<bexpr_type>$.nTrue = strdup(genLabel().c_str());
		$<bexpr_type>$.nFalse = strdup(genLabel().c_str());
	}
	b_expression 
	RIGHT_BRACKET LEFT_BRACKET_CURLY 
	{
		fout<<$<bexpr_type>4.nTrue<<":"<<endl;
		$<stmt_type>$.next = $<stmt_type>1.next;
	}
	statement 
	{
		fout<<"goto "<<$<stmt_type>1.next<<endl;
	}
	RIGHT_BRACKET_CURLY 
	ELSE_WORD LEFT_BRACKET_CURLY 
	{
		fout<<$<bexpr_type>4.nFalse<<":"<<endl;
		$<stmt_type>$.next = $<stmt_type>1.next;
	}
	statement 
	RIGHT_BRACKET_CURLY
	{$$ = $<stmt_type>0;}
	;
while:
	{
		$<while_type>$.next = $<stmt_type>0.next;
		$<while_type>$.begin = strdup(genLabel().c_str());
		fout<<$<while_type>$.begin<<":"<<endl;
	} 
	WHILE_WORD LEFT_BRACKET
	{
		$<bexpr_type>$.nTrue = strdup(genLabel().c_str());
		$<bexpr_type>$.nFalse = $<while_type>1.next;
	}
	b_expression
	RIGHT_BRACKET LEFT_BRACKET_CURLY 
	{
		fout<<$<bexpr_type>4.nTrue<<":"<<endl;
		$<stmt_type>$.next = $<stmt_type>1.next;
	}
	statement 
	RIGHT_BRACKET_CURLY
	{
		fout<<"goto "<<$<while_type>1.begin;
	}
	{$$ = $<while_type>1;}
	;
assignment: 
	IDENTIFIER EQUALS expression SEMI_COLON
	{
		string str($1);
		/* after expression finishes, its result should be on top of stack. 
		we just store the top of stack to the identifier*/
		if(checkId(str))
		{
			if($3.sType == symbTab[str].second)
			{
				if($3.sType == INT_T)
				{
					fout<<"istore "<<symbTab[str].first<<endl;
				}else if ($3.sType == FLOAT_T)
				{
					fout<<"fstore "<<symbTab[str].first<<endl;
				}
			}
			else
			{
				cast(str,$3.sType);	/* do casting */
			}
		}else{
			string err = "identifier: "+str+" isn't declared in this scope";
			yyerror(err.c_str());
		}
	}
	;
expression: 
	FLOAT 	{$$.sType = FLOAT_T; fout<<"ldc "<<$1<<endl;}
	| INT 	{$$.sType = INT_T;  fout<<"ldc "<<$1<<endl;} 
	| expression ARITH_OP expression	{arithCast($1.sType, $3.sType, string($2));}
	| IDENTIFIER {
		string str($1);
		if(checkId(str))
		{
			$$.sType = symbTab[str].second;
			if(symbTab[str].second == INT_T)
			{
				fout<<"iload "<<symbTab[str].first<<endl;
			}else if (symbTab[str].second == FLOAT_T)
			{
				fout<<"fload "<<symbTab[str].first<<endl;
			}
		}
		else
		{
			string err = "identifier: "+str+" isn't declared in this scope";
			yyerror(err.c_str());
			$$.sType = ERROR_T;
		}
	}
	| LEFT_BRACKET expression RIGHT_BRACKET {$$.sType = $2.sType;}
	;
system_print:
	SYSTEM_OUT LEFT_BRACKET expression RIGHT_BRACKET SEMI_COLON
	{
		if($3.sType == INT_T)
		{
			/* expression is at top of stack now */
			fout<<"istore "<< symbTab["1syso_int_var"].first << endl;
			/* save it at the predefined temp syso var */
			fout<<"getstatic      java/lang/System/out Ljava/io/PrintStream;";
			/* call syso */
			fout<<"iload "<< symbTab["1syso_int_var"].first << endl;
			/*insert param*/
			fout<<"invokevirtual java/io/PrintStream/println(I)V"<<endl;
			/*invoke syso*/

		}else if ($3.sType == FLOAT_T)
		{
			fout<<"fstore "<< symbTab["1syso_float_var"].first << endl;
			fout<<"getstatic      java/lang/System/out Ljava/io/PrintStream;";
			fout<<"iload "<< symbTab["1syso_int_var"].first << endl;
			fout<<"invokevirtual java/io/PrintStream/println(F)V"<<endl;
		}
	}
	;
b_expr_temp: {
		string lab1 = genLabel(),lab2 = genLabel();
		$$.nTrue = strdup(lab1.c_str());
		$$.nFalse = strdup(lab2.c_str());
	};
b_expression:
	BOOL
	{
		$$ = $<bexpr_type>0;
		if($1)
		{
			/* bool is 'true' */
			fout<<"goto "<<$$.nTrue<<endl;
		}else
		{
			fout<<"goto "<<$$.nFalse<<endl;
		}
	}
	| expression RELA_OP expression		
	{$$ = $<bexpr_type>0;relaCast(string($2),$$.nTrue,$$.nFalse);}
	/*|expression RELA_OP BOOL 	// to be considered */ 

	|b_expr_temp
	b_expression
	BOOL_OP 
	{
		$<bexpr_type>$ = $<bexpr_type>0;
		if(!strcmp($3, "&&"))
		{
			fout<<$<bexpr_type>0.nTrue<<":"<<endl;
		}
		else if(! strcmp($3,"||"))
		{
			fout<<$<bexpr_type>0.nFalse<<":"<<endl;
		}
		$<bexpr_type>$.nTrue = $<bexpr_type>0.nTrue;
		$<bexpr_type>$.nFalse = $<bexpr_type>0.nFalse;
	}
	b_expression
	{
		$$ = $<bexpr_type>0;
		if(!strcmp($3, "&&"))
		{
			fout<<$<bexpr_type>1.nFalse<<": goto "<<$$.nFalse<<endl;	/* dummy jump to next expression */
		}else if (!strcmp($3,"||"))
		{
			fout<<$<bexpr_type>1.nTrue<<": goto "<<$$.nTrue<<endl;
		}
	}	
	
	;
%%





/*------------------------------separator------------------------------------------------*/

main (int argv, char * argc[])
{
	FILE *myfile;
	if(argv == 1) 
	{
		myfile = fopen("input_code.txt", "r");
		outfileName = "input_code.txt";
	}
	else 
	{
		myfile = fopen(argc[2], "r");
		outfileName = string(argc[2]);
	}
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
	fout<<".source "<<outfileName<<endl;
	fout<<".class public test\n.super java/lang/Object"<<endl<<endl; //code for defining class
	fout<<".method public <init>()V"<<endl<<"aload_0"<<endl<<"invokenonvirtual java/lang/Object/<init>()V"<<endl<<"return"<<endl<<".end method"<<endl<<endl;
	fout<<".method public static main([java/lang/String)V"<<endl;
	fout<<".limit locals 100\n.limit stack 100"<<endl;

	/* generate temporal vars for syso*/
	defineVar("1syso_int_var",INT_T);
	defineVar("1syso_float_var",FLOAT_T);

	/*generate line*/
	fout<<".line 1"<<endl;
}

void generateFooter()
{
	fout<<"retL:"<<endl;
	fout<<"return"<<endl;
	fout<<".end method"<<endl;
}

void cast (string str, int t1)
{
	yyerror("casting not implemented yet :)");
}

void arithCast(int from , int to, string op)
{
	if(from == to)
	{
		if(from == INT_T)
		{
			fout<<"i"<<getOp(op)<<endl;
		}else if (from == FLOAT_T)
		{
			fout<<"f"<<getOp(op)<<endl;
		}
	}
	else
	{
		yyerror("cast not implemented yet");
	}
}

/*"=="|"!="|">"|">="|"<"|"<="*/
void relaCast(string op,char * nTrue, char * nFalse)
{
	fout << getOp(op)<< " "<<nTrue<<endl;
	fout << "goto "<<nFalse<<endl;
}
string getOp(string op)
{
	if(inst_list.find(op) != inst_list.end())
	{
		return inst_list[op];
	}
	return "";
}

bool checkId(string op)
{
	return (symbTab.find(op) != symbTab.end());
}

void defineVar(string name, int type)
{
	if(checkId(name))
	{
		string err = "variable: "+name+" declared before";
		yyerror(err.c_str());
	}else
	{
		if(type == INT_T)
		{
			fout<<"iconst_0\nistore "<<varaiblesNum<<endl;
		}
		else if ( type == FLOAT_T)
		{
			fout<<"fconst_0\nfstore "<<varaiblesNum<<endl;	
		}
		symbTab[name] = make_pair(varaiblesNum++,(type_enum)type);
	}
}

string genLabel()
{
	return "L_"+to_string(labelsCount++);
}
/*
char *strdup (const char *s) {
    char *d = (char *) malloc (strlen (s) + 1);   // Space for length plus nul
    if (d == NULL) return NULL;          // No memory
    strcpy (d,s);                        // Copy the characters
    return d;                            // Return the new string
}
*/