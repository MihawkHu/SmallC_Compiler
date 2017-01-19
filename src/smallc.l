/*
  File Name: smallc.l
  Destination OutputFile: lex.yy.c
  This program is the source file of the lexical analyzer for SMALLC.
  It can be compiled and run alone if you delete the omit symbols
  that wrap the print languages.
  More often, it is used together with smallc.y to build a syntax 
  analyzer and return the tokens to the syntax analyzer.
*/
%{
    #include "smallc.tab.h"
    #include <cstdio>
    #include <cstdlib>

    extern "C" {
        int yylex(void);
    }

    int linecount = 1;
    void updatePosition();
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
