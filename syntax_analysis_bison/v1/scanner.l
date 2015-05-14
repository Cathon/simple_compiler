/*KW=keyword,UW=userword,OP=operater*/
%{
#include "scanner.tab.h"
int lineno = 0;
%}

number          [0-9]+
variable        [A-Za-z][a-zA-Z0-9]*

%x COM
%%
"//"[^\n]*\n    lineno++;//eat out one-line comment
"/*"            BEGIN(COM);
<COM>\n         lineno++;
<COM>.          ;
<COM>"*/"       BEGIN (INITIAL);//eat out block comment

[\040\t]        ;//eat out white space
\n              lineno++;
program         return KW_PROGRAM;
var             return KW_VAR;
procedure       return KW_PROCEDURE;
begin           return KW_BEGIN;
end             return KW_END;
if              return KW_IF;
then            return KW_THEN;
else            return KW_ELSE;
while           return KW_WHILE;
do              return KW_DO;
call            return KW_CALL;
integer         return KW_INTEGER;

{variable}      return UW_NAME;
{number}        return NUMBER;//Notice! Only nonpositive number is ok1

"+"             return OP_PLUS; 
"-"             return OP_MINUS;
"*"             return OP_STAR;
"/"             return OP_DIV;
"<"             return OP_LESS;
">"             return OP_GREAT;
"("             return OP_LP;
")"             return OP_RP;
"~"             return OP_WAVE;
":"             return OP_COLON;
":="            return OP_EQU;
"<="            return OP_LEQU;
">="            return OP_GEQU;
"<>"            return OP_NEQU;
"&&"            return OP_AND;
"||"            return OP_OR;
";"             return OP_SEMI;
"."             return OP_DOT;
","             return OP_COMMA;
%%
