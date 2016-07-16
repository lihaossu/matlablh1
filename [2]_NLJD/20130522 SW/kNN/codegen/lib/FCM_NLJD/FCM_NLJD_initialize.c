/*
 * FCM_NLJD_initialize.c
 *
 * Code generation for function 'FCM_NLJD_initialize'
 *
 * C source code generated on: Tue Jun 18 15:54:57 2013
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "FCM_NLJD.h"
#include "FCM_NLJD_initialize.h"
#include "FCM_NLJD_data.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
void FCM_NLJD_initialize(void)
{
  int32_T i0;
  rt_InitInfAndNaN(8U);
  state_not_empty = FALSE;
  state = 1144108930U;
  for (i0 = 0; i0 < 2; i0++) {
    b_state[i0] = 362436069U + 158852560U * (uint32_T)i0;
  }

  method = 7U;
}

/* End of code generation (FCM_NLJD_initialize.c) */
