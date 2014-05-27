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

 All the main behavior of the H264 testbench

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

#include "H264_tb.h"
#include "H264_ttb.h"

#ifdef MODELSIM 
typedef PLI_INT32 PLIType;
#else
typedef uint32_t PLIType;
#endif

#define GLOBAL_PRINT false

using namespace std;

extern "C" PLIType H264_check();
extern "C" PLIType H264_set();
extern "C" PLIType H264_init();
extern "C" PLIType H264_end();

#ifdef MODELSIM
s_tfcell veriusertfs[] = {
  {usertask, 0, params_check, 0, H264_init, 0,    "$H264_init"},
  {usertask, 0, params_check, 0, H264_set,  0,    "$H264_set"},
  {usertask, 0, params_check, 0, H264_check,0,    "$H264_check"},
  {usertask, 0, params_check, 0, H264_end,0,      "$H264_end"},
  {0} /* last entry must be 0 */
};
#endif
	

uint64_t num_ops_queue_until = NUM_EXECUTE_CYCLES - 10;//FIXME: change back to 1000// ((NUM_EXECUTE_CYCLES/4));//250-20;

uint64_t when_to_clear = NUM_EXECUTE_CYCLES/2; // Issue a clear this in the middle of operation

uint64_t total_insts_queued = 0;

// Keep handles public, to save time
H264_ports_p H264_handles;

// ********************** Start Function Definitions ************************

/* This function determines how often clear gets asserted */
// void do_clear(){
//   // Enforce ~2%  duty cycle for clear.
//   if (rand() %100 > 97)//(num_total_ops >= when_to_clear && num_total_ops <= (when_to_clear +0))
//      clear = 0; //FIXME: change back to 1, reenable clear assertion
//   else 
//      clear = 0;
// }



PLIType H264_init() {

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
	
	opt = mc_scan_plusargs("clk=");
	if (opt) {
		num_ops_queue_until = atoi(opt);
		if (GLOBAL_PRINT)
			vpi_printf("@D Changing clock speed, num_op_total=%d\n", num_ops_queue_until);		
	}	


	// Check to see if we have handles, if not, iterate until we do.  
	// Next time, we won't have a performance penalty for scanning handles.
	//
	if (H264_handles == NULL) {
		if (GLOBAL_PRINT) vpi_printf("\n@D H264_init(), about to scan for ports\n");
		H264_handles = new H264_ports_s;
			
		while( (parameter = vpi_scan( arg_iterator )) != NULL ) {
			const char *name = vpi_get_str( vpiName, parameter );
			if (GLOBAL_PRINT) vpi_printf("@D Name Found:%s\n", name);
      
	             	if (strcasecmp(name,"reset_n") == 0) {H264_handles->reset_n = parameter;}
	             	if (strcasecmp(name,"pin_disable_DF") == 0) {H264_handles->pin_disable_DF = parameter;}
	             	if (strcasecmp(name,"freq_ctrl0") == 0) {H264_handles->freq_ctrl0 = parameter;}
	             	if (strcasecmp(name,"freq_ctrl1") == 0) {H264_handles->freq_ctrl1 = parameter;}
		}// while iterating through handles
			
	} // /if handles not initialized

	H264_tb_init();


	return 0;
}// /H264_init()




// Check if operation produced the correct result
PLIType H264_check(){ 
	static H264_ 	H264_check(H264_handles);
	H264_check.clear_fn();

	if (GLOBAL_PRINT) vpi_printf("@D *****************H264_ttb check()****start******** num[%d]\n", num_total_ops);
	H264_tb_check(&H264_check);
// 	H264_check.write_a();
  return 0;
}// /H264_check()

// May be deprecated, inefficient
// PLIType H264_clk_advance() {
// 
// }// /clock advance

/* The main function, set all the data inputs
   This fn is independant of H264_check(), to increase verification */
PLIType H264_set() {
	static H264_ 	H264_set(H264_handles);
  H264_set.clear_fn();
	

	if (GLOBAL_PRINT)  vpi_printf("@D *****************H264_ttb set()****Start********num[%d]\n", num_total_ops);
	/* Handle finishing the tb here, call end fn when time */
	if (num_total_ops >= NUM_EXECUTE_CYCLES && NUM_EXECUTE_CYCLES != 0) {
		H264_end();
		#ifdef MODELSIM_GUI
			tf_dostop();
		#else
			tf_dofinish();
		#endif
	}
        H264_tb_set(&H264_set);
        
        H264_set.tb_cycle = num_total_ops;
        num_total_ops++; // keep track of clock cycle; used for tests


	return 0;
}// /H264_set()


// Print all errors, summary, free memory
PLIType H264_end() {

	if (GLOBAL_PRINT)  vpi_printf("\n\n");

	
// 	vpi_printf("\n%d Clock Cycles Total H264_tb FINISHED\n", num_total_ops); 

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

	H264_tb_end();
	return 0;
}// /H264_end()


PLIType params_check() {
 
	return 0;
}

