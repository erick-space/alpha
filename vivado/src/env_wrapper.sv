module env_wrapper #(
  parameter int DATA_W = 32
)(
  input  logic clk,
  input  logic rst_n,

  input  logic [DATA_W-1:0] env_data,
  input  logic              env_valid,
  input  logic              env_last,

  axis_if.master m_axis
);

  assign m_axis.tdata  = env_data;
  assign m_axis.tvalid = env_valid;
  assign m_axis.tlast  = env_last;

endmodule