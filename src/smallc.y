/*

*/
%{
    #include <cstdio>
    #include <cstdlib>
    #include "lex.yy.c"
    #include "semanticAnalysis.h"
    #include "intermediateCodeGen.h"
    
    Node *root;
    void yyerror(const char *msg);
%}
%union {
    struct Node *node;
    char *string;
}

%type <node> PROGRAM EXTDEFS EXTDEF EXTVARS STSPEC SEXTVARS VAR FUNC PARAS SDEFS 
%type <node> STMTBLOCK STMTS STMT DEFS DECS INIT EXPS EXP ARRS ARGS SDECS

%token <string> INT ID TYPE STRUCT RETURN IF ELSE BREAK CONT FOR READ WRITE
%token <string> SEMI COMMA
%token <string> LC RC

%token <string> ASSIGN_EQUAL ASSIGN_PLUS ASSIGN_MINUS ASSIGN_MULTI ASSIGN_DIV ASSIGN_AND ASSIGN_XOR ASSIGN_OR ASSIGN_SHL ASSIGN_SHR 
%token <string> LOG_OR LOG_AND BI_OR BI_XOR BI_AND EQUAL NOT_EQUAL GREAT_THAN LESS_THAN NOT_GREAT_THAN NOT_LESS_THAN SHL SHR PLUS MINUS MULTI DIV MOD NOT MINUS_ONE PLUS_ONE REVERSE LP RP LB RB DOT

%nonassoc LTIF
%nonassoc ELSE

%right ASSIGN_EQUAL ASSIGN_PLUS ASSIGN_MINUS ASSIGN_MULTI ASSIGN_DIV ASSIGN_AND ASSIGN_XOR ASSIGN_OR ASSIGN_SHL ASSIGN_SHR
%left LOG_OR
%left LOG_AND
%left BI_OR
%left BI_XOR
%left BI_AND
%left EQUAL NOT_EQUAL
%left GREAT_THAN LESS_THAN NOT_GREAT_THAN NOT_LESS_THAN
%left SHL SHR
%left PLUS MINUS
%left MULTI DIV MOD
%right NOT MINUS_ONE PLUS_ONE REVERSE
%left LP RP LB RB DOT

%start PROGRAM
%%
PROGRAM     : EXTDEFS {
                root = $$ = newNode(linecount, "PROGRAM", 1, $1);
            }
            ;
EXTDEFS     : EXTDEF EXTDEFS {
                $$ = newNode(linecount, "EXTDEFS", 2, $1, $2);
            }
            | {
                $$ = newNode(linecount, "EXTDEFS", 1, newNode(linecount, "NULL", 0));
            }
            ;
EXTDEF      : TYPE EXTVARS SEMI {
                $$ = newNode(linecount, "EXTDEF", 2, newNode(linecount, "TYPE", 1, newNode(linecount, "INT", 0)), $2);
            }
            | STSPEC SEXTVARS SEMI {
                $$ = newNode(linecount, "EXTDEF", 2, $1, $2);
            }
            | TYPE FUNC STMTBLOCK {
                $$ = newNode(linecount, "EXTDEF", 3, newNode(linecount, "TYPE", 1, newNode(linecount, "INT", 0)), $2, $3);
            }
            ;
SEXTVARS    : ID {
                $$ = newNode(linecount, "SEXTVARS", 1, newNode(linecount, $1, 0));
            }
            | ID COMMA SEXTVARS {
                $$ = newNode(linecount, "SEXTVARS", 3, newNode(linecount, $1, 0), newNode(linecount, $2, 0), $3);
            }
            | {
                $$ = newNode(linecount, "SEXTVARS", 1, newNode(linecount, "NULL", 0));
            }
            ;
