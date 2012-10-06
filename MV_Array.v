module MV_Array(clk,reset,WE,feed,curpos,MVector,vecout,AddrOut,topMVout);
input clk,reset,WE,feed;
input [13:0] MVector;
input [13:0] curpos;
input wire [13:0] AddrOut;
output wire [13:0] vecout,topMVout;
reg [1:0] count;
reg [13:0] Addr;
wire [13:0] vecout1addr,vecout2addr,vecout3addr;
wire [6:0] bposx,bposy;
// max 120x67 total blocks of 16x16 px size
//reg [13:0] VecMem[0:8039];
wire [6:0] vec1x,vec2y, vec3y, vec3x;
parameter blockcountROW = 80;
parameter blockcountCOL = 45;

assign bposy = curpos[13:7];
assign bposx = curpos[6:0];

assign vecout1addr = {bposy,vec1x};
assign vecout2addr = {vec2y,bposx};
assign vecout3addr = {vec3y,vec3x};


assign vec1x = (bposx == 0) ? bposx : bposx-1;
assign vec2y = (bposy == 0) ? bposy : bposy-1;
assign vec3y = (bposy == blockcountCOL-1) ? bposy : bposy+1 ;
assign vec3x = (bposx >= blockcountROW-2) ? blockcountROW-1 : bposx+2;
always @ (posedge clk, posedge reset)
begin
		if(reset)
		begin
			count <= 0;
		end
		else if (feed)
			count <= count + 1;
		else
			count <= 0;
end 

always @*
begin
	if (feed)
	begin
		case(count)
		0: Addr = vecout1addr;
		1: Addr = vecout2addr;
		2: Addr = vecout3addr;
		default: Addr = 0;
		endcase
	end
	else
		Addr = curpos;
end

BlockRAM_Vec vecmem(clk,WE,Addr,AddrOut,topMVout,MVector,vecout);

endmodule


