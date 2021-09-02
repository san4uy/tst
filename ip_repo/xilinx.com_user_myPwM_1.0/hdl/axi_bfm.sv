module axi_bfm #(
  parameter      AXI_DATA_WIDTH = 32,
  parameter      AXI_ADDR_WIDTH =  6
)  
(
  input  wire                            clk,   
  input  wire                            rst,    

      // AXI-Lite bus 
  output wire                            axi_aclk,   
  output wire                            axi_aresetn,    
      
         
  output reg  [AXI_ADDR_WIDTH-1 : 0]     axi_awaddr,
  output reg  [2 : 0]                    axi_awprot,
  output reg                             axi_awvalid,
  input  wire                            axi_awready,
  output reg  [AXI_DATA_WIDTH-1 : 0]     axi_wdata,
	
  output reg  [(AXI_DATA_WIDTH/8)-1 : 0] axi_wstrb,
  output reg                             axi_wvalid,
  input  wire                            axi_wready,
	
  input  wire [1 : 0]                    axi_bresp,
  input  wire                            axi_bvalid,
  output reg                             axi_bready,
	
  output reg  [AXI_ADDR_WIDTH-1 : 0]     axi_araddr,
  output reg  [2 : 0]                    axi_arprot,
  output reg                             axi_arvalid,
	
  input  wire                            axi_arready,
  input  wire [AXI_DATA_WIDTH-1 : 0]     axi_rdata,
  input  wire [1 : 0]                    axi_rresp,
  input  wire                            axi_rvalid,
  output reg                             axi_rready
  
);

assign axi_aclk    =  clk;
assign axi_aresetn = ~rst; 

initial begin
  axi_awaddr     = {AXI_ADDR_WIDTH{1'b0}};
  axi_awprot     = 3'b000;
  axi_awvalid    = 1'b0;
  axi_wdata      = {AXI_DATA_WIDTH{1'b0}};
	
  axi_wstrb      = {AXI_DATA_WIDTH/8{1'b0}};
  axi_wvalid     = 1'b0;
	
  axi_bready     = 1'b0;
	
  axi_araddr     = {AXI_ADDR_WIDTH{1'b0}};
  axi_arprot     = 3'b000;
  axi_arvalid    = 1'b0;
	  
  axi_rready     = 1'b0;
end	  

  task writeto (
    input  [AXI_ADDR_WIDTH-1 : 0]     bus_addr,
    input  [(AXI_DATA_WIDTH/8)-1 : 0] lane_en,
    input  [AXI_DATA_WIDTH-1:0]       axi_data
  );
    reg as,ds;
    
    begin
      @(posedge clk);
      as = 1'b0;
      ds = 1'b0;
      axi_bready   = 1'b0;
      axi_awaddr   = {AXI_ADDR_WIDTH{1'b0}};
      //axi_awready  = 1'b0;
      axi_awprot   = 3'b000;
      axi_awvalid  = 1'b0;
      axi_wdata    = {AXI_DATA_WIDTH{1'b0}};
      axi_wstrb    = {(AXI_DATA_WIDTH/8)-1{1'b0}};
      axi_wvalid   = 1'b0;
      
      @(posedge clk);
      axi_awaddr   = bus_addr;
      axi_awvalid  = 1'b1;      
      axi_wdata    = axi_data;
      axi_wstrb    = lane_en;
      axi_wvalid   = 1'b1;
      axi_bready   = 1'b1;
      
      do begin
        @(posedge clk);
         if ((!as) && axi_awready ) begin
            as = 1'b1;
            axi_awaddr   = {AXI_ADDR_WIDTH{1'b0}};
            axi_awvalid  = 1'b0;      
         end
         if ( (!ds) && axi_wready ) begin
           ds = 1'b1;
           axi_wdata    = {AXI_DATA_WIDTH{1'b0}};
           axi_wstrb    = {(AXI_DATA_WIDTH/8)-1{1'b0}};
           axi_wvalid   = 1'b0;
         end 
      end while ( (as==1'b0) && (ds==1'b0) );

      as = 1'b0;
      ds = 1'b0;
      while (axi_bvalid)
        @(posedge clk);
      axi_bready = 1'b0;
    end
  endtask
  
  task readfrom(
      input  [AXI_ADDR_WIDTH-1 : 0]     bus_addr,
      output [AXI_DATA_WIDTH-1:0]       axi_data
    );
 
//  output reg  [AXI_ADDR_WIDTH-1 : 0]     axi_araddr,
//  output reg  [2 : 0]                    axi_arprot,
//  output reg                             axi_arvalid,
//	
//  input  wire                            axi_arready,
//  input  wire [AXI_DATA_WIDTH-1 : 0]     axi_rdata,
//  input  wire [1 : 0]                    axi_rresp,
//  input  wire                            axi_rvalid,
//  output reg                             axi_rready
 
  
    begin
      @(posedge clk);
      axi_araddr  = {AXI_ADDR_WIDTH{1'b0}};
      axi_arprot  = 3'b000;
      axi_arvalid = 1'b0;
      axi_rready  = 1'b0;
      @(posedge clk);
      axi_araddr  = bus_addr;
      axi_arvalid = 1'b1;
      axi_rready  = 1'b1;
      
      do begin 
       @(posedge clk);
      end while(!axi_arready);
      axi_arvalid = 1'b0;

      do begin 
       @(posedge clk);
      end while(!axi_rvalid);
      
      axi_data = axi_rdata;
      axi_rready  = 1'b0;
    end
  endtask

endmodule