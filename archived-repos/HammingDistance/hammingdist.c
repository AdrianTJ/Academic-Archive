#include <stdint.h>
#include <stdio.h>

int hammingDistance (uint64_t x, uint64_t y) {
        uint64_t res = x ^ y;
        return __builtin_popcountll (res);
}

int main() {
   printf("%d ",hammingDistance(0b10000000000,0b1111111111));
   return 0;
}