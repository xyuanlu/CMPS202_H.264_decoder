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

#ifndef H264_TTB
#define H264_TTB		


/**********************************************************************
 * Define storage structure for file pointer and vector handle.
 *********************************************************************/
typedef struct H264_ports {
	
	vpiHandle	reset_n, pin_disable_DF, freq_ctrl0, freq_ctrl1;
} H264_ports_s, *H264_ports_p;



// Main tb object alu_ref_design definition
class H264_{
  private: 
     H264_ports_p handles;

  public:
    
    //Start DUT variable definition
	BoolType		reset_n;
	BoolType		pin_disable_DF;
	BoolType		freq_ctrl0;
	BoolType		freq_ctrl1;
    
    // Clear objects every clock cycle. Optimization so we only read / write members we have to
    void clear_fn(){
	
	    reset_n.clear_fn();
	    pin_disable_DF.clear_fn();
	    freq_ctrl0.clear_fn();
	    freq_ctrl1.clear_fn();
    }// /clear_fn()

    // Constructor
    H264_(H264_ports_p h=0):  
			reset_n((h!=0)?&(h->reset_n):0, 0, "reset_n") //h.reset
,			pin_disable_DF((h!=0)?&(h->pin_disable_DF):0, 0, "pin_disable_DF") //h.switch_2_block
,			freq_ctrl0((h!=0)?&(h->freq_ctrl0):0, 0, "freq_ctrl0") //h.switch_2_blockValid
,			freq_ctrl1((h!=0)?&(h->freq_ctrl1):0, 0, "freq_ctrl1") //h.switch_2_blockRetry
{
    
	handles = h;
	if (h == 0) vpi_printf("@D H264 constructor: no handles given");
	clear_fn(); // Clear all objects of read, since we have not read yet; also has to be done start of every ttb_set

	if (0==1) vpi_printf("@D H264 constructor:");
    }// /constructor
};// /Main tb object H264 definition

#endif


