`timescale 1ns / 1ps
`default_nettype none

// Project F: Async Reset Test Bench
// (C)2019 Will Green, Open source hardware released under the MIT License
// Learn more at https://projectf.io

module TB_PwM();

    localparam W              = 12;
	localparam AXI_DATA_WIDTH = 32;
	localparam AXI_ADDR_WIDTH =  6;
	
//
// --- Name of register's ---
//
    localparam PWM_BA   = 0;        // BaseArrd (in local test is always 0)
    localparam PWM_CST  = 0;        // Control and Status Register
    localparam PWM_DN0  = 8;        // 
    localparam PWM_LIM0 = 12;        // 
    localparam PWM_DN1  = 16;        // 
    localparam PWM_LIM1 = 20;        // 
    localparam PWM_DN2  = 24;        // 
    localparam PWM_LIM2 = 28;        // 
    
    wire                            wIRQ;
    wire                            axi_aclk;   
    wire                            axi_aresetn;    
     
    // AXI-Lite bus    
	wire [AXI_ADDR_WIDTH-1 : 0]     axi_awaddr;
	wire [2 : 0]                    axi_awprot;
	wire                            axi_awvalid;
	wire                            axi_awready;
	wire [AXI_DATA_WIDTH-1 : 0]     axi_wdata;
	
	wire [(AXI_DATA_WIDTH/8)-1 : 0] axi_wstrb;
	wire                            axi_wvalid;
	wire                            axi_wready;
	
	wire [1 : 0]                    axi_bresp;
	wire                            axi_bvalid;
	wire                            axi_bready;
	
	wire [AXI_ADDR_WIDTH-1 : 0]     axi_araddr;
	wire [2 : 0]                    axi_arprot;
	wire                            axi_arvalid;
	
	wire                            axi_arready;
	wire [AXI_DATA_WIDTH-1 : 0]     axi_rdata;
	wire [1 : 0]                    axi_rresp;
	wire                            axi_rvalid;
	wire                            axi_rready;

 
    wire [2:0]      wPwm_out;
    reg             rst;
    reg             clk100M;

    initial begin
      clk100M = 1'b0;
      #500;
      forever begin
        #5;
        clk100M =  ~clk100M;
      end
    end

//------------------------------------------------------  
    axi_bfm #(
      .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
      .AXI_ADDR_WIDTH (AXI_ADDR_WIDTH)
      
    ) axi_bfm_I(
      .clk         (clk100M),
      .rst         (rst),
    
          // AXI-Lite bus
      .axi_aclk    (axi_aclk   ),   
      .axi_aresetn (axi_aresetn),    
      
      .axi_awaddr  (axi_awaddr ),
      .axi_awprot  (axi_awprot ),
      .axi_awvalid (axi_awvalid),
      .axi_awready (axi_awready),
      .axi_wdata   (axi_wdata  ),
    	
      .axi_wstrb   (axi_wstrb ),
      .axi_wvalid  (axi_wvalid),
      .axi_wready  (axi_wready),
    	
      .axi_bresp   (axi_bresp ),
      .axi_bvalid  (axi_bvalid),
      .axi_bready  (axi_bready),
    	
      .axi_araddr  (axi_araddr ),
      .axi_arprot  (axi_arprot ),
      .axi_arvalid (axi_arvalid),
    	
      .axi_arready (axi_arready),
      .axi_rdata   (axi_rdata  ),
      .axi_rresp   (axi_rresp  ),
      .axi_rvalid  (axi_rvalid ),
      .axi_rready  (axi_rready )
    );

    myPwM_v1_0 #(
        .W (W),
        
		.C_S00_AXI_DATA_WIDTH (AXI_DATA_WIDTH),
		// Width of S_AXI address bus
		.C_S00_AXI_ADDR_WIDTH	(AXI_ADDR_WIDTH)

	) myPwM_v1_0_I(
		// Users to add ports here
		.pwm_out            (wPwm_out),
		// User ports ends
		
		.s00_axi_aclk       (axi_aclk   ),
		.s00_axi_aresetn    (axi_aresetn),
		
		.s00_axi_awaddr     (axi_awaddr ),
		.s00_axi_awprot     (axi_awprot ),
		.s00_axi_awvalid    (axi_awvalid),
		.s00_axi_awready    (axi_awready),
		.s00_axi_wdata      (axi_wdata  ),
		.s00_axi_wstrb      (axi_wstrb  ),
		.s00_axi_wvalid     (axi_wvalid ),
		.s00_axi_wready     (axi_wready ),
		.s00_axi_bresp      (axi_bresp  ),
		.s00_axi_bvalid     (axi_bvalid ),
		.s00_axi_bready     (axi_bready ),
		.s00_axi_araddr     (axi_araddr ),
		.s00_axi_arprot     (axi_arprot ),
		.s00_axi_arvalid    (axi_arvalid),
		.s00_axi_arready    (axi_arready),
		.s00_axi_rdata      (axi_rdata  ),
		.s00_axi_rresp      (axi_rresp  ),
		.s00_axi_rvalid     (axi_rvalid ),
		.s00_axi_rready     (axi_rready )
	);

//------------------------------------------------//
//          T E S T   B E N C H                   //
//------------------------------------------------//
   reg [31:0] data_from_axi_bus;


   initial begin

      rst = 1'b0;
      repeat (1000) @(posedge clk100M);
      rst = 1'b1;
      repeat (200) @(posedge clk100M);
      rst = 1'b0;
      repeat (1000) @(posedge clk100M);
   
      axi_bfm_I.writeto(PWM_BA+PWM_DN0,      4'b1111, 32'd80);
      axi_bfm_I.writeto(PWM_BA+PWM_LIM0,     4'b1111, 32'd255);
      axi_bfm_I.writeto(PWM_BA+PWM_CST,      4'b1111, 32'h7);

      repeat (50000) @(posedge clk100M);
      $stop;
   end

endmodule
