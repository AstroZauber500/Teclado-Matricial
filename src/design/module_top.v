module module_top (

    input logic clk,
    input logic rst,
    input logic [3:0] row_in,
    output logic [3:0] col_out,
    output logic [6:0] catodo_po,
    output logic [3:0] anodo_po,
    output logic [3:0] col_shift_reg


);

    logic slow_clk;
    //logic [3:0] col_shift_reg;
    logic [3:0] column_index;
    logic [3:0] key_value;
    logic key_pressed;
    logic [3:0] clean_rows; 
    logic [15:0] bcd;

    assign col_out = col_shift_reg;

    freq_divider divisor_inst (
        .clk(clk),
        .rst(rst),
        .slow_clk(slow_clk)
    );

    col_shift_register registro_inst (
        .slow_clk(slow_clk),
        .rst(rst),
        .col_shift_reg(col_out),
        .column_index(column_index)
    );

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : debouncer_loop
            debouncer debounce_inst (
                .clk(clk),
                .rst(rst),
                .noisy_signal(row_in[i]),
                .clean_signal(clean_rows[i])
            );
        end
    endgenerate

    row_scanner scanner_inst (
        .col_shift_reg(col_out),
        .row_in(clean_rows),
        .key_value(key_value)
    );

    seg7_control display_inst (
        .dec(key_value),
        .seg(catodo_po),
        .an(anodo_po)
    );


    //bin_decimal converter_inst (
    //    .binario(key_value),
    //    .bcd(bcd)
    //);
    
    
    //module_7_segments display_inst (
    //    .clk_i(clk),
    //    .rst_i(rst),
    //    .bcd_i(),
    //    .anodo_o(anodo_po),
    //    .catodo_o(catodo_po)
    //);


endmodule