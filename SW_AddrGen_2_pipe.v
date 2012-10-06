module SW_AddrGen(clk,reset,enable,SW_WE_req,vecin,updatein/*,UWDATA_Out*/,UW_WE,MV_ready,outMV,/*InputDATA,InputADDR,*/done,UWaddress_out,UW_ROW,UW_COL,MVselect_WE,MVwait,Row_end,frame_end,feed,UW_sel_col,whichblock_x, whichblock_y,Sel_col_out,rowcol_filled);
input clk,reset,enable,rowcol_filled;
input wire [5:0] updatein;
input wire [13:0] vecin;
input wire MV_ready,Row_end,frame_end;
output reg [13:0] outMV;
//output reg [(8*22)-1:0] UWDATA_Out;
output reg UW_WE,Sel_col_out;
output wire UW_sel_col;
//input wire [0:63] InputDATA;
//input wire [6:0] InputADDR;
output done,feed;
output reg MVselect_WE,SW_WE_req;
output wire [4:0] UWaddress_out;
output reg [4:0] UW_ROW,UW_COL;
output reg MVwait;
wire preMVwait;
reg MVselect_WEpre;
reg [13:0] preoutMV;
reg [2:0] feedcount;
wire inside,within_reach, inside_row, inside_col;
reg [13:0] UWpos;
reg[13:0] out;
wire [1:0] pre_median;
reg [1:0] median;
wire pre_underTh;
reg underTh,rowcol_filled_d;
reg [2:0] State;
reg [2:0] SubState, SubState_d;
reg [13:0] vectors0,vectors1,vectors2;
reg [13:0] medianMV;
reg [5:0] UW_count_d;
reg [5:0] UWcount;
//reg [6:0] check_y_d;
//reg [6:0] check_x_d;
wire [7:0] act_howmany_row_signed, act_howmany_col_signed;
reg [7:0] withincheck,UWcount_col_value,UWcount_row_value,howmany_row_signed,howmany_col_signed;
wire [6:0] limited_out_x;
wire [6:0] limited_out_y;
//reg [6:0] neg_lim_out_x_reg ,neg_lim_out_y_reg;
wire [6:0] new_UWpos_x, new_UWpos_y;
output reg [6:0] whichblock_x, whichblock_y;
reg valid,UW_Filled;

reg [4:0] reference_block_x, reference_block_y;
reg [5:0] pre_new_ref_x, pre_new_ref_y, pre_new_ref_x_reg, pre_new_ref_y_reg;
wire [4:0] new_ref_x, new_ref_y, ref_x_minusone, ref_y_minusone, mod_ref_x_minusone, mod_ref_y_minusone;
reg [4:0] start_block_x, start_block_y;
wire [4:0] ref_check_x, ref_check_y;
//wire [5:0] howmany_signed_col, howmany_signed_row;
wire [6:0] howmany_col, howmany_row, act_howmany_row, act_howmany_col;
wire sign_howmany_row,sign_howmany_col;

//wire WE_S;
integer i;
wire [13:0] vecin1, vecin2, vecin3;
wire [5:0] preUWaddr_out;

parameter S_idle = 0, S_init = 1, S_Vector1 = 2, S_Vector2u = 3, S_Vector3 = 4, S_Wait = 5;
parameter Sub_Init = 0, Sub_Fill_UW_row_load = 3, Sub_Fill_UW_row = 4, Sub_Fill_UW_col_load = 1, Sub_Fill_UW_col = 2, Sub_Filled = 5;

assign preUWaddr_out = ((UW_sel_col) ? start_block_x : start_block_y) + UW_count_d;

assign UWaddress_out = ((preUWaddr_out > 22) ? ((preUWaddr_out > 42) ? (preUWaddr_out + 22) : (preUWaddr_out - 22)) : preUWaddr_out);

assign vecin1 = vectors0;
assign vecin2 = vectors1;
assign vecin3 = vectors2;

assign high = 1'b1;
assign low = 1'b0;

