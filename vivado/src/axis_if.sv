interface axis_if #(
  parameter int DATA_W = 32,
)(
  input logic clk,
  input logic rst_n
);

  logic [DATA_W-1:0] tdata;
  logic              tvalid;
  logic              tready;
  logic              tlast;

  modport master (
    output tdata,
    output tvalid,
    output tlast,
    input  tready
  );

  modport slave (
    input  tdata,
    input  tvalid,
    input  tlast,
    output tready
  );

endinterface