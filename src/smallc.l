/*
  File:     smallc.l
  Author:   Hu Hu
  Function: lexical analysis file for the small-C complier. Read the input file
            and analze the lexical part. This file includes some fundamental key 
            words such as int and if, return corresponding symbol in syntax tree.
            Also, this file includes some extra key words such as comment. The 
            variable "linecount" is a global variable of this complier, which is 
            the present of the input program line. Rather than standrand IO 
            functions, I used write() and read() to do IO operation. Use lex to 
            complie this file.
  Output:   lex.yy.o
*/
%{
    #include "smallc.tab.h"
    #include <cstdio>
    #include <cstdlib>
    
    int linecount = 1;
    void updatePosition();
    extern "C" {
        int yylex(void);
    }
%}

%x comment

%option noyywrap

%%
"/*" BEGIN(comment);
<comment>{
[^*\n]*
"*"+[^*/\n]*
\n
"*"+"/" BEGIN(INITIAL);
}

0[0-7]* { yylval.mI_Int = strtoul(yytext, NULL, 0); return INT;}
[1-9][0-9]* { yylval.mI_Int =  atoi(yytext); return INT;}
0[Xx][0-9a-fA-F]+ { yylval.mI_Int = strtoul(yytext, NULL, 0); return INT;}

";" { return SEMI;}
"," { return COMMA;}
"." { return DOT;}
"-" { return MINUS;}
"!" { return LOGICALNOT;}
"++" { return PREINC;}
"--" { return PREDEC;}
"~" { return BITNOT;}
"*" { return MUL;}
"/" { return DIV;}
"%" { return MOD;}
"+" { return PLUS;}
"<<" { return SHL;}
">>" { return SHR;}
">" { return GT;}
">=" { return GE;}
"<" { return LT;}
"<=" { return LE;}
"==" { return ET;}
"!=" { return NET;}
"&" { return BITAND;}
"^" { return BITXOR;}
"|" { return BITOR;}
"&&" { return LOGICALAND;}
"||" { return LOGICALOR;}
"=" { return ASSIGN;}
"+=" { return PLUSASSIGN;}
"-=" { return MINUSASSIGN;}
"*=" { return MULASSIGN;}
"/=" { return DIVASSIGN;}
"&=" { return ANDASSIGN;}
"^=" { return XORASSIGN;}
"|=" { return ORASSIGN;}
"<<=" { return SHLASSIGN;}
">>=" { return SHRASSIGN;}

int { return TYPE;}
"(" { return LP;}
")" { return RP;}
"[" { return LB;}
"]" { return RB;}
"{" { return LC;}
"}" { return RC;}

struct { return STRUCT;}
return { return RETURN;}
read {return READ;}
write {return WRITE;}
if { return IF;}
else { return ELSE;}
break { return BREAK;}
continue { return CONT;}
for { return FOR;}

[a-zA-Z_][a-zA-Z_0-9]* { yylval.mS_Id = new std::string(yytext); return ID;}
[\n] { ++linecount;}
[ \t]
"//"(.)*  { }
%%

void updatePosition(){
    yylloc.first_line = linecount;
}
