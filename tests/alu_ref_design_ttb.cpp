//==============================================================================
//      File:           $URL$
//      Version:        $Revision$
//      Author:         Tom Golubev
//      Copyright:      Copyright 2005-2008 UC Santa Cruz
//==============================================================================

//==============================================================================
//      Section:        License
//==============================================================================
//      Copyright (c) 2005-2008, Regents of the University of California
//      All rights reserved.
//
//      Redistribution and use in source and binary forms, with or without modification,
//      are permitted provided that the following conditions are met:
//
//              - Redistributions of source code must retain the above copyright notice,
//                      this list of conditions and the following disclaimer.
//              - Redistributions in binary form must reproduce the above copyright
//                      notice, this list of conditions and the following disclaimer
//                      in the documentation and/or other materials provided with the
//                      distribution.
//              - Neither the name of the University of California, Santa Cruz nor the
//                      names of its contributors may be used to endorse or promote
//                      products derived from this software without specific prior
//                      written permission.
//
//      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//      ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//      WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//      DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//      ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//      (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//      LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//      ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//      SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

/****************************************************************************
    Description:

 All the main behavior of the alu_ref_design testbench

****************************************************************************/

#include <iostream>
#include <ctime>
#include <cstdlib>
#include <iomanip>
#include <time.h>
#include <string.h>

#include "vpi_user.h"
#include "veriuser.h"

#include "atc_fns.h" // Functions for general ATC functionality

#include "alu_ref_design_tb.h"
#include "alu_ref_design_ttb.h"

#ifdef MODELSIM
typedef PLI_INT32 PLIType;
#else
typedef uint32_t PLIType;
#endif

#define GLOBAL_PRINT false

using namespace std;

extern "C" PLIType alu_ref_design_check();
extern "C" PLIType alu_ref_design_set();
extern "C" PLIType alu_ref_design_init();
extern "C" PLIType alu_ref_design_end();
extern "C" PLIType inc_stat1();
extern "C" PLIType inc_stat2();
extern "C" PLIType params_check();

#ifdef MODELSIM
s_tfcell veriusertfs[] = {
  {usertask, 0, params_check, 0, alu_ref_design_init, 0,    "$alu_ref_design_init"},
  {usertask, 0, params_check, 0, alu_ref_design_set,  0,    "$alu_ref_design_set"},
  {usertask, 0, params_check, 0, alu_ref_design_check,0,    "$alu_ref_design_check"},
  {usertask, 0, params_check, 0, inc_stat1, 0,"$inc_stat1"},
  {usertask, 0, params_check, 0, inc_stat2, 0,"$inc_stat2"},
  {usertask, 0, params_check, 0, alu_ref_design_end,0,      "$alu_ref_design_end"},
  {0} /* last entry must be 0 */
};
#endif


uint64_t num_ops_queue_until = NUM_EXECUTE_CYCLES - 10;//FIXME: change back to 1000// ((NUM_EXECUTE_CYCLES/4));//250-20;

uint64_t when_to_clear = NUM_EXECUTE_CYCLES/2; // Issue a clear this in the middle of operation

uint64_t total_insts_queued = 0;

// Keep handles public, to save time
alu_ref_design_ports_p alu_ref_design_handles;

// ********************** Start Function Definitions ************************

/* This function determines how often clear gets asserted */
// void do_clear(){
//   // Enforce ~2%  duty cycle for clear.
//   if (rand() %100 > 97)//(num_total_ops >= when_to_clear && num_total_ops <= (when_to_clear +0))
//      clear = 0; //FIXME: change back to 1, reenable clear assertion
//   else
//      clear = 0;
// }



