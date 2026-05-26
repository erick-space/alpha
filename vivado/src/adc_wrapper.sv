module adc_wrapper #(
  parameter int DATA_W = 16
)(
  input  logic clk,
  input  logic rst_n,

  input  logic [DATA_W-1:0] adc_data,
  input  logic              adc_valid,
  input  logic              adc_last,

  axis_if.master m_axis
);


// ------------------------------------------------------------
// ADC data
// ------------------------------------------------------------
  
  // Sample and transfer samples from ADC
  always_ff (@posedge clk) begin
    m_axis.tvalid <= adc_valid;
    m_axis.tdata <= adc_valid;
    m_axis.adc_last <= adc_last;
  end 


// ------------------------------------------------------------
// Sample Generator for debugging
// ------------------------------------------------------------

  logic [DATA_W-1:0] counter;
  logic [7:0] sample_counter;
  always_ff (@posedge clk) begin
    if (!rst_n) 
      counter <= 16'd0;
      sample_counter <= 16'd0;
      sample_valid <= 1'b1;
    else begin 
      sample_valid <= 1'b0;
      if (sample_counter = 9) begin
        counter <= counter + 16'd1;
        sample_valid <= 1'b1;
      end else 
        sample_counter <= sample_counter + 16'd1;
    end 
  end
  
  // Assign output
  // assign m_axis.tvalid = sample_valid;
  // assign m_axis.tdata = counter;




endmodule