
%{
#include "y.tab.h"
#include <math.h>
#include <stdlib.h>
extern double vbltable[26];
%}
%option nounput
%option noinput
%%
([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)  {
                  yylval.dval = atof(yytext); return NUMBER;
                }

[\t ]+   ;        /* ignore white space */

[A-Za-z][A-Za-z0-9]+    {      yylval.vblno = yytext[0] - 'a'; return NAME; }

"$"      { return 0; }    /*  end of input  */
">="	return GE;
"<=" 	return LE;
"=="    return EQ;
"!="    return NE;

"^"   return EXP;
"&"   return LOG;

"("   return LEFT;
")"   return RIGHT;

\n       |
.                return yytext[0];
%%

int yywrap(void) {
	return 1;
}



