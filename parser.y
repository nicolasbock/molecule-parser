%{
#include <stdio.h>
int yydebug = 1;
void yyerror(const char*);
%}

%union{
  char *string;
  int   int_value;
}

%token EOL "End of Line"
%token <string> ATOM "Atom"
%token <int_value> INTEGER_LITERAL "Integer literal"

%destructor { if($$) free($$); } <string>

%%

input: /* empty */
     | input atom
     ;

atom: ATOM EOL { printf("atom: %s\n", $1); }
    | ATOM INTEGER_LITERAL EOL
      { printf("atom: %s, %d\n", $1, $2); }
    ;

%%

void yyerror (const char *msg)
{
  fprintf(stderr, "%s\n", msg);
}
