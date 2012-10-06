
module RegFileUW(clk,reset,WE,DataIN,DataOUT,R_ROW,R_COL,W_SELECT_ROW_OR_COL,write_addr,rowcol_filled);
    input clk,reset,WE,W_SELECT_ROW_OR_COL;
    input [63:0] DataIN;
    output [(16*16*8)-1:0] DataOUT;
	output wire rowcol_filled;
    //reg [0:(22*22*8)-1] UWreg;
	reg [1:0] write_count;
	input wire [4:0] write_addr;
    input [4:0] R_ROW, R_COL;
	wire [15:0] inputpart1,inputpart2,inputpart3,inputpart4;
    reg [2:0] row;
	parameter WROW = 0, WCOL = 1;
	reg [0:175] preOut1,preOut2,preOut3,preOut4,preOut5,preOut6,preOut7,preOut8,preOut9,preOut10,preOut11,preOut12,preOut13,preOut14,preOut15,preOut16;
wire [0:175] RpreOut1,RpreOut2,RpreOut3,RpreOut4,RpreOut5,RpreOut6,RpreOut7,RpreOut8,RpreOut9,RpreOut10,RpreOut11,RpreOut12,RpreOut13,RpreOut14,RpreOut15,RpreOut16;
wire [0:175] junk1,junk2,junk3,junk4,junk5,junk6,junk7,junk8,junk9,junk10,junk11,junk12,junk13,junk14,junk15,junk16;
wire [7:0] shR_ROW;

reg [0:((8*22)-1)] search_array1;
reg [0:((8*22)-1)] search_array2;
reg [0:((8*22)-1)] search_array3;
reg [0:((8*22)-1)] search_array4;
reg [0:((8*22)-1)] search_array5;
reg [0:((8*22)-1)] search_array6;
reg [0:((8*22)-1)] search_array7;
reg [0:((8*22)-1)] search_array8;
reg [0:((8*22)-1)] search_array9;
reg [0:((8*22)-1)] search_array10;
reg [0:((8*22)-1)] search_array11;
reg [0:((8*22)-1)] search_array12;
reg [0:((8*22)-1)] search_array13;
reg [0:((8*22)-1)] search_array14;
reg [0:((8*22)-1)] search_array15;
reg [0:((8*22)-1)] search_array16;
reg [0:((8*22)-1)] search_array17;
reg [0:((8*22)-1)] search_array18;
reg [0:((8*22)-1)] search_array19;
reg [0:((8*22)-1)] search_array20;
reg [0:((8*22)-1)] search_array21;
reg [0:((8*22)-1)] search_array22;



