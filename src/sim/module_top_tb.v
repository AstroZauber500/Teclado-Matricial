`timescale 1ns/1ps

module teclado_matricial_tb; 

    logic clk,           // Señal de reloj (27 MHz)
    logic rst,           // Señal de reinicio
    logic [3:0] row_in,  // Entradas de las filas
    logic [3:0] col_out, // Salidas de las columnas
    logic [3:0] key_out,  // Código de la tecla presionada
    logic slow_clk,

    logic [3:0] anodo_po,
    logic [6:0] catodo_po

    teclado_matricial dut (

        .clk(clk),
        .rst(rst),
        .row_in(row_in),
        .col_out(col_out),
        .key_out(key_out),
        .slow_clk(slow_clk),
        .anodo_po(anodo_o),
        .catodo_po(catodo_o)
    );

    always #18.518 clk = ~clk; // Período de 37.037 ns (27 MHz)

    initial begin
        clk = 0;
        rst = 1;           // Aplicar reinicio
        row_in = 4'b0000;  // Inicialmente, no hay teclas presionadas
    
        
    end

        
endmodule    
