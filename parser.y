%{
#include <stdio.h>
#include <stdlib.h>
#include "ptypes.h"
int yydebug = 1;
void yyerror(const char*);
%}

%union{
  char *string;
  int   int_value;
  struct molecule_t *molecule;
}

%token EOL "End of Line"
%token OPEN_GROUP "Open atom group"
%token CLOSE_GROUP "Close atom group"
%token <string> ATOM "Atom"
%token <int_value> INTEGER_LITERAL "Integer literal"

%type <molecule> atoms

%destructor { if($$) free($$); } <string>

%%

input: /* empty */
     | input molecule
     ;

molecule: atoms EOL
          { printf("molecule: %s\n", $1->string); }
        ;

atoms: /* empty */
       { $$ = calloc(1, sizeof(struct molecule_t)); }
     | atoms atom
       { printf("appending atom\n"); }
     | atoms atom_group
     ;

atom_group: OPEN_GROUP atoms CLOSE_GROUP INTEGER_LITERAL { printf("atom group\n"); }
          ;

atom: ATOM
      { printf("atom: %s\n", $1); }
    | ATOM INTEGER_LITERAL
      { printf("atom: %s, %d\n", $1, $2); }
    ;

%%

void yyerror (const char *msg)
{
  fprintf(stderr, "%s\n", msg);
}
