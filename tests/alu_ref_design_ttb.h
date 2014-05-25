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

 All the defines / structs for the alu_ref_design testbench

****************************************************************************/

#ifndef alu_ref_design_TTB
#define alu_ref_design_TTB		


/**********************************************************************
 * Define storage structure for file pointer and vector handle.
 *********************************************************************/
typedef struct alu_ref_design_ports {
	// All alu_ref_design's ports
	
	vpiHandle	reset, switch_2_block, switch_2_blockValid, switch_2_blockRetry;
	vpiHandle	rci0, rco1, block_2_switch, block_2_switchValid;
	vpiHandle	block_2_switchRetry;
	vpiHandle	tb_cycle;
	vpiHandle	tb_tune_val;
} alu_ref_design_ports_s, *alu_ref_design_ports_p;



// wrapper function to reduce code density
inline uint64_t  alu_ref_design_read(vpiHandle handle, s_vpi_value data, int length, bool first=false) {
	
	uint64_t ret=0;
	data.format = vpiBinStrVal;
	vpi_get_value(handle, &data);
	read_uint64_t(data.value.str, length, &ret, first);
	
  return ret;
}

// Main tb object alu_ref_design definition
class alu_ref_design_{
  private: 
     alu_ref_design_ports_p handles;

  public:
    
    //Start DUT variable definition
    BoolType		reset;
    RingPacketType		switch_2_block;
    BoolType		switch_2_blockValid;
    BoolType		switch_2_blockRetry;
    ReclkIOType		rci0;
    ReclkIOType		rco1;
    RingPacketType		block_2_switch;
    BoolType		block_2_switchValid;
    BoolType		block_2_switchRetry;
    GenType		tb_cycle;
    GenType   tb_tune_val; 
    
    // Clear objects every clock cycle. Optimization so we only read / write members we have to
    void clear_fn(){
	
	    reset.clear_fn();
	    switch_2_block.clear_fn();
	    switch_2_blockValid.clear_fn();
	    switch_2_blockRetry.clear_fn();
	    rci0.clear_fn();
	    rco1.clear_fn();
	    block_2_switch.clear_fn();
	    block_2_switchValid.clear_fn();
	    block_2_switchRetry.clear_fn();
	    tb_cycle.clear_fn();
      tb_tune_val.clear_fn();
    }// /clear_fn()

    // Constructor
    alu_ref_design_(alu_ref_design_ports_p h=0):  
			reset((h!=0)?&(h->reset):0, 0, "reset") //h.reset
,			switch_2_block((h!=0)?&(h->switch_2_block):0, 0, "switch_2_block") //h.switch_2_block
,			switch_2_blockValid((h!=0)?&(h->switch_2_blockValid):0, 0, "switch_2_blockValid") //h.switch_2_blockValid
,			switch_2_blockRetry((h!=0)?&(h->switch_2_blockRetry):0, 0, "switch_2_blockRetry") //h.switch_2_blockRetry
,			rci0((h!=0)?&(h->rci0):0, 0, "rci0") //h.rci0
,			rco1((h!=0)?&(h->rco1):0, 0, "rco1") //h.rco1
,			block_2_switch((h!=0)?&(h->block_2_switch):0, 0, "block_2_switch") //h.block_2_switch
,			block_2_switchValid((h!=0)?&(h->block_2_switchValid):0, 0, "block_2_switchValid") //h.block_2_switchValid
,			block_2_switchRetry((h!=0)?&(h->block_2_switchRetry):0, 0, "block_2_switchRetry") //h.block_2_switchRetry
,     tb_cycle((h!=0)?&(h->tb_cycle):0, 0, "tb_cycle", 32)
,     tb_tune_val((h!=0)?&(h->tb_tune_val):0, 0, "tb_tune_val", 32){
    
	handles = h;
	if (h == 0) vpi_printf("@D alu_ref_design constructor: no handles given");
	clear_fn(); // Clear all objects of read, since we have not read yet; also has to be done start of every ttb_set

	if (0==1) vpi_printf("@D alu_ref_design constructor:");
    }// /constructor
};// /Main tb object alu_ref_design definition

#endif

//end alu_ref_design_ttb.h
