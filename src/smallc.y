/*
  File:     smallc.y
  Author:   Hu Hu
  Function: This file is the core file of this small-C complier. The main() 
            function in this file is the entrance of this complier. In the main()
            function, there are the clear process of the complier, which includes
            the lexical analysis, syntax analysis, semantic checking, intermediate
            code generation, mips code generation. 
            This file mainly does the syntax analysis. It recieve the result of 
            lexical analysis and generate syntax tree of the input program. In 
            the syntax analysis part, I wrote it based on the grammar given in 
            in the instruction, and solved the conflicts.
  Output:   smallc.tab.c, smallc.tab.h, smallc.output
*/
%code requires{
    #include "node.h"
    #include "inter.h"
    #include "intermediate.h"
    #include "mips.h"
}
%{
    #include <fstream>
    #include <stdio.h>
    #include <string>
    #include <vector>
    using namespace std;
    
    extern "C"{
        void yyerror(const char *s);
        extern int yylex(void);
    }
    extern int linecount;
    extern char* yytext;

    struct Node;
    struct SymbolTable;
    struct Intermediate;
    class Instruction;
    class Inter;
    
    Node* root;
    SymbolTable* symbol_table;
    vector<Inter*>* inters;
    vector<Instruction*>* instrs;
%}
%union {
    int mI_Int;
    std::string* mS_Id;
    std::vector<Node*>* gt_NodeVector;
    Node* node;
    struct Variable_ArrayDeclarationInfo* gt_Var_Arr_Dec_Info;
    std::vector<Variable_ArrayDeclarationInfo*>* gt_Var_Arr_Dec_Info_Vector;
    std::vector<std::string>* gt_StringVector;
}

%type <node> EXPS EXP EXTDEF STMT STMTBLOCK PROGRAM
%type <gt_NodeVector> ARRS ARGS INIT DEFS EXTDEFS STMTS
%type <gt_Var_Arr_Dec_Info> VAR
%type <gt_Var_Arr_Dec_Info_Vector> DECS EXTVARS
%type <gt_StringVector> SDEFS SDECS STSPEC SEXTVARS FUNC PARAS

%token <mI_Int> INT
%token <mS_Id> ID
%token SEMI COMMA
%token TYPE
%token STRUCT
%token RETURN
%token IF ELSE
%token BREAK CONT
%token FOR
%token LC RC
%token READ WRITE

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%right ASSIGN PLUSASSIGN MINUSASSIGN MULASSIGN DIVASSIGN ANDASSIGN XORASSIGN ORASSIGN SHLASSIGN SHRASSIGN
%left LOGICALOR
%left LOGICALAND
%left BITOR
%left BITXOR
%left BITAND
%left ET NET
%left GT GE LT LE
%left SHL SHR
%left PLUS MINUS
%left MUL DIV MOD
%right LOGICALNOT PREINC PREDEC BITNOT
%left LP RP LB RB DOT

%start PROGRAM
%%
PROGRAM:    EXTDEFS {
                root = new Node(@$.first_line, Program);
                root->extern_declarations = $1;
            }
 ;
EXTDEFS:    EXTDEFS EXTDEF         {
                $$ = $1;
                if ($2 != NULL) {
                    $$->push_back($2);
                }
            }
            | {
                $$ = new vector<Node*>();
            }
            ;
EXTDEF:     TYPE EXTVARS SEMI {
                if ($2->size() == 0) $$ = NULL;
                else {
                    $$ = new Node(@$.first_line, Declaration);
                    $$->initial_Declaration_Global_Variable_Array($2);
                }
            }
            | STSPEC SEXTVARS SEMI {
                $$ = new Node(@$.first_line, Declaration);
                $$->initial_Declaration_Global_Struct($1, $2);
            }
            | TYPE FUNC STMTBLOCK {
                $$ = new Node(@$.first_line, Function);
                $$->initial_Function($2, $3);
            }
            ;
