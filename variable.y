%{
#include <stdio.h>
void yyerror(const char* msg) {
	fprintf(stderr, "%s\n", msg);
}

int yylex();
void yyerror(const char *s);
double vbltable[26];  /* double형의 기억장소 배열 */
%}
%union  {
                double dval;
                int vblno;
        }
%token    <vblno> NAME
%token    <dval> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS
%type <dval> expression
%%
statement_list: statement '\n'
          |         statement_list statement '\n'
          ;
statement:        NAME '=' expression  { vbltable[$1] = $3; }
          |   expression                 { printf("= %g\n",$1); }
          ;
expression: expression '+' expression  { $$ = $1 + $3;  }
          | expression '-' expression  { $$ = $1 - $3;  }
          | expression '*' expression  { $$ = $1 * $3;  }
          | expression '/' expression
                    {  if($3 == 0.0)
                             yyerror("divide by zero");
			     return -1;
                       else   $$ = $1 /$3;
                    }
           |  '-'expression  %prec UMINUS   { $$ = -$2; }
           |  '('expression')'     { $$ = $2; }
           |       NUMBER
           |       NAME       { $$ = vbltable[$1]; }
           ;
%%
main()
{
    yyparse();
}
