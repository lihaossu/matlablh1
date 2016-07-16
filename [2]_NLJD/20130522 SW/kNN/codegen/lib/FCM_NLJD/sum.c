/*
 * sum.c
 *
 * Code generation for function 'sum'
 *
 * C source code generated on: Tue Jun 18 15:54:57 2013
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "FCM_NLJD.h"
#include "sum.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void sum(const real_T x[40], real_T y[20])
{
  int32_T ix;
  int32_T iy;
  int32_T i;
  int32_T ixstart;
  ix = 1;
  iy = -1;
  for (i = 0; i < 20; i++) {
    ixstart = ix;
    ix += 2;
    iy++;
    y[iy] = x[ixstart - 1] + x[ixstart];
  }
}

/* End of code generation (sum.c) */
