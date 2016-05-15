#ifndef _____BYTE_CODE_INSTRUCTIONS
#define _____BYTE_CODE_INSTRUCTIONS

#include <map>
using namespace std;

/* list of mnemonics that corresponds to specific operators */
map<string,string> inst_list = {
	/* arithmetic operations */
	{"+", "add"},
	{"-", "sub"},
	{"/", "div"},
	{"*", "mul"},
	{"|", "or"},
	{"&", "and"},
	{"%", "rem"},

	/* relational op */
	{"==", "ifcmpeq"},
	{"<=", "ifcmple"},
	{">=", "ifcmpge"},
	{"!=", "ifcmpne"},
	{">",  "ifcmpgt"},
	{"<",  "ifcmplt"}
};

#endif