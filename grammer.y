%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
%}

%union {
    char *string;
}

%token <string> STRING
%token COLON COMMA LBRACE RBRACE LBRACKET RBRACKET TRUE FALSE NUMBER VNULL

%%


object:
    LBRACE members RBRACE { printf("object"); }
    ;

members:
    member
    | member COMMA members
    ;

member:
    STRING COLON value { printf("%s, ", $1); }
    ;

value:
    STRING { printf("string "); }
    | NUMBER { printf("number "); }
    | TRUE { printf("boolean "); }
    | FALSE { printf("boolean "); }
    | object
    | array
    | VNULL { printf("null"); }
    ;

array:
    LBRACKET values RBRACKET { printf("array "); }
    ;

values:
    value
    | value COMMA values
    ;

%%

main(int argc, char **argv){
    yyparse();
}

void yyerror(const char *s) {
  fprintf(stderr, "錯誤: %s\\n", s);
  exit(1);
}