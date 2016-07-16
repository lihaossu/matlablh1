/*
 * FCM_NLJD.c
 *
 * Code generation for function 'FCM_NLJD'
 *
 * C source code generated on: Tue Jun 18 15:53:57 2013
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "FCM_NLJD.h"
#include "sum.h"
#include "rand.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
static real_T rt_powd_snf(real_T u0, real_T u1);

/* Function Definitions */
static real_T rt_powd_snf(real_T u0, real_T u1)
{
  real_T y;
  real_T d0;
  real_T d1;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = rtNaN;
  } else {
    d0 = fabs(u0);
    d1 = fabs(u1);
    if (rtIsInf(u1)) {
      if (d0 == 1.0) {
        y = rtNaN;
      } else if (d0 > 1.0) {
        if (u1 > 0.0) {
          y = rtInf;
        } else {
          y = 0.0;
        }
      } else if (u1 > 0.0) {
        y = 0.0;
      } else {
        y = rtInf;
      }
    } else if (d1 == 0.0) {
      y = 1.0;
    } else if (d1 == 1.0) {
      if (u1 > 0.0) {
        y = u0;
      } else {
        y = 1.0 / u0;
      }
    } else if (u1 == 2.0) {
      y = u0 * u0;
    } else if ((u1 == 0.5) && (u0 >= 0.0)) {
      y = sqrt(u0);
    } else if ((u0 < 0.0) && (u1 > floor(u1))) {
      y = rtNaN;
    } else {
      y = pow(u0, u1);
    }
  }

  return y;
}

void FCM_NLJD(const real_T Database[20], real_T center[3], real_T U[20])
{
  real_T obj_fcn[10];
  real_T col_sum[20];
  int32_T ix;
  int32_T iy;
  int32_T i;
  boolean_T exitg1;
  real_T mf[20];
  int32_T k;
  real_T x[20];
  real_T y[2];
  int32_T b_i;
  int32_T ixstart;
  real_T s;
  real_T b_mf[3];
  real_T dv0[3];
  real_T dist[20];
  real_T b_y[20];

  memset(&obj_fcn[0], 0, 10U * sizeof(real_T));

  b_rand(U);
  sum(U, col_sum);
  for (ix = 0; ix < 20; ix++) {
    for (iy = 0; iy < 2; iy++) {
      U[iy + (ix << 1)] /= col_sum[ix];
    }
  }

  /*  Initial fuzzy partition */
  /*  Main loop */
  i = 0;
  exitg1 = FALSE;
  while ((exitg1 == FALSE) && (i < 10)) {

    for (k = 0; k < 20; k++) {
      mf[k] = rt_powd_snf(U[k], 2.0);
    }

    /*  MF matrix after exponential modification */
    for (ix = 0; ix < 2; ix++) {
      for (iy = 0; iy < 20; iy++) {
        x[iy + 20 * ix] = mf[ix + (iy << 1)];
      }
    }

    ix = -1;
    iy = -1;
    for (b_i = 0; b_i < 2; b_i++) {
      ixstart = ix + 1;
      ix++;
      s = x[ixstart];
      for (k = 0; k < 19; k++) {
        ix++;
        s += x[ix];
      }

      iy++;
      y[iy] = s;
    }

    for (ix = 0; ix < 2; ix++) {
      for (iy = 0; iy < 2; iy++) {
        b_mf[ix + (iy << 1)] = 0.0;
        for (ixstart = 0; ixstart < 20; ixstart++) {
          b_mf[ix + (iy << 1)] += mf[ix + (ixstart << 1)] * Database[ixstart +
            20 * iy];
        }

        dv0[ix + (iy << 1)] = y[ix];
      }
    }

    for (ix = 0; ix < 2; ix++) {
      for (iy = 0; iy < 2; iy++) {
        center[iy + (ix << 1)] = b_mf[iy + (ix << 1)] / dv0[iy + (ix << 1)];
      }
    }

    for (k = 0; k < 2; k++) {
      for (ix = 0; ix < 20; ix++) {
        for (iy = 0; iy < 2; iy++) {
          x[ix + 20 * iy] = Database[ix + 20 * iy] - center[k + (iy << 1)];
        }
      }

      for (ixstart = 0; ixstart < 20; ixstart++) {
        b_y[ixstart] = rt_powd_snf(x[ixstart], 2.0);
      }

      for (ix = 0; ix < 20; ix++) {
        for (iy = 0; iy < 2; iy++) {
          x[iy + (ix << 1)] = b_y[ix + 20 * iy];
        }
      }

      sum(x, col_sum);
      for (ixstart = 0; ixstart < 20; ixstart++) {
        dist[k + (ixstart << 1)] = sqrt(col_sum[ixstart]);
      }
    }

    /*  fill the distance matrix */
    for (k = 0; k < 20; k++) {
      x[k] = rt_powd_snf(dist[k], 2.0) * mf[k];
    }

    sum(x, col_sum);
    s = col_sum[0];
    for (k = 0; k < 19; k++) {
      s += col_sum[k + 1];
    }

    /*  objective function */
    for (k = 0; k < 20; k++) {
      x[k] = rt_powd_snf(dist[k], -2.0);
    }

    /*  calculate new U, suppose expo != 1 */
    sum(x, col_sum);
    for (ix = 0; ix < 2; ix++) {
      for (iy = 0; iy < 20; iy++) {
        U[ix + (iy << 1)] = x[ix + (iy << 1)] / col_sum[iy];
      }
    }

    obj_fcn[i] = s;

    /*  check termination condition */
    if ((1 + i > 1) && (fabs(obj_fcn[i] - obj_fcn[i - 1]) < 1.0)) {
      exitg1 = TRUE;
    } else {
      i++;
    }
  }
}