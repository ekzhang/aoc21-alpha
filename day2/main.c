#include <stdio.h>
#include <stdlib.h>

extern int64_t soln(char *buf);
extern int64_t soln2(char *buf);

int main(void) {
  char *buf = calloc(2000, sizeof(char[16])); // 2000 lines, each <= 16 chars
  size_t index = 0;
  int ch;
  while ((ch = getchar()) != EOF) {
    buf[index++] = ch;
  }
  buf[index++] = '\0';

  printf("%lld\n", soln(buf));
  printf("%lld\n", soln2(buf));

  free(buf);
  return 0;
}
