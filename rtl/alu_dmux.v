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

 
module alu_dmux
 (input BoolType        clk
 ,input BoolType        reset
   
 //Input from Switch
 ,input RingPacketType  switch_2_dmux
 ,input BoolType        switch_2_dmuxValid
 //Retry
 ,output BoolType       switch_2_dmuxRetry
 
 //Output to switch
 ,output RingPacketType block_2_switch
 ,output BoolType       block_2_switchValid
 //Stop
 ,input BoolType    block_2_switchRetry
);

  assign           switch_2_dmuxRetry = 0;  //****Never Retry****

  //Signals for node
  BoolType           alu_inst_valid_next;
  ALUopType          alu_op_next;
  shamtType         shamt_next;
  data1Type         data1_next;
  data2Type            data2_next;

  //Signals for switch
  BoolType           resultValid;
  ResultType      aluResult;


  //Inputs set for design 
  always_comb begin
    alu_inst_valid_next = switch_2_dmuxValid;//switch_2_dmux.opcode[0];//lowest bit of opcode

    alu_op_next         = switch_2_dmux.opcode[4:1];
    shamt_next          = switch_2_dmux.data[63:59]; //should always be zero based on TB

    data1_next          = switch_2_dmux.data[63:32];
    data2_next          = switch_2_dmux.data[31:0];
  end

  //Outputs from design
  always_comb begin
    block_2_switchValid   = 0;
    block_2_switch.srcid  = 0;
    block_2_switch.destid = 0;
    block_2_switch.cmd    = 0;

    block_2_switch.opcode = 0;
    block_2_switch.data   = 0;

    if(resultValid) begin
      block_2_switchValid   = 1'b1;
      block_2_switch.srcid  = 4'b0;
      block_2_switch.destid = 4'b1;
      block_2_switch.cmd    = 1'b0;

      block_2_switch.opcode = 7'b0000100;
      block_2_switch.data   = {32'b0, aluResult};
    end
  end

  BoolType        instValid;
  ALUopType       ALUop;
  shamtType       shamt;
  data1Type       data1;
  data2Type       data2;
  // flop inputs without computation if the block is a flop based one
  always_comb begin
    instValid = alu_inst_valid_next;
    ALUop     = alu_op_next;
    shamt     = shamt_next;
    data1     = data1_next;
    data2     = data2_next;
  end
  
  alu           dut
  (.clk            (clk),
  .reset           (reset),

  .stop            (block_2_switchRetry),
  .instValid_next  (instValid),
  .ALUop_next      (ALUop),
  .shamt_next      (shamt),
  .data1_next      (data1),
  .data2_next      (data2),

  .outValid        (resultValid),
  .out             (aluResult)
  );

endmodule
