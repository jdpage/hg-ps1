/*
 * Copyright 2011 Jonathan D. Page
 * 
 * This guy called Jonathan wrote this sweet code. You are hereby granted
 * permission to do whatever you feel like doing with it on the understanding
 * that he's not responsible for anything that results from your use of this
 * sweet code.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

int pdir(const char *pwd) {
	FILE *f;
	char *hg_path;
	int plen = strlen(pwd);
	char c;

	if ((hg_path = (char *)malloc(plen + 12 * sizeof(char))) == NULL)
		return -1;
	
	sprintf(hg_path, "%s/.hg/branch", pwd);

	if ((f = fopen(hg_path, "r")) == NULL) {
		struct stat st;
		sprintf(hg_path, "%s/.hg", pwd);
		if (stat(hg_path, &st) != 0) {
			free(hg_path);
			return 1;
		}
		printf("default");
		free(hg_path);
		return 0;
	}
	
	while ((c = fgetc(f)) != EOF && c != '\n')
		putchar(c);

	free(hg_path);
	fclose(f);
	return 0;
}

int main() {
	char *dir_path;
	int l, r, k;

	dir_path = getcwd(NULL, 0);

	while ((l = strlen(dir_path)) > 0) {
		r = pdir(dir_path);
		if (r < 1)
			return r * -1;
		for (k = l - 1; k >= 0; k--) {
			if (dir_path[k] == '/') {
				dir_path[k] = 0;
				break;
			}
		}
	}

	free(dir_path);

	return 0;
}
