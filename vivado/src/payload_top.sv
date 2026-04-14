module payload_top #(
  parameter int DATA_W = 32,
  parameter int KEEP_W = DATA_W/8,
  parameter int ID_W   = 4,
  parameter int USER_W = 16,
  parameter int DEPTH  = 256
)(
  input logic clk,
  input logic rst_n,

  input logic [DATA_W-1:0] cam_data,
  input logic              cam_valid,
  input logic              cam_last,

  input logic [DATA_W-1:0] adc_data,
  input logic              adc_valid,
  input logic              adc_last,

  input logic [DATA_W-1:0] imu_data,
  input logic              imu_valid,
  input logic              imu_last,

  input logic [DATA_W-1:0] env_data,
  input logic              env_valid,
  input logic              env_last,

  output logic [DATA_W-1:0] out_tdata,
  output logic [KEEP_W-1:0] out_tkeep,
  output logic [ID_W-1:0]   out_tid,
  output logic [USER_W-1:0] out_tuser,
  output logic              out_tvalid,
  input  logic              out_tready,
  output logic              out_tlast
);

  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) cam_if      (clk, rst_n);
  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) adc_if      (clk, rst_n);
  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) imu_if      (clk, rst_n);
  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) env_if      (clk, rst_n);

  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) cam_fifo_if (clk, rst_n);
  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) adc_fifo_if (clk, rst_n);
  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) imu_fifo_if (clk, rst_n);
  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) env_fifo_if (clk, rst_n);

  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) arb_if      (clk, rst_n);
  axis_if #(DATA_W, KEEP_W, ID_W, USER_W) fmt_if      (clk, rst_n);

  logic cam_full, cam_empty;
  logic adc_full, adc_empty;
  logic imu_full, imu_empty;
  logic env_full, env_empty;

  camera_wrapper #(DATA_W, KEEP_W, ID_W, USER_W) u_camera_wrapper (
    .clk    (clk),
    .rst_n  (rst_n),
    .cam_data(cam_data),
    .cam_valid(cam_valid),
    .cam_last(cam_last),
    .m_axis (cam_if)
  );

  // Repeat for adc_wrapper / imu_wrapper / env_wrapper

  axis_fifo #(DATA_W, KEEP_W, ID_W, USER_W, DEPTH) u_cam_fifo (
    .clk   (clk),
    .rst_n (rst_n),
    .s_axis(cam_if),
    .m_axis(cam_fifo_if),
    .full  (cam_full),
    .empty (cam_empty)
  );

  axis_arbiter_mux #(DATA_W, KEEP_W, ID_W, USER_W) u_arbiter (
    .clk   (clk),
    .rst_n (rst_n),
    .s0    (cam_fifo_if),
    .s1    (adc_fifo_if),
    .s2    (imu_fifo_if),
    .s3    (env_fifo_if),
    .m_axis(arb_if)
  );

  payload_formatter #(DATA_W, KEEP_W, ID_W, USER_W) u_formatter (
    .clk   (clk),
    .rst_n (rst_n),
    .s_axis(arb_if),
    .m_axis(fmt_if)
  );

  assign fmt_if.tready = out_tready;

  assign out_tdata  = fmt_if.tdata;
  assign out_tkeep  = fmt_if.tkeep;
  assign out_tid    = fmt_if.tid;
  assign out_tuser  = fmt_if.tuser;
  assign out_tvalid = fmt_if.tvalid;
  assign out_tlast  = fmt_if.tlast;

endmodule