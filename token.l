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
true|false       { yylval.string = strdup(yytext); return BOOLEAN; }
-?[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)? { yylval.string = strdup(yytext); return NUMBER; }
null              return VNULL;

%%