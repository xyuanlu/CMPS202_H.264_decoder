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

 All the defines / structs for the H264 testbench

****************************************************************************/

#ifndef H264_TTB
#define H264_TTB		


/**********************************************************************
 * Define storage structure for file pointer and vector handle.
 *********************************************************************/
typedef struct H264_ports {
	// All H264's ports
	
	vpiHandle	reset_n, inputInterface, pin_disable_DF, freq_ctrl0;
	vpiHandle	freq_ctrl1, instValid, outStop, outputInterface, outValid, stop;
	vpiHandle	tb_cycle, rci0, rco1,;
	vpiHandle	tb_tune_val;
} H264_ports_s, *H264_ports_p;



// wrapper function to reduce code density
inline uint64_t  H264_read(vpiHandle handle, s_vpi_value data, int length, bool first=false) {
	
	uint64_t ret=0;
	data.format = vpiBinStrVal;
	vpi_get_value(handle, &data);
	read_uint64_t(data.value.str, length, &ret, first);
	
  return ret;
}

// Main tb object H264 definition
class H264_{
  private: 
     H264_ports_p handles;

  public:
    
    //Start DUT variable definition
    BoolType		reset_n;
    BoolType		pin_disable_DF;
    BoolType		freq_ctrl0;
    BoolType		freq_ctrl1;
	InputPacketType	  inputInterface;
	BoolType      	  instValid;
	BoolType         outStop;
	OutputPacketType   outputInterface;
	BoolType         outValid;
	BoolType          stop;
	ReclkIOType		rci0;
    ReclkIOType		rco1;
    GenType		tb_cycle;
    GenType   tb_tune_val; 
    
    // Clear objects every clock cycle. Optimization so we only read / write members we have to
    void clear_fn(){
	
	    reset_n.clear_fn();	    
	    pin_disable_DF.clear_fn();
	    freq_ctrl0.clear_fn();
	    freq_ctrl1.clear_fn();
		inputInterface.clear_fn();
		instValid.clear_fn();
		outStop.clear_fn();
		outputInterface.clear_fn();
		outValid.clear_fn();
		stop.clear_fn();
	    rci0.clear_fn();
	    rco1.clear_fn();
	    tb_cycle.clear_fn();
      tb_tune_val.clear_fn();
    }// /clear_fn()

    // Constructor
    H264_(H264_ports_p h=0):  
			reset_n((h!=0)?&(h->reset_n):0, 0, "reset_n") //h.reset_n
,			pin_disable_DF((h!=0)?&(h->pin_disable_DF):0, 0, "pin_disable_DF") //h.pin_disable_DF
,			freq_ctrl0((h!=0)?&(h->freq_ctrl0):0, 0, "freq_ctrl0") //h.freq_ctrl0
,			freq_ctrl1((h!=0)?&(h->freq_ctrl1):0, 0, "freq_ctrl1") //h.freq_ctrl1
,			inputInterface((h!=0)?&(h->inputInterface):0, 0, "inputInterface")
,			instValid((h!=0)?&(h->instValid):0, 0, "instValid")
,			outStop((h!=0)?&(h->outStop):0, 0, "outStop")
,			outputInterface((h!=0)?&(h->outputInterface):0, 0, "outputInterface")
,			outValid((h!=0)?&(h->outValid):0, 0, "outValid")
,			stop((h!=0)?&(h->stop):0, 0, "stop")
,			rci0((h!=0)?&(h->rci0):0, 0, "rci0") //h.rci0
,			rco1((h!=0)?&(h->rco1):0, 0, "rco1") //h.rco1
,     tb_cycle((h!=0)?&(h->tb_cycle):0, 0, "tb_cycle", 32)
,     tb_tune_val((h!=0)?&(h->tb_tune_val):0, 0, "tb_tune_val", 32){
    
	handles = h;
	vpi_printf("@D handles h=%d:", h);
	if (h == 0) vpi_printf("@D H264 constructor: no handles given");
	clear_fn(); // Clear all objects of read, since we have not read yet; also has to be done start of every ttb_set

	if (0==1) vpi_printf("@D H264 constructor:");
    }// /constructor
};// /Main tb object H264 definition

#endif

//end H264_ttb.h
