%{
#include <stdio.h>
extern int lineno;
%}

%token KW_PROGRAM KW_VAR KW_PROCEDURE KW_BEGIN KW_END KW_IF KW_THEN KW_ELSE KW_WHILE KW_DO KW_CALL KW_INTEGER
%token UW_NAME NUMBER
%token OP_PLUS OP_MINUS OP_STAR OP_DIV OP_LESS OP_GREAT OP_LP OP_RP OP_WAVE
%token OP_COLON OP_EQU OP_LEQU OP_GEQU OP_NEQU OP_SEMI OP_DOT OP_COMMA OP_AND OP_OR

%%
pl_program: KW_PROGRAM pl_identifier OP_SEMI pl_subprogram {printf("True.\n");}
    ;
pl_subprogram: pl_var_declaration KW_BEGIN pl_statement_list KW_END OP_DOT
    ;
pl_var_declaration: KW_VAR pl_var_declaration_list OP_SEMI
    ;
pl_var_declaration_list: pl_var_list OP_COLON pl_type
    | pl_var_declaration_list OP_SEMI pl_var_list OP_COLON pl_type 
    ;
pl_type: KW_INTEGER
    ;
pl_var_list: pl_var
    | pl_var_list OP_COMMA pl_var
    ;
pl_statement_list: pl_statement
    | pl_statement_list OP_SEMI pl_statement
    ;
pl_statement: pl_assign_statement
    | pl_condition_statement
    | pl_while_statement
    | pl_compound_statement
    ;
pl_assign_statement: pl_var OP_EQU pl_math_expression
    ;
pl_condition_statement: KW_IF pl_relation_expression KW_THEN pl_statement {/*conflict! "else"*/}
    | KW_IF pl_relation_expression KW_THEN pl_statement KW_ELSE pl_statement
    ;
pl_while_statement: KW_WHILE pl_relation_expression KW_DO pl_statement
    ;
pl_compound_statement: KW_BEGIN pl_statement_list KW_END
    ;
pl_math_expression: pl_term
    | pl_math_expression OP_PLUS pl_term 
    | pl_math_expression OP_MINUS pl_term
    ;
pl_term: pl_factor
    | pl_term OP_STAR pl_factor
    | pl_term OP_DIV pl_factor
    ;
pl_factor: pl_var
    | pl_constant
    | OP_LP pl_math_expression OP_RP
    ;
pl_relation_expression: pl_math_expression pl_relation_char pl_math_expression
    | pl_relation_expression pl_op_connection pl_math_expression pl_relation_char pl_math_expression
    ;
pl_var: pl_identifier
    ;
pl_identifier: UW_NAME 
    ;
pl_constant: NUMBER 
    ;
pl_op_connection: OP_AND
    | OP_OR
    ;
pl_relation_char: OP_LESS
    | OP_GREAT
    | OP_LEQU
    | OP_GEQU
    | OP_NEQU
    ;
%%
int main(int argc, char** argv){
    yyparse();
    return 0;
}

yyerror(char* s){
    printf("False! Errorinfo:%d:%s\n", lineno+1, s);
}
