%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int object_size_cnt = 0;

%}

%union {
    char *string;
}

%token <string> STRING
%token <string> NUMBER
%token <string> BOOLEAN
%token COLON COMMA LBRACE RBRACE LBRACKET RBRACKET VNULL
%type <string> value
%type <string> array
%type <string> values


%%

object:
    LBRACE members RBRACE 
    ;

members:
    member {object_size_cnt++;}
    | member COMMA members {object_size_cnt++;}
    ;

member:
    STRING COLON value {printf("%s:%s\n", $1, $3); }

    | STRING COLON array { printf("%s: array\n   %s\n", $1, $3); }
    | STRING COLON object { printf("%s: object, object size: %d\n", $1, object_size_cnt); object_size_cnt = 0; }
    ;

value:
    STRING { 
                char *result = malloc(strlen($1) + 20); 
                strcpy(result, " string "); 
                strcat(result, $1);
                $$ = result;
    }
    | NUMBER { 
                char *result = malloc(strlen($1) + 20); 
                strcpy(result, " number "); 
                strcat(result, $1);
                $$ = result;
    }
    | BOOLEAN {
                char *result = malloc(strlen($1) + 20); 
                strcpy(result, " boolean "); 
                strcat(result, $1);
                $$ = result;
    }
    | VNULL { $$ = " null"; }
    ;

array:
    LBRACKET values RBRACKET { $$ = $2 }
    ;


values:
    value { $$ = $1 }
    | value COMMA values{
        char *result = malloc(strlen($$) + 80);
        strcpy(result, $$);
        strcat(result, $3);
        $$ = result;
        free($1)
    }
    ;

%%

main(int argc, char **argv){
    yyparse();
}

void yyerror(const char *s) {
  fprintf(stderr, "錯誤: %s\n", s);
  exit(1);
}