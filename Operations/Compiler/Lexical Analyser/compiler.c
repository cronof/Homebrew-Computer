// Compiler

#include <stdio.h>
#include <stdlib.h>


#define BIT8 8
#define BIT16 16
typedef enum token_types 
{
  LET, ID, INT, LPAREN, RPAREN, NEWLINE, ASSIGNOP, PLUSOP, MINUSOP, MULTOP, DIVOP, SCANEOF
}Token;

typedef opcode_types
{
	LOAD, ADD, SUB, MUL, DIV, OR, XOR, BRA, BRAZ, BRAL, BRALZ, CALL, HALT, IN, OUT
}opcode;

char *tokSyms[] = {"let", "var", "num", "(", ")", "\n", "=", 
             		"+", "-", "*", "/", "eof"};
char *keywords[NUMKEYS] = {"let", "SCANEOF"};
Token keywordToks[NUMKEYS] = {LET, SCANEOF};       		
char RA;
char RB;
char RD;
char R;


char opcodeCheck (opcode, RA, RB, RD){
	if (opcode == LOAD){
		if (RA != NULL && RB == NULL)
			RD = RA;
		else if (RB != NULL && RA == NULL)
			RD = RB;
	} 
	else if (opcode == ADD)
	{
		RD = RA+RB;
	}
	else if (opcode == SUB)
	{
		RD = RA-RB;
	}
	else if (opcode == MUL)
	{
		RD = RA*RB;
	}
	else if (opcode == DIV)
	{
		RD = RA/RB;
	}
	else if (opcode == OR)
	{
		if (RA != NULL && RB == NULL)
			RD = RA;
		else if (RB != NULL && RA == NULL)
			RD = RB;
	}
	else if (opcode == XOR)
	{
		/* code */
	}
	else if (opcode == BRA)
	{
		/* code */
	}
	else if (opcode == BRAZ)
	{
		/* code */
	}
	else if (opcode == BRAL)
	{
		/* code */
	}
	else if (opcode == BRALZ)
	{
		/* code */
	}
	else if (opcode == CALL)
	{
		/* code */
	}
	else if (opcode == HALT)
	{
		/* code */
	}
	else if (opcode == IN)
	{
		/* code */
	}
	else if (opcode == OUT)
	{
		/* code */
	}
	else
	{
		/* code */
	}

}
