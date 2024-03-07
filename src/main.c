#include <cosmo.h>
#include <stdio.h>
#include <libc/dce.h>

int main() {
	if (IsWindows()) printf("OS: Windows\n");
	if (IsLinux()  ) printf("OS: Linux\n");
	if (IsXnu()    ) printf("OS: macOS\n");
	if (IsFreebsd()) printf("OS: FreeBSD\n");

	FILE* file = fopen("/zip/text.txt", "r");

	char content[128];
	fgets(content, 128, file);

	printf("%s", content);


	return 0;
}
