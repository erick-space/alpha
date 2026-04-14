interface axis_if #(
  parameter int DATA_W = 32,
  parameter int KEEP_W = (DATA_W/8),
  parameter int ID_W   = 4,
  parameter int USER_W = 16
)(
  input logic clk,
  input logic rst_n
);

  logic [DATA_W-1:0] tdata;
  logic [KEEP_W-1:0] tkeep;
  logic [ID_W-1:0]   tid;
  logic [USER_W-1:0] tuser;
  logic              tvalid;
  logic              tready;
  logic              tlast;

  modport master (
    output tdata,
    output tkeep,
    output tid,
    output tuser,
    output tvalid,
    output tlast,
    input  tready
  );

  modport slave (
    input  tdata,
    input  tkeep,
    input  tid,
    input  tuser,
    input  tvalid,
    input  tlast,
    output tready
  );

endinterface