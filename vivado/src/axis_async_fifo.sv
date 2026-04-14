module axis_fifo #(
  parameter int DATA_W = 32,
  parameter int KEEP_W = DATA_W/8,
  parameter int ID_W   = 4,
  parameter int USER_W = 16,
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
  assign m_axis.tkeep  = s_axis.tkeep;
  assign m_axis.tid    = s_axis.tid;
  assign m_axis.tuser  = s_axis.tuser;
  assign m_axis.tvalid = s_axis.tvalid;
  assign m_axis.tlast  = s_axis.tlast;

  assign full  = 1'b0;
  assign empty = ~s_axis.tvalid;

endmodule