`timescale 1ns/100ps
module Mux_masters_tb();
	parameter bits_addr_slave =	 1; //сколько бит занимает адрес устройства
	parameter slaves_number =	 2; //количество выходных устройств
	parameter first_master = 	 2'b01;
	parameter second_master = 	 2'b10;
	parameter CLK_DELAY =1;

	parameter N = 32;
	reg  [slaves_number-1:0]	arb_master_req;
	reg  [N-1:0]			master_1_addr;
	reg 					master_1_cmd;
	reg 					master_1_req;
	reg  [N-1:0]			master_1_wdata;

	reg  [N-1:0]			master_2_addr;
	reg 					master_2_cmd;
	reg 					master_2_req;
	reg  [N-1:0]			master_2_wdata;

	reg 					slave_ack;
	reg [N-1:0]				slave_rdata;

	wire					slave_req;
	wire [N-1:0]			slave_addr;
	wire					slave_cmd;
	wire [N-1:0]			slave_wdata;

	wire  					master_1_ack;
	wire  [N-1:0]			master_1_rdata;

	wire  					master_2_ack;
	wire  [N-1:0]			master_2_rdata;


	reg					rst;
	reg					clk;
	integer i;

	Mux_masters	dut
	(
		.arb_master_req(arb_master_req),

		.master_1_addr(master_1_addr),
		.master_1_cmd(master_1_cmd),
		.master_1_wdata(master_1_wdata),
		.master_1_req(master_1_req),

		.master_2_addr(master_2_addr),
		.master_2_cmd(master_2_cmd),
		.master_2_wdata(master_2_wdata),
		.master_2_req(master_2_req),




		.slave_ack(slave_ack),
		.slave_rdata(slave_rdata),

	////////////////////////////////////////////////////////

		.master_1_ack(master_1_ack),
		.master_1_rdata(master_1_rdata),

		.master_2_ack(master_2_ack),
		.master_2_rdata(master_2_rdata),


		.slave_req(slave_req),
		.slave_addr(slave_addr),
		.slave_cmd(slave_cmd),
		.slave_wdata(slave_wdata),

		.rst(rst),
		.clk(clk)

	);

	initial begin
		arb_master_req = 2'b01;
		slave_ack = '0;
		master_1_addr  = '0;
		master_2_addr  = '0;
		master_1_cmd  = 0;
		master_2_cmd  = 1;
		master_1_req  = 1;
		master_2_req  = 1;
 		master_1_wdata  = 32'h11111111;
		master_2_wdata  = 32'hFFFFFFFF;
		slave_rdata = 32'hFFFFFFFF;
		rst = 1;
		clk = 0;
		#(4*CLK_DELAY) ;
		rst = 0;
		for (i=0; i< 16; i = i + 1) begin

			{master_1_cmd, master_2_cmd} ={master_2_cmd, master_1_cmd};
			slave_rdata = ~slave_rdata;
			#(8*CLK_DELAY);
		end
		$stop;
	end


		always
			#(4*CLK_DELAY) arb_master_req =  ~arb_master_req;
		always
			#(2*CLK_DELAY) slave_ack = ~slave_ack;

		always
			#(CLK_DELAY) clk = ~clk;


endmodule
