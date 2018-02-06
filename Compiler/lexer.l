%{
#include "node.hpp"
#include "parser.hpp"
#define TOKEN(t) (yylval.token = t)
  
unsigned int lineno = 1;

extern "C" int yywrap() { }
%}

whitespace [ \t]
newline [\n]

%%
{whitespace}  ;
{newline}		lineno++;
"+"        		return '+';
"-"       		return '-';
">"        		return '>';
"<"        		return '<';
"."        		return '.';
","        		return ',';
"["         	return '[';
"]"         	return ']';
"="				return '=';  
"LOAD"			return 'LOAD';
"ADD"			return 'ADD';
"SUB"			return 'SUB';
"OR"			return 'OR';
"XOR"			return 'XOR';
"BRA"			return 'BRA';
"BRAZ"			return 'BRAZ';  
"BRAL"			return 'BRAL';  
"BRALZ"			return 'BRALZ';  
"CALL"			return 'CALL';  
"HALT"			return 'HALT';  
"IN"			return 'IN';  
"OUT"			return 'OUT';  
.             ; // ignore
%%
