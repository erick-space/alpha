module axis_fifo #(
  parameter int DATA_W = 32,
  parameter int DEPTH  = 256
)(
  input  logic clk,
  input  logic rst_n,

  axis_if.slave  s_axis,
  axis_if.master m_axis,

  output logic full,
  output logic empty
);

  // Placeholder skeleton only.
  // Replace with true FIFO storage later.

  assign s_axis.tready = m_axis.tready;

  assign m_axis.tdata  = s_axis.tdata;
  assign m_axis.tvalid = s_axis.tvalid;
  assign m_axis.tlast  = s_axis.tlast;

  assign full  = 1'b0;
  assign empty = ~s_axis.tvalid;

endmodule