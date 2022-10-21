`timescale 1ns / 1ps

module ConvDecode(
    clock,
	din,
	dout,
	reset
);
input           clock;
input           reset;
input 	[1:0]	din;
output  [7:0]   dout;

wire [7:0]  dout;
reg  [7:0]  out_reg;
reg  [15:0] status;
wire [12:0] tmp_len  [0:15];
reg  [12:0] min_len  [0:7];
wire [12:0] min_len_temp  [0:7];
reg  [2:0]  count;
reg  [15:0] in_bit;
always @(posedge clock)
begin
    in_bit <= {in_bit[13:0],din};
end

wire [12:0] min_12;
wire [12:0] min_34;
wire [12:0] min_56;
wire [12:0] min_78;
wire [12:0] min_14;
wire [12:0] min_58;
wire [12:0] min_18;

assign min_len_temp[0] = (tmp_len[0][4:0]<tmp_len[14][4:0])?tmp_len[0]:tmp_len[14];
assign min_len_temp[1] = (tmp_len[1][4:0]<tmp_len[15][4:0])?tmp_len[1]:tmp_len[15];
assign min_len_temp[2] = (tmp_len[3][4:0]<tmp_len[13][4:0])?tmp_len[3]:tmp_len[13];
assign min_len_temp[3] = (tmp_len[2][4:0]<tmp_len[12][4:0])?tmp_len[2]:tmp_len[12];
assign min_len_temp[4] = (tmp_len[4][4:0]<tmp_len[10][4:0])?tmp_len[4]:tmp_len[10];
assign min_len_temp[5] = (tmp_len[5][4:0]<tmp_len[11][4:0])?tmp_len[5]:tmp_len[11];
assign min_len_temp[6] = (tmp_len[7][4:0]<tmp_len[9 ][4:0])?tmp_len[7]:tmp_len[9 ];
assign min_len_temp[7] = (tmp_len[6][4:0]<tmp_len[8 ][4:0])?tmp_len[6]:tmp_len[8 ];

assign min_12 = (min_len_temp[0][4:0]<min_len_temp[1][4:0])?min_len_temp[0]:min_len_temp[1];
assign min_34 = (min_len_temp[2][4:0]<min_len_temp[3][4:0])?min_len_temp[2]:min_len_temp[3];
assign min_56 = (min_len_temp[4][4:0]<min_len_temp[5][4:0])?min_len_temp[4]:min_len_temp[5];
assign min_78 = (min_len_temp[6][4:0]<min_len_temp[7][4:0])?min_len_temp[6]:min_len_temp[7];
assign min_14 = (min_12[4:0]<min_34[4:0])?min_12:min_34;
assign min_58 = (min_56[4:0]<min_78[4:0])?min_56:min_78;
assign min_18 = (min_14[4:0]<min_58[4:0])?min_14:min_58;
assign dout = out_reg;

assign tmp_len[0] =  {min_len[0][11:5],1'b0,min_len[0][4:0]+ status[15]+ status[14]};
assign tmp_len[1] =  {min_len[0][11:5],1'b1,min_len[0][4:0]+!status[15]+!status[14]};
assign tmp_len[2] =  {min_len[1][11:5],1'b0,min_len[1][4:0]+!status[15]+!status[14]};
assign tmp_len[3] =  {min_len[1][11:5],1'b1,min_len[1][4:0]+ status[15]+ status[14]};
assign tmp_len[4] =  {min_len[2][11:5],1'b0,min_len[2][4:0]+ status[15]+!status[14]};   
assign tmp_len[5] =  {min_len[2][11:5],1'b1,min_len[2][4:0]+!status[15]+ status[14]};
assign tmp_len[6] =  {min_len[3][11:5],1'b0,min_len[3][4:0]+!status[15]+ status[14]};
assign tmp_len[7] =  {min_len[3][11:5],1'b1,min_len[3][4:0]+ status[15]+!status[14]};
assign tmp_len[8] =  {min_len[4][11:5],1'b0,min_len[4][4:0]+ status[15]+!status[14]};
assign tmp_len[9] =  {min_len[4][11:5],1'b1,min_len[4][4:0]+!status[15]+ status[14]};
assign tmp_len[10] = {min_len[5][11:5],1'b0,min_len[5][4:0]+!status[15]+ status[14]};
assign tmp_len[11] = {min_len[5][11:5],1'b1,min_len[5][4:0]+ status[15]+!status[14]};
assign tmp_len[12] = {min_len[6][11:5],1'b0,min_len[6][4:0]+ status[15]+ status[14]};
assign tmp_len[13] = {min_len[6][11:5],1'b1,min_len[6][4:0]+!status[15]+!status[14]};
assign tmp_len[14] = {min_len[7][11:5],1'b0,min_len[7][4:0]+!status[15]+!status[14]};
assign tmp_len[15] = {min_len[7][11:5],1'b1,min_len[7][4:0]+ status[15]+ status[14]};

always @(posedge clock or negedge reset)
begin
    if (!reset)
        begin
            out_reg <= 0;
            status <= 0;
            min_len[0] <= 13'b0000000000000;
            min_len[1] <= 12'b0000000001111;
            min_len[2] <= 12'b0000000001111;
            min_len[3] <= 12'b0000000001111;
            min_len[4] <= 12'b0000000001111;
            min_len[5] <= 12'b0000000001111;
            min_len[6] <= 12'b0000000001111;
            min_len[7] <= 12'b0000000001111;
            count<=4;
        end
    //else if (reset_clk)
    //    begin
    //        status <= {status[13:0],din};
    //        count <= 3'b000;
    //    end
    else
        begin
            status <= {status[13:0],din};
            count <= (count+1)%8;
            if (count == 7)
            begin
            min_len[0] <= 13'b0000000000000;
            min_len[1] <= 12'b0000000001111;
            min_len[2] <= 12'b0000000001111;
            min_len[3] <= 12'b0000000001111;
            min_len[4] <= 12'b0000000001111;
            min_len[5] <= 12'b0000000001111;
            min_len[6] <= 12'b0000000001111;
            min_len[7] <= 12'b0000000001111;
            out_reg <= min_18[12:5];
            end
            else
            begin
            min_len[0] <= min_len_temp[0];
            min_len[1] <= min_len_temp[1];
            min_len[2] <= min_len_temp[2];
            min_len[3] <= min_len_temp[3];
            min_len[4] <= min_len_temp[4];
            min_len[5] <= min_len_temp[5];
            min_len[6] <= min_len_temp[6];
            min_len[7] <= min_len_temp[7];
            end
        end
end
endmodule