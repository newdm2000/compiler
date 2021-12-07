
%{
#include "symbol.h"
#include "y.tab.h"
#include <math.h>
#include <stdlib.h>
extern double vbltable[26];
extern struct symtab *symlook(char *);
//extern double factorial(double);
%}
%option nounput
%option noinput
%option noyywrap
%%
([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)  {
                  yylval.dval = atof(yytext); return NUMBER;
                }

[\t ]+   ;        /* ignore white space */

[A-Za-z][A-Za-z0-9]*    {      yylval.symp=symlook(yytext); return NAME; }

"$"      { return 0; }    /*  end of input  */
">="	return GE;
"<=" 	return LE;
"=="    return EQ;
"!="    return NE;

"^"   return EXP;
"&"   return LOG;

"%"   return MOD;
"!"   return FAC;
"("   return LEFT;
")"   return RIGHT;

\n       |
.                return yytext[0];
%%
/*
int yywrap(void) {
	return 1;
}
*/
