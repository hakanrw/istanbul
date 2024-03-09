#include <cosmo.h>
#include <stdio.h>
#include <libc/dce.h>

int main() {
	if (IsWindows()) printf("OS: Windows\n");
	if (IsLinux()  ) printf("OS: Linux\n");
	if (IsXnu()    ) printf("OS: macOS\n");
	if (IsFreebsd()) printf("OS: FreeBSD\n");
	if (IsOpenbsd()) printf("OS: OpenBSD\n");
	if (IsNetbsd() ) printf("OS: NetBSD\n");
	if (IsMetal()  ) printf("OS: N/A - Bare Metal\n");
	printf("Architecture: %s\n", _ARCH_NAME);
	printf("\n");

	FILE* file = fopen("/zip/file.txt", "r");
	FILE* thanks_file = fopen("/zip/directory/thanks.txt", "r");
	FILE* info_file = fopen("/zip/directory/info.txt", "r");

	char content[1024];

	memset(content, 0, 1024);
	fread(content, 1024, 1, file);
	printf("%s", content);
	printf("-----------------------------------------------\n");

	memset(content, 0, 1024);
	fread(content, 1024, 1, thanks_file);
	printf("%s", content);
	printf("-----------------------------------------------\n");

	memset(content, 0, 1024);
	fread(content, 1024, 1, info_file);
	printf("%s", content);

	return 0;
}
