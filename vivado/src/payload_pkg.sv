package payload_pkg;

  parameter int AXIS_DATA_W = 32;
  parameter int AXIS_KEEP_W = AXIS_DATA_W/8;
  parameter int AXIS_ID_W   = 4;
  parameter int AXIS_USER_W = 16;
  parameter int FIFO_DEPTH  = 256;

  typedef enum logic [15:0] {
    SRC_CAMERA = 4'd0,
    SRC_ADC    = 4'd1,
    SRC_IMU    = 4'd2,
    SRC_ENV    = 4'd3
  } payload_src_e;

  typedef struct packed {
    payload_src_e source_id;
    logic [15:0] sequence_num;
    logic [15:0] time_stamp1_0;
    logic [15:0] time_stamp3_2;
    logic [15:0] payload_count;
    logic [15:0] sample_count;
  } header_t


endpackage