always @*
begin
	case (median)
	0: medianMV = vectors0;
	1: medianMV = vectors1;
	2: medianMV = vectors2;
	3: medianMV = 0;
	endcase
end
//assign medianMV = vectors[median];

//assign WE_S = SW_WE;
//assign UWpos_x = (limited_out_x > 33) ? ((limited_out_x <= 36) ? 33 : ((limited_out_x < 95) ? 95 : limited_out_x)) : limited_out_x;
//assign UWpos_y = (limited_out_y > 33) ? ((limited_out_y <= 36) ? 33 : ((limited_out_y < 95) ? 95 : limited_out_y)) : limited_out_y;
//assign UWpos_x = (neg_lim_out_x > 33) ? ((neg_lim_out_x <= 36) ? 33 : ((neg_lim_out_x < 95) ? 95 : neg_lim_out_x)) : neg_lim_out_x;
//assign UWpos_y = (neg_lim_out_y > 33) ? ((neg_lim_out_y <= 36) ? 33 : ((neg_lim_out_y < 95) ? 95 : neg_lim_out_y)) : neg_lim_out_y;

assign done = (State == S_Wait && MV_ready) ? 1'b1 : 1'b0;

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		howmany_row_signed <= 0;
		howmany_col_signed <= 0;
	end
	else
	begin
		howmany_row_signed <= {{1 {limited_out_y[6]}}, limited_out_y} - {{1 {UWpos[13]}}, UWpos[13:7]};
		howmany_col_signed = {{1 {limited_out_x[6]}}, limited_out_x} - {{1 {UWpos[6]}}, UWpos[6:0]};
	end
end

