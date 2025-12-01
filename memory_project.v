module mem(clk,rst,wr_rd,addr,wdata,rdata,valid,ready);
 parameter WIDTH=8;
 parameter DEPTH=40;
 parameter ADDR_WIDTH=$clog2(DEPTH);
 input clk,rst,wr_rd,valid;
 input [WIDTH-1:0] wdata;
 input [ADDR_WIDTH-1:0] addr;
 output reg [WIDTH-1:0] rdata;
 output reg ready;
 integer i;
 
// declare memory
reg [WIDTH-1:0] mem [DEPTH-1:0];

always @(posedge clk) begin 
   if(rst==1) begin
      rdata=0;
	  ready=0;
      for (i=0;i<DEPTH;i=i+1)
      mem[i]=0;
   end
   else begin 
   if(valid==1) begin
	  ready=1;
    if (wr_rd==1)
	mem[addr]=wdata;
    else 
	rdata=mem[addr];
	end
   end
  end
endmodule

// test bench
module tb;
parameter WIDTH=8;
 parameter DEPTH=40;
 parameter ADDR_WIDTH=$clog2(DEPTH);
 reg clk,rst,wr_rd,valid;
 reg [WIDTH-1:0] wdata;
 reg [ADDR_WIDTH-1:0] addr;
 wire [WIDTH-1:0] rdata;
 wire ready;
 
 mem dut(.clk(clk),.rst(rst),.wr_rd(wr_rd),.addr(addr),.wdata(wdata),
            .rdata(rdata),.valid(valid),.ready(ready));
integer i;
always #5 clk=~clk;

   initial begin
		clk=0;
		rst=1;
		wr_rd=0;
		addr=0;
		wdata=0;
		valid=0;
		repeat(2) @(posedge clk);
		rst=0;
// write operation 
    for (i=0;i<DEPTH;i=i+1) begin
       @(posedge clk);
        wr_rd=1;
        addr=i;
        wdata=$random;
        valid=1;
        wait(ready==1);
    end
    @(posedge clk);
    wr_rd=0;
    addr=0;
    wdata=0;
    valid=0;
// read operation
   for (i=0;i<DEPTH;i=i+1) begin
       @(posedge clk)
        wr_rd=0;
        addr=i;
        valid=1;
        wait(ready==1);
   end
   @(posedge clk);
    wr_rd=0;
    addr=0;
    wdata=0;
    valid=0;
  
	#100;
	$finish;
  end
endmodule


