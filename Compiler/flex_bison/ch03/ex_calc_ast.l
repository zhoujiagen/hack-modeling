%option noyywrap nodefault yylineno

%{
#include "ex_calc_ast.h"
#include "ex_calc_ast.tab.h"
%}

/* float exponent */
EXP	([Ee][-+]?[0-9]+)

%%
"+" |
"-" |
"*" |
"/" |
"|" |
"(" |
")"                     { return yytext[0]; }
[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}?        { yylval.d = atof(yytext); return NUMBER; }

\n                      { return EOL; }
"//".*  
[ \t]                   { /* ignore white space */ }
.	                      { yyerror("Mystery character %c\n", *yytext); }

%%
