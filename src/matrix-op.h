#ifndef MATRIX_OP_H
#define MATRIX_OP_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct sqm {
    int size;
    int *data;
};

#define sqm_create_fill(s) sqm_create(s, true)
#define sqm_create_blank(s) sqm_create(s, false)
struct sqm sqm_create(int size, bool fill);
void sqm_print(struct sqm m);
void sqm_free(struct sqm m);
void sqm_mul(struct sqm src1, struct sqm src2, struct sqm *dst);

#endif // MATRIX_OP_H