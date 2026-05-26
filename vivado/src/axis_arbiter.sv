

module #(
  parameter int D_WIDTH = 16
){
  input logck clk,
  input logic rst_n,
  
  axis_if.slave s0,
  axis_if.slave s1,
  axis_if.slave s2,
  axis_if.slave s3,
  axis_if.master m_axis
};

  //Pass s0 out for now
  assign m_axis.tdata = s0.tdata;
  assign m_axis.tvalid = s0.tvalid;
  assign m_axis.tlast = s0.tvalid;
  assign s0.tready = m_axis.tready;

endmodule