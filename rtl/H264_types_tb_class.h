//==============================================================================
//      File:           $URL$
//      Version:        Automatically generated by 'System Verilog to VPI' script
//      Author:         Script By Tom Golubev
//      Copyright:      Copyright 2005-2009 UC Santa Cruz
//==============================================================================

//==============================================================================
//     Section:        License
//==============================================================================
//      Copyright (c) 2005-2009, Regents of the University ofCalifornia
//      All rights reserved.
//
//      Redistribution and use in source and binary forms, with or without modification,
//      are permitted provided thatthefollowing conditions are met:
//
//              - Redistributions of source code must retain the above copyright notice,
//                      this list ofconditions and the following disclaimer.
//              - Redistributions in binary form must reproduce the above copyright
//                      notice, this list ofconditions and the following disclaimer
//                      in the documentation and/or other materials provided with the
//                      distribution.
//             - Neither the name of the University of California, Santa Cruz nor the
//                      names of its contributors may be used to endorse or promote
//                     products derived from this software without specific prior
//                      written permission.
//
//      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTHOLDERSAND CONTRIBUTORS "AS IS" AND
//      ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//      WARRANTIES OF MERCHANTABILITY ANDFITNESS FOR A PARTICULAR PURPOSE ARE
//      DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//      ANY DIRECT, INDIRECT, INCIDENTAL,SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//      (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//      LOSS OF USE, DATA, ORPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//      ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//      (INCLUDING NEGLIGENCE OROTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//      SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================



#ifndef H264_TYPES_tb
#define H264_TYPES_tb


  	//	Class definition for BoolType which is 0 bits

class BoolType: public SharedAllClass {   
  private:
   
  public:   
      BoolType(vpiHandle *h=0, SharedAllClass *obj = 0, char *name="default", uint32_t bits=1){
				ttb_name    = name;   
				num_bits    = bits;
				handle      = h;   

        if (bits > 64){ 
          bit_array = new char[bits];
          for (uint32_t i = 0; i < num_bits; i++) 
            bit_array[i] = '0';
        }else{
          bit_array = 0;
        }

				if(obj)   
					top_obj = obj;   
				else   
					top_obj = this;   

			  if (TB_FN_DEBUG) vpi_printf("@D BoolType Constructor, name=%s\n", ttb_name);   
   
      }// /BoolType constructor   

     BoolType &operator =(const uint64_t in) {     
        if (num_bits > 64) {
          ERROR("= operator to a larger than 64 bits wire (%d bits)\n",num_bits); 
        }

				// To provide a true representation, modulus so that an 8 bit value cannot exceed true size     
				value = in; 
				top_obj->written_to = true;   
  			if (TB_FN_DEBUG) vpi_printf("@D BoolType &operator =, name=%s, top_obj->written_to[%d], value=%u (unsinged)\n", ttb_name, written_to, in); 
				top_obj->write_a();       

        return *this;
     }
                
 };// /BoolType Class 


#endif
