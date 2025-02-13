module RangeFinder
  #(parameter WIDTH=16)
  (input logic [WIDTH-1:0] data_in,
   input logic clock, reset,
   input logic go, finish,
   output logic [WIDTH-1:0] range,
   output logic debug_error);

  enum logic [1:0] {READY=2'b0, READ=2'b01, DONE=2'b10, BAD=2'b11} cs, ns;

  logic [WIDTH-1:0] curr_max, curr_min;

  // Next state logic
  always_comb begin
    ns = cs;
    if (cs == READY) begin
      if (finish) ns = BAD;
      else if (go) ns = READ;
    end
    else if (cs == READ) begin
      if (finish) ns = DONE;
    end
    else if (cs == DONE) begin
      ns = READY;
    end
    else if (cs == BAD) begin
      if (go) ns = READ;
    end
  end

  // Tracking max/min
  always_comb begin
    case (cs)
      READY: begin
        curr_max = '0;
        curr_min = '1;
      end
      BAD: begin
        curr_max = '0;
        curr_min = '1;
      end
      READ: begin
        if (data_in > curr_max) curr_max = data_in;
        if (data_in < curr_min) curr_min = data_in;
      end
    endcase
  end

  // Output logic
  always_comb begin
    debug_error = 1'b0;
    if (cs == BAD) debug_error = 1'b1;
    range = curr_max - curr_min;
  end


  // FF for state
  always_ff @(posedge clock, posedge reset)
    if (reset)
      cs <= READY;
    else
      cs <= ns;

endmodule: RangeFinder
