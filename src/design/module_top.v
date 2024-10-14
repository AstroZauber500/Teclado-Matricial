module module_top (
    input logic clk,
    input logic rst,
    input logic [3:0] row_in,
    output logic [3:0] col_out,
    output logic [6:0] catodo_po,
    output logic [3:0] anodo_po,
    output logic [12:0] acumulador
);

    logic slow_clk;
    logic [3:0] column_index;
    logic [3:0] key_value;
    logic [3:0] clean_rows;
    logic key_pressed;
    //logic [12:0] acumulador;
    logic [3:0] col_shift_reg;

    assign col_shift_reg = col_out;

    // Instancia del divisor de frecuencia
    freq_divider divisor_inst (
        .clk(clk),
        .rst(rst),
        .slow_clk(slow_clk)
    );
    
    // Instancia del registro de desplazamiento de columnas
    col_shift_register registro_inst (
        .slow_clk(slow_clk),
        .rst(rst),
        .key_pressed(key_pressed),
        .col_shift_reg(col_out),
        .column_index(column_index)
    );

    // Instancias del debouncer para cada fila
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

    // Instancia del escáner de filas
    row_scanner scanner_inst (
        .slow_clk(slow_clk),
        .rst(rst),
        .col_shift_reg(col_out),
        .row_in(clean_rows),
        .key_value(key_value),
        .key_pressed(key_pressed)
    );

    // Instancia del controlador del display de 7 segmentos
    //seg7_control display_inst (
    //    .dec(key_value),
    //    .seg(catodo_po),
    //    .an(anodo_po)
    //);

    input_control control_inst (
        .clk(clk),
        .rst(rst),
        .key_value(key_value),
        .key_pressed(key_pressed),
        .acumulador(acumulador)
    );

    bin_decimal converter_inst (
        .binario(acumulador),
        .bcd(bcd)
    );

    
    module_7_segments display_inst (
        .clk_i(clk),
        .rst_i(rst),
        .bcd_i(bcd),
        .anodo_o(anodo_po),
        .catodo_o(catodo_po)
    );


endmodule