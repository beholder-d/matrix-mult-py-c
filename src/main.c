#include "matrix-op.h"

#define DIM 20

int main() {
    struct sqm m1 = sqm_create_fill(DIM);
    struct sqm m2 = sqm_create_fill(DIM);
    struct sqm m3 = sqm_create_blank(DIM);

    sqm_mul(m1, m2, &m3);

    sqm_print(m1);
    sqm_print(m2);
    sqm_print(m3);

    sqm_free(m1);
    sqm_free(m2);
    sqm_free(m3);

    return 0;
}