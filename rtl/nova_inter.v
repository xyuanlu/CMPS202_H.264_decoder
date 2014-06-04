`include "nova_defines.v"

import retry_common::*;
import rnet_common::*;
import H264_types::*;

module nova_inter
 (input BoolType        clk
 ,input BoolType        reset_n
   
 //Input from Switch
 ,input BoolType		pin_disable_DF
 ,input BoolType		freq_ctrl0
 ,input BoolType		freq_ctrl1
 ,input InputPacketType  inputInterface
 ,input BoolType        instValid
 //Retry
 ,output BoolType       outStop
 
 //Output to switch
 ,output OutputPacketType outputInterface
 ,output BoolType       outValid
 //Stop
 ,input BoolType    stop
);

	BoolType				stop_t;
	BoolType        		instValid_t;
	BitstreamType         	BitStream_buffer_input_t;
	RamDataType         	ext_frame_RAM0_data_t;
	RamDataType         	ext_frame_RAM1_data_t;
	
	BoolType          	outValid_t;
	BoolType 	BitStream_ram_ren_t;
	BitstreamAddrType 	BitStream_ram_addr_t;
	PicnumType 	pic_num_t;
	BoolType 	ext_frame_RAM0_cs_n_t;
	BoolType 	ext_frame_RAM0_wr_t;
	RamAddrType ext_frame_RAM0_addr_t;
	BoolType 	ext_frame_RAM1_cs_n_t;
	BoolType 	ext_frame_RAM1_wr_t;
	RamAddrType 	ext_frame_RAM1_addr_t;
	RamDataType 	dis_frame_RAM_din_t;
	BoolType 	slice_header_s6_t;


  assign           outStop = 0;  //****Never Retry****
  //Inputs set for design 
  always_comb begin
    instValid_t = instValid;//
	BitStream_buffer_input_t = inputInterface.BitStream_buffer_input;
	ext_frame_RAM0_data_t = inputInterface.ext_frame_RAM0_data;
	ext_frame_RAM1_data_t = inputInterface.ext_frame_RAM1_data;
  end

  //Outputs from design
  always_comb begin
    outValid   = 0;
    outputInterface.BitStream_ram_ren  = 1;
    outputInterface.BitStream_ram_addr = 0;
    outputInterface.pic_num    = 0;
	outputInterface.ext_frame_RAM0_cs_n = 1;
	outputInterface.ext_frame_RAM0_wr = 0;
	outputInterface.ext_frame_RAM0_addr = 0;
	outputInterface.ext_frame_RAM1_cs_n = 0;
	outputInterface.ext_frame_RAM1_wr = 0;
	outputInterface.ext_frame_RAM1_addr = 0;
	outputInterface.dis_frame_RAM_din = 0;
	outputInterface.slice_header_s6 = 0;
	
    if(outValid_t) begin
		outValid   = 1'b1;
		outputInterface.BitStream_ram_ren  = BitStream_ram_ren_t;
		outputInterface.BitStream_ram_addr = BitStream_ram_addr_t;
		outputInterface.pic_num    = pic_num_t;
		outputInterface.ext_frame_RAM0_cs_n = ext_frame_RAM0_cs_n_t;
		outputInterface.ext_frame_RAM0_wr = ext_frame_RAM0_wr_t;
		outputInterface.ext_frame_RAM0_addr = ext_frame_RAM0_addr_t;
		outputInterface.ext_frame_RAM1_cs_n = ext_frame_RAM1_cs_n_t;
		outputInterface.ext_frame_RAM1_wr = ext_frame_RAM1_wr_t;
		outputInterface.ext_frame_RAM1_addr = ext_frame_RAM1_addr_t;
		outputInterface.dis_frame_RAM_din = dis_frame_RAM_din_t;
		outputInterface.slice_header_s6 = slice_header_s6_t;      
    end
  end


 nova           dut
  (.clk            (clk),
  .reset_n           (reset_n),
  .stop            (stop_t),
  .instValid_next  (instValid_t),
  
  .pin_disable_DF	(pin_disable_DF),
  .freq_ctrl0	(freq_ctrl0),
  .freq_ctrl1	(freq_ctrl1),
  
  .BitStream_buffer_input_next      (BitStream_buffer_input_t),
  .ext_frame_RAM0_data_next	(ext_frame_RAM0_data_t),
  .ext_frame_RAM1_data_next	(ext_frame_RAM1_data_t),
  
  .BitStream_ram_ren      (BitStream_ram_ren_t),
  .BitStream_ram_addr      (BitStream_ram_addr_t),
  .pic_num      (pic_num_t),
  .ext_frame_RAM0_cs_n	(ext_frame_RAM0_cs_n_t),
  .ext_frame_RAM0_wr	(ext_frame_RAM0_wr_t),
  .ext_frame_RAM0_addr	(ext_frame_RAM0_addr_t),
  .ext_frame_RAM1_cs_n	(ext_frame_RAM1_cs_n_t),
  .ext_frame_RAM1_wr	(ext_frame_RAM1_wr_t),
  .ext_frame_RAM1_addr	(ext_frame_RAM1_addr_t),
  .dis_frame_RAM_din	(dis_frame_RAM_din_t),
  .slice_header_s6	(slice_header_s6_t),
  
  .outValid        (outValid_t)
  );
  
  endmodule
  
  
  