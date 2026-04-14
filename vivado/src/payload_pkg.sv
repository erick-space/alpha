package payload_pkg;

  parameter int AXIS_DATA_W = 32;
  parameter int AXIS_KEEP_W = AXIS_DATA_W/8;
  parameter int AXIS_ID_W   = 4;
  parameter int AXIS_USER_W = 16;
  parameter int FIFO_DEPTH  = 256;

  typedef enum logic [AXIS_ID_W-1:0] {
    SRC_CAMERA = 4'd0,
    SRC_ADC    = 4'd1,
    SRC_IMU    = 4'd2,
    SRC_ENV    = 4'd3
  } payload_src_e;

endpackage