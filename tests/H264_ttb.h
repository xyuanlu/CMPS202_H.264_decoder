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
	
	vpiHandle	reset_n, BitStream_buffer_input, pin_disable_DF, freq_ctrl0;
	vpiHandle	freq_ctrl1, BitStream_ram_ren, BitStream_ram_addr, pic_num;
	vpiHandle	ext_frame_RAM0_cs_n, ext_frame_RAM0_wr, ext_frame_RAM0_addr, ext_frame_RAM0_data;
	vpiHandle	ext_frame_RAM1_cs_n, ext_frame_RAM1_wr, ext_frame_RAM1_addr, ext_frame_RAM1_data;
	vpiHandle	dis_frame_RAM_din, slice_header_s6;
	vpiHandle	tb_cycle;
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
    BitstreamType		BitStream_buffer_input;
    BoolType		pin_disable_DF;
    BoolType		freq_ctrl0;
    BoolType		freq_ctrl1;
    BoolType		BitStream_ram_ren;
    BitstreamAddrType		BitStream_ram_addr;
    PicnumType		pic_num;
    BoolType		ext_frame_RAM0_cs_n;
    BoolType		ext_frame_RAM0_wr;
    RamAddrType		ext_frame_RAM0_addr;
    RamDataType		ext_frame_RAM0_data;
    BoolType		ext_frame_RAM1_cs_n;
    BoolType		ext_frame_RAM1_wr;
    RamAddrType		ext_frame_RAM1_addr;
    RamDataType		ext_frame_RAM1_data;
    RamDataType		dis_frame_RAM_din;
    BoolType		slice_header_s6;
    GenType		tb_cycle;
    GenType   tb_tune_val; 
    
    // Clear objects every clock cycle. Optimization so we only read / write members we have to
    void clear_fn(){
	
	    reset_n.clear_fn();
	    BitStream_buffer_input.clear_fn();
	    pin_disable_DF.clear_fn();
	    freq_ctrl0.clear_fn();
	    freq_ctrl1.clear_fn();
	    BitStream_ram_ren.clear_fn();
	    BitStream_ram_addr.clear_fn();
	    pic_num.clear_fn();
	    ext_frame_RAM0_cs_n.clear_fn();
	    ext_frame_RAM0_wr.clear_fn();
	    ext_frame_RAM0_addr.clear_fn();
	    ext_frame_RAM0_data.clear_fn();
	    ext_frame_RAM1_cs_n.clear_fn();
	    ext_frame_RAM1_wr.clear_fn();
	    ext_frame_RAM1_addr.clear_fn();
	    ext_frame_RAM1_data.clear_fn();
	    dis_frame_RAM_din.clear_fn();
	    slice_header_s6.clear_fn();
	    tb_cycle.clear_fn();
      tb_tune_val.clear_fn();
    }// /clear_fn()

    // Constructor
    H264_(H264_ports_p h=0):  
			reset_n((h!=0)?&(h->reset_n):0, 0, "reset_n") //h.reset_n
,			BitStream_buffer_input((h!=0)?&(h->BitStream_buffer_input):0, 0, "BitStream_buffer_input") //h.BitStream_buffer_input
,			pin_disable_DF((h!=0)?&(h->pin_disable_DF):0, 0, "pin_disable_DF") //h.pin_disable_DF
,			freq_ctrl0((h!=0)?&(h->freq_ctrl0):0, 0, "freq_ctrl0") //h.freq_ctrl0
,			freq_ctrl1((h!=0)?&(h->freq_ctrl1):0, 0, "freq_ctrl1") //h.freq_ctrl1
,			BitStream_ram_ren((h!=0)?&(h->BitStream_ram_ren):0, 0, "BitStream_ram_ren") //h.BitStream_ram_ren
,			BitStream_ram_addr((h!=0)?&(h->BitStream_ram_addr):0, 0, "BitStream_ram_addr") //h.BitStream_ram_addr
,			pic_num((h!=0)?&(h->pic_num):0, 0, "pic_num") //h.pic_num
,			ext_frame_RAM0_cs_n((h!=0)?&(h->ext_frame_RAM0_cs_n):0, 0, "ext_frame_RAM0_cs_n") //h.ext_frame_RAM0_cs_n
,			ext_frame_RAM0_wr((h!=0)?&(h->ext_frame_RAM0_wr):0, 0, "ext_frame_RAM0_wr") //h.ext_frame_RAM0_wr
,			ext_frame_RAM0_addr((h!=0)?&(h->ext_frame_RAM0_addr):0, 0, "ext_frame_RAM0_addr") //h.ext_frame_RAM0_addr
,			ext_frame_RAM0_data((h!=0)?&(h->ext_frame_RAM0_data):0, 0, "ext_frame_RAM0_data") //h.ext_frame_RAM0_data
,			ext_frame_RAM1_cs_n((h!=0)?&(h->ext_frame_RAM1_cs_n):0, 0, "ext_frame_RAM1_cs_n") //h.ext_frame_RAM1_cs_n
,			ext_frame_RAM1_wr((h!=0)?&(h->ext_frame_RAM1_wr):0, 0, "ext_frame_RAM1_wr") //h.ext_frame_RAM1_wr
,			ext_frame_RAM1_addr((h!=0)?&(h->ext_frame_RAM1_addr):0, 0, "ext_frame_RAM1_addr") //h.ext_frame_RAM1_addr
,			ext_frame_RAM1_data((h!=0)?&(h->ext_frame_RAM1_data):0, 0, "ext_frame_RAM1_data") //h.ext_frame_RAM1_data
,			dis_frame_RAM_din((h!=0)?&(h->dis_frame_RAM_din):0, 0, "dis_frame_RAM_din") //h.dis_frame_RAM_din
,			slice_header_s6((h!=0)?&(h->slice_header_s6):0, 0, "slice_header_s6") //h.slice_header_s6
,     tb_cycle((h!=0)?&(h->tb_cycle):0, 0, "tb_cycle", 32)
,     tb_tune_val((h!=0)?&(h->tb_tune_val):0, 0, "tb_tune_val", 32){
    
	handles = h;
	if (h == 0) vpi_printf("@D H264 constructor: no handles given");
	clear_fn(); // Clear all objects of read, since we have not read yet; also has to be done start of every ttb_set

	if (0==1) vpi_printf("@D H264 constructor:");
    }// /constructor
};// /Main tb object H264 definition

#endif

//end H264_ttb.h
