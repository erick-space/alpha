module imu_wrapper #(
  parameter int DATA_W = 32
)(
  input  logic clk,
  input  logic rst_n,

  input  logic [DATA_W-1:0] imu_data,
  input  logic              imu_valid,
  input  logic              imu_last,

  axis_if.master m_axis
);

  assign m_axis.tdata  = imu_data;
  assign m_axis.tvalid = imu_valid;
  assign m_axis.tlast  = imu_last;

endmodule