1    #include <stdio.h>

2    int main( )
3    {
4    int num_symbols=0; 
5    int line =1; 
6    int column =4; 
7    int paren =0; 

8    struct entry 
9      
10       {
11       char *lexptr; 
12       int token; 
13       }; 

14   struct entry symtable[MAXSYMBOLS]; 

15   int lookup( char *lexeme)
16       {
17       for ( int i =0; i <num_symbols; i++)
18           {
19           // printf("%d %s %s\n", symtable[i].token, lexeme, symtable[i].lexptr);
20           if ( strcmp( lexeme,symtable[i].lexptr)==0)
21           return symtable[i].token; 
22           }
23       return -1; 
24       }

25   int insert( char *a,int token)
26       {
27       if ( num_symbols +1>MAXSYMBOLS)
28           {
29           printf( "ERROR: Number of identifiers more than limit specified."); 
30           return -1; 
31           }
32       else 
33           {
34           struct entry identifier =
35               {a,0}; 
36           symtable[num_symbols++]=identifier; 
37           return 0; 
38           }
39       }

40   fprintf( stdout,"hello, world\n"); 
41   fprintf( stderr,"this is an error\n"); 
42   return 1; 
43   }


