#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

struct sqm {
    int size;
    int *data;
};

#define sqm_create_fill(s) sqm_create(s, true)
#define sqm_create_blank(s) sqm_create(s, false)
struct sqm sqm_create(int size, bool fill) {
    int total_size = sizeof(int) * size * size;
    struct sqm m = {
        .size = size,
        .data = malloc(total_size),
    };
    if (m.data == NULL) {
        printf("Unable allocate space %i", total_size);
        exit(1);
    }
    if (fill) {
        for (int row = 0; row < m.size * m.size; row += m.size) {
            for (int col = 0; col < m.size; col++) {
                m.data[row + col] = (row + col) % 10;
            }
        }
    } else {
        memset(&(m.data), 0, m.size * m.size);
    }
    return m;
}

void sqm_print(struct sqm m) {
    for (int row = 0; row < m.size * m.size; row += m.size) {
        for (int col = 0; col < m.size; col++) {
            printf("%04i ", m.data[row + col]);
        }
        printf("\n");
    }
    printf("\n");
}

void sqm_free(struct sqm m) { free(m.data); }

void sqm_mult(struct sqm src1, struct sqm src2, struct sqm *dst) {
    if (src1.size != src2.size || src2.size != dst->size) {
        printf("Only similarly sized matricies are allowed %i, %i, %i", src1.size, src2.size,
               dst->size);
    }
    /*
     * It's 10% slower to use m.data[row * m.data + col]
     * then incrementing row but m.data, who might have thought, Sergey Zubkov probably :)
     */
    for (int row = 0; row < dst->size * dst->size; row += dst->size) {
        for (int col = 0; col < dst->size; col++) {
            dst->data[row + col] = 0;
            for (int i = 0, ri = 0; i < dst->size; i++, ri += dst->size) {
                dst->data[row + col] += (src1.data[row + i] * src2.data[ri + col]);
            }
        }
    }
};

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