assign rowcol_filled = (write_count == 1) ? 1 : 0;

    always @(posedge clk, posedge reset)
	begin
	    if (reset)
		begin
			//UWreg <= 3872'b0;
		   search_array1 <= 0;
		   search_array2 <= 0;
		   search_array3 <= 0;
		   search_array4 <= 0;
		   search_array5 <= 0;
		   search_array6 <= 0;
		   search_array7 <= 0;
		   search_array8 <= 0;
		   search_array9 <= 0;
		   search_array10 <= 0;
		   search_array11 <= 0;
		   search_array12 <= 0;
		   search_array13 <= 0;
		   search_array14 <= 0;
	       search_array15 <= 0;
		   search_array16 <= 0;
		   search_array17 <= 0;
		   search_array18 <= 0;
		   search_array19 <= 0;
		   search_array20 <= 0;
		   search_array21 <= 0;
		   search_array22 <= 0;
			write_count <= 0;
		end
		else if (WE)
		begin
			if (W_SELECT_ROW_OR_COL == WCOL)
			begin
				case (write_addr)
				0:	search_array1[write_count*64 +: 64] <= DataIN;
				1:	search_array2[write_count*64 +: 64] <= DataIN;
				2:	search_array3[write_count*64 +: 64] <= DataIN;
				3:	search_array4[write_count*64 +: 64] <= DataIN;
				4:	search_array5[write_count*64 +: 64] <= DataIN;
				5:	search_array6[write_count*64 +: 64] <= DataIN;
				6:	search_array7[write_count*64 +: 64] <= DataIN;
				7:	search_array8[write_count*64 +: 64] <= DataIN;
				8:	search_array9[write_count*64 +: 64] <= DataIN;
				9:	search_array10[write_count*64 +: 64] <= DataIN;
				10:	search_array11[write_count*64 +: 64] <= DataIN;
				11:	search_array12[write_count*64 +: 64] <= DataIN;
				12:	search_array13[write_count*64 +: 64] <= DataIN;
				13:	search_array14[write_count*64 +: 64] <= DataIN;
				14:	search_array15[write_count*64 +: 64] <= DataIN;
				15:	search_array16[write_count*64 +: 64] <= DataIN;
				16:	search_array17[write_count*64 +: 64] <= DataIN;
				17:	search_array18[write_count*64 +: 64] <= DataIN;
				18:	search_array19[write_count*64 +: 64] <= DataIN;
				19:	search_array20[write_count*64 +: 64] <= DataIN;
				20:	search_array21[write_count*64 +: 64] <= DataIN;
				21:	search_array22[write_count*64 +: 64] <= DataIN;
				//default: search_array <= search_array;
				endcase
			//UWreg[(write_count*8*8) +: 64] <= DataIN;
			end
			else
			begin
				case(write_count)
				0:
				begin
					search_array1[write_addr*8 +: 8] <= DataIN[63 -: 8];
					search_array2[write_addr*8 +: 8] <= DataIN[55 -: 8];
					search_array3[write_addr*8 +: 8] <= DataIN[47 -: 8];
					search_array4[write_addr*8 +: 8] <= DataIN[39 -: 8];
					search_array5[write_addr*8 +: 8] <= DataIN[31 -: 8];
					search_array6[write_addr*8 +: 8] <= DataIN[23 -: 8];
					search_array7[write_addr*8 +: 8] <= DataIN[15 -: 8];
					search_array8[write_addr*8 +: 8] <= DataIN[7 -: 8];
				end
				1:
				begin
					search_array9[write_addr*8 +: 8] <= DataIN[63 -: 8];
					search_array10[write_addr*8 +: 8] <= DataIN[55 -: 8];
					search_array11[write_addr*8 +: 8] <= DataIN[47 -: 8];
					search_array12[write_addr*8 +: 8] <= DataIN[39 -: 8];
					search_array13[write_addr*8 +: 8] <= DataIN[31 -: 8];
					search_array14[write_addr*8 +: 8] <= DataIN[23 -: 8];
					search_array15[write_addr*8 +: 8] <= DataIN[15 -: 8];
					search_array16[write_addr*8 +: 8] <= DataIN[7 -: 8];
				end
				2:
				begin
					search_array17[write_addr*8 +: 8] <= DataIN[63 -: 8];
					search_array18[write_addr*8 +: 8] <= DataIN[55 -: 8];
					search_array19[write_addr*8 +: 8] <= DataIN[47 -: 8];
					search_array20[write_addr*8 +: 8] <= DataIN[39 -: 8];
					search_array21[write_addr*8 +: 8] <= DataIN[31 -: 8];
					search_array22[write_addr*8 +: 8] <= DataIN[23 -: 8];
				end
				endcase
			end
			
			if(write_count != 2)
				write_count <= write_count + 1;
			else
				write_count <= 0;
		end
		else
			write_count <= 0;
	end
    
 /*   always @(*)
     begin
	     case(R_ROW)
	     0: row = 3;
	     1: row = 4;
	     2: row = 5;
	     3: row = 6;
	     4: row = 2;
	     5: row = 1;
	     6: row = 0;
	     default: row = 3;
	     endcase
     end
    */ 
     /*always @(*)
     begin
	     case(R_COL)
	     0: col = 3;
	     1: col = 4;
	     2: col = 5;
	     3: col = 6;
	     4: col = 2;
	     5: col = 1;
	     6: col = 0;
	     default: col = 3;
	     endcase
     end
     */
