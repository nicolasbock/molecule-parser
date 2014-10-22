#ifndef __PTYPES_H
#define __PTYPES_H

/** The atom data structure. */
struct atom_t
{
  /** The atom name. */
  char *name;

  /** The number of this kind of atom. */
  int number;

  /** Pointer to next atom in list. */
  struct atom_t *next;
};

/** The molecule data structure. */
struct molecule_t
{
  /** The molecule string representation (as read from the input). */
  char *name;

  /** The molecule atom decomposition. */
  struct atom_t *atoms;
};

#endif
