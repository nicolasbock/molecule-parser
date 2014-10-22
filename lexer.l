%{
#include "parser.h"
%}

%%

[A-Z][a-z]{0,1} { yylval.string = strdup(yytext); return ATOM; }
[0-9]+          { yylval.int_value = strtol(yytext, NULL, 10); return INTEGER_LITERAL; }
[ \t]           /* Skip. */
\n              { return EOL; }
