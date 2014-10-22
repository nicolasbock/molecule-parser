#ifndef __PTYPES_H
#define __PTYPES_H

/** The atom data structure. */
struct atom_t
{
  /** The atom name. */
  char *name;

  /** The number of this kind of atom. */
  int number;
};

/** The molecule data structure. */
struct molecule_t
{
  /** The string representation of the molecule. */
  char *string;

  /** The list of atoms. */
  struct atom_t *atoms;
};

#endif
