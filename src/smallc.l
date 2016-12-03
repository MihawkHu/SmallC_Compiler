/*

*/
%{
    #include <cstdio>
    #include <cstdlib>
    #include "y.tab.h"
    #include "parseTree.h"
    
    int linecount = 1;
%}
digit [0-9]
digits {digit}+
number {digits}|(0(x|X)[0-9a-fA-F]+)|(0[0-7]+)
int  -{number}|{number}
id [a-zA-Z_][a-zA-Z0-9_]*
semi ";"
comma ","

type int
lp "("
rp ")"
lb "["
rb "]"
lc "{"
rc "}"
struct struct
return return 
if if
else else 
break break
cont continue
for for

dot "."
minus "-"
not "!"
plusOne "++"
minusOne "--"
reverse "~"
multi "*"
div "/"
mod "%"
plus "+"
shiftLeft "<<"
shiftRight ">>"
greatThan ">"
notLessThan ">="
lessThan "<"
notGreatThan "<="
equal "=="
notEqual "！="
biAnd "&"
biXor "^"
biOr "|"
logAnd "&&"
logOr "||"

assignEqual "="
assignPlus "+="
assignMinus "-="
assignMulti "*="
assignDiv "/="
assignAnd "&="
assignXor "^="
assignOr "|="
assignSHL "<<="
assignSHR ">>="

read read
write write
whiteSpace [ \t\v\r\f]+
newline [\n]

%%
{int} {yylval.string = strdup(yytext); return INT;}
{semi} {yylval.string = strdup(yytext); return SEMI;}
{comma} {yylval.string = strdup(yytext); return COMMA;}
{type} {yylval.string = strdup(yytext); return TYPE;}
{lp} {yylval.string = strdup(yytext); return LP;}
{rp} {yylval.string = strdup(yytext); return RP;}
{lb} {yylval.string = strdup(yytext); return LB;}
{rb} {yylval.string = strdup(yytext); return RB;}
{lc} {yylval.string = strdup(yytext); return LC;}
{rc} {yylval.string = strdup(yytext); return RC;}
{struct} {yylval.string = strdup(yytext); return STRUCT;}
{return} {yylval.string = strdup(yytext); return RETURN;}
{if} {yylval.string = strdup(yytext); return IF;}
{else} {yylval.string = strdup(yytext); return ELSE;}
{break} {yylval.string = strdup(yytext); return BREAK;}
{cont} {yylval.string = strdup(yytext); return CONT;}
{for} {yylval.string = strdup(yytext); return FOR;}

{dot} {yylval.string = strdup(yytext); return DOT;}
{minus} {yylval.string = strdup(yytext); return MINUS;}
{not} {yylval.string = strdup(yytext); return NOT;}
{plusOne} {yylval.string = strdup(yytext); return PLUS_ONE;}
{minusOne} {yylval.string = strdup(yytext); return MINUS_ONE;}
{reverse} {yylval.string = strdup(yytext); return REVERSE;}
{multi} {yylval.string = strdup(yytext); return MULTI;}
{div} {yylval.string = strdup(yytext); return DIV;}
{mod} {yylval.string = strdup(yytext); return MOD;}
{plus} {yylval.string = strdup(yytext); return PLUS;}
{shiftLeft} {yylval.string = strdup(yytext); return SHL;}
{shiftRight} {yylval.string = strdup(yytext); return SHR;}
{greatThan} {yylval.string = strdup(yytext); return GREAT_THAN;}
{notLessThan} {yylval.string = strdup(yytext); return NOT_LESS_THAN;}
{lessThan} {yylval.string = strdup(yytext); return LESS_THAN;}
{notGreatThan} {yylval.string = strdup(yytext); return NOT_GREAT_THAN;}
{equal} {yylval.string = strdup(yytext); return EQUAL;}
{notEqual} {yylval.string = strdup(yytext); return NOT_EQUAL;}
{biAnd} {yylval.string = strdup(yytext); return BI_AND;}
{biXor} {yylval.string = strdup(yytext); return BI_XOR;}
{biOr} {yylval.string = strdup(yytext); return BI_OR;}
{logAnd} {yylval.string = strdup(yytext); return LOG_AND;}
{logOr} {yylval.string = strdup(yytext); return LOG_OR;}

{assignEqual} {yylval.string = strdup(yytext); return ASSIGN_EQUAL;}
{assignPlus} {yylval.string = strdup(yytext); return ASSIGN_PLUS;}
{assignMinus} {yylval.string = strdup(yytext); return ASSIGN_MINUS;}
{assignMulti} {yylval.string = strdup(yytext); return ASSIGN_MULTI;}
{assignDiv} {yylval.string = strdup(yytext); return ASSIGN_DIV;}
{assignAnd} {yylval.string = strdup(yytext); return ASSIGN_AND;}
{assignXor} {yylval.string = strdup(yytext); return ASSIGN_XOR;}
{assignOr} {yylval.string = strdup(yytext); return ASSIGN_OR;}
{assignSHL} {yylval.string = strdup(yytext); return ASSIGN_SHL;}
{assignSHR} {yylval.string = strdup(yytext); return ASSIGN_SHR;}
{read} {yylval.string = strdup(yytext); return READ;}
{write} {yylval.string = strdup(yytext); return WRITE;}
{id} {yylval.string = strdup(yytext); return ID;}
{whiteSpace} {;}
{newline} {linecount++;}
%%