SEXTVARS:   ID {
                $$ = new vector<string>();
                $$->push_back(*$1);
                delete $1;
            }
            | SEXTVARS COMMA ID {
                $$ = $1;
                $$->push_back(*$3);
                delete $3;
            }
            | {
                $$ = new vector<string>();
            }
            ;
EXTVARS: VAR {
                $$ = new vector<Variable_ArrayDeclarationInfo*>();
                $1->tt_InitList = new vector<Node*>();
                $$->push_back($1);
            }
            | VAR ASSIGN INIT {
                $$ = new vector<Variable_ArrayDeclarationInfo*>();
                $1->tt_InitList = $3;
                $$->push_back($1);
            }
            | EXTVARS COMMA VAR {
                $$ = $1;
                $3->tt_InitList = new vector<Node*>();
                $$->push_back($3);
            }
            | EXTVARS COMMA VAR ASSIGN INIT{
                $$ = $1;
                $3->tt_InitList = $5;
                $$->push_back($3);
            }
            | {
                $$ = new vector<Variable_ArrayDeclarationInfo*>();
            }
            ;
STSPEC:     STRUCT ID LC SDEFS RC {
                $$ = $4;
                $$->push_back(*$2);
                delete $2;
            }
            | STRUCT LC SDEFS RC {
                $$ = $3;
                $$->push_back("#");
            }
            | STRUCT ID {
                $$ = new vector<string>();
                $$->push_back(*$2);
                delete $2;
            }
            ;
FUNC:        ID LP PARAS RP {
                $$ = $3;
                $$->push_back(*$1);
                delete $1;
            }
            ;
PARAS:      PARAS COMMA TYPE ID {
                $$ = $1;
                $$->push_back(*$4);
                delete $4;
            }
            | TYPE ID {
                $$ = new vector<string>();
                $$->push_back(*$2);
                delete $2;
            }
            | {
                $$ = new vector<string>();
            }
            ;
STMTBLOCK:  LC DEFS STMTS RC {
                $$ = new Node(@$.first_line, Statement);
                $$->initial_Statement_StmtBlock($2, $3);
            }
            ;
STMTS:       STMTS STMT {
                $$ = $1;
                $$->push_back($2);
            }
            | {
                $$ = new vector<Node*>();
            }
            ;
STMT:       EXP SEMI {
                $$ = $1;
            }
            | STMTBLOCK {
                $$ = $1;
            }
            | RETURN EXP SEMI {
                $$ = new Node(@$.first_line, Statement);
                $$->initial_Statement_Return($2);
            }
            | IF LP EXP RP STMT %prec LOWER_THAN_ELSE {
                $$ = new Node(@$.first_line, Statement);
                $$->initial_Statement_if ($3, $5);
            }
            | IF LP EXP RP STMT ELSE STMT {
                $$ = new Node(@$.first_line, Statement);
                $$->initial_Statement_IfElse($3, $5, $7);
            }
            | FOR LP EXP SEMI EXP SEMI EXP RP STMT {
                $$ = new Node(@$.first_line, Statement);
                $$->initial_Statement_For($3, $5, $7, $9);
            }
            | CONT SEMI {
                $$ = new Node(@$.first_line, Statement);
                $$->tem_StatementType = Stmt_Continue;
            }
            | BREAK SEMI {
                $$ = new Node(@$.first_line, Statement);
                $$->tem_StatementType = Stmt_Break;
            }
            | READ LP EXP RP SEMI {
                $$ = new Node(@$.first_line, Statement);
                $$->tem_StatementType = Stmt_Read;
                $$->io_Expression = $3;
            }
            | WRITE LP EXP RP SEMI {
                $$ = new Node(@$.first_line, Statement);
                $$->tem_StatementType = Stmt_Write;
                $$->io_Expression = $3;
            }
            ;
