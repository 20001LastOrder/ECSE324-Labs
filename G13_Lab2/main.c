#include <stdio.h>
extern int MAX_2(int x, int y);


int main(){
	int list[] = {3,4,5,2,4,1,5,13,52,4213,123,23,3};
	int length = sizeof(list)/sizeof(list[0]);
	int i, max = 0;
	for(i = 0; i < length; i++){
		max = MAX_2(max, list[i]);
	}
	fprintf(stdout, "the max is : %d", max);
	return max;
}
