/*need add uw to a list && func for searching*/
%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#define UW_ID           1   //id of words defined by programer
#define KW_ID           2   //id of words defined by language
#define NUM_ID          3   //id of number defined by programer
#define OP_ID           4   //id of some common operators
#define ERRORCODE       250 //signal of error

#define KW_PROGRAM      1
#define KW_VAR          2
#define KW_PROCEDURE    3
#define KW_BEGIN        4
#define KW_END          5
#define KW_IF           6
#define KW_THEN         7
#define KW_ELSE         8
#define KW_WHILE        9
#define KW_DO           10
#define KW_CALL         11

#define UW_NAME         12  //name of variable quantity
#define NUMBER          13  //numbers

#define OP_PLUS         21  //  +
#define OP_MINUS        22  //  -
#define OP_STAR         23  //  *
#define OP_DIV          24  //  /
#define OP_LESS         25  //  <
#define OP_GREAT        26  //  >
#define OP_LP           27  //  (
#define OP_RP           28  //  )
#define OP_WAVE         29  //  ~
#define OP_EQU          30  //  :=
#define OP_LEQU         31  //  <=
#define OP_GEQU         32  //  >=
#define OP_NEQU         33  //  !=
#define OP_SEMI         34  //  ;
#define OP_DOT          35  //  .
#define OP_COMMA        36  //  ,
#define OP_COLON        37  //  :

int wordnum = 0;
char str[100][20];
%}
number          [+]?[0-9]+
variable        [_A-Za-z][_a-zA-Z0-9]*

%x COM
%%
"//"[^\n]*\n    return -1;//eat out one-line comment
"/*"            BEGIN(COM);
<COM>\n         return -1;
<COM>.          return -1;
<COM>"*/"       BEGIN (INITIAL);//eat out block comment

[\040\t\n]      return -1;//eat out white space
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

{variable}      return UW_NAME;
{number}        return NUMBER;

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
";"             return OP_SEMI;
"."             return OP_DOT;
","             return OP_COMMA;

.               return ERRORCODE;
%%
void main(int argc, char **argv){
    if(argc >= 2){
        if ((yyin = fopen(argv[1], "r")) == NULL){
            printf("Cannot open file %s\n", argv[1]);
            exit(0);
        }
    }else{
        yyin = stdin;
    }

    int c;
    while(c = yylex()){

        if (c == -1) continue;
        if(c <= 11 && c >= 1){
            /*key words*/
            printf("(%d %d %s) \n", KW_ID, c, yytext);
        }else if(c == UW_NAME){
            /*variable*/
            if (yyleng > 8) {
                printf("(ERROR: %s is too long) \n", yytext);
                continue;
            }
            int pos = findInWordList(yytext);
            if (pos == -1){
                pos = insertIntoWordList(yytext);
            }
            if (pos != -1){
                /*from 1 on*/
                printf("(%d %d %s) \n", UW_ID, pos, yytext);
            }else{
                /*"defined too much variable quantity.*/
                printf("Error tmvq.\n");
            }
        }else if(c == NUMBER){
            /*numbers*/
            printf("(%d %s) \n", NUM_ID, yytext);
        }else if(c < 40 && c > 20){
            /*operators*/
            printf("(%d %s) \n",c , yytext);
        }else if(c == 250){
            /*error(undefined)*/
            printf("ERROR(\"%s\") \n", yytext);
        }
    }
}

int findInWordList(char *word){
    int i = 0;
    for(i=0; i<wordnum; i++){
        if(strcmp(str[i], word) == 0){
            return i+1;
        }
    }
    return -1;
}

int insertIntoWordList(char *word){
    if(wordnum >=99 ) return -1;
    strcpy(str[wordnum], word);
    wordnum++;
    return wordnum;
}
