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

/****************************************************************************
    Description:
    This module is a simple alu with flopped inputs and outputs
    It serves as the reference design needed for communication
    on the MURN chip.
    An important note is this module has a 3 entry FIFO  
****************************************************************************/

import retry_common::*;
import rnet_common::*;
import alu_types::*;

module alu
(input BoolType         clk
 ,input BoolType        reset

 ,input BoolType        stop
 ,input BoolType        instValid_next
 ,input ALUopType       ALUop_next
 ,input shamtType       shamt_next
 ,input data1Type       data1_next
 ,input data2Type       data2_next
 
 ,output BoolType       outValid
 ,output ResultType     out
);


  BoolType        		instValid;
  ALUopType         	ALUop;
  shamtType         	shamt;
  data1Type         	data1;
  data2Type         	data2;

  BoolType          	outValid_next;
  ResultType        	out_next;

  BoolType          	delay_1_valid;
  ResultType        	delay_1;
 
  BoolType          	tmp_flop_valid;
  ResultType        	tmp_flop;

  logic        			stop_cntr_next;
  logic        			stop_cntr;
 
  BoolType        		instValid_p1;
  ALUopType       		ALUop_p1;
  shamtType       		shamt_p1;
  data1Type       		data1_p1;
  data2Type       		data2_p1;
   
  always_ff @(posedge clk) begin
    //Always accept new packets. We do not generate back pressure (this may
    //drop requests if we can not send a packet due to a stop). This module
    //assumes that there is no new packet until the answer has been sent out
    if (reset) begin
      instValid_p1     	<= 'b0;
      ALUop_p1         	<= 'b0;
      shamt_p1         	<= 'b0;
      data1_p1         	<= 'b0;
      data2_p1         	<= 'b0;
    end else begin
      instValid_p1     	<= instValid_next;
      ALUop_p1         	<= ALUop_next;
      shamt_p1         	<= shamt_next;
      data1_p1         	<= data1_next;
      data2_p1         	<= data2_next;
    end
  end 
  always_ff @(posedge clk) begin
    if (reset) begin
      instValid     		<= 'b0;
      ALUop         		<= 'b0;
      shamt         		<= 'b0;
      data1         		<= 'b0;
      data2         		<= 'b0;
    end else begin
      instValid     		<= instValid_p1;
      ALUop         		<= ALUop_p1;
      shamt         		<= shamt_p1;
      data1         		<= data1_p1;
      data2         		<= data2_p1;
    end
  end 
   
  always_comb begin
    if(ALUop == 4'd0) begin
      out_next      	= data1 + data2;
    end else if (ALUop == 4'd1) begin
      out_next      	= data1 << shamt;
    end else if (ALUop == 4'd2) begin
      out_next      	= data1 >> shamt;
    end else if (ALUop == 4'd3) begin
      out_next      = data1 * data2;
    end else if (ALUop == 4'd4)begin
      out_next      = data1 - data2;
    end else begin
      out_next      = data1 + data2;
    end
  end

  always_comb begin
    outValid_next   = instValid;

	case({stop,stop_cntr})
		'b00:stop_cntr_next = 0;
		'b01:stop_cntr_next = 0;
		'b10:stop_cntr_next = 1;
		default:stop_cntr_next = 1;
	endcase
    /*
	if( (stop == 0) && (stop_cntr == 0) ) begin
      stop_cntr_next = 0;
    end else if( (stop == 0) && (stop_cntr == 1) ) begin
      stop_cntr_next = 0; 
    end else if( (stop == 1) && (stop_cntr == 0) ) begin
      stop_cntr_next = 1; 
    end else if( (stop == 1) && (stop_cntr == 1) ) begin
      stop_cntr_next = 1; 
      outValid_next = delay_1_valid;
    end
	*/ 
  end


  always_ff @(posedge clk) begin
    if(reset) begin
      stop_cntr      <= 0;  
    end else begin
      stop_cntr      <= stop_cntr_next;
    end
  end

  always_ff @(posedge clk) begin
    if(reset) begin
      delay_1_valid   <= 0;  
    end else begin
      delay_1_valid   <= outValid_next;  
    end
  end

  always_ff @(posedge clk) begin
    if(reset) begin
      delay_1 <= 0;
    end else begin
      if( (stop) && (stop_cntr == 1) ) begin
        delay_1 <= delay_1;
      end else begin
        delay_1 <= out_next;
      end
    end
  end
  
  BoolType          tmp_flop_valid_next;
  ResultType        tmp_flop_next;
  always_comb begin
    if ( (stop == 0) && (stop_cntr == 1) ) begin
      tmp_flop_valid_next  = delay_1_valid;  
      tmp_flop_next        = delay_1;    
    end else if ( (stop == 1) && (stop_cntr == 0) ) begin
      tmp_flop_valid_next  = delay_1_valid;  
      tmp_flop_next        = delay_1;  
    end else begin
      tmp_flop_valid_next  = tmp_flop_valid;  
      tmp_flop_next        = tmp_flop;  
    end
  end
  always_ff @(posedge clk) begin
    if(reset) begin
      tmp_flop_valid  <= 0;  
      tmp_flop        <= 0;
    end else begin
      tmp_flop_valid  <= tmp_flop_valid_next;  
      tmp_flop        <= tmp_flop_next;    
    end
  end

  BoolType       outValid2_next;
  ResultType     out2_next;
  always_comb begin
    if ( (stop == 0) && (stop_cntr == 0) ) begin
      outValid2_next        = delay_1_valid;  
      out2_next             = delay_1;
    end else if ( (stop == 0) && (stop_cntr == 1) ) begin
      outValid2_next        = tmp_flop_valid;  
      out2_next             = tmp_flop;
    end else begin
      outValid2_next        = outValid;  
      out2_next             = out;
    end
  end

  always_ff @(posedge clk) begin
    if(reset) begin
      outValid        <= 0;  
      out             <= 0;
    end else begin
      outValid        <= outValid2_next;  
      out             <= out2_next;
    end
  end
   
endmodule