PLIType alu_ref_design_init() {

  uint32_t time_seed = 0xdeaddead; // time(0);

	vpiHandle       systf_handle;
	vpiHandle       arg_iterator;
	vpiHandle       parameter;

	systf_handle = vpi_handle( vpiSysTfCall, NULL );
	arg_iterator = vpi_iterate( vpiArgument, systf_handle );

 	if (GLOBAL_PRINT)vpi_printf("@D Running for %d cycles\n", NUM_EXECUTE_CYCLES);

	// Handle command line parameters
	char *opt = mc_scan_plusargs("print=");
	if (opt) {
		if (strcasecmp(opt,"errors") == 0) {
			if (GLOBAL_PRINT) vpi_printf("@D Printing only errors\n");
		}
	}

	/* Handle RNG Seeding     MOVED TO TB FILE
	opt = mc_scan_plusargs("seed=");
	if (opt) {
		time_seed = atoi(opt);
	}
	time_seed = 1240608344; //FIXME: remove, just for debugging
	srand ( time_seed ); // seed RNG
	vpi_printf("\t\t\tTestbench Seeded with %d\n\n", time_seed);
	 */

	opt = mc_scan_plusargs("clk=");
	if (opt) {
		num_ops_queue_until = atoi(opt);
		if (GLOBAL_PRINT)
			vpi_printf("@D Changing clock speed, num_op_total=%d\n", num_ops_queue_until);
	}

// 	opt = mc_scan_plusargs("test=");
// 	if (opt) {
// 		if (strcasecmp(opt,"test1") == 0) {
// 			do_test = TEST_TEST1;
// 			vpi_printf("testing test1\n");
// 		}
// 		if (strcasecmp(opt,"test2") == 0) {
// 			do_test = TEST_TEST2;
// 			vpi_printf("testing test2\n");
// 		}
//
// 	}else{
// 		do_test = TEST_TEST1;
// 		if (GLOBAL_PRINT) vpi_printf("@D testing test1\n");
// 	}
	// /end param handling

	// Check to see if we have handles, if not, iterate until we do.
	// Next time, we won't have a performance penalty for scanning handles.
	//
	if (alu_ref_design_handles == NULL) {
		if (GLOBAL_PRINT) vpi_printf("\n@D alu_ref_design_init(), about to scan for ports\n");
		alu_ref_design_handles = new alu_ref_design_ports_s;

		while( (parameter = vpi_scan( arg_iterator )) != NULL ) {
			const char *name = vpi_get_str( vpiName, parameter );
			if (GLOBAL_PRINT) vpi_printf("@D Name Found:%s\n", name);

	             	if (strcasecmp(name,"reset") == 0) {alu_ref_design_handles->reset = parameter;}
	             	if (strcasecmp(name,"switch_2_block") == 0) {alu_ref_design_handles->switch_2_block = parameter;}
	             	if (strcasecmp(name,"switch_2_blockValid") == 0) {alu_ref_design_handles->switch_2_blockValid = parameter;}
	             	if (strcasecmp(name,"switch_2_blockRetry") == 0) {alu_ref_design_handles->switch_2_blockRetry = parameter;}
	             	if (strcasecmp(name,"rci0") == 0) {alu_ref_design_handles->rci0 = parameter;}
	             	if (strcasecmp(name,"rco1") == 0) {alu_ref_design_handles->rco1 = parameter;}
	             	if (strcasecmp(name,"block_2_switch") == 0) {alu_ref_design_handles->block_2_switch = parameter;}
	             	if (strcasecmp(name,"block_2_switchValid") == 0) {alu_ref_design_handles->block_2_switchValid = parameter;}
	             	if (strcasecmp(name,"block_2_switchRetry") == 0) {alu_ref_design_handles->block_2_switchRetry = parameter;}

			if (strcasecmp(name,"tb_cycle") == 0) {alu_ref_design_handles->tb_cycle = parameter;}
      if (strcasecmp(name, "tb_tune_val") == 0) {alu_ref_design_handles->tb_tune_val = parameter;}
		}// while iterating through handles

	} // /if handles not initialized

	alu_ref_design_tb_init();


	return 0;
}// /alu_ref_design_init()




// Check if operation produced the correct result
PLIType alu_ref_design_check(){
	static alu_ref_design_ 	alu_ref_design_check(alu_ref_design_handles);
	alu_ref_design_check.clear_fn();

	if (GLOBAL_PRINT) vpi_printf("@D *****************alu_ref_design_ttb check()****start******** num[%d]\n", num_total_ops);
	alu_ref_design_tb_check(&alu_ref_design_check);
// 	alu_ref_design_check.write_a();
  return 0;
}// /alu_ref_design_check()

// May be deprecated, inefficient
// PLIType alu_ref_design_clk_advance() {
//
// }// /clock advance

/* The main function, set all the data inputs
   This fn is independant of alu_ref_design_check(), to increase verification */
PLIType alu_ref_design_set() {
	static alu_ref_design_ 	alu_ref_design_set(alu_ref_design_handles);
  alu_ref_design_set.clear_fn();


	if (GLOBAL_PRINT)  vpi_printf("@D *****************alu_ref_design_ttb set()****Start********num[%d]\n", num_total_ops);
	/* Handle finishing the tb here, call end fn when time */
	if (num_total_ops >= NUM_EXECUTE_CYCLES && NUM_EXECUTE_CYCLES != 0) {
		alu_ref_design_end();
		#ifdef MODELSIM_GUI
			tf_dostop();
		#else
			tf_dofinish();
		#endif
	}
        alu_ref_design_tb_set(&alu_ref_design_set);

        alu_ref_design_set.tb_cycle = num_total_ops;
        num_total_ops++; // keep track of clock cycle; used for tests


	return 0;
}// /alu_ref_design_set()

// Gather statistics/accessing an internal variable
PLIType inc_stat1() {
  //add code here

  tb_inc_stat1();
	return 0;
}// /alu_ref_design_inc_stat1()

// Gather statistics/accessing an internal variable
PLIType inc_stat2() {
  //add code here
  tb_inc_stat2();
	return 0;
}// /alu_ref_design_inc_stat2()


// Print all errors, summary, free memory
PLIType alu_ref_design_end() {


	if (GLOBAL_PRINT)  vpi_printf("\n\n");


// 	vpi_printf("\n%d Clock Cycles Total alu_ref_design_tb FINISHED\n", num_total_ops);

#if 0
        // NOT WORKING COVERAGE STATISTICS GATHERING
	vpiHandle       arg_iterator;
	vpiHandle       assertion;
        arg_iterator = vpi_iterate(vpiAssertion, NULL);
        while (assertion = vpi_scan(arg_iterator)) {
          //          if (vpi_get(vpiAssertionType, assertion) == vpiCoverType) {
          {

            PLI_INT32 covered = vpi_get(vpiCovered,assertion);
            PLI_INT32 attempt = vpi_get(vpiAssertAttemptCovered,assertion);
            PLI_INT32 success = vpi_get(vpiAssertSuccessCovered,assertion);

            vpi_printf("covered %d: attempt %d: success %d\n",covered,attempt,success);
          }
        }
#endif

	alu_ref_design_tb_end();
	return 0;
}// /alu_ref_design_end()


PLIType params_check() {

	return 0;
}

