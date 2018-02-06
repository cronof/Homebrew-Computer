#include <stdio.h>
%option noyywrap

%{
	#include "grammar.tab.h"
%}


alpha [a-zA-Z]
name {alpha}([0-9]*{alpha}*)+
whitespace [ \r\t\v\f]
newline \n

%%
{whitespace}  
{linefeed}		++yylineno;
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
