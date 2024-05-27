%{
#include "grammer.tab.h"
#include <string.h>

%}

%%

[ \t\n]           ;
\"[^"]*\" { yylval.string = strdup(yytext); return STRING; }
:                 return COLON;
,                 return COMMA;
\{                return LBRACE;
\}                return RBRACE;
\[                return LBRACKET;
\]                return RBRACKET;
true              return TRUE;
false             return FALSE;
-?[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)? { return NUMBER; }
null              return VNULL;

%%

int yywrap() {
    return 1;
}