//assign howmany_row_signed = {{1 {limited_out_y[6]}}, limited_out_y} - {{1 {UWpos[13]}}, UWpos[13:7]};
//assign howmany_col_signed = {{1 {limited_out_x[6]}}, limited_out_x} - {{1 {UWpos[6]}}, UWpos[6:0]};
assign sign_howmany_row = (howmany_row_signed > 127) ? 1'b1 : 1'b0;
assign sign_howmany_col = (howmany_col_signed > 127) ? 1'b1 : 1'b0;
assign howmany_row = (sign_howmany_row) ? (~howmany_row_signed + 1'b1) : (howmany_row_signed);  
assign howmany_col = (sign_howmany_col) ? (~howmany_col_signed + 1'b1) : (howmany_col_signed);
assign act_howmany_row = (inside_row) ? 0 : howmany_row - 3;
assign act_howmany_col = (inside_col) ? 0 : howmany_col - 3;
assign act_howmany_row_signed = (sign_howmany_row) ? (~act_howmany_row + 1'b1) : act_howmany_row;
assign act_howmany_col_signed = (sign_howmany_col) ? (~act_howmany_col + 1'b1) : act_howmany_col;
assign inside_row = (howmany_row <= 3) ? 1'b1 : 1'b0;
assign inside_col = (howmany_col <= 3) ? 1'b1 : 1'b0;
assign inside = valid ? ((inside_row && inside_col) ? 1'b1 : 1'b0) : 1'b0;

always @*
begin
	if (!inside_row)
		if (!inside_col)
			withincheck = act_howmany_row + act_howmany_col;
		else
			withincheck = act_howmany_row;
	else
		withincheck = act_howmany_col;
end


assign within_reach = valid ? ((withincheck <= 21) ? 1'b1 : 1'b0) : 1'b0;

assign new_UWpos_x = UWpos[6:0] + act_howmany_col_signed;
assign new_UWpos_y = UWpos[13:7] + act_howmany_row_signed;


assign new_ref_x = (pre_new_ref_x_reg > 21) ? ((pre_new_ref_x_reg > 42) ? (pre_new_ref_x_reg + 22) : (pre_new_ref_x_reg - 22)) : pre_new_ref_x_reg;
assign new_ref_y = (pre_new_ref_y_reg > 21) ? ((pre_new_ref_y_reg > 42) ? (pre_new_ref_y_reg + 22) : (pre_new_ref_y_reg - 22)) : pre_new_ref_y_reg;

//assign howmany_col = (howmany_signed_col > 32) ? (~howmany_signed_col + 1'b1) : howmany_signed_col;
//assign howmany_row = (howmany_signed_row > 32) ? (~howmany_signed_row + 1'b1) : howmany_signed_row;
assign ref_x_minusone = reference_block_x - 1;
assign ref_y_minusone = reference_block_y - 1;
assign mod_ref_x_minusone = (ref_x_minusone == 31) ? 21 : ref_x_minusone;
assign mod_ref_y_minusone = (ref_y_minusone == 31) ? 21 : ref_y_minusone;

always @*
begin
	if (within_reach)
	begin
		UWcount_col_value = act_howmany_col_signed;
		UWcount_row_value = act_howmany_row_signed;
		//howmany_signed_col = (UWcheck_col > 36) ? (UWcheck_col + 3) : (UWcheck_col -3);
		//howmany_signed_row = (UWcheck_row > 36) ? (UWcheck_row + 3) : (UWcheck_row -3);
		//start_block_x = (UWcheck_col > 36) ? ((reference_block_x == 0) ? 21 : 0) : reference_block_x;
		//start_block_y = (UWcheck_row > 36) ? ((reference_block_y == 0) ? 21 : 0) : reference_block_y;
		start_block_x = (sign_howmany_col) ? (mod_ref_x_minusone) : (reference_block_x);
		start_block_y = (sign_howmany_row) ? (mod_ref_y_minusone) : (reference_block_y);
		pre_new_ref_x = reference_block_x + act_howmany_col_signed;
		pre_new_ref_y = reference_block_y + act_howmany_row_signed;
	end
	else
	begin
		UWcount_col_value = (sign_howmany_col) ? 42 : 22;
		UWcount_row_value = 0;
		//howmany_col_signed = 22;
		//howmany_row_signed = 0;
		start_block_x = (sign_howmany_col) ? 21 : 0;
		start_block_y = (sign_howmany_row) ? 21 : 0;
		pre_new_ref_x = 0;
		pre_new_ref_y = 0;
	end
end

always @ (posedge clk, posedge reset)
begin
	if (reset)
	begin
		pre_new_ref_x_reg <=0;
		pre_new_ref_y_reg <=0;
	end
	else if (SubState == Sub_Init)
	begin
		pre_new_ref_x_reg <= pre_new_ref_x;
		pre_new_ref_y_reg <= pre_new_ref_y;
	end
end

assign ref_check_x = howmany_col_signed + reference_block_x;
assign ref_check_y = howmany_row_signed + reference_block_y;

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		median <= 0;
		underTh <= 0;
	end
	else
	begin
		median <= pre_median;
		underTh <= pre_underTh;
	end
end

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		UWcount <= 0;
	end
/*	else if (bi stateteyken)
	begin
		UWcount_col <= howmany_col;
		UWcount_row <= howmany_row;
	end*/
	else if (SubState == Sub_Fill_UW_col_load)
	begin
		if (sign_howmany_col)
			UWcount <= UWcount_col_value + 1;
		else
			UWcount <= UWcount_col_value - 1;
	end
	else if (SubState == Sub_Fill_UW_col)
	begin
		/*if (UWcount_col == act_howmany_col)
			UWcount_col <= 0;
		else*/
		if (rowcol_filled)
		begin
			if (sign_howmany_col)	
				UWcount <= UWcount + 1;
			else
				UWcount <= UWcount - 1;
		end
	end
	else if (SubState == Sub_Fill_UW_row_load)
	begin
		if (sign_howmany_row)
			UWcount <= UWcount_row_value + 1;
		else
			UWcount <= UWcount_row_value - 1;
	end
	else if (SubState == Sub_Fill_UW_row)
		if (rowcol_filled)
		begin
			if (sign_howmany_row)	
				UWcount <= UWcount + 1;
			else
				UWcount <= UWcount - 1;
		end
	else
	begin
		UWcount<= 0;
	end
end

/*always @*
begin
	if (inside)
	begin
		if (ref_check_y > 24)
			UW_ROW = ref_check_y + 22;
		else if (ref_check_y > 21)
			UW_ROW = ref_check_y - 22;
		else
			UW_ROW = ref_check_y;
		if (ref_check_x > 24)
			UW_COL = ref_check_x + 22;
		else if (ref_check_x > 21)
			UW_COL = ref_check_x - 22;
		else
			UW_COL = ref_check_x;
	end
	else
	begin
		UW_ROW = 0;
		UW_COL = 0;
	end

end*/

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		UW_ROW <= 0;
		UW_COL <= 0;
	end
	else if (inside)
	begin
		if (ref_check_y > 24)
			UW_ROW <= ref_check_y + 22;
		else if (ref_check_y > 21)
			UW_ROW <= ref_check_y - 22;
		else
			UW_ROW <= ref_check_y;
		if (ref_check_x > 24)
			UW_COL <= ref_check_x + 22;
		else if (ref_check_x > 21)
			UW_COL <= ref_check_x - 22;
		else
			UW_COL <= ref_check_x;
	end
end


assign limited_out_x = (out[6:0] > 36) ? ((out[6:0] < 40) ? 36 : ((out[6:0] < (~7'd36 + 1'b1)) ? (~7'd36 + 1'b1) : out[6:0])) : out[6:0];
assign limited_out_y = (out[13:7] > 36) ? ((out[13:7] < 40) ? 36 : ((out[13:7] < (~7'd36 + 1'b1)) ? (~7'd36 + 1'b1) : out[13:7])) : out[13:7]; 
//assign neg_lim_out_x = (~limited_out_x+1'b1);
//assign neg_lim_out_y = (~limited_out_y+1'b1);

//assign premodSWcoord_y = SWcoord_y_reg + (sign_howmany_row ? (~UWcount_row +1'b1) : UWcount_row);
//assign premodSWcoord_x = SWcoord_x + (UW_sel_col ? {{1 {UWcount[5]}},UWcount} : 0);
//assign modSWcoord_y = (premodSWcoord_y < 88) ? premodSWcoord_y : premodSWcoord_y - 88;
//assign modSWcoord_x = (premodSWcoord_x < 88) ? premodSWcoord_x : (sign_howmany_col ? (premodSWcoord_x + 88) : (premodSWcoord_x - 88));

always @*
begin
	if (!within_reach)
	begin
		whichblock_x = (sign_howmany_col ? (new_UWpos_x + 21) : new_UWpos_x) + {{1 {UWcount[5]}},UWcount} ;
		whichblock_y = new_UWpos_y;
	end
	else if(SubState == Sub_Fill_UW_row || SubState == Sub_Fill_UW_row_load)
	begin
		whichblock_x = UWpos[6:0];
		whichblock_y = (sign_howmany_row ? (UWpos[13:7]-1) : (UWpos[13:7] + 22)) + {{1 {UWcount[5]}},UWcount};
	end
	else
	begin
		whichblock_y = UWpos[13:7];
		whichblock_x = (sign_howmany_col ? (UWpos[6:0]-1) : (UWpos[6:0] + 22)) + {{1 {UWcount[5]}},UWcount};
	end
end


/*assign preSWcoord_x = {{1 {whichblock_x[6]}},whichblock_x} + 33 + SWshift;
assign preSWcoord_y = {{1 {whichblock_y[6]}},whichblock_y} + 33;
assign SWcoord_x = (preSWcoord_x <88) ? preSWcoord_x : preSWcoord_x - 88;
assign SWcoord_y = (preSWcoord_y <88) ? preSWcoord_y : preSWcoord_y - 88;
assign prewhichRAM = SWcoord_mod_x + SWcoord_mod_y + {{1 {UWcount[5]}},UWcount};
assign whichRAM = (prewhichRAM < 22) ? prewhichRAM : ((prewhichRAM < 44) ? prewhichRAM - 22 : ((prewhichRAM < 66) ? prewhichRAM - 44 : prewhichRAM + 22));
*/
//assign addrrow = modSWcoord_y << 2;
//assign readaddr = addrrow + mod_x;

assign UW_sel_col = (SubState_d == Sub_Fill_UW_col || SubState_d == Sub_Fill_UW_col_load  ) ? 1'b1 : 1'b0;



always @(posedge clk, posedge reset)
begin
	if (reset)
		MVwait <= 0;
	else
		MVwait <= preMVwait;
end


always @(posedge clk, posedge reset)
begin
    if (reset)
	begin
    preoutMV <= 14'b0;
	MVselect_WE <= 0;
	end
    else if (enable)
	begin
    preoutMV <= {limited_out_y,limited_out_x};
	MVselect_WE <= MVselect_WEpre;
	end
    
end

always @(posedge clk, posedge reset)
begin
	if (reset)
		outMV <= 14'b0;
	else
		outMV <= preoutMV;
end

always @(posedge clk, posedge reset)
begin
    if (reset)
    State <= S_idle;
    else
    begin
        case(State)
			S_idle:
				if(enable)
					State <= S_init;
			S_init: //buna gerek var mi ?
				if(feedcount == 4)
					State <= S_Vector1;
			S_Vector1:
				if (inside)
					State <= S_Vector2u;
			S_Vector2u:
				if (inside)
					if (underTh)
						State <= S_Wait;
					else
						State <= S_Vector3;
			S_Vector3:
				if (inside)
					State <= S_Wait;
			S_Wait:
				if (MV_ready)
					State <= S_idle;
			//default: State <= S_idle;
		endcase
    end
end

assign preMVwait = (State == S_Wait) ? 1 : 0;
assign feed = (State == S_init) ? 1 : 0;

always @ (posedge clk, posedge reset)
begin
	if (reset)
		feedcount <= 0;
	else if (feed)
		feedcount <= feedcount + 1;
	else
		feedcount <= 0;
end

always @ (posedge clk, posedge reset)
begin
	if (reset)
	begin
		vectors0 <= 14'b0;
		vectors1 <= 14'b0;
		vectors2 <= 14'b0;
	end
	else
	begin
		case(feedcount)
		1: vectors0 <= vecin;
		2: vectors1 <= vecin;
		3: vectors2 <= vecin;
		endcase
	end
end



always @ (posedge clk, posedge reset)
begin
	if (reset)
	begin
		valid <= 0;
		//UWpos <= 0;
		//reference_block_x <= 0;
		//reference_block_y <= 0;
	end
	else if (State == S_Wait)
		valid <= 0;
	else if (UW_Filled)
	begin
		valid <= 1'b1;
		//UWpos <= {new_UWpos_y,new_UWpos_x};
		//reference_block_x <= new_ref_x;
		//reference_block_y <= new_ref_y;
	end
end

always @(*)
begin
    case(State)
        S_Vector1:
           out = medianMV;
        S_Vector2u:
        begin
           if (underTh)
              out = {medianMV[13:7]+{{4 {updatein[5]}},updatein[5:3]},medianMV[6:0] + {{4 {updatein[2]}},updatein[2:0]}};
           else   
              out = (median == 1) ? {vecin1[13:7]+{{4 {updatein[5]}},updatein[5:3]},vecin1[6:0] + {{4 {updatein[2]}},updatein[2:0]}} : {vecin2[13:7]+{{4 {updatein[5]}},updatein[5:3]},vecin2[6:0] + {{4 {updatein[2]}},updatein[2:0]}};
        end
        S_Vector3:
           out = (median == 2) ? vecin1 : vecin3;
        default:
           out = 14'b0;
    endcase
end

/*always @*
begin
    if (State == S_Vector1 || State == S_Vector2u || State == S_Vector3)
       FillSW = 1'b1;
    else
       FillSW = 1'b0;
end*/



always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		SubState <= Sub_Init; 
	end
	else
	case (SubState)
	Sub_Init:
		if (State == S_Vector1 || State == S_Vector2u || State == S_Vector3)
		begin
			if (!inside)
			begin
				if (inside_row || !within_reach)
					SubState <= Sub_Fill_UW_col_load;
				else
					SubState <= Sub_Fill_UW_row_load;
			end
		end
	Sub_Fill_UW_row_load:
		SubState <= Sub_Fill_UW_row;
	Sub_Fill_UW_row:
		if ((UWcount == 0) && rowcol_filled)
		begin
			if (inside_col)
				SubState <= Sub_Filled;
			else
				SubState <= Sub_Fill_UW_col_load;
			
		end
	Sub_Fill_UW_col_load:
		SubState <= Sub_Fill_UW_col;
	Sub_Fill_UW_col:
		if ((UWcount == 0) && rowcol_filled)
		begin
			SubState <= Sub_Filled;
			
		end
	Sub_Filled:
		SubState <= Sub_Init;
	//default: SubState <= Sub_Init;
	endcase
	
end
always @(posedge clk, posedge reset)
begin
if (reset)
rowcol_filled_d <= 0;
else
rowcol_filled_d <= rowcol_filled;
end

always @(posedge clk, posedge reset)
begin
if (reset)
begin
	UWpos <=0;
	//reference_block_x <= 0;
	//reference_block_y <= 0;
end
else if (SubState_d == Sub_Fill_UW_row && UW_count_d == 0 && rowcol_filled_d)
begin
	UWpos[13:7] <= new_UWpos_y;
	//reference_block_y <= new_ref_y;
	//reference_block_x <= new_ref_x;
end
else if (SubState_d == Sub_Fill_UW_col && UW_count_d == 0 && rowcol_filled_d)
begin
	UWpos[6:0] <= new_UWpos_x;
	//reference_block_x <= new_ref_x;
	//reference_block_y <= new_ref_y;
end
//else if (SubState == Sub_Fill_UW_row && UWcount == 0)
	//reference_block_y <= new_ref_y;
//else if (SubState == Sub_Fill_UW_col && UWcount == 0)
	//reference_block_x <= new_ref_x;
end

always @ (posedge clk, posedge reset)
begin
	if (reset)
	begin
		reference_block_x <= 0;
		reference_block_y <= 0;
	end
	else if (SubState == Sub_Filled)
	begin
		reference_block_y <= new_ref_y;
		reference_block_x <= new_ref_x;
	end
end

always @*
begin
	if ((State == S_Vector1 || State == S_Vector2u || State == S_Vector3) && inside)
		MVselect_WEpre = 1;
	else
		MVselect_WEpre = 0;
end

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		SW_WE_req <= 0;
		Sel_col_out <= 0;
	end
	else if (SubState == Sub_Fill_UW_row_load)
	begin
		SW_WE_req <= 1;
		Sel_col_out <= 0;
	end
	else if (SubState == Sub_Fill_UW_col_load)
	begin
		SW_WE_req <= 1;
		Sel_col_out <= 1;
	end
	else if ((UWcount == 0) && rowcol_filled)
		SW_WE_req <= 0;
end

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		SubState_d <= 0;
		//whichRAM_d <= 0;
	end
	else
	begin
		SubState_d <= SubState;
		//whichRAM_d <= whichRAM;
	end
end

always @*
begin
	if (SubState == Sub_Filled)
		UW_Filled = 1'b1;
	else
		UW_Filled = 1'b0;
end


always @(posedge clk, posedge reset)
begin
if (reset)
	UW_count_d <= 0;
else if ((SubState == Sub_Fill_UW_col) || (SubState == Sub_Fill_UW_row))
	UW_count_d <= UWcount;
else
	UW_count_d <= 0;

end

always @(*)
begin
if ((SubState_d == Sub_Fill_UW_col) || (SubState_d == Sub_Fill_UW_row))
begin
	UW_WE = 1;
end
else
	UW_WE = 0;
end


 

median Mdn (.vec1(vecin1), .vec2(vecin2), .vec3(vecin3), .median(pre_median), .underTh(pre_underTh));
endmodule


