%{
  const PNet = require('pnet');
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
":="                  return ':='
":"                   return ':'
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
    : Scope EOF { return $1; }
    ;

Scope
    : '{' Scopes '}' { $$ = new PNet.Scopes($2); }
    | ID ':=' Function { $$ = new PNet.Declaration($1, $3); }
    | ARC '(' ID ':' ID ':' NUMBER ')' { $$ = new PNet.Arc($3, $5, $7); }
    ;

Scopes
    :  { $$ = null; }
    | Scope Scopes { $$ = {val:$1, next:$2}; }
    ;

Function
    : PLACE '(' NUMBER ':' Label ')' { $$ = new PNet.Place($3, $5); }
    | TRANSITION '(' Label ')' { $$ = new PNet.Transition($3); }
    | SEQUENCE '(' NUMBER ':' Label ')' { $$ = new PNet.Sequence($3, $5); }
    ;

Label
    : ID { $$ = $1; }
    | NULL { $$ = null; }
    |  { $$ = null; }
    ;