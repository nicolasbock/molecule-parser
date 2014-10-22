Parse molecule strings
----------------------

This parser implementation parses a string representing a molecule and groups
elements. For example, the string

~~~~
(C2H2)2NH3
~~~~

Gets parsed into

~~~~
4 C
7 H
2 N
~~~~
