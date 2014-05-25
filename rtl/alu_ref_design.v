//==============================================================================
//      File:           $URL$
//      Version:        $Revision$
//      Author:         Rigo Dicochea (http://masc.cse.ucsc.edu/)
//                      Jose Renau
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
import alu_types::*;


module alu_ref_design
(input BoolType	          clk
 ,input BoolType      	  reset
  
 //Input from switch
 ,input RingPacketType	  switch_2_block      //connected to stage switch_2_block port
 ,input BoolType      	  switch_2_blockValid //connected to stage switch_2_blockValid port
 //Retry
 ,output BoolType         switch_2_blockRetry //connected to stage switch_2_blockRetry

 //Retry Re-clocking signals
 ,input  ReclkIOType      rci0
 ,output ReclkIOType      rco1

 //Output to switch
 ,output RingPacketType   block_2_switch //connected to 
 ,output BoolType         block_2_switchValid //connected 
  //Stop
 ,input BoolType          block_2_switchRetry //connected 
);


    RingPacketType	  result;
    BoolType		  resultValid;
    BoolType		  stop;
    ReclkIOType           rco0;
    ReclkIOType           rci1;
	
    RingPacketType	  switch_2_block_flop;
    BoolType      	  switch_2_block_flopValid;
    BoolType              switch_2_block_flopRetry;


    stage #(.Size($bits(RingPacketType)))  stage_inputs
    (.clk       	  (clk),
     .reset               (reset),

     .din       	  (switch_2_block),
     .dinValid            (switch_2_blockValid),
     .dinRetry            (switch_2_blockRetry),
     //outputs to switch
     .q                   (switch_2_block_flop),
     .qValid              (switch_2_block_flopValid),
     .qRetry              (switch_2_block_flopRetry),
     //Re-clocking signals
     .rci           	  (rci0),
     .rco          	  (rco0)
    );

    alu_top               alu_rnode
    (.clk                 (clk),
     .reset               (reset),
  
     //Input from switch
     .switch_2_blockValid (switch_2_block_flopValid),
     .switch_2_block	  (switch_2_block_flop),
     //output retry signal sent backwards to stage.v block
     .switch_2_blockRetry (switch_2_block_flopRetry),

     //Output to switch
     .block_2_switchValid (resultValid),
     .block_2_switch	  (result),
     //****Stop signal Input
     .block_2_switchRetry (stop)
    );

    always_comb begin
        rci1 = rco0;
    end

    stage #(.Size($bits(RingPacketType)))  stage_outputs
    (.clk       	  (clk),
     .reset               (reset),

     .din                 (result),
     .dinValid            (resultValid),
     .dinRetry            (stop),
     //outputs to switch
     .q                   (block_2_switch),
     .qValid              (block_2_switchValid),
     .qRetry              (block_2_switchRetry),
     //Re-clocking signals
     .rci           	  (rci1),
     .rco          	  (rco1)
    );

 
endmodule
