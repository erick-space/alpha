

module payload_formatter #(
  parameter int DATA_W        = 8,
  parameter int HEADER_LENGTH = 6
)(
  input  logic          clk,
  input  logic          rst_n,
  input  logic          start,
  input  logic [15:0]   sample_count,
  input  logic [31:0]   time_stamp,
  input  logic [15:0]   record_per_packet,
  payload_src_e   payload_id,
  axis_if.slave   axis_in,
  axis_if.master  axis_out
);

  typedef enum logic [1:0] {
    WRITE_HEADER,
    WRITE_PAYLOAD
  } state_t;

  state_t state;

  logic [7:0] header_count;
  logic [15:0] sequence_num;
  logic [15:0] payload_count
  logic [DATA_W-1:0] header_array [HEADER_LENGTH];


  // ------------------------------------------------------------
  // Header packing
  // ------------------------------------------------------------
  always_comb begin
    header_array[0] = payload_id;
    header_array[1] = sequence_num;
    header_array[2] = time_stamp[15:0];
    header_array[3] = time_stamp[31:16];
    header_array[4] = payload_count;
    header_array[5] = sample_count;
  end


  always_ff (@posedge clk) begin
    if(!rst_n) begin
      state <= write_header;
      axis_out.tvalid <= 1'b1;
      header_count <= '0;
      sequence_num <= '0;
      payload_count <= '0;
    end else begin
      case (state) begin

        // ------------------------------------------------------
        // Send header words first
        // ------------------------------------------------------
        WRITE_HEADER:
          if (start) begin
            axis_out.tdata <= header_array[header_count];
            axis_out.tvalid <= 1'b1;

            if (header_count == HEADER_LENGTH-1) begin
              header_count <= '0;
              sequence_num <= sequence_num + 1'd1;
              state        <= WRITE_PAYLOAD;
            end else begin
              header_count <= header_count + 1'b1;
            end
          end

  
        // ------------------------------------------------------
        // Forward payload after header is complete
        // ------------------------------------------------------
        WRITE_PAYLOAD: begin
          axis_out.tvalid <= axis_in.tvalid;
          axis_out.tdata  <= axis_in.tdata;
          
          if (axis_in.tvalid) begin
            if (sample_counter == header.sample_count) begin
              state <= WRITE_HEADER;
              sample_counter <= '0;
            end else 
              sample_counter <= sample_counter + 1'b1;
          end

        end

        default: begin
          state        <= WRITE_HEADER;
          header_count <= '0;
          sample_counter <= '0;
        end

      endcase 

    end

  // ------------------------------------------------------
  // Count records that goes in each packet. Assert tlast to indicate end of packet
  // ------------------------------------------------------
  always_ff (@posedge clk) begin
    if(!rst_n) begin
      record_counter <= '0;
      axis_out.tlast <= 1'b0;
    end else begin
      axis_out.tlast <= 1'b0;
      if (sampler_counter == header.sample_count) begin
        if (record_counter == record_per_packet) begin
          record_counter <= '0;
          axis_out.tlast  <= 1'b1;;
        end else
          record_counter <= record_counter + 16'd0;
    end 
  end

  // ------------------------------------------------------
  // Assert buffer error when writing to buffer that is not taking in data
  // -----------------------------------------------------  
  logic buffer_error;
  assign buffer_error = axis_out.tvalid && !axis_out.tready


endmodule