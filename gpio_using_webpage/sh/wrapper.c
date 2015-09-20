#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

int main (int argc, char *argv[])
{
     setuid (0);

     /* WARNING: Only use an absolute path to the script to execute,
      *          a malicious user might fool the binary and execute
      *          arbitary commands if not.
      * */
	if(argc<2){
		printf("Usage: %s <path to shellscript> <args for that script(optional)>\n",argv[0]);
		exit(1);
	}
	int i,len=0;
	for(i=1;i<argc;i++){
	   len += strlen(argv[i]);	
	}
	char *comm = (char*)malloc(sizeof(char)*len + 10);
	sprintf(comm,"%s %s", "/bin/bash",argv[1]);

	for(i=2;i<argc;i++){
	  sprintf(comm,"%s %s",comm,argv[i]);
	}
	printf("%s\n",comm);

 //    system ("/bin/sh /var/www/html/sh/php_shell.sh");
	system(comm);
     return 0;
}
