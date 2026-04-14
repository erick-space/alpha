module adc_wrapper #(
  parameter int DATA_W = 32,
  parameter int KEEP_W = DATA_W/8,
  parameter int ID_W   = 4,
  parameter int USER_W = 16
)(
  input  logic clk,
  input  logic rst_n,

  input  logic [DATA_W-1:0] adc_data,
  input  logic              adc_valid,
  input  logic              adc_last,

  axis_if.master m_axis
);

  assign m_axis.tdata  = adc_data;
  assign m_axis.tkeep  = '1;
  assign m_axis.tid    = 'd0;
  assign m_axis.tuser  = '0;
  assign m_axis.tvalid = adc_valid;
  assign m_axis.tlast  = adc_last;

endmodule