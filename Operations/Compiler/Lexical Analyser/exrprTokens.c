


// constants for tokens and their values
#define NUMKEYS 2
typedef enum token_types 
{
  LET, ID, INT, LPAREN, RPAREN, NEWLINE, ASSIGNOP, 
  PLUSOP, MINUSOP, MULTOP, DIVOP, SCANEOF
}Token;
char *tokSyms[] = {"let", "var", "num", "(", ")", "\n", "=", 
             		"+", "-", "*", "/", "eof"};
char *keywords[NUMKEYS] = {"let", "SCANEOF"};
Token keywordToks[NUMKEYS] = {LET, SCANEOF};



Token currToken;
int lineNum = 1;   // num lines read in
int main(void)
{
	printf("%2d:  ", lineNum);
	do {
	    nextToken();
	    printToken();
	}while (currToken != SCANEOF);
	return 0;
}



#define MAX_IDLEN 30
char tokString[MAX_IDLEN];
int currTokValue;    // used when token is an integer
void printToken(void)
{	
	if (currToken == ID)     // an ID,  variable name
    	printf("%s(%s) ", tokSyms[currToken], tokString);
    else if (currToken == INT)		// a number
        printf("%s(%d) ", tokSyms[currToken], currTokValue);  // show value
    else if (currToken == NEWLINE)
        printf("%s%2d: ", tokSyms[currToken], lineNum);   // print newline token
    else
        printf("'%s' ", tokSyms[currToken]);  // other toks
}  // end of printToken()



void nextToken(void)
{  
	currToken = scanner(); 
}



Token scanner(void)		// converts chars into a token
{
	int inCh;
    clearTokStr();

    if (feof(stdin))
    	return SCANEOF;

    while ((inCh = getchar()) != EOF) {  /* EOF is ^D */
    	if (inCh == '\n') {
      		lineNum++;
         	return NEWLINE;
    	}
    	else if (isspace(inCh))   // do nothing
      		continue;
      	else if (isalpha(inCh)){ // ID = ALPHA (ALPHA_NUM | '_')*
     		extendTokStr(inCh);
     		for (inCh = getchar(); (isalnum(inCh) || inCh == '_'); inCh = getchar())
       			extendTokStr(inCh);
     		ungetc(inCh, stdin);
     		return checkKeyword();
   		}
      	else if (isdigit(inCh)){  // INT = DIGIT+
     		extendTokStr(inCh);
     		for (inCh = getchar(); isdigit(inCh); inCh = getchar())
       			extendTokStr(inCh);
     		ungetc(inCh, stdin);
     		currTokValue = atoi(tokString);   // token --> int
     		return INT;
   		}
    	else if (inCh == '(')
      		return LPAREN;
	 	else if ...     // more tests of inCh
	 		   ...
    	else if (inCh == '=')
      		return ASSIGNOP;
    	else
      		lexicalErr(inCh);
  	}
  	return SCANEOF;
} // end of scanner()




void clearTokStr(void) // reset the token string to be empty
{ 
	tokString[0] = '\0';
  	tokStrLen = 0;
} // end of clearTokStr()


void extendTokStr(char ch) // add ch to the end of the token string
{
  	if (tokStrLen == (MAX_IDLEN-1))
    	printf("Token string too long for %c\n", ch);
  	else {
    	tokString[tokStrLen] = ch;
    	tokStrLen++;
    	tokString[tokStrLen] = '\0';  // terminate string
  	}
} // end of extendTokStr()


Token checkKeyword(void)
{
  	int i;
  	for(i=0; i<NUMKEYS; i++) {
    	if(!strcmp(tokString, keywords[i]))
      		return keywordToks[i];
  	}
  	return ID;
} // end of checkKeyword()


void lexicalErr(char ch)
{ 
	printf("Lexical error at \"%c\" on line %d\n",  ch, lineNum);  
    exit(1);
}
