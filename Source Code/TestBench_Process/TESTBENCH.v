module Test;

reg clk;
reg rst;

wire [7:0] PC;
wire [7:0] out;
Process myuut ( 
    .PC(PC), 
	 .out(out),
	 .clk(clk),
	 .rst(rst)
);

initial
begin
// Clock and reset   
clk = 1; 
rst = 1; 
#1 rst = 0; 

#1000 $finish;   
end  
always clk = #1 ~clk; 
endmodule 
