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

package H264_types;

  typedef logic [16-1:0]  BitstreamType;
 
  typedef logic [17-1:0]   BitstreamAddrType;
  typedef logic [6-1:0]   PicnumType;
 
  typedef logic [32-1:0]  RamDataType;
  typedef logic [14-1:0]  RamAddrType;
  
  //typedef logic [1-1:0]   EnableType;
  
  typedef struct packed{
    BitstreamType    BitStream_buffer_input;   //16 bits
    RamDataType    ext_frame_RAM0_data;  //32 bits
    RamDataType    ext_frame_RAM1_data;     //32 bits
  }InputPacketType;  //80 bits
  
  typedef struct packed{
    BoolType    BitStream_ram_ren;   //1 bits
    BitstreamAddrType    BitStream_ram_addr;  //17 bits
    PicnumType    pic_num;     //6 bits
	BoolType		ext_frame_RAM0_cs_n;//1
	BoolType		ext_frame_RAM0_wr;//1
	RamAddrType		ext_frame_RAM0_addr;//14
	BoolType		ext_frame_RAM1_cs_n;//1
	BoolType		ext_frame_RAM1_wr;//1
	RamAddrType		ext_frame_RAM1_addr;//14
	RamDataType		dis_frame_RAM_din;//32
	BoolType		slice_header_s6;//1
  }OutputPacketType;  //89 bits
 
  
endpackage