DEFS:       DEFS TYPE DECS SEMI {
                $$ = $1;
                Node* temp = new Node(@2.first_line,Declaration);
                temp->initial_Declaration_Local_Variable_Array($3);
                $$->push_back(temp);
            }
            | DEFS STSPEC SDECS SEMI {
                $$ = $1;
                Node* temp = new Node(@2.first_line, Declaration);
                temp->initial_Declaration_Local_Struct($2, $3);
                $$->push_back(temp);
            }
            | {
                $$ = new vector<Node*>();
            }
            ;
SDEFS:      SDEFS TYPE SDECS SEMI {
                $$ = $1;
                for(int i=0; i<$3->size(); ++i) {
                    $1->push_back((*$3)[i]);
                }
                delete $3;
            }
            | {
                $$ = new vector<string>();
            }
            ;
SDECS:      SDECS COMMA ID {
                $$ = $1;
                $$->push_back(*$3);
                delete $3;
            }
            | ID {
                $$ = new vector<string>();
                $$->push_back(*$1);
                delete $1;
            }
            ;
DECS:       VAR {
                $$ = new vector<Variable_ArrayDeclarationInfo*>();
                $1->tt_InitList = new vector<Node*>();
                $$->push_back($1);
            }
            | DECS COMMA VAR {
                $$ = $1;
                $3->tt_InitList = new vector<Node*>();
                $$->push_back($3);
            }
            | VAR ASSIGN INIT {
                $$ = new vector<Variable_ArrayDeclarationInfo*>();
                $1->tt_InitList = $3;
                $$->push_back($1);
            }
            | DECS COMMA VAR ASSIGN INIT {
                $$ = $1;
                $3->tt_InitList = $5;
                $$->push_back($3);
            }
            ;
VAR:        ID {
                $$ = new Variable_ArrayDeclarationInfo();
                $$->ms_Name = *$1; delete $1;
            }
            | VAR LB INT RB {
                $$ = $1;
                $$->tt_ArrayDeclarationSubscriptList.push_back($3);
            }
            ;
INIT:       EXP {
                $$ = new vector<Node*>();
                $$->push_back($1);
            }
            | LC ARGS RC {
                $$ = $2;
            }
            ;
EXP:        EXPS { 
                $$ = $1;
            }
            | { 
                $$ = NULL;
            }
            ;
