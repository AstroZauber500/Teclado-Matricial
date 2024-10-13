module row_scanner (
    
    input logic [3:0] col_shift_reg,
    input logic [3:0] row_in,
    input logic [3:0] key_value,
    input logic key_pressed
);


    always_comb begin : blockName
    // Inicializacion de variables

        key_pressed = 4'b0;
        key_value = 4'b0000;

        // Posibles combinaciones
        case (col_shift_reg)
            4'b1000 :  case (row_in) // cuarta columna activa

                            4'b1000 : key_value = 4'b0001;  // "1"
                            4'b0100 : key_value = 4'b0010;  // "2"
                            4'b0010 : key_value = 4'b0011;  // "3"
                            4'b0001 : key_value = 4'b1010;  // "A"

                        endcase
            4'b0100 :  case (row_in) // tercera columna activa

                            4'b1000 : key_value = 4'b0100;  // "4"
                            4'b0100 : key_value = 4'b0101;  // "5"
                            4'b0010 : key_value = 4'b0110;  // "6"
                            4'b0001 : key_value = 4'b1011;  // "B"

                        endcase
            4'b0010 :   case (row_in) // segunda columna activa

                            4'b1000 : key_value = 4'b0111;  // "7"
                            4'b0100 : key_value = 4'b1000;  // "8"
                            4'b0010 : key_value = 4'b1001;  // "9"
                            4'b0001 : key_value = 4'b1100;  // "C"

                        endcase
            4'b0001 : case (row_in) // primera columna activa

                            4'b1000 : key_value = 4'b0000;  // "1"
                            4'b0100 : key_value = 4'b0000;  // "2"
                            4'b0010 : key_value = 4'b0000;  // "3"
                            4'b0001 : key_value = 4'b1101;  // "D"

                        endcase
        endcase

        
    end
    
    
endmodule