EXTVARS     : VAR {
                $$ = newNode(linecount, "SEXTVARS", 1, $1);
            }
            | VAR ASSIGN_EQUAL INIT {
                $$ = newNode(linecount, "SEXTVARS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | VAR COMMA EXTVARS {
                $$ = newNode(linecount, "SEXTVARS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | VAR ASSIGN_EQUAL INIT COMMA EXTVARS {
                $$ = newNode(linecount, "SEXTVARS", 5, $1, newNode(linecount, $2, 0), $3, newNode(linecount, $4, 0), $5);
            } 
            | {
                $$ = newNode(linecount, "SEXTVARS", 1, newNode(linecount, "NULL", 0));
            }
            ;
STSPEC      : STRUCT ID LC SDEFS RC {
                $$ = newNode(linecount, "STSPEC", 5, newNode(linecount, $1, 0), newNode(linecount, $2, 0), newNode(linecount, $3, 0), $4, newNode(linecount, $5, 0));
            }
            | STRUCT LC SDEFS RC {
                $$ = newNode(linecount, "STSPEC", 4, newNode(linecount, $1, 0), newNode(linecount, $1, 0), $3, newNode(linecount, $4, 0));
            }
            | STRUCT ID {
                $$ = newNode(linecount, "STSPEC", 2, newNode(linecount, $1, 0), newNode(linecount, $2, 0));
            }
            ;
FUNC        : ID LP PARAS RP {
                $$ = newNode(linecount, "FUNC", 4, newNode(linecount, $1, 0), newNode(linecount, $2, 0), $3, newNode(linecount, $4, 0));
            }
            ;
PARAS       : TYPE ID COMMA PARAS {
                $$ = newNode(linecount, "PARAS", 4, newNode(linecount, $1, 0), newNode(linecount, $2, 0), newNode(linecount, $3, 0), $4);
            }
            | TYPE ID {
                $$ = newNode(linecount, "PARAS", 2, newNode(linecount, $1, 0), newNode(linecount, $2, 0));
            }
            | {
                $$ = newNode(linecount, "PARAS", 1, newNode(linecount, "NULL", 0));
            }
            ;
STMTBLOCK   : LC DEFS STMTS RC {
                $$ = newNode(linecount, "STMTBLOCK", 4, newNode(linecount, $1, 0), $2, $3, newNode(linecount, $4, 0));
            }
            ;
STMTS       : STMT STMTS {
                $$ = newNode(linecount, "STMTS", 2, $1, $2);
            }
            | {
                $$ = newNode(linecount, "STMTS", 1, newNode(linecount, "NULL", 0));
            }
            ;
STMT        : EXP SEMI {
                $$ = newNode(linecount, "STMT", 2, $1, newNode(linecount, $2, 0));
            }
            | STMTBLOCK {
                $$ = newNode(linecount, "STMT", 1, $1);
            }
            | RETURN EXP SEMI {
                $$ = newNode(linecount, "STMT", 3, newNode(linecount, $1, 0), $2, newNode(linecount, $3, 0));
            }
            | IF LP EXP RP STMT %prec LTIF {
                $$ = newNode(linecount, "STMT", 5, newNode(linecount, $1, 0), newNode(linecount, $2, 0), $3, newNode(linecount, $4, 0), $5);
            }
            | IF LP EXP RP STMT ELSE STMT {
                $$ = newNode(linecount, "STMT", 7, newNode(linecount, $1, 0), newNode(linecount, $2, 0), $3, newNode(linecount, $4, 0), $5, newNode(linecount, $6, 0), $7);
            }
            | FOR LP EXP SEMI EXP SEMI EXP RP STMT {
                $$ = newNode(linecount, "STMT", 9, newNode(linecount, $1, 0), newNode(linecount, $2, 0), $3, newNode(linecount, $4, 0), newNode(linecount, $4, 0), $5, newNode(linecount, $6, 0), $7, newNode(linecount, $8, 0), $9);
            }
            | CONT SEMI {
                $$ = newNode(linecount, "STMT", 2, newNode(linecount, $1, 0), newNode(linecount, $2, 0));
            }
            | BREAK SEMI {
                $$ = newNode(linecount, "STMT", 2, newNode(linecount, $1, 0), newNode(linecount, $2, 0));
            }
            | READ LP EXPS RP {
                $$ = newNode(linecount, "STMT", 4, newNode(linecount, $1, 0), newNode(linecount, $2, 0), $3, newNode(linecount, $4, 0));
            }
            | WRITE LP EXPS RP {
                $$ = newNode(linecount, "STMT", 4, newNode(linecount, $1, 0), newNode(linecount, $2, 0), $3, newNode(linecount, $4, 0));
            }
            ;
DEFS        : TYPE DECS SEMI DEFS {
                $$ = newNode(linecount, "DEFS", 4, newNode(linecount, $1, 0), $2, newNode(linecount, $3, 0), $4);
            }
            | STSPEC SDECS SEMI DEFS {
                $$ = newNode(linecount, "DEFS", 4, $1, $2, newNode(linecount, $3, 0), $4);
            }
            | {
                $$ = newNode(linecount, "DEFS", 1, newNode(linecount, "NULL", 0));
            }
            ;
SDEFS       : TYPE SDECS SEMI SDEFS {
                $$ = newNode(linecount, "SDEFS", 4, newNode(linecount, $1, 0), $2, newNode(linecount, $3, 0), $4);
            }
            | {
                $$ = newNode(linecount, "SDEFS", 1, newNode(linecount, "NULL", 0));
            }
            ;
SDECS       : ID COMMA SDECS {
                $$ = newNode(linecount, "SDECS", 3, newNode(linecount, $1, 0), newNode(linecount, $2, 0), $3);
            }
            | ID {
                $$ = newNode(linecount, "SDECS", 1, newNode(linecount, $1, 0));
            }
            ;
DECS        : VAR {
                $$ = newNode(linecount, "DECS", 1, $1);
            }
            | VAR COMMA DECS {
                $$ = newNode(linecount, "DECS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | VAR ASSIGN_EQUAL INIT COMMA DECS {
                $$ = newNode(linecount, "DECS", 5, $1, newNode(linecount, $2, 0), $3, newNode(linecount, $4, 0), $5);
            }
            | VAR ASSIGN_EQUAL INIT {
                $$ = newNode(linecount, "DECS", 3, $1, newNode(linecount, $2, 0), $3);
            } 
VAR         : ID {
                $$ = newNode(linecount, "VAR", 1, newNode(linecount, $1, 0));
            }
            | VAR LB INT RB {
                $$ = newNode(linecount, "VAR", 4, $1, newNode(linecount, $2, 0), newNode(linecount, $3, 0), newNode(linecount, $4, 0));
            }
INIT        : EXP {
                $$ = newNode(linecount, "INIT", 1, $1);
            }
            | LC ARGS RC {
                $$ = newNode(linecount, "INIT", 3, newNode(linecount, $1, 0), newNode(linecount, $3, 0));
            }
            ;
EXP         : EXPS {
                $$ = newNode(linecount, "EXP", 1, $1);
            }
            | {
                $$ = newNode(linecount, "EXP", 1, newNode(linecount, "NULL", 0));
            }
            ;
EXPS        : EXPS MULTI EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS DIV EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS MOD EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS PLUS EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS MINUS EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS SHL EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS SHR EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS GREAT_THAN EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS LESS_THAN EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS NOT_GREAT_THAN EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS NOT_LESS_THAN EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS EQUAL EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS NOT_EQUAL EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS BI_AND EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS BI_OR EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS BI_XOR EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS LOG_AND EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS LOG_OR EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_EQUAL EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_PLUS EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_MINUS EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_MULTI EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_DIV EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_AND EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_XOR EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_OR EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_SHR EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXPS ASSIGN_SHL EXPS {
                $$ = newNode(linecount, "EXPS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | MINUS EXPS {
                $$ = newNode(linecount, "EXPS", 2, newNode(linecount, $1, 0), $2);
            }
            | NOT EXPS {
                $$ = newNode(linecount, "EXPS", 2, newNode(linecount, $1, 0), $2);
            }
            | REVERSE EXPS {
                $$ = newNode(linecount, "EXPS", 2, newNode(linecount, $1, 0), $2);
            }
            | PLUS_ONE EXPS {
                $$ = newNode(linecount, "EXPS", 2, newNode(linecount, $1, 0), $2);
            }
            | MINUS_ONE EXPS {
                $$ = newNode(linecount, "EXPS", 2, newNode(linecount, $1, 0), $2);
            }
            | LP EXPS RP {
                $$ = newNode(linecount, "EXPS", 3, newNode(linecount, $1, 0), $2, newNode(linecount, $3, 0));
            }
            | ID LP ARGS RP {
                $$ = newNode(linecount, "EXPS", 4, newNode(linecount, $1, 0), newNode(linecount, $2, 0), $3, newNode(linecount, $4, 0));
            }
            | ID ARRS {
                $$ = newNode(linecount, "EXPS", 2, newNode(linecount, $1, 0), $2);
            }
            | ID DOT ID {
                $$ = newNode(linecount, "EXPS", 3, newNode(linecount, $1, 0), newNode(linecount, $2, 0), newNode(linecount, $3, 0));
            } 
            | INT {
                $$ = newNode(linecount, "EXPS", 1, newNode(linecount, $1, 0));
            } 
            ;
ARRS        : LB EXP RB ARRS {
                $$ = newNode(linecount, "ARRS", 4, newNode(linecount, $1, 0), $2, newNode(linecount, $3, 0), $4);
            }
            | {
                $$ = newNode(linecount, "ARRS", 1, newNode(linecount, "NULL", 0));
            }
            ;
ARGS        : EXP COMMA ARGS {
                $$ = newNode(linecount, "ARGS", 3, $1, newNode(linecount, $2, 0), $3);
            }
            | EXP {
                $$ = newNode(linecount, "ARGS", 1, $1);
            }
            ;

%%

int yywrap() {
    return 1;
}

void yyerror(const char *msg) {
    fflush(stdout);
    fprintf(stderr, "Error[%d]: %s, %s\n", linecount, msg, yytext);
}

int main(int argc, char *argv[]) 
{
    if (argc != 3) {
        printf("Input Error!\n");
        printf("You should assign the input file and output file.\n");
        return -1;
    }
    
    yyin = fopen(argv[1] ,"r");
    yyout = fopen(argv[2], "w");
    
    if (yyparse() != 0) {
        printf("Parsing Error!\n");
        return -1;
    }
    
    /*Print parse tree to check whether parsing is correct*/
    /*printParseTree(root);*/
    
    semanticAnalysis(root);

    /*intermediateCodeGen(root);*/
    
    /*mipsCodeGen();*/
    
    fclose(yyin);
    fclose(yyout);
    
    return 0;
}
