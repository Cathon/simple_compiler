
## HowTo

1. flex scanner.l 
2. gcc -o analyse lex.yy.c
3. ./analyse input > output
4. you can see the answer in output


## NOTE:

1. when the program read '0d0a', it can only read '0a' as '\n', '0d' will cause a problem
so we use `dos2unix` to change '0d0a' to '0a' in a file at first
//http://blog.sina.com.cn/s/blog_7226f3660100uipz.html

2. gcc -o analyse lex.yy.c -ll
I don't use -ll because my linux cannot find -ll
So I add a statement "%option noyywrap" at the first line of scanner.l