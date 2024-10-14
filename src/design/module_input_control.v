module input_control (
    input logic clk,
    input logic rst,
    input logic [3:0] key_value,
    input logic key_pressed,
    output logic [11:0] acumulador // Acumulador de 12 bits
);
    logic key_pressed_prev; // Aca no cambio esto entonces aja 

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            acumulador <= 12'b000000000000; // Reinicia el acumulador
            key_pressed_prev <= 1'b0; // Reinicia el estado previo del botón
        end
        else begin
            // Detecta el flanco ascendente del botón de suma
            if (key_pressed && !key_pressed_prev) begin
                // Asegura que el valor acumulado no exceda el límite de 12 bits
                acumulador <= acumulador + {8'b0, key_value}; // Agregar el valor de los dipswitches
            end
            
            key_pressed_prev <= key_pressed; // Actualiza el estado previo del botón
        end
    end
endmodule