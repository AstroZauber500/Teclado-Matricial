module seg7_control(

    input logic [3:0] dec, 
    output logic [6:0] seg, // señales de segmentos
    output logic [3:0] anode // señales de ánodo
);
    assign anode = 8'b11111111;

    always_comb begin // Decodificador de binario a 7 segmentos
        case(dec)
            4'b0000: seg [ 6 : 0 ] = 7'b1000000; // Muestra A en el 7 segmentos

            4'b0001: seg [ 6 : 0 ] = 7'b1111001; // Muestra 3 en el 7 segmentos
            4'b0010: seg [ 6 : 0 ] = 7'b0100100; // Muestra 2 en el 7 segmentos
            4'b0011: seg [ 6 : 0 ] = 7'b0110000; // Muestra 1 en el 7 segmentos

            4'b0100: seg [ 6 : 0 ] = 7'b0011001; // Muestra B en el 7 segmentos
            4'b0101: seg [ 6 : 0 ] = 7'b0010010; // Muestra 6 en el 7 segmentos
            4'b0110: seg [ 6 : 0 ] = 7'b0100000; // Muestra 5 en el 7 segmentos
            4'b0111: seg [ 6 : 0 ] = 7'b1111000; // Muestra 4 en el 7 segmentos

            4'b1000: seg [ 6 : 0 ] = 7'b0000000; // Muestra C en el 7 segmentos
            4'b1001: seg [ 6 : 0 ] = 7'b0011000; // Muestra 9 en el 7 segmentos
            4'b1010: seg [ 6 : 0 ] = 7'b0000000; // Muestra 8 en el 7 segmentos
            4'b1011: seg [ 6 : 0 ] = 7'b0000000; // Muestra 7 en el 7 segmentos

            4'b1100: seg [ 6 : 0 ] = 7'b1000000; // Muestra D en el 7 segmentos
            4'b1101: seg [ 6 : 0 ] = 7'b1000000; // Muestra # en el 7 segmentos
            4'b1110: seg [ 6 : 0 ] = 7'b1000000; // Muestra 0 en el 7 segmentos
            4'b1111: seg [ 6 : 0 ] = 7'b1000000; // Muestra * en el 7 segmentos

            default: seg [ 6 : 0 ] = 7'b1000000; // Muestra 0 en el 7 segmentos // Muestra 9 en el 7 segmentos
        endcase
    end

endmodule