always @*
begin
	case(R_COL)
	19:
	begin
		preOut1 = search_array1;
		preOut2 = search_array2;
		preOut3 = search_array3;
		preOut4 = search_array4;
		preOut5 = search_array5;
		preOut6 = search_array6;
		preOut7 = search_array7;
		preOut8 = search_array8;
		preOut9 = search_array9;
		preOut10 = search_array10;
		preOut11 = search_array11;
		preOut12 = search_array12;
		preOut13 = search_array13;
		preOut14 = search_array14;
		preOut15 = search_array15;
		preOut16 = search_array16;
	end
	20:
	begin
		preOut1 = search_array2;
		preOut2 = search_array3;
		preOut3 = search_array4;
		preOut4 = search_array5;
		preOut5 = search_array6;
		preOut6 = search_array7;
		preOut7 = search_array8;
		preOut8 = search_array9;
		preOut9 = search_array10;
		preOut10 = search_array11;
		preOut11 = search_array12;
		preOut12 = search_array13;
		preOut13 = search_array14;
		preOut14 = search_array15;
		preOut15 = search_array16;
		preOut16 = search_array17;
	end
	21:
	begin
		preOut1 = search_array3;
		preOut2 = search_array4;
		preOut3 = search_array5;
		preOut4 = search_array6;
		preOut5 = search_array7;
		preOut6 = search_array8;
		preOut7 = search_array9;
		preOut8 = search_array10;
		preOut9 = search_array11;
		preOut10 = search_array12;
		preOut11 = search_array13;
		preOut12 = search_array14;
		preOut13 = search_array15;
		preOut14 = search_array16;
		preOut15 = search_array17;
		preOut16 = search_array18;
	end
	0:
	begin
		preOut1 = search_array4;
		preOut2 = search_array5;
		preOut3 = search_array6;
		preOut4 = search_array7;
		preOut5 = search_array8;
		preOut6 = search_array9;
		preOut7 = search_array10;
		preOut8 = search_array11;
		preOut9 = search_array12;
		preOut10 = search_array13;
		preOut11 = search_array14;
		preOut12 = search_array15;
		preOut13 = search_array16;
		preOut14 = search_array17;
		preOut15 = search_array18;
		preOut16 = search_array19;
	end
	1:
	begin
		preOut1 = search_array5;
		preOut2 = search_array6;
		preOut3 = search_array7;
		preOut4 = search_array8;
		preOut5 = search_array9;
		preOut6 = search_array10;
		preOut7 = search_array11;
		preOut8 = search_array12;
		preOut9 = search_array13;
		preOut10 = search_array14;
		preOut11 = search_array15;
		preOut12 = search_array16;
		preOut13 = search_array17;
		preOut14 = search_array18;
		preOut15 = search_array19;
		preOut16 = search_array20;
	end
	2:
	begin
		preOut1 = search_array6;
		preOut2 = search_array7;
		preOut3 = search_array8;
		preOut4 = search_array9;
		preOut5 = search_array10;
		preOut6 = search_array11;
		preOut7 = search_array12;
		preOut8 = search_array13;
		preOut9 = search_array14;
		preOut10 = search_array15;
		preOut11 = search_array16;
		preOut12 = search_array17;
		preOut13 = search_array18;
		preOut14 = search_array19;
		preOut15 = search_array20;
		preOut16 = search_array21;
	end
	3:
	begin
		preOut1 = search_array7;
		preOut2 = search_array8;
		preOut3 = search_array9;
		preOut4 = search_array10;
		preOut5 = search_array11;
		preOut6 = search_array12;
		preOut7 = search_array13;
		preOut8 = search_array14;
		preOut9 = search_array15;
		preOut10 = search_array16;
		preOut11 = search_array17;
		preOut12 = search_array18;
		preOut13 = search_array19;
		preOut14 = search_array20;
		preOut15 = search_array21;
		preOut16 = search_array22;
	end
	4:
	begin
		preOut1 = search_array8;
		preOut2 = search_array9;
		preOut3 = search_array10;
		preOut4 = search_array11;
		preOut5 = search_array12;
		preOut6 = search_array13;
		preOut7 = search_array14;
		preOut8 = search_array15;
		preOut9 = search_array16;
		preOut10 = search_array17;
		preOut11 = search_array18;
		preOut12 = search_array19;
		preOut13 = search_array20;
		preOut14 = search_array21;
		preOut15 = search_array22;
		preOut16 = search_array1;
	end
	5:
	begin
		preOut1 = search_array9;
		preOut2 = search_array10;
		preOut3 = search_array11;
		preOut4 = search_array12;
		preOut5 = search_array13;
		preOut6 = search_array14;
		preOut7 = search_array15;
		preOut8 = search_array16;
		preOut9 = search_array17;
		preOut10 = search_array18;
		preOut11 = search_array19;
		preOut12 = search_array20;
		preOut13 = search_array21;
		preOut14 = search_array22;
		preOut15 = search_array1;
		preOut16 = search_array2;
	end
	6:
	begin
		preOut1 = search_array10;
		preOut2 = search_array11;
		preOut3 = search_array12;
		preOut4 = search_array13;
		preOut5 = search_array14;
		preOut6 = search_array15;
		preOut7 = search_array16;
		preOut8 = search_array17;
		preOut9 = search_array18;
		preOut10 = search_array19;
		preOut11 = search_array20;
		preOut12 = search_array21;
		preOut13 = search_array22;
		preOut14 = search_array1;
		preOut15 = search_array2;
		preOut16 = search_array3;
	end
	7:
	begin
		preOut1 = search_array11;
		preOut2 = search_array12;
		preOut3 = search_array13;
		preOut4 = search_array14;
		preOut5 = search_array15;
		preOut6 = search_array16;
		preOut7 = search_array17;
		preOut8 = search_array18;
		preOut9 = search_array19;
		preOut10 = search_array20;
		preOut11 = search_array21;
		preOut12 = search_array22;
		preOut13 = search_array1;
		preOut14 = search_array2;
		preOut15 = search_array3;
		preOut16 = search_array4;
	end
	8:
	begin
		preOut1 = search_array12;
		preOut2 = search_array13;
		preOut3 = search_array14;
		preOut4 = search_array15;
		preOut5 = search_array16;
		preOut6 = search_array17;
		preOut7 = search_array18;
		preOut8 = search_array19;
		preOut9 = search_array20;
		preOut10 = search_array21;
		preOut11 = search_array22;
		preOut12 = search_array1;
		preOut13 = search_array2;
		preOut14 = search_array3;
		preOut15 = search_array4;
		preOut16 = search_array5;
	end
	9:
	begin
		preOut1 = search_array13;
		preOut2 = search_array14;
		preOut3 = search_array15;
		preOut4 = search_array16;
		preOut5 = search_array17;
		preOut6 = search_array18;
		preOut7 = search_array19;
		preOut8 = search_array20;
		preOut9 = search_array21;
		preOut10 = search_array22;
		preOut11 = search_array1;
		preOut12 = search_array2;
		preOut13 = search_array3;
		preOut14 = search_array4;
		preOut15 = search_array5;
		preOut16 = search_array6;
	end
	10:
	begin
		preOut1 = search_array14;
		preOut2 = search_array15;
		preOut3 = search_array16;
		preOut4 = search_array17;
		preOut5 = search_array18;
		preOut6 = search_array19;
		preOut7 = search_array20;
		preOut8 = search_array21;
		preOut9 = search_array22;
		preOut10 = search_array1;
		preOut11 = search_array2;
		preOut12 = search_array3;
		preOut13 = search_array4;
		preOut14 = search_array5;
		preOut15 = search_array6;
		preOut16 = search_array7;
	end
	11:
	begin
		preOut1 = search_array15;
		preOut2 = search_array16;
		preOut3 = search_array17;
		preOut4 = search_array18;
		preOut5 = search_array19;
		preOut6 = search_array20;
		preOut7 = search_array21;
		preOut8 = search_array22;
		preOut9 = search_array1;
		preOut10 = search_array2;
		preOut11 = search_array3;
		preOut12 = search_array4;
		preOut13 = search_array5;
		preOut14 = search_array6;
		preOut15 = search_array7;
		preOut16 = search_array8;
	end
	12:
	begin
		preOut1 = search_array16;
		preOut2 = search_array17;
		preOut3 = search_array18;
		preOut4 = search_array19;
		preOut5 = search_array20;
		preOut6 = search_array21;
		preOut7 = search_array22;
		preOut8 = search_array1;
		preOut9 = search_array2;
		preOut10 = search_array3;
		preOut11 = search_array4;
		preOut12 = search_array5;
		preOut13 = search_array6;
		preOut14 = search_array7;
		preOut15 = search_array8;
		preOut16 = search_array9;
	end
	13:
	begin
		preOut1 = search_array17;
		preOut2 = search_array18;
		preOut3 = search_array19;
		preOut4 = search_array20;
		preOut5 = search_array21;
		preOut6 = search_array22;
		preOut7 = search_array1;
		preOut8 = search_array2;
		preOut9 = search_array3;
		preOut10 = search_array4;
		preOut11 = search_array5;
		preOut12 = search_array6;
		preOut13 = search_array7;
		preOut14 = search_array8;
		preOut15 = search_array9;
		preOut16 = search_array10;
	end
	14:
	begin
		preOut1 = search_array18;
		preOut2 = search_array19;
		preOut3 = search_array20;
		preOut4 = search_array21;
		preOut5 = search_array22;
		preOut6 = search_array1;
		preOut7 = search_array2;
		preOut8 = search_array3;
		preOut9 = search_array4;
		preOut10 = search_array5;
		preOut11 = search_array6;
		preOut12 = search_array7;
		preOut13 = search_array8;
		preOut14 = search_array9;
		preOut15 = search_array10;
		preOut16 = search_array11;
	end
	15:
	begin
		preOut1 = search_array19;
		preOut2 = search_array20;
		preOut3 = search_array21;
		preOut4 = search_array22;
		preOut5 = search_array1;
		preOut6 = search_array2;
		preOut7 = search_array3;
		preOut8 = search_array4;
		preOut9 = search_array5;
		preOut10 = search_array6;
		preOut11 = search_array7;
		preOut12 = search_array8;
		preOut13 = search_array9;
		preOut14 = search_array10;
		preOut15 = search_array11;
		preOut16 = search_array12;
	end
	16:
	begin
		preOut1 = search_array20;
		preOut2 = search_array21;
		preOut3 = search_array22;
		preOut4 = search_array1;
		preOut5 = search_array2;
		preOut6 = search_array3;
		preOut7 = search_array4;
		preOut8 = search_array5;
		preOut9 = search_array6;
		preOut10 = search_array7;
		preOut11 = search_array8;
		preOut12 = search_array9;
		preOut13 = search_array10;
		preOut14 = search_array11;
		preOut15 = search_array12;
		preOut16 = search_array13;
	end
	17:
	begin
		preOut1 = search_array21;
		preOut2 = search_array22;
		preOut3 = search_array1;
		preOut4 = search_array2;
		preOut5 = search_array3;
		preOut6 = search_array4;
		preOut7 = search_array5;
		preOut8 = search_array6;
		preOut9 = search_array7;
		preOut10 = search_array8;
		preOut11 = search_array9;
		preOut12 = search_array10;
		preOut13 = search_array11;
		preOut14 = search_array12;
		preOut15 = search_array13;
		preOut16 = search_array14;
	end
	18:
	begin
		preOut1 = search_array22;
		preOut2 = search_array1;
		preOut3 = search_array2;
		preOut4 = search_array3;
		preOut5 = search_array4;
		preOut6 = search_array5;
		preOut7 = search_array6;
		preOut8 = search_array7;
		preOut9 = search_array8;
		preOut10 = search_array9;
		preOut11 = search_array10;
		preOut12 = search_array11;
		preOut13 = search_array12;
		preOut14 = search_array13;
		preOut15 = search_array14;
		preOut16 = search_array15;
	end
	default:
	begin
		preOut1 = search_array4;
		preOut2 = search_array5;
		preOut3 = search_array6;
		preOut4 = search_array7;
		preOut5 = search_array8;
		preOut6 = search_array9;
		preOut7 = search_array10;
		preOut8 = search_array11;
		preOut9 = search_array12;
		preOut10 = search_array13;
		preOut11 = search_array14;
		preOut12 = search_array15;
		preOut13 = search_array16;
		preOut14 = search_array17;
		preOut15 = search_array18;
		preOut16 = search_array19;
	end
	endcase	
