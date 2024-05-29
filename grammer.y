%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int obj_sz = 0;
int arr_sz = 0;

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
        char *result = malloc((strlen($1) + 10) * sizeof(char)); 
        strcpy(result, " string "); 
        strcat(result, $1);
        $$ = result;
    }
    | NUMBER { 
        char *result = malloc((strlen($1) + 10) * sizeof(char)); 
        strcpy(result, " number "); 
        strcat(result, $1);
        $$ = result;
    }
    | BOOLEAN {
        char *result = malloc((strlen($1) + 10) * sizeof(char)); 
        strcpy(result, " boolean "); 
        strcat(result, $1);
        $$ = result;
    }
    | VNULL { $$ = " null"; }
    | array
    | object
    ;

object:
    LBRACE members RBRACE {
        char *result = malloc(20 * sizeof(char));
        strcpy(result, " object size: ");
        char *num = malloc(5 * sizeof(char));
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
    ;


array:
    LBRACKET values RBRACKET { 
        char *result = malloc((strlen($2) + 20) * sizeof(char));
        strcpy(result, $2);
        strcat(result, " array size: ");
        char *num = malloc(5 * sizeof(char));
        itoa(arr_sz, num, 10);
        strcat(result, num);
        $$ = result;
        arr_sz = 0;
    }
    ;


values:
    value { arr_sz++; $$ = $1 }
    | value COMMA values{
        arr_sz++;
        char *result = malloc(1000 * sizeof(char));
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

yyerror(const char *s){
    fprintf(stderr, "錯誤: %s\n", s);
}