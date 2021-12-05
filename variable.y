%{
#include <stdio.h>
void yyerror(const char* msg) {
	fprintf(stderr, "%s\n", msg);
}
#include <math.h>
int yylex();
//void yyerror(const char *s);
double vbltable[26];  /* double형의 기억장소 배열 */
%}
%union  {
                double dval;
                int vblno;
        }
%token    <vblno> NAME
%token    <dval> NUMBER
%left   LEFT
%right  RIGHT
%left     '>' '<'
%left GE LE EQ NE  
%left '-' '+'
%left '*' '/'
%left EXP LOG
%nonassoc UMINUS UPLUS
%type <dval> expression
%%
statement_list: statement '\n'
	                |         statement_list statement '\n'	
	;
statement:        NAME '=' expression  { vbltable[$1] = $3; }
	           |   expression                 { printf("= %g\n",$1); }
	 ;
expression: expression '+' expression  { $$ = $1 + $3;  }
//	  | expression '+' {yyerrok; yyerror("right operator doesn't exist"); $$=$1;}
//	  | expression '-' {yyerrok; yyerror("right operator doesn't exist"); $$=$1;}
	            | expression '*' expression  { $$ = $1 * $3;  }
          | expression '-' expression  { $$ = $1 - $3;  }
          | expression '/' expression
                    {  if($3 == 0.0){
                             yyerror("divide by zero");
			     return -1;
			}
                       else   $$ = $1 /$3;
                    }
           |  '-'expression  %prec UMINUS   { $$ = -$2; }
	   |  '+'expression  %prec UPLUS  {$$=$2;}
	   |  LEFT expression RIGHT { $$=$2;}
	   |  LEFT expression   { yyerrok; yyerror("parenthesis matching error"); $$=$2; }
//	   |  expression LEFT   { yyerrok; yyerror("parenthesis matching error"); $$=$1; }
	   |  expression RIGHT {yyerrok; yyerror("parenthesis matching error"); $$=$1;}
//	   |  RIGHT expression {yyerrok; yyerror("parenthesis matching error"); $$=$2;}

           |       NUMBER
           |       NAME       { $$ = vbltable[$1]; }
	   | expression '>' expression { $$ = $1 > $3;  }
	   | expression '<' expression { $$ = $1 < $3;  }
	   | expression GE  expression { $$ = $1 >= $3; }
	   | expression LE  expression { $$ = $1 <= $3; }
	   | expression NE  expression { $$ = $1 != $3; }
	   | expression EQ  expression { $$ = $1 == $3; }
	   | expression EXP expression { $$ = pow($1, $3);}		     
	   | LOG expression {  if ($2==0.0) {
					yyerror("argument zero");
					return -1; }
			       else
			 	$$ = log($2);}           
;
%%
int main()
{
    yyparse();
}
