`timescale 1ns/100ps
module arbiter_tb();
	parameter N = 2; // Number of requesters
	parameter CLK_DELAY = 1;
	reg[N-1:0]		req;
	wire[N-1:0]		grant;
	reg				ack, rst, clk;

	integer i;

	arbiter	dut(.rst(rst), .ack(ack), .req(req), .grant(grant), .clk(clk));
	initial begin
		req = 1;
		ack = 1;
		rst = 0;
		clk = 0;
		#(5*CLK_DELAY);
		rst = 1;
		#(5*CLK_DELAY);
		rst = 0;
		for (i=0; i< 16; i = i + 1) begin
			req = req + 1;
			#(8*CLK_DELAY);
		end
		$stop;
	end

	always
		#(2*CLK_DELAY) ack = ~ack;
	always
		#(CLK_DELAY) clk = ~clk;

endmodule