end

assign shR_ROW = R_ROW << 3;

assign { RpreOut1, junk1 } = { preOut1, preOut1 } << shR_ROW;
assign { RpreOut2, junk2 } = { preOut2, preOut2 } << shR_ROW;
assign { RpreOut3, junk3 } = { preOut3, preOut3 } << shR_ROW;
assign { RpreOut4, junk4 } = { preOut4, preOut4 } << shR_ROW;
assign { RpreOut5, junk5 } = { preOut5, preOut5 } << shR_ROW;
assign { RpreOut6, junk6 } = { preOut6, preOut6 } << shR_ROW;
assign { RpreOut7, junk7 } = { preOut7, preOut7 } << shR_ROW;
assign { RpreOut8, junk8 } = { preOut8, preOut8 } << shR_ROW;
assign { RpreOut9, junk9 } = { preOut9, preOut9 } << shR_ROW;
assign { RpreOut10, junk10 } = { preOut10, preOut10 } << shR_ROW;
assign { RpreOut11, junk11 } = { preOut11, preOut11 } << shR_ROW;
assign { RpreOut12, junk12 } = { preOut12, preOut12 } << shR_ROW;
assign { RpreOut13, junk13 } = { preOut13, preOut13 } << shR_ROW;
assign { RpreOut14, junk14 } = { preOut14, preOut14 } << shR_ROW;
assign { RpreOut15, junk15 } = { preOut15, preOut15 } << shR_ROW;
assign { RpreOut16, junk16 } = { preOut16, preOut16 } << shR_ROW;

