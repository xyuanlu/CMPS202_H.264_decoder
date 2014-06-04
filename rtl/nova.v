//--------------------------------------------------------------------------------------------------
// Design    : nova
// Author(s) : Ke Xu
// Email	   : eexuke@yahoo.com
// File      : nova.v
// Generated : Feb 25,2006
// Copyright (C) 2008 Ke Xu                
//-------------------------------------------------------------------------------------------------
// Description 
// central logic of H264 decoder with input and output flops
//-------------------------------------------------------------------------------------------------

// synopsys translate_off
//`include "timescale.v"
// synopsys translate_on
`include "nova_defines.v"

import retry_common::*;
import rnet_common::*;
import H264_types::*;

module nova
(input BoolType 	clk
 ,input BoolType 	reset_n
 
 ,input BoolType        stop
 ,input BoolType        instValid_next
 ,output BoolType       outValid
 
 
 ,input BitstreamType 	BitStream_buffer_input_next
 ,input BoolType 	pin_disable_DF
 ,input BoolType 	freq_ctrl0
 ,input BoolType 	freq_ctrl1
	
 ,output BoolType 	BitStream_ram_ren
 ,output BitstreamAddrType 	BitStream_ram_addr
 ,output PicnumType 	pic_num
	//---ext_frame_RAM0---
 ,output BoolType 	ext_frame_RAM0_cs_n
 ,output BoolType 	ext_frame_RAM0_wr
 ,output RamAddrType ext_frame_RAM0_addr
	//inout [31:0] ext_frame_RAM0_data;
 ,input RamDataType 	ext_frame_RAM0_data_next
	
	//---ext_frame_RAM1---
 ,output BoolType 	ext_frame_RAM1_cs_n
 ,output BoolType 	ext_frame_RAM1_wr
 ,output RamAddrType 	ext_frame_RAM1_addr
	//inout [31:0] ext_frame_RAM1_data;
 ,input RamDataType 	ext_frame_RAM1_data_next
	
 ,output RamDataType 	dis_frame_RAM_din
 ,output BoolType 	slice_header_s6
 );
 
  always @ (posedge clk)	
		$display("BitStream_ram_addr:= %d\n", BitStream_ram_addr);
 
 
	BoolType        		instValid;
	BitstreamType         	BitStream_buffer_input;
	RamDataType         	ext_frame_RAM0_data;
	RamDataType         	ext_frame_RAM1_data;

	BoolType          	outValid_next;
	BoolType 	BitStream_ram_ren_next;
	BitstreamAddrType 	BitStream_ram_addr_next;
	PicnumType 	pic_num_next;
	BoolType 	ext_frame_RAM0_cs_n_next;
	BoolType 	ext_frame_RAM0_wr_next;
	RamAddrType ext_frame_RAM0_addr_next;
	BoolType 	ext_frame_RAM1_cs_n_next;
	BoolType 	ext_frame_RAM1_wr_next;
	RamAddrType 	ext_frame_RAM1_addr_next;
	RamDataType 	dis_frame_RAM_din_next;
	BoolType 	slice_header_s6_next;


	BoolType          	delay_1_valid;
	BoolType        	delay_1_BitStream_ram_ren;
	BitstreamAddrType 	delay_1_BitStream_ram_addr;
	PicnumType 	delay_1_pic_num;
	BoolType 	delay_1_ext_frame_RAM0_cs_n;
	BoolType 	delay_1_ext_frame_RAM0_wr;
	RamAddrType delay_1_ext_frame_RAM0_addr;
	BoolType 	delay_1_ext_frame_RAM1_cs_n;
	BoolType 	delay_1_ext_frame_RAM1_wr;
	RamAddrType 	delay_1_ext_frame_RAM1_addr;
	RamDataType 	delay_1_dis_frame_RAM_din;
	BoolType 	delay_1_slice_header_s6;
 
	BoolType          	tmp_flop_valid;
	BoolType        	tmp_flop_BitStream_ram_ren;
	BitstreamAddrType 	tmp_flop_BitStream_ram_addr;
	PicnumType 	tmp_flop_pic_num;
	BoolType 	tmp_flop_ext_frame_RAM0_cs_n;
	BoolType 	tmp_flop_ext_frame_RAM0_wr;
	RamAddrType tmp_flop_ext_frame_RAM0_addr;
	BoolType 	tmp_flop_ext_frame_RAM1_cs_n;
	BoolType 	tmp_flop_ext_frame_RAM1_wr;
	RamAddrType 	tmp_flop_ext_frame_RAM1_addr;
	RamDataType 	tmp_flop_dis_frame_RAM_din;
	BoolType 	tmp_flop_slice_header_s6;

	logic        			stop_cntr_next;
	logic        			stop_cntr;
 
	BoolType        		instValid_p1;
	BitstreamType         	BitStream_buffer_input_p1;
	RamDataType         	ext_frame_RAM0_data_p1;
	RamDataType         	ext_frame_RAM1_data_p1;
	
  always_ff @(posedge clk) begin

    if (!reset_n) begin
	  instValid_p1     	<= 'b0;
      BitStream_buffer_input_p1     	<= 'b0;
      ext_frame_RAM0_data_p1         	<= 'b0;
      ext_frame_RAM1_data_p1         	<= 'b0;
    end else begin
	  instValid_p1     	<= instValid_next;
      BitStream_buffer_input_p1     	<= BitStream_buffer_input_next;
      ext_frame_RAM0_data_p1         	<= ext_frame_RAM0_data_next;
      ext_frame_RAM1_data_p1         	<= ext_frame_RAM1_data_next;
    end
  end 
  always_ff @(posedge clk) begin
    if (!reset_n) begin
      instValid     		<= 'b0;
      BitStream_buffer_input         		<= 'b0;
      ext_frame_RAM0_data         		<= 'b0;
      ext_frame_RAM1_data         		<= 'b0;
    end else begin
      instValid     		<= instValid_p1;
      BitStream_buffer_input         		<= BitStream_buffer_input_p1;
      ext_frame_RAM0_data         		<= ext_frame_RAM0_data_p1;
      ext_frame_RAM1_data         		<= ext_frame_RAM1_data_p1;
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

  end

  always_ff @(posedge clk) begin
    if(!reset_n) begin
      stop_cntr      <= 0;  
    end else begin
      stop_cntr      <= stop_cntr_next;
    end
  end

  always_ff @(posedge clk) begin
    if(!reset_n) begin
      delay_1_valid   <= 0;  
    end else begin
      delay_1_valid   <= outValid_next;  
    end
  end
	
	
  always_ff @(posedge clk) begin
    if(!reset_n) begin
      delay_1_BitStream_ram_ren <= 1;
	  delay_1_BitStream_ram_addr <= 0;
	  delay_1_pic_num <= 0;
	  delay_1_ext_frame_RAM0_cs_n <= 1;
	  delay_1_ext_frame_RAM0_wr <= 0;
	  delay_1_ext_frame_RAM0_addr <= 0;
	  delay_1_ext_frame_RAM1_cs_n <= 1;
	  delay_1_ext_frame_RAM1_wr <= 0;
	  delay_1_ext_frame_RAM1_addr <= 0;
	  delay_1_dis_frame_RAM_din <= 0;	
	  delay_1_slice_header_s6 <= 0;		  
    end else begin
      if( (stop) && (stop_cntr == 1) ) begin
        delay_1_BitStream_ram_ren <= delay_1_BitStream_ram_ren;
	    delay_1_BitStream_ram_addr <= delay_1_BitStream_ram_addr;
		delay_1_pic_num <= delay_1_pic_num;
		delay_1_ext_frame_RAM0_cs_n <= delay_1_ext_frame_RAM0_cs_n;
		delay_1_ext_frame_RAM0_wr <= delay_1_ext_frame_RAM0_wr;
		delay_1_ext_frame_RAM0_addr <= delay_1_ext_frame_RAM0_addr;
		delay_1_ext_frame_RAM1_cs_n <= delay_1_ext_frame_RAM1_cs_n;
		delay_1_ext_frame_RAM1_wr <= delay_1_ext_frame_RAM1_wr;
		delay_1_ext_frame_RAM1_addr <= delay_1_ext_frame_RAM1_addr;
		delay_1_dis_frame_RAM_din <= delay_1_dis_frame_RAM_din;	
		delay_1_slice_header_s6 <= delay_1_slice_header_s6;	
      end else begin
		delay_1_BitStream_ram_ren <= BitStream_ram_ren_next;
	    delay_1_BitStream_ram_addr <= BitStream_ram_addr_next;
		delay_1_pic_num <= pic_num_next;
		delay_1_ext_frame_RAM0_cs_n <= ext_frame_RAM0_cs_n_next;
		delay_1_ext_frame_RAM0_wr <= ext_frame_RAM0_wr_next;
		delay_1_ext_frame_RAM0_addr <= ext_frame_RAM0_addr_next;
		delay_1_ext_frame_RAM1_cs_n <= ext_frame_RAM1_cs_n_next;
		delay_1_ext_frame_RAM1_wr <= ext_frame_RAM1_wr_next;
		delay_1_ext_frame_RAM1_addr <= ext_frame_RAM1_addr_next;
		delay_1_dis_frame_RAM_din <= dis_frame_RAM_din_next;	
		delay_1_slice_header_s6 <= slice_header_s6_next;
      end
    end
  end
  
	BoolType          	tmp_flop_valid_next;
	BoolType        	tmp_flop_BitStream_ram_ren_next;
	BitstreamAddrType 	tmp_flop_BitStream_ram_addr_next;
	PicnumType 	tmp_flop_pic_num_next;
	BoolType 	tmp_flop_ext_frame_RAM0_cs_n_next;
	BoolType 	tmp_flop_ext_frame_RAM0_wr_next;
	RamAddrType tmp_flop_ext_frame_RAM0_addr_next;
	BoolType 	tmp_flop_ext_frame_RAM1_cs_n_next;
	BoolType 	tmp_flop_ext_frame_RAM1_wr_next;
	RamAddrType 	tmp_flop_ext_frame_RAM1_addr_next;
	RamDataType 	tmp_flop_dis_frame_RAM_din_next;
	BoolType 	tmp_flop_slice_header_s6_next;

  always_comb begin
    if ( (stop == 0) && (stop_cntr == 1) ) begin
      tmp_flop_valid_next  = delay_1_valid;  
	  tmp_flop_BitStream_ram_ren_next = delay_1_BitStream_ram_ren;
	  tmp_flop_BitStream_ram_addr_next = delay_1_BitStream_ram_addr;
	  tmp_flop_pic_num_next = delay_1_pic_num;
	  tmp_flop_ext_frame_RAM0_cs_n_next = delay_1_ext_frame_RAM0_cs_n;
	  tmp_flop_ext_frame_RAM0_wr_next = delay_1_ext_frame_RAM0_wr;
	  tmp_flop_ext_frame_RAM0_addr_next = delay_1_ext_frame_RAM0_addr;
	  tmp_flop_ext_frame_RAM1_cs_n_next = delay_1_ext_frame_RAM1_cs_n;
	  tmp_flop_ext_frame_RAM1_wr_next = delay_1_ext_frame_RAM1_wr;
	  tmp_flop_ext_frame_RAM1_addr_next = delay_1_ext_frame_RAM1_addr;
	  tmp_flop_dis_frame_RAM_din_next = delay_1_dis_frame_RAM_din;
	  tmp_flop_slice_header_s6_next = delay_1_slice_header_s6;  
    end else if ( (stop == 1) && (stop_cntr == 0) ) begin
      tmp_flop_valid_next  = delay_1_valid;  
	  tmp_flop_BitStream_ram_ren_next = delay_1_BitStream_ram_ren;
	  tmp_flop_BitStream_ram_addr_next = delay_1_BitStream_ram_addr;
	  tmp_flop_pic_num_next = delay_1_pic_num;
	  tmp_flop_ext_frame_RAM0_cs_n_next = delay_1_ext_frame_RAM0_cs_n;
	  tmp_flop_ext_frame_RAM0_wr_next = delay_1_ext_frame_RAM0_wr;
	  tmp_flop_ext_frame_RAM0_addr_next = delay_1_ext_frame_RAM0_addr;
	  tmp_flop_ext_frame_RAM1_cs_n_next = delay_1_ext_frame_RAM1_cs_n;
	  tmp_flop_ext_frame_RAM1_wr_next = delay_1_ext_frame_RAM1_wr;
	  tmp_flop_ext_frame_RAM1_addr_next = delay_1_ext_frame_RAM1_addr;
	  tmp_flop_dis_frame_RAM_din_next = delay_1_dis_frame_RAM_din;
	  tmp_flop_slice_header_s6_next = delay_1_slice_header_s6;   
    end else begin
	  tmp_flop_valid_next  = tmp_flop_valid;  
	  tmp_flop_BitStream_ram_ren_next = tmp_flop_BitStream_ram_ren;
	  tmp_flop_BitStream_ram_addr_next = tmp_flop_BitStream_ram_addr;
	  tmp_flop_pic_num_next = tmp_flop_pic_num;
	  tmp_flop_ext_frame_RAM0_cs_n_next = tmp_flop_ext_frame_RAM0_cs_n;
	  tmp_flop_ext_frame_RAM0_wr_next = tmp_flop_ext_frame_RAM0_wr;
	  tmp_flop_ext_frame_RAM0_addr_next = tmp_flop_ext_frame_RAM0_addr;
	  tmp_flop_ext_frame_RAM1_cs_n_next = tmp_flop_ext_frame_RAM1_cs_n;
	  tmp_flop_ext_frame_RAM1_wr_next = tmp_flop_ext_frame_RAM1_wr;
	  tmp_flop_ext_frame_RAM1_addr_next = tmp_flop_ext_frame_RAM1_addr;
	  tmp_flop_dis_frame_RAM_din_next = tmp_flop_dis_frame_RAM_din;
	  tmp_flop_slice_header_s6_next = tmp_flop_slice_header_s6; 
    end
  end
  always_ff @(posedge clk) begin
    if(!reset_n) begin
	  tmp_flop_valid  <= 0;  
	  tmp_flop_BitStream_ram_ren <= 1;
	  tmp_flop_BitStream_ram_addr <= 0;
	  tmp_flop_pic_num <= 0;
	  tmp_flop_ext_frame_RAM0_cs_n <= 1;
	  tmp_flop_ext_frame_RAM0_wr <= 0;
	  tmp_flop_ext_frame_RAM0_addr <= 0;
	  tmp_flop_ext_frame_RAM1_cs_n <= 1;
	  tmp_flop_ext_frame_RAM1_wr <= 0;
	  tmp_flop_ext_frame_RAM1_addr <= 0;
	  tmp_flop_dis_frame_RAM_din <= 0;
	  tmp_flop_slice_header_s6 <= 0; 
    end else begin
	  tmp_flop_valid  <= tmp_flop_valid_next;  
	  tmp_flop_BitStream_ram_ren <= tmp_flop_BitStream_ram_ren_next;
	  tmp_flop_BitStream_ram_addr <= tmp_flop_BitStream_ram_addr_next;
	  tmp_flop_pic_num <= tmp_flop_pic_num_next;
	  tmp_flop_ext_frame_RAM0_cs_n <= tmp_flop_ext_frame_RAM0_cs_n_next;
	  tmp_flop_ext_frame_RAM0_wr <= tmp_flop_ext_frame_RAM0_wr_next;
	  tmp_flop_ext_frame_RAM0_addr <= tmp_flop_ext_frame_RAM0_addr_next;
	  tmp_flop_ext_frame_RAM1_cs_n <= tmp_flop_ext_frame_RAM1_cs_n_next;
	  tmp_flop_ext_frame_RAM1_wr <= tmp_flop_ext_frame_RAM1_wr_next;
	  tmp_flop_ext_frame_RAM1_addr <= tmp_flop_ext_frame_RAM1_addr_next;
	  tmp_flop_dis_frame_RAM_din <= tmp_flop_dis_frame_RAM_din_next;
	  tmp_flop_slice_header_s6 <= tmp_flop_slice_header_s6_next;    
    end
  end

	BoolType          	outvalid2_next;
	BoolType        	BitStream_ram_ren2_next;
	BitstreamAddrType 	BitStream_ram_addr2_next;
	PicnumType 	pic_num2_next;
	BoolType 	ext_frame_RAM0_cs_n2_next;
	BoolType 	ext_frame_RAM0_wr2_next;
	RamAddrType ext_frame_RAM0_addr2_next;
	BoolType 	ext_frame_RAM1_cs_n2_next;
	BoolType 	ext_frame_RAM1_wr2_next;
	RamAddrType 	ext_frame_RAM1_addr2_next;
	RamDataType 	dis_frame_RAM_din2_next;
	BoolType 	slice_header_s62_next;

  always_comb begin
    if ( (stop == 0) && (stop_cntr == 0) ) begin
	  outvalid2_next  = delay_1_valid;  
	  BitStream_ram_ren2_next = delay_1_BitStream_ram_ren;
	  BitStream_ram_addr2_next = delay_1_BitStream_ram_addr;
	  pic_num2_next = delay_1_pic_num;
	  ext_frame_RAM0_cs_n2_next = delay_1_ext_frame_RAM0_cs_n;
	  ext_frame_RAM0_wr2_next = delay_1_ext_frame_RAM0_wr;
	  ext_frame_RAM0_addr2_next = delay_1_ext_frame_RAM0_addr;
	  ext_frame_RAM1_cs_n2_next = delay_1_ext_frame_RAM1_cs_n;
	  ext_frame_RAM1_wr2_next = delay_1_ext_frame_RAM1_wr;
	  ext_frame_RAM1_addr2_next = delay_1_ext_frame_RAM1_addr;
	  dis_frame_RAM_din2_next = delay_1_dis_frame_RAM_din;
	  slice_header_s62_next = delay_1_slice_header_s6;

    end else if ( (stop == 0) && (stop_cntr == 1) ) begin	
	  outvalid2_next  = tmp_flop_valid;  
	  BitStream_ram_ren2_next = tmp_flop_BitStream_ram_ren;
	  BitStream_ram_addr2_next = tmp_flop_BitStream_ram_addr;
	  pic_num2_next = tmp_flop_pic_num;
	  ext_frame_RAM0_cs_n2_next = tmp_flop_ext_frame_RAM0_cs_n;
	  ext_frame_RAM0_wr2_next = tmp_flop_ext_frame_RAM0_wr;
	  ext_frame_RAM0_addr2_next = tmp_flop_ext_frame_RAM0_addr;
	  ext_frame_RAM1_cs_n2_next = tmp_flop_ext_frame_RAM1_cs_n;
	  ext_frame_RAM1_wr2_next = tmp_flop_ext_frame_RAM1_wr;
	  ext_frame_RAM1_addr2_next = tmp_flop_ext_frame_RAM1_addr;
	  dis_frame_RAM_din2_next = tmp_flop_dis_frame_RAM_din;
	  slice_header_s62_next = tmp_flop_slice_header_s6;

    end else begin
	  outvalid2_next  = outValid;  
	  BitStream_ram_ren2_next = BitStream_ram_ren;
	  BitStream_ram_addr2_next = BitStream_ram_addr;
	  pic_num2_next = pic_num;
	  ext_frame_RAM0_cs_n2_next = ext_frame_RAM0_cs_n;
	  ext_frame_RAM0_wr2_next = ext_frame_RAM0_wr;
	  ext_frame_RAM0_addr2_next = ext_frame_RAM0_addr;
	  ext_frame_RAM1_cs_n2_next = ext_frame_RAM1_cs_n;
	  ext_frame_RAM1_wr2_next = ext_frame_RAM1_wr;
	  ext_frame_RAM1_addr2_next = ext_frame_RAM1_addr;
	  dis_frame_RAM_din2_next = dis_frame_RAM_din;
	  slice_header_s62_next = slice_header_s6;
    end
  end

  always_ff @(posedge clk) begin
    if(!reset_n) begin
      outValid        <= 0;  
      BitStream_ram_ren <= 1;
	  BitStream_ram_addr <= 0;
	  pic_num <= 0;
	  ext_frame_RAM0_cs_n <= 1;
	  ext_frame_RAM0_wr <= 0;
	  ext_frame_RAM0_addr <= 0;
	  ext_frame_RAM1_cs_n <= 1;
	  ext_frame_RAM1_wr <= 0;
	  ext_frame_RAM1_addr <= 0;
	  dis_frame_RAM_din <= 0;
	  slice_header_s6 <= 0;
    end else begin
	  outValid        <= outvalid2_next;  
      BitStream_ram_ren <= BitStream_ram_ren2_next;
	  BitStream_ram_addr <= BitStream_ram_addr2_next;
	  pic_num <= pic_num2_next;
	  ext_frame_RAM0_cs_n <= ext_frame_RAM0_cs_n2_next;
	  ext_frame_RAM0_wr <= ext_frame_RAM0_wr2_next;
	  ext_frame_RAM0_addr <= ext_frame_RAM0_addr2_next;
	  ext_frame_RAM1_cs_n <= ext_frame_RAM1_cs_n2_next;
	  ext_frame_RAM1_wr <= ext_frame_RAM1_wr2_next;
	  ext_frame_RAM1_addr <= ext_frame_RAM1_addr2_next;
	  dis_frame_RAM_din <= dis_frame_RAM_din2_next;
	  slice_header_s6 <= slice_header_s62_next;
    end
  end
 
 always @ (posedge clk)	
		$display("stop:= %d\n", stop);
	   
	wire trigger_CAVLC;	
	wire end_of_NonZeroCoeff_CAVLC;
	wire end_of_DCBlk_IQIT;
	wire end_of_one_blk4x4_sum;
	wire end_of_MB_DEC;
	wire gclk_end_of_MB_DEC;
	wire end_of_one_residual_block;
	wire end_of_one_frame;
	wire Is_skip_run_entry;
	wire Is_skip_run_end;
	wire skip_mv_calc;
	wire [3:0] mb_type_general;
	wire [3:0] mb_num_h;
	wire [3:0] mb_num_v;
	wire NextMB_IsSkip;
	wire LowerMB_IsSkip;
	wire [4:0] blk4x4_rec_counter;
	wire [3:0] slice_data_state;
	wire [3:0] residual_state; 
	wire [3:0] cavlc_decoder_state;
	wire [1:0] Intra16x16_predmode;
	wire [63:0] Intra4x4_predmode_CurrMb;
	wire [1:0] Intra_chroma_predmode;
	wire [5:0] QPy;
	wire [5:0] QPc;
	wire [1:0] i4x4_CbCr;
	wire [3:0] slice_alpha_c0_offset_div2;
	wire [3:0] slice_beta_offset_div2;
	wire [3:0] CodedBlockPatternLuma;
	wire [1:0] CodedBlockPatternChroma;
	wire [4:0] TotalCoeff;
	wire disable_DF;
	wire [8:0] coeffLevel_0, coeffLevel_1, coeffLevel_2,coeffLevel_3, coeffLevel_4, coeffLevel_5; 
	wire [8:0] coeffLevel_6, coeffLevel_7, coeffLevel_8, coeffLevel_9,coeffLevel_10,coeffLevel_11;
	wire [8:0] coeffLevel_12,coeffLevel_13,coeffLevel_14,coeffLevel_15;	
	wire mv_is16x16;
	wire [3:0] mv_below8x8;
	wire [31:0] mvx_CurrMb0,mvx_CurrMb1,mvx_CurrMb2,mvx_CurrMb3;
	wire [31:0] mvy_CurrMb0,mvy_CurrMb1,mvy_CurrMb2,mvy_CurrMb3;
	wire [11:0] bs_V0,bs_V1,bs_V2,bs_V3;
	wire [11:0] bs_H0,bs_H1,bs_H2,bs_H3;
	wire curr_DC_IsZero;
	wire end_of_BS_DEC;
	
	
	BitStream_controller BitStream_controller (
		.clk(clk),
	  .reset_n(reset_n),
		.freq_ctrl0(freq_ctrl0),
		.freq_ctrl1(freq_ctrl1),
	  .BitStream_buffer_input(BitStream_buffer_input),
		.pin_disable_DF(pin_disable_DF),
	  .trigger_CAVLC(trigger_CAVLC),
		.blk4x4_rec_counter(blk4x4_rec_counter),
		.end_of_DCBlk_IQIT(end_of_DCBlk_IQIT),
		.end_of_one_blk4x4_sum(end_of_one_blk4x4_sum),
		.end_of_MB_DEC(end_of_MB_DEC),
		.gclk_end_of_MB_DEC(gclk_end_of_MB_DEC),
		.curr_DC_IsZero(curr_DC_IsZero),
	    
		.BitStream_ram_ren(BitStream_ram_ren_next),
		.BitStream_ram_addr(BitStream_ram_addr_next),
		.pic_num(pic_num_next),
		.mb_type_general(mb_type_general),
	  .mb_num_h(mb_num_h),
	  .mb_num_v(mb_num_v),
		.NextMB_IsSkip(NextMB_IsSkip),
		.LowerMB_IsSkip(LowerMB_IsSkip),
		.slice_data_state(slice_data_state),
		.residual_state(residual_state),
		.cavlc_decoder_state(cavlc_decoder_state),
		.end_of_one_residual_block(end_of_one_residual_block),
		.end_of_NonZeroCoeff_CAVLC(end_of_NonZeroCoeff_CAVLC),
		.end_of_one_frame(end_of_one_frame),
		.Intra16x16_predmode(Intra16x16_predmode),
		.Intra4x4_predmode_CurrMb(Intra4x4_predmode_CurrMb),
		.Intra_chroma_predmode(Intra_chroma_predmode),
		.QPy(QPy),
		.QPc(QPc),
		.i4x4_CbCr(i4x4_CbCr),
		.slice_alpha_c0_offset_div2(slice_alpha_c0_offset_div2),
		.slice_beta_offset_div2(slice_beta_offset_div2),
		.CodedBlockPatternLuma(CodedBlockPatternLuma),
		.CodedBlockPatternChroma(CodedBlockPatternChroma),
		.TotalCoeff(TotalCoeff),
		.Is_skip_run_entry(Is_skip_run_entry),
		.skip_mv_calc(skip_mv_calc),
		.disable_DF(disable_DF),
		.coeffLevel_0(coeffLevel_0),
		.coeffLevel_1(coeffLevel_1),
		.coeffLevel_2(coeffLevel_2), 
		.coeffLevel_3(coeffLevel_3), 
		.coeffLevel_4(coeffLevel_4), 
		.coeffLevel_5(coeffLevel_5), 
		.coeffLevel_6(coeffLevel_6), 
		.coeffLevel_7(coeffLevel_7),
		.coeffLevel_8(coeffLevel_8),
		.coeffLevel_9(coeffLevel_9),
		.coeffLevel_10(coeffLevel_10),
		.coeffLevel_11(coeffLevel_11),
		.coeffLevel_12(coeffLevel_12),
		.coeffLevel_13(coeffLevel_13),
		.coeffLevel_14(coeffLevel_14),
		.coeffLevel_15(coeffLevel_15),
		.mv_is16x16(mv_is16x16),
		.mv_below8x8(mv_below8x8),
		.mvx_CurrMb0(mvx_CurrMb0),
		.mvx_CurrMb1(mvx_CurrMb1),
		.mvx_CurrMb2(mvx_CurrMb2),
		.mvx_CurrMb3(mvx_CurrMb3),
		.mvy_CurrMb0(mvy_CurrMb0),
		.mvy_CurrMb1(mvy_CurrMb1),
		.mvy_CurrMb2(mvy_CurrMb2),
		.mvy_CurrMb3(mvy_CurrMb3),
		.end_of_BS_DEC(end_of_BS_DEC),
		.bs_V0(bs_V0),
		.bs_V1(bs_V1),
		.bs_V2(bs_V2),
		.bs_V3(bs_V3),
		.bs_H0(bs_H0),
		.bs_H1(bs_H1),
		.bs_H2(bs_H2),
		.bs_H3(bs_H3),
		
		.slice_header_s6(slice_header_s6_next)
		);
	reconstruction reconstruction (
		.clk(clk),
	  .reset_n(reset_n),
	  .mb_type_general(mb_type_general),
	  .mb_num_h(mb_num_h),
	  .mb_num_v(mb_num_v),
		.NextMB_IsSkip(NextMB_IsSkip),
		.LowerMB_IsSkip(LowerMB_IsSkip),
		.slice_data_state(slice_data_state),
		.residual_state(residual_state),
		.cavlc_decoder_state(cavlc_decoder_state),
		.end_of_one_residual_block(end_of_one_residual_block),
		.end_of_NonZeroCoeff_CAVLC(end_of_NonZeroCoeff_CAVLC),
		.end_of_one_frame(end_of_one_frame),
	  .Intra16x16_predmode(Intra16x16_predmode),
		.Intra4x4_predmode_CurrMb(Intra4x4_predmode_CurrMb),
		.Intra_chroma_predmode(Intra_chroma_predmode),
		.QPy(QPy),
		.QPc(QPc),
		.i4x4_CbCr(i4x4_CbCr),
		.slice_alpha_c0_offset_div2(slice_alpha_c0_offset_div2),
		.slice_beta_offset_div2(slice_beta_offset_div2),
		.CodedBlockPatternLuma(CodedBlockPatternLuma),
		.CodedBlockPatternChroma(CodedBlockPatternChroma),
		.TotalCoeff(TotalCoeff), 
		.Is_skip_run_entry(Is_skip_run_entry),
		.skip_mv_calc(skip_mv_calc),
		.disable_DF(disable_DF),
		.coeffLevel_0(coeffLevel_0),
		.coeffLevel_1(coeffLevel_1),
		.coeffLevel_2(coeffLevel_2), 
		.coeffLevel_3(coeffLevel_3), 
		.coeffLevel_4(coeffLevel_4), 
		.coeffLevel_5(coeffLevel_5), 
		.coeffLevel_6(coeffLevel_6), 
		.coeffLevel_7(coeffLevel_7),
		.coeffLevel_8(coeffLevel_8),
		.coeffLevel_9(coeffLevel_9),
		.coeffLevel_10(coeffLevel_10),
		.coeffLevel_11(coeffLevel_11),
		.coeffLevel_12(coeffLevel_12),
		.coeffLevel_13(coeffLevel_13),
		.coeffLevel_14(coeffLevel_14),
		.coeffLevel_15(coeffLevel_15),
		.mv_is16x16(mv_is16x16),
		.mv_below8x8(mv_below8x8),
		.mvx_CurrMb0(mvx_CurrMb0),
		.mvx_CurrMb1(mvx_CurrMb1),
		.mvx_CurrMb2(mvx_CurrMb2),
		.mvx_CurrMb3(mvx_CurrMb3),
		.mvy_CurrMb0(mvy_CurrMb0),
		.mvy_CurrMb1(mvy_CurrMb1),
		.mvy_CurrMb2(mvy_CurrMb2),
		.mvy_CurrMb3(mvy_CurrMb3),
		.end_of_BS_DEC(end_of_BS_DEC),
		.bs_V0(bs_V0),
		.bs_V1(bs_V1),
		.bs_V2(bs_V2),
		.bs_V3(bs_V3),
		.bs_H0(bs_H0),
		.bs_H1(bs_H1),
		.bs_H2(bs_H2),
		.bs_H3(bs_H3),
			
		.trigger_CAVLC(trigger_CAVLC),
		.blk4x4_rec_counter(blk4x4_rec_counter),
		.end_of_DCBlk_IQIT(end_of_DCBlk_IQIT),
		.end_of_one_blk4x4_sum(end_of_one_blk4x4_sum),
		.end_of_MB_DEC(end_of_MB_DEC),
		.gclk_end_of_MB_DEC(gclk_end_of_MB_DEC),
		.curr_DC_IsZero(curr_DC_IsZero),
		.ext_frame_RAM0_cs_n(ext_frame_RAM0_cs_n_next),
		.ext_frame_RAM0_wr(ext_frame_RAM0_wr_next),
		.ext_frame_RAM0_addr(ext_frame_RAM0_addr_next),
		.ext_frame_RAM0_data(ext_frame_RAM0_data),
		.ext_frame_RAM1_cs_n(ext_frame_RAM1_cs_n_next),
		.ext_frame_RAM1_wr(ext_frame_RAM1_wr_next),
		.ext_frame_RAM1_addr(ext_frame_RAM1_addr_next),
		.ext_frame_RAM1_data(ext_frame_RAM1_data),
		.dis_frame_RAM_din(dis_frame_RAM_din_next)
		);

endmodule
