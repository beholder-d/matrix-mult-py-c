#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

struct sqm {
    int size;
    int *data;
};

#define sqm_create_fill(s) sqm_create(s, true)
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
        for (int row=0; row<m.size*m.size; row+=m.size) {
            for (int col=0; col<m.size; col++) {
                m.data[row + col] = (row + col) % 10;
            }
        }
    }
    return m;
}

void sqm_print(struct sqm m) {
    for (int row=0; row<m.size*m.size; row+=m.size) {
        for (int col=0; col<m.size; col++) {
            printf("%04i ", m.data[row + col]);
        }
        printf("\n");
    }
    printf("\n");
}

void sqm_free(struct sqm m) {
    free(m.data);
}

void sqm_mult(struct sqm m1, struct sqm m2, struct sqm *m3)
{
    if (m1.size != m2.size || m2.size != m3->size) {
        printf("Only similarly sized matricies are allowed %i, %i, %i",
                m1.size, m2.size, m3->size);
    }
    /* It's 10% slower to use m3->data[row * m3->data + col]
    * then incrementing row but m3->data, who might have thought
    * Sergey Zubkov probably :)
    */
    for (int row=0; row<m3->size * m3->size; row += m3->size) {
        for (int col=0; col<m3->size; col++) {
            m3->data[row + col] = 0;
            for (int i = 0, ri = 0; i<m3->size; i++, ri+=m3->size) {
                m3->data[row + col] += (m1.data[row + i]
                        * m2.data[ri + col]);
            }

        }
    }
};


#define DIM 20

int main() {
    struct sqm m1 = sqm_create_fill(DIM);
    struct sqm m2 = sqm_create_fill(DIM);
    struct sqm m3 = sqm_create(DIM, false);

    sqm_mult_mul(m1, m2, &m3);

    sqm_print(m1);
    sqm_print(m2);
    sqm_print(m3);

    sqm_free(m1);
    sqm_free(m2);
    sqm_free(m3);

    return 0;
}