`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
    RangeFinder #(10) rf(
                .data_in(io_in[9:0]),
                .go(io_in[11]),
                .finish(io_in[10]),
                .range(io_out[9:0]),
                .debug_error(io_out[11]),
                .*);

endmodule
