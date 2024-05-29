%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int obj_sz = 0;

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
%type <string> object

%start json

%%

json:
    | value
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
    | VNULL { $$ = "null"; }
    | array
    | object
    ;

object:
    LBRACE members RBRACE {
        char *result = malloc(20);
        strcpy(result, " object size: ");
        char *num;
        itoa(obj_sz, num, 10);
        strcat(result, num);
        $$ = result;
        obj_sz = 0;
    }
    ;

members:
    member {obj_sz++;}
    | member COMMA members {obj_sz++;}
    ;

member:
    STRING COLON value {printf("%s:%s\n", $1, $3); }

    // | STRING COLON array { printf("%s: array\n   %s\n", $1, $3); }
    // | STRING COLON object { printf("%s: object, object size: %d\n", $1, obj_sz); obj_sz = 0; }
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