EXPS:       EXPS MUL EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_MUL, $3);
            }
            | EXPS DIV EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_DIV, $3);
            }
            | EXPS MOD EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_MOD, $3);
            }
            | EXPS PLUS EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_PLUS, $3);
            }
            | EXPS MINUS EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_MINUS, $3);
            }
            | EXPS SHL EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_SHL, $3);
            }
            | EXPS SHR EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_SHR, $3);
            }
            | EXPS GT EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_GT, $3);
            }
            | EXPS GE EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_GE, $3);
            }
            | EXPS LT EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_LT, $3);
            }
            | EXPS LE EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_LE, $3);
            }
            | EXPS ET EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_ET, $3);
            }
            | EXPS NET EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_NET, $3);
            }
            | EXPS BITAND EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_BITAND, $3);
            }
            | EXPS BITXOR EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_BITXOR, $3);
            }
            | EXPS BITOR EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_BITOR, $3);
            }
            | EXPS LOGICALAND EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_LOGICALAND, $3);
            }
            | EXPS LOGICALOR EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_BinaryOp($1, OP_LOGICALOR, $3);
            }
            | EXPS ASSIGN EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, $3);
            }
            | EXPS PLUSASSIGN EXPS {
                Node* temp = new Node(@$.first_line, Expression);
                temp->initial_Expression_BinaryOp($1, OP_PLUS, $3);
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, temp);
            }
            | EXPS MINUSASSIGN EXPS {
                Node* temp = new Node(@$.first_line, Expression);
                temp->initial_Expression_BinaryOp($1, OP_MINUS, $3);
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, temp);
            }
            | EXPS MULASSIGN EXPS {
                Node* temp = new Node(@$.first_line, Expression);
                temp->initial_Expression_BinaryOp($1, OP_MUL, $3);
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, temp);     
            }
            | EXPS DIVASSIGN EXPS {
                Node* temp = new Node(@$.first_line, Expression);
                temp->initial_Expression_BinaryOp($1, OP_DIV, $3);
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, temp);
            }
            | EXPS ANDASSIGN EXPS {
                Node* temp = new Node(@$.first_line, Expression);
                temp->initial_Expression_BinaryOp($1, OP_BITAND, $3);
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, temp);
            }
            | EXPS XORASSIGN EXPS {
                Node* temp = new Node(@$.first_line, Expression);
                temp->initial_Expression_BinaryOp($1, OP_BITXOR, $3);
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, temp);
            }
            | EXPS ORASSIGN EXPS {
                Node* temp = new Node(@$.first_line, Expression);
                temp->initial_Expression_BinaryOp($1, OP_BITOR, $3);
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, temp);
            }
            | EXPS SHLASSIGN EXPS {
                Node* temp = new Node(@$.first_line, Expression);
                temp->initial_Expression_BinaryOp($1, OP_SHL, $3);
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, temp);
            }
            | EXPS SHRASSIGN EXPS {
                Node* temp = new Node(@$.first_line, Expression);
                temp->initial_Expression_BinaryOp($1, OP_SHR, $3);
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Assign($1, temp);
            }
            | MINUS EXPS %prec LOGICALNOT {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_UnaryOp(OP_MINUS, $2);
            }
            | LOGICALNOT EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_UnaryOp(OP_LOGICALNOT, $2);
            }
            | BITNOT EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_UnaryOp(OP_BITNOT, $2);
            }
            | PREINC EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_UnaryAssign(OP_PREINC, $2);
            }
            | PREDEC EXPS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_UnaryAssign(OP_PREDEC, $2);
            }
            | LP EXPS RP {
                $$ = $2;
            }
            | ID LP ARGS RP {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_FunctionCall($1, $3);
            }
            | ID ARRS {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Variable_Array($1, $2);
            }
            | ID DOT ID {
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_StructMember($1, $3);
            }
            | INT { 
                $$ = new Node(@$.first_line, Expression);
                $$->initial_Expression_Int($1);
            }
            ;
ARRS:       ARRS LB EXP RB {
                $$ = $1;
                $$->push_back($3);
            }
            | { 
                $$ = new vector<Node*>();
            }
            ;
ARGS:       ARGS COMMA EXP {
                $$ = $1;
                $1->push_back($3);
            }
            | EXP {
                $$ = new vector<Node*>();
                if ($1!=NULL)$$->push_back($1);
            }
            ;
%%
void yyerror(const char *s)
{
    fprintf(stderr, "[line %d]: %s %s\n", yylloc.first_line, s, yytext);
}

// core function of the complier
int main(int argc, char **argv)
{
    if (argc != 3) {
        printf("\033[1mInput Error!\033[0m\n");
        printf("You should assign the input file and output file.\n");
        return -1;
    }
    extern FILE* yyin;
    yyin = fopen(argv[1] ,"r");
    
    // syntax analysis
    if (yyparse() != 0) {
        printf("\033[1mParsing Error!\033[0m\n");
        return -1;
    }
    
    // semantic analysis
    inters = new vector<Inter*>();
    instrs = new vector<Instruction*>(); 
    if (!generate_intermediates(symbol_table, inters, root, instrs)) {
        cout << "\033[1mSemantic Error!\033[0m" << endl;
        return 0;
    }

    // intermediate code generate
    ofstream fout("InterCode");
    for(auto it = inters->begin(); it != inters->end(); ++it) {
        fout << **it;
        delete (*it);
    }

    // mips code generate
    ofstream ffout(argv[2]);
    for(auto it = instrs->begin(); it != instrs->end(); ++it) {
        ffout << **it;
        delete(*it);
    }
    
    fclose(yyin);
    fout.close();
    ffout.close();
    return 0;
}

