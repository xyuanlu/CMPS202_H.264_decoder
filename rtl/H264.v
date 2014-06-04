//==============================================================================
//      File:           $URL$
//      Version:        $Revision$
//      Author:         Bipeng zhang 
//                      Xiaoyuan Lu
//      Copyright:      Copyright 2011 UC Santa Cruz
//==============================================================================

//==============================================================================
//      Section:        License
//==============================================================================
//      Copyright (c) 2011, Regents of the University of California
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

import retry_common::*;
import rnet_common::*;
import H264_types::*;


module H264
(input BoolType	          clk
 ,input BoolType      	  reset_n
 ,input BoolType		  pin_disable_DF
 ,input BoolType		  freq_ctrl0
 ,input BoolType		  freq_ctrl1
  
 //Input from switch
 ,input InputPacketType	  inputInterface      //
 ,input BoolType      	  instValid //
 //Retry
 ,output BoolType         outStop //

 //Retry Re-clocking signals
 ,input  ReclkIOType      rci0
 ,output ReclkIOType      rco1

 //Output to switch
 ,output OutputPacketType   outputInterface //
 ,output BoolType         outValid //
  //Stop
 ,input BoolType          stop //
);

always @ (posedge clk)	
		$display("H264_stop:= %d\n", stop);


	InputPacketType		inputInterface_t;
	BoolType		instValid_t;
	BoolType		outStop_t;
	OutputPacketType		outputInterface_t;
	BoolType		outValid_t;
	BoolType		stop_t;

	ReclkIOType           rco0;
    ReclkIOType           rci1;

    stage #(.Size($bits(InputPacketType)))  stage_inputs
    (.clk       	  (clk),
     .reset               (reset_n),

     .din       	  (inputInterface),
     .dinValid            (instValid),
     .dinRetry            (stop_t),
     //outputs to switch
     .q                   (inputInterface_t),
     .qValid              (instValid_t),
     .qRetry              (stop),
     //Re-clocking signals
     .rci           	  (rci0),
     .rco          	  (rco0)
    );

	

    nova_inter               dut_nova
    (.clk                 (clk),
     .reset_n               (reset_n),
	 .pin_disable_DF		(pin_disable_DF),
	 .freq_ctrl0		(freq_ctrl0),
	 .freq_ctrl1		(freq_ctrl1),
  
     //Input from switch
     .inputInterface (inputInterface_t),
     .instValid	  (instValid_t),
     //output retry signal sent backwards to stage.v block
     .outStop (outStop_t),

     //Output to switch
     .outputInterface (outputInterface_t),
     .outValid	  (outValid_t),
     //****Stop signal Input
     .stop (stop_t)
    );

    always_comb begin
        rci1 = rco0;
    end

	stage #(.Size($bits(OutputPacketType)))  stage_outputs
    (.clk       	  (clk),
     .reset               (reset_n),

     .din                 (outputInterface_t),
     .dinValid            (outValid_t),
     .dinRetry            (outStop),
     //outputs to switch
     .q                   (outputInterface),
     .qValid              (outValid),
     .qRetry              (outStop_t),
     //Re-clocking signals
     .rci           	  (rci1),
     .rco          	  (rco1)
    );
 
endmodule
