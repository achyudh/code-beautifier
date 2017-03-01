%option noyywrap
%{

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  #define INDENT (4)
  #define MAXSYMBOLS 10000

  int num_symbols=0;
  int line = 1;
  int column = 0;
  int paren = 0;

  struct entry
	{
		char *lexptr;
		int token;
	};

	struct entry symtable[MAXSYMBOLS];

	int lookup(char *lexeme) {
    for (int i = 0; i < num_symbols; i++) {
    //   printf("%d %s %s\n", symtable[i].token, lexeme, symtable[i].lexptr);
      if (strcmp(lexeme, symtable[i].lexptr) == 0)
        return symtable[i].token;
    }
    return -1;
  }

	int insert(char *a, int token) {
    if (num_symbols + 1 > MAXSYMBOLS) {
      printf("ERROR: Number of identifiers more than limit specified.");
      return -1;
    }
    else {
      struct entry identifier = {a, token};
      symtable[num_symbols++] = identifier;
      return 0;
    }
  }

	void init() {
    insert("auto", 0);
    insert("break", 0);
    insert("case", 0);
    insert("char", 0);
    insert("const", 0);
    insert("continue", 0);
    insert("default", 0);
    insert("do", 0);
    insert("double", 0);
    insert("else", 0);
    insert("enum", 0);
    insert("extern", 0);
    insert("float", 0);
    insert("for", 0);
    insert("goto", 0);
    insert("if", 0);
    insert("int", 0);
    insert("long", 0);
    insert("register", 0);
    insert("return", 0);
    insert("short", 0);
    insert("signed", 0);
    insert("sizeof", 0);
    insert("static", 0);
    insert("struct", 0);
    insert("switch", 0);
    insert("typedef", 0);
    insert("union", 0);
    insert("unsigned", 0);
    insert("void", 0);
    insert("volatile", 0);
    insert("while", 0);
    insert("typeof", 0);
    insert("inline", 0);
  }

void indent() {
   printf("\n%-*d ", column, line++);
}
void indent_wnl() {
   printf("%-*d ", column, line++);
}
void write_html_char(int c) {
switch (c)
	{
	case '<': printf("&lt;"); break;
	case '>': printf("&gt;"); break;
	case '"': printf("&quot;"); break;
	case '&': printf("&amp;"); break;
	default: putchar(c);
	}
}
static int input();
void write_id();
void write_char(){
		int c;
		printf("<font color='#00FFFF'>");
		printf("<u>");
		for(int i=0;i<strlen(yytext);i++)
		{
			 write_html_char(yytext[i]);
		}
		printf("</u>");
		printf("</font>");
}

void write_inline()
{
	char c;
  // indent_wnl();
	printf("<font color='#00FF00'>");
	for(int i=0;i<strlen(yytext);i++)
		{
			 write_html_char(yytext[i]);
		}
	printf("</font>");
}
void write_string()
{
	char c;
  // indent_wnl();
	printf("<font color='#FF0000'>");
	for(int i=0;i<strlen(yytext);i++)
		{
			 write_html_char(yytext[i]);
		}
	printf("</font>");
}
void write_hex()
{
	char c;
	printf("<font color='#00FFFF'>");
	printf("<i>");

	for(int i=0;i<strlen(yytext);i++)
		{
			 write_html_char(yytext[i]);
		}
	printf("</i>");
	printf("</font>");

}
void write_comment();
void write_oct()
{
	char c;
	printf("<font color='#00FFFF'>");
	printf("<i>");

	for(int i=0;i<strlen(yytext);i++)
		{
			 write_html_char(yytext[i]);
		}
	printf("</i>");
	printf("</font>");
}

void write_int()
{
	char c;
	printf("<font color='#00FFFF'>");
	printf("<i>");

for(int i=0;i<strlen(yytext);i++)
		{
			 write_html_char(yytext[i]);
		}
	printf("</i>");
	printf("</font>");
}
void write_fp()
{
	char c;
	printf("<font color='#00FFFF'>");
	for(int i=0;i<strlen(yytext);i++)
		{
			 write_html_char(yytext[i]);
		}
	printf("</font>");
}
void write_op()
{

	char c;
	printf("<font color=#00000><b>%s</b></font>",yytext);
}
void write_directive()
{
	char c;
	printf("<font color='#FF00FF'>");
	for(int i=0;i<strlen(yytext);i++)
			write_html_char(yytext[i]);
	//printf("\n");
	// write_html();

  printf("</font>");
}
void write_html()
{
	char *s = yytext;
	while (*s)
		write_html_char(*s++);
}

void write_sep()
{
	write_html();
	// if (paren ) indent();
	// else
		putchar(' ');
}
// begin {}-block
void write_begin()

{
  column += INDENT;
	indent();
	write_html();
	// indent();
}
// end {}-block
void write_end()
{
	column -= INDENT;
	//  indent_wnl();
	write_html();
	// indent();
}

// start opening paren
void write_open()
{
	write_html();
	 putchar(' ');
	paren++;
}
// close paren

void write_close()
{
	write_html();
  //putchar(' ');
	paren--;
}
void write_bopen()
{
	write_html();
	paren++;
}
// close paren

void write_bclose()
{
	write_html();
	paren--;
}
%}
ch [^\n\'"]
digit [0-9]
alpha [A-Za-z]
id {alpha}[a-zA-Z0-9_]*
space [ \r\v\t]
nl "\n"
quote '\'
ditto \"
back \\
exp (e|E)('+'|'-')digit+
hex ({digit}|[a-f]|[A-F])

open "("
close ")"

begin "{"
end "}"
bopen "["
bclose "]"
sep ";"
eq [=]
inline "//".*[\n]
multiline "/*"
op (\.|\-\>|\+\+|\-\-|&|\*|\+|\-|~|!|\/|\%|\<\<|\>\>|\<|\>|=|==|&&|\<=|\>=|!=|\^\||&&|\|\|\?|\*=|\/=|\%=|\+=|\-=|\<\<=|\>\>=|&=|\^=|\|=|,|#|##|;|:|\.\.\.)

%%
^(.) {
      indent_wnl();
      if(yytext[0] != '\n')
        unput(yytext[0]);
//     write_linenum(1);
}
nl {}

{inline} {
	// printf("inline-%s\n",yytext);
	write_inline();
	}

{sep}+ {
	// printf("sep-%s\n",yytext);
	write_sep();
	}
{bopen}+ {
	// printf("bopen-%s\n",yytext);
	write_bopen();
	}
{bclose}+ {
	// printf("bclose-%s\n",yytext);
	write_bclose();
	}
{open}+ {
	// printf("open-%s\n",yytext);
	write_open();
        }
{close}+ {
		// printf("close-%s\n",yytext);
	write_close();
        }

{begin}+ {
	// printf("begin-%s\n",yytext);
	write_begin();
	}
{end}+ {
	// printf("end-%s\n",yytext);
	write_end();
	}
{ditto}({back}{ch}+|{back}{back}|{back}{quote}|{back}{ditto}|{ch}+|quote){ditto} {
	// printf("string-%s\n",yytext);
	write_string();
}
{quote}(({back}{ch})|({back}{back})|({back}{quote})|({back}{ditto})|{ch}+|ditto){quote} {
	// printf("char-%s\n",yytext);
	write_char();
}

0(x|X){hex}+ {
	// printf("hex-%s\n",yytext);
	write_hex();
}
0[0-7]+ {
	// printf("oct-%s\n",yytext);
	write_oct();
}
{digit}+ {
	// printf("int-%s\n",yytext);
	write_int();
}
{digit}*.digit*{exp}? {
	// printf("fp-%s\n",yytext);
	write_fp();
	}
{op} {
	write_op();
	}
"#".*[\n] {
	// printf("directive-%s\n",yytext);
  indent_wnl();
	write_directive();

  // unput('\n');
}
{id} {
	 //printf("id-%s\n",yytext);
	write_id();
	}
{multiline} {
    	// printf("multiline-%s\n",yytext);
    	write_comment();
    	}

space { printf("%s",yytext); }
ch {}
digit {}
exp {}
. {}
%%

void write_comment() {
	char c, c1;
  indent_wnl();
	printf("<font color='#00FF00'>/*");
	loop:
		while ((c = input()) != '*' && c != 0) {
			write_html_char(c);
            if(c=='\n') {
                	printf("<font color='#000000'>");
                  // write_linenum(0);
                  indent_wnl();
                  printf("</font>");
                }
            }
		write_html_char('*');
		if ((c1 = input()) != '/' && c != 0)
		{
			unput(c1);
			goto loop;
			}
			if (c != 0) {
				write_html_char(c1);
                if(c1=='\n'){
                    	printf("<font color='#000000'>");
                      // write_linenum(0);
                      indent_wnl();
                      printf("</font>");
                    }
                }
			printf("</font>");
}


void write_id()
{
	char c;
  printf("<font color='#0000FF'>");
	if(lookup(yytext) == 0) {
    printf("<b>%s</b>", yytext);
  }
  else if(lookup(yytext) < 0) {
    insert(yytext, num_symbols);
    printf("<a name=\"%s\">%s</a>", yytext, yytext);
  }
  else {
    printf("<a href=\"#%s\">%s</a>", yytext, yytext);
  }

	while(1)
	{
		c=input();
		if(c==' ' || c=='\t'||c=='\r' || c=='\n' || c=='\v')
		{
			printf("%c",' ');
            if(c=='\n'){
                	printf("<font color='#000000'>");
                  // write_linenum(0);
                  indent();
                  printf("</font>");
                }
		}
		else {
			unput(c);
            // printf("Unput c: %c\n",c);
			break;
			}
		}
	printf("</font>");
}


int main()
{
  init();
	printf("<html><pre>\n");
	// indent();

	yylex();
	printf("\n</pre></html>\n");
	return 0;
}
