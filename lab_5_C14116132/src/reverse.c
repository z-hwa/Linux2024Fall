#include "../include/reverse.h"

char *reverse(char *dest, const char *src) 
{
	//FIX ME
	int length = 9;
	if(sizeof(*dest) < sizeof(*src)) return dest;

	int pos=0;
	for(int i=0;i<length;i++){
		pos = length - i - 1;
		dest[pos] = src[i];
	}

	return dest;
}
