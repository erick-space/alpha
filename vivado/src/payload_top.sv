module payload_top #(
  parameter int DATA_W = 16,
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
  output logic              out_tvalid,
  input  logic              out_tready,
  output logic              out_tlast
);

  axis_if #(DATA_W) cam_if      (clk, rst_n);
  axis_if #(DATA_W) adc_if      (clk, rst_n);
  axis_if #(DATA_W) imu_if      (clk, rst_n);
  axis_if #(DATA_W) env_if      (clk, rst_n);

  axis_if #(DATA_W) cam_fmt_if      (clk, rst_n);
  axis_if #(DATA_W) adc_fmt_if      (clk, rst_n);
  axis_if #(DATA_W) imu_fmt_if      (clk, rst_n);
  axis_if #(DATA_W) env_fmt_if      (clk, rst_n);

  axis_if #(DATA_W) cam_fifo_if (clk, rst_n);
  axis_if #(DATA_W) adc_fifo_if (clk, rst_n);
  axis_if #(DATA_W) imu_fifo_if (clk, rst_n);
  axis_if #(DATA_W) env_fifo_if (clk, rst_n);

  axis_if #(DATA_W) arb_if      (clk, rst_n);
  axis_if #(DATA_W) fmt_if      (clk, rst_n);

  logic cam_full, cam_empty;
  logic adc_full, adc_empty;
  logic imu_full, imu_empty;
  logic env_full, env_empty;

  camera_wrapper #(DATA_W) u_camera_wrapper (
    .clk    (clk),
    .rst_n  (rst_n),
    .cam_data(cam_data),
    .cam_valid(cam_valid),
    .cam_last(cam_last),
    .m_axis (cam_if)
  );

  axis_fifo #(DATA_W) u_cam_fifo (
    .clk   (clk),
    .rst_n (rst_n),
    .s_axis(cam_if),
    .m_axis(cam_fifo_if),
    .full  (cam_full),
    .empty (cam_empty)
  );

// ------------------------------------------------------------
// ADC
// ------------------------------------------------------------ 
  adc_wrapper #(DATA_W) u_adc_wrapper (
    .clk (clk),
    .rst_n (rst_n),
    .adc_data(adc_data),
    .adc_valid(adc_valid),
    .adc_last(adc_last),
    .m_axis(adc_if)
  );

  payload_formatter #(DATA_W) u_pack_adc (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .sample_count(16'd10),
    .time_stamp(32'd0),
    .record_per_packet(16'd1),
    .payload_id(SRC_ADC)),
    .s_axis(adc_if),
    .m_axis(adc_fmt_if)
  );

  axis_fifo #(DATA_W) u_adc_fifo (
    .clk (clk),
    .rst_n (rst_n),
    .s_axis(adc_fmt_if),
    .m_axis(adc_fifo_if), 
    .full (adc_full),
    .empty (adc_empty)
  );
///////////////////////////////////////////////////////////////

  // Repeat for imu_wrapper / env_wrapper


  axis_arbiter #(DATA_W) u_arbiter (
    .clk   (clk),
    .rst_n (rst_n),
    .s0    (adc_fifo_if),
    .s1    (cam_fifo_if),
    .s2    (imu_fifo_if),
    .s3    (env_fifo_if),
    .m_axis(arb_if)
  );

  assign arb_if.tready = out_tready;
  assign out_tdata  = arb_if.tdata;
  assign out_tvalid = arb_if.tvalid;
  assign out_tlast  = arb_if.tlast;

endmodule