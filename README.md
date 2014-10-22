Parse molecule strings
----------------------

This parser implementation parses a string representing a molecule and groups
elements. For example, the string

~~~~
(C2H2)2NH3
~~~~

Gets parsed into

~~~~
molecule (canonical form C4H4N1H3): 4:C 7:H 1:N
~~~~
