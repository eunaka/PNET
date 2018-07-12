%{
  const Tree = require('tree');
%}

%lex
%%
(" "|\n)+          /* skip whitespace */
"Net"                 return 'NET'
"Place"               return 'PLACE'
"Transition"          return 'TRANSITION'
"Arc"                 return 'ARC'
"Sequence"            return 'SEQUENCE'
"null"                return 'NULL'
[A-Za-z][A-Za-z0-9]*  return 'ID'
[0-9]+                return 'NUMBER'
":="                  return 'DEF'
":"                   return 'COLON'
"{"                   return '{'
"}"                   return '}'
"["                   return '['
"]"                   return ']'
"("                   return '('
")"                   return ')'
"'"                   return 'APOS'
"#"                   return 'COMMENT'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

%start init

%% /* language grammar */

init
    : PETRINET EOF { return $1; }
    ;

PETRINET
    : Escope { $$ = new Tree.Net($1); }
    ;

Escope
    : Escope Escope { $$ = {this: $1, next: $2}; }
    | ID DEF Function { $$ = new Tree.Declaration($1, $3); }
    | ARC '(' ID COLON ID COLON NUMBER ')' { $$ = new Tree.Arc($3, $5, $7); }
    ;

Function
    : PLACE '(' NUMBER COLON ID ')' { $$ = new Tree.Place($3, $5); }
    | TRANSITION '(' ID ')' { $$ = new Tree.Transition($3); }
    | TRANSITION '(' NULL ')' { $$ = {type: 'TRANSITION', label: undefined}; }
    | NET '(' ID ')' { $$ = {type: 'NET', id: $3}; }
    | SEQUENCE '(' NUMBER COLON Type COLON Type ')' { $$ = {type: 'SEQUENCE', token: $3, in: $5, out: $7}; }
    ;

Type
    : PLACE { $$ = 'PLACE'; }
    | TRANSITION { $$ = 'TRANSITION'; }
    ;