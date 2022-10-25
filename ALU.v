// ALU (Arithmetic and Logic Unit) -> aici se vor desfasura

module ALU (
    input [7:0] a,                      // Primul numar pe 8 biti asupra caruia se desfasoara operatia
    input [7:0] b,                      // Al doilea numar pe 8 biti asupra caruia se desfasoara operatia
    input [2:0] ALU_instr,              // Instructiunea pentru operatia care o desfasoara ALU 
    output reg [7:0] result,            // Rezultatul obtinut
    output zero,                        // Flag pentru 0 (va fii activ daca rezulatul este egal cu 0)
    output reg ovr                      // Flag pentru overflow (va fii activ daca rezulatul este mai mare decat numarul care poate fii stocat)
);

    always @(*)begin
        case(ALU_instr)
            // Instructiunea de aditie
            3'b000: begin
                {ovr,result} = a + b;   // Se aduna numarul din a cu numarul din b si se stocheaza oveflow daca exista
            end
            // Instructiunea de scadere
            3'b001: begin
                result = a - b;         // Se scade din numarul a numarul b
            end
            // Instructiunea de si logic
            3'b010: begin
                result = a & b;         // Se face si logic intre biti din a si biti din b
            end
            // Instructiunea de sau logic
            3'b011: begin
                result = a | b;         // Se face sau logic intre biti din a si biti din b
            end
            // Instructiunea de mai mic
            3'b100: begin
                if (a < b) begin        // Se face operatiunea a mai mic decat b
                    result = 8'd1;      // Daca a e mai mic decat b, rezultatul va fi 8 biti de 1
                end
                else begin
                    result = 8'd0;      // Daca b e mai mic sau egal cu a, rezultatul va fi 8 biti de 0
                end
            end
            // Instructiunea de egalitate
            3'b101: begin
                if (a == b) begin       // Se face operatiunea a egal cu b
                    result = 8'd1;      // Daca a este egal cu b, rezultatul va fi 8 biti de 1
                end
                else begin
                    result = 8'd0;      // Daca a nu este egal cu b, rezultatul va fi 8 biti de 0
                end
            end
        endcase
    end

    assign zero = (result == 8'd0) ? 1'b1: 1'b0;                         // Aici se tine cont daca flagul de zero se activeaza
    
endmodule