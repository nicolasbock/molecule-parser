%{
#include "parser.h"
%}

%%

"("             { return OPEN_GROUP; }
")"             { return CLOSE_GROUP; }
[A-Z][a-z]{0,1} { yylval.string = strdup(yytext); return ATOM; }
[0-9]+          { yylval.int_value = strtol(yytext, NULL, 10); return INTEGER_LITERAL; }
[ \t]           /* Skip. */
\n              { return EOL; }