assign DataOUT[16*16*8-1 -: 128] = RpreOut1[24 +: 128];
assign DataOUT[15*16*8-1 -: 128] = RpreOut2[24 +: 128];
assign DataOUT[14*16*8-1 -: 128] = RpreOut3[24 +: 128];
assign DataOUT[13*16*8-1 -: 128] = RpreOut4[24 +: 128];
assign DataOUT[12*16*8-1 -: 128] = RpreOut5[24 +: 128];
assign DataOUT[11*16*8-1 -: 128] = RpreOut6[24 +: 128];
assign DataOUT[10*16*8-1 -: 128] = RpreOut7[24 +: 128];
assign DataOUT[9*16*8-1 -: 128] = RpreOut8[24 +: 128];
assign DataOUT[8*16*8-1 -: 128] = RpreOut9[24 +: 128];
assign DataOUT[7*16*8-1 -: 128] = RpreOut10[24 +: 128];
assign DataOUT[6*16*8-1 -: 128] = RpreOut11[24 +: 128];
assign DataOUT[5*16*8-1 -: 128] = RpreOut12[24 +: 128];
assign DataOUT[4*16*8-1 -: 128] = RpreOut13[24 +: 128];
assign DataOUT[3*16*8-1 -: 128] = RpreOut14[24 +: 128];
assign DataOUT[2*16*8-1 -: 128] = RpreOut15[24 +: 128];
assign DataOUT[1*16*8-1 -: 128] = RpreOut16[24 +: 128]; 
	/*assign DataOUT = {UWreg[col*22*8+row*8 +: 128], UWreg[(col+1)*22*8+row*8 +: 128],
	               UWreg[(col+2)*22*8+row*8 +: 128],UWreg[(col+3)*22*8+row*8 +: 128],
	               UWreg[(col+4)*22*8+row*8 +: 128],UWreg[(col+5)*22*8+row*8 +: 128],
	               UWreg[(col+6)*22*8+row*8 +: 128],UWreg[(col+7)*22*8+row*8 +: 128],
	               UWreg[(col+8)*22*8+row*8 +: 128],UWreg[(col+9)*22*8+row*8 +: 128],
	               UWreg[(col+10)*22*8+row*8 +: 128],UWreg[(col+11)*22*8+row*8 +: 128],
	               UWreg[(col+12)*22*8+row*8 +: 128],UWreg[(col+13)*22*8+row*8 +: 128],
	               UWreg[(col+14)*22*8+row*8 +: 128],UWreg[(col+15)*22*8+row*8 +: 128]} ;
       */
endmodule
