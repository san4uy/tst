
`timescale 1 ns / 1 ps

	module myPwM_v1_0 #
	(
		// Users to add parameters here
        parameter W = 32,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 5

	)
	(
		// Users to add ports here
        input  wire [7 : 0] inp_bus,
        output wire [7 : 0] out_bus,
        
        output wire [2 : 0] pwm_out,
		//input  wire         master_enable,
		// User ports ends
		// Do not modify the ports beyond this line

		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);

		wire [C_S00_AXI_DATA_WIDTH-1:0] rgCST; 
        wire [W-1:0] rgDn0; 
        wire [W-1:0] rgLim0;
        wire [W-1:0] rgDn1; 
        wire [W-1:0] rgLim1;
        wire [W-1:0] rgDn2; 
        wire [W-1:0] rgLim2;

// Instantiation of Axi Bus Interface S00_AXI
	myPwM_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) myPwM_v1_0_S00_AXI_inst (
		.rgCST (rgCST ), 
        .rgDn0 (rgDn0 ), 
        .rgLim0(rgLim0),
        .rgDn1 (rgDn1 ), 
        .rgLim1(rgLim1),
        .rgDn2 (rgDn2 ), 
        .rgLim2(rgLim2),
        .out_bus(out_bus),
        .inp_bus(inp_bus),
	
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);


// Add user logic here
	
pwm_1ch #( .W (W) )
pwm_ch0(
    .clk       (s00_axi_aclk),
    .arst      (~s00_axi_aresetn),
    .ctrl      (rgCST[1:0]),
    .pos_dn    (rgDn0[W-1:0]),
    .pos_end   (rgLim0[W-1:0]),
    .pwm_out   (pwm_out[0])
);

pwm_1ch #( .W (W) )
pwm_ch1(
    .clk       (s00_axi_aclk),
    .arst      (~s00_axi_aresetn),
    .ctrl      (rgCST[3:2]),
    .pos_dn    (rgDn1[W-1:0]),
    .pos_end   (rgLim1[W-1:0]),
    .pwm_out   (pwm_out[1])
);

pwm_1ch #( .W (W) )
pwm_ch3(
    .clk       (s00_axi_aclk),
    .arst      (~s00_axi_aresetn),
    .ctrl      (rgCST[5:4]),
    .pos_dn    (rgDn2[W-1:0]),
    .pos_end   (rgLim2[W-1:0]),
    .pwm_out   (pwm_out[2])
);



	// User logic ends
//assign pwm_out[2:0] = inp_bus[2:0]; 
	endmodule
