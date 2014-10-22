%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ptypes.h"
int yydebug = 1;
void yyerror(const char*);
struct molecule_t* insert_atom(struct molecule_t*, const struct atom_t*);
struct molecule_t * merge_molecules(struct molecule_t*, const struct molecule_t*);
%}

%union{
  char *string;
  int   int_value;
  struct atom_t *atom;
  struct molecule_t *molecule;
}

%token EOL "End of Line"
%token OPEN_GROUP "Open atom group"
%token CLOSE_GROUP "Close atom group"
%token <string> ATOM "Element name"
%token <int_value> INTEGER_LITERAL "Integer literal"

%type <atom> atom
%type <molecule> molecule atoms atom_group

%printer
{
  if($$) { fprintf(yyoutput, "%s", $$); }
} <string>
%printer
{
  fprintf(yyoutput, "%d", $$);
} <int_value>
%printer
{
  struct atom_t *atom;
  if($$)
  {
    if($$->name)
    {
      for(atom = $$; atom != NULL; atom = atom->next)
      {
        fprintf(yyoutput, "%s%d", atom->name, atom->number);
      }
    }
    else
    {
      fprintf(yyoutput, "no atoms");
    }
  }
  else
  {
    fprintf(yyoutput, "NULL");
  }
} <atom>
%printer
{
  if($$)
  {
    if($$->name)
    {
      fprintf(yyoutput, "%s", $$->name);
    }
    else
    {
      fprintf(yyoutput, "no name");
    }
  }
  else
  {
    fprintf(yyoutput, "NULL");
  }
} <molecule>

%destructor { if($$) free($$); } <string>

%%

input: /* empty */
     | input molecule
     ;

molecule: atoms EOL
          {
            struct atom_t *atom;
            if($1)
            {
              if($1->atoms)
              {
                printf("molecule (canonical form %s):", $1->name);
                for(atom = $1->atoms; atom != NULL; atom = atom->next)
                {
                  printf(" %d:%s", atom->number, atom->name);
                }
                printf("\n");
              }
              else
              {
                printf("empty molecule\n");
              }
            }
            else
            {
              printf("NULL\n");
            }
            $$ = $1;
          }
        ;

atom_group: OPEN_GROUP atoms CLOSE_GROUP INTEGER_LITERAL
            {
              struct atom_t *atom;
              $$ = $2;
              if($$->atoms)
              {
                for(atom = $$->atoms; atom != NULL; atom = atom->next)
                {
                  atom->number *= $4;
                }
              }
            }
          ;

atoms: /* empty */
       {
         $$ = calloc(1, sizeof(struct molecule_t));
       }
       | atoms atom
       {
         $$ = insert_atom($1, $2);
       }
     | atoms atom_group
       {
         $$ = merge_molecules($1, $2);
       }
     ;

atom: ATOM
      {
        $$ = calloc(1, sizeof(struct atom_t));
        $$->name = strdup($1);
        $$->number = 1;
      }
    | ATOM INTEGER_LITERAL
      {
        $$ = calloc(1, sizeof(struct atom_t));
        $$->name = strdup($1);
        $$->number = $2;
      }
    ;

%%

void yyerror (const char *msg)
{
  fprintf(stderr, "%s\n", msg);
  exit(1);
}

/** Insert a new atom into the atom list. If the atom already has an entry,
 * increment the atom count for this atom. This function modifies the
 * molecule.
 *
 * @param molecule The molecule to insert into.
 * @param atom The atom to insert.
 * @return The new molecule.
 */
struct molecule_t *
insert_atom (struct molecule_t *molecule, const struct atom_t *atom)
{
  struct atom_t *current_atom;
  char *temp;
  if(molecule->atoms == NULL)
  {
    molecule->atoms = calloc(1, sizeof(struct atom_t));
    current_atom = molecule->atoms;
  }
  else
  {
    for(current_atom = molecule->atoms;
        current_atom != NULL;
        current_atom = current_atom->next)
    {
      if(strcmp(current_atom->name, atom->name) == 0) break;
      if(current_atom->next == NULL)
      {
        current_atom->next = calloc(1, sizeof(struct atom_t));
        current_atom = current_atom->next;
        break;
      }
    }
  }
  current_atom->name = atom->name;
  current_atom->number += atom->number;
  temp = calloc(1000, sizeof(char));
  if(!molecule->name)
  {
    molecule->name = calloc(1, sizeof(char));
  }
  snprintf(temp, 1000, "%s%s%d",
    molecule->name, atom->name, atom->number);
  if(molecule->name) free(molecule->name);
  molecule->name = temp;
  return molecule;
}

/** Merge two molecules into the first one. Entries with identical atoms are
 * added together. This function modifies the molecule.
 *
 * @param molecule The molecule to merge into.
 * @param molecule_2 The molecule to merge.
 * @return The new molecule.
 */
struct molecule_t *
merge_molecules (struct molecule_t *molecule, const struct molecule_t *molecule_2)
{
  struct atom_t *current_atom;
  if(molecule_2)
  {
    if(molecule_2->atoms)
    {
      for(current_atom = molecule_2->atoms;
          current_atom != NULL;
          current_atom = current_atom->next)
      {
        molecule = insert_atom(molecule, current_atom);
      }
    }
  }
  return molecule;
}
