module module_top (
    input logic clk,
    input logic rst,
    input logic [3:0] row_in,
    output logic [3:0] col_out,
    output logic [6:0] catodo_po,
    output logic [3:0] anodo_po,
    output logic [3:0] col_shift_reg
);

    // Definición de los estados
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        DEBOUNCE = 2'b01,
        SCAN = 2'b10
    } state_t;

    state_t state, next_state;

    logic slow_clk;
    logic [3:0] column_index;
    logic [3:0] key_value;
    logic [3:0] clean_rows;
    logic key_pressed;

    logic enable_shift_reg;
    logic enable_debouncer;
    logic enable_scanner;

    assign col_out = col_shift_reg;

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
        .enable(enable_shift_reg),  // Añadir la señal de habilitación
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
                .enable(enable_debouncer),  // Añadir la señal de habilitación
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
        .enable(enable_scanner),  // Añadir la señal de habilitación
        .key_value(key_value),
        .key_pressed(key_pressed)
    );

    // Instancia del controlador del display de 7 segmentos
    seg7_control display_inst (
        .dec(key_value),
        .seg(catodo_po),
        .an(anodo_po)
    );

    // Máquina de estado
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Lógica de habilitación de los módulos según el estado
    always_comb begin
        // Deshabilitar todos los módulos por defecto
        enable_shift_reg = 1'b0;
        enable_debouncer = 1'b0;
        enable_scanner = 1'b0;
        
        // Lógica de transición de estados
        next_state = state;
        case (state)
            IDLE: begin
                enable_shift_reg = 1'b1; // Activar registro de desplazamiento
                next_state = DEBOUNCE;   // Pasar al estado de debounce
            end

            DEBOUNCE: begin
                enable_debouncer = 1'b1; // Activar el debouncer
                if (|clean_rows) begin   // Si alguna fila es activa
                    next_state = SCAN;
                end
            end

            SCAN: begin
                enable_scanner = 1'b1; // Activar el escaneo de teclas
                if (!key_pressed) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

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