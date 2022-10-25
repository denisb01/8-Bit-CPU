// Control unit -> controleaza toate instructiunile din RAM care se executa

module control_unit (
    input clk,                                  // Semnalul de clock
    input [3:0] pc,                             // Semnalul de program count (adresa din ram de unde se ia instructiunea care se va executa)
    input [7:0] RAM_data,                       // Datele citite din RAM
    input [7:0] reg_data_1,                     // Datele citite din registri
    input [7:0] reg_data_2,                     // Datele citite din registri
    input [7:0] ALU_res,                        // Resultatul operatiunii din ALU
    output reg [7:0] wr_reg_data,               // Datele scrise in registri
    output reg [7:0] wr_RAM_data,               // Datele scrise in RAM
    output reg pc_en,                           // Semnalul de enable pentru program counter
    output reg re_en_RAM,                       // Semnalul de enable pentru citire din RAM
    output reg wr_en_RAM,                       // Semnalul de enable pentru scriere in RAM
    output reg re_en_reg,                       // Semnalul de enable pentru citire din registri
    output reg wr_en_reg,                       // Semnalul de enable pentru scriere in registri
    output reg [3:0] addr_RAM,                  // Adresa din RAM de unde se citeste/scrie instructiunea
    output reg [1:0] reg_dest_1,                // Adresa registrului in care se scrie/citeste valoarea
    output reg [1:0] reg_dest_2,                // Adresa registrului in care se scrie/citeste valoarea
    output reg [3:0] new_count,                 // Adresa din RAM la care se va face JUMP
    output reg jump,                            // Semnalul de enable pentru JUMP
    output reg [7:0] ALU_val_1,                 // Valoare din primul registru pentru ALU
    output reg [7:0] ALU_val_2,                 // Valoare din al doilea registru pentru ALU
    output reg [2:0] ALU_instr                  // Instructiunea pentru ALU
);
    reg [3:0] instr_count;                      // Counterul pentru semi-istructiuni

    reg [3:0] instr_addr;                       // Adresa din RAM de unde se citeste instructiunea
    reg [7:0] instr_reg;                        // Instructiunea citita din RAM

    always @(negedge clk) begin                             // La fiecare palier negativ de clock se executa urmatoarele linii de cod
        if(instr_count<=6)begin                             
            assign instr_count = instr_count + 1;           // Se incrementeaza de 6 ori instruction counter-ul (de la 0 -> 6 adica 7 semi-instructiuni)
        end
        else begin
            assign instr_count = 0;                         // Cand a depasit 6 se reseteaza instruction counter-ul la 0
        end

        case (instr_count)                                  
            3'b000: begin
                instr_addr <= pc;                           // La instruction conter = 0 se va lua adresa din RAM de instructiune (fetch phase)
            end 
            3'b001: begin
                assign re_en_RAM = 1;                       // Se face semnalul de read din RAM activ pentru citirea instructiunii din RAM
                assign addr_RAM = instr_addr;               // Se da adresa de unde se citeste instructiunea din RAM
            end
            3'b010: begin
                instr_reg <= RAM_data;                      // Se citeste in instruction register instructiunea citita din RAM (decode phase)
                assign pc_en = 1;                           // Se activeaza enable pentru program counter (se incrementeaza cu 1)
            end
            default: begin
                assign pc_en = 0;                           // Se dezactiveaza enable pentru program counter
            end
        endcase

        case (instr_reg[7:4])                               // Decode -> primi patru biti de instructiune

/*                                      Citire din RAM                                                  */
            // Load from RAM into register 1
            4'b0001: begin
                case(instr_count)
                    3'b011: begin                               // Aici incepe execute phase
                        assign addr_RAM = instr_reg[3:0];       // Se da adresa de unde se citeste din RAM valoarea (ultimi 4 biti din instr_reg)
                        assign reg_dest_1 = 2'b00;              // Se da adresa registrului in care se va scrie din RAM
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registri activ
                    end
                    3'b100: begin
                        wr_reg_data <= RAM_data;                // Scrierea valorii din RAM in registru
                    end
                    3'b101: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        assign re_en_RAM = 0;
                        wr_reg_data <= 8'dx;
                    end
                endcase
            end
            // Load from RAM into register 2
            4'b0010: begin
                case(instr_count)
                    3'b011: begin                               // Aici incepe execute phase
                        assign addr_RAM = instr_reg[3:0];       // Se da adresa de unde se citeste din RAM valoarea (ultimi 4 biti din instr_reg)
                        assign reg_dest_1 = 2'b01;              // Se da adresa registrului in care se va scrie din RAM
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registri activ
                    end
                    3'b100: begin
                        wr_reg_data <= RAM_data;                // Scrierea valorii din RAM in registru
                    end
                    3'b101: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        assign re_en_RAM = 0;
                        wr_reg_data <= 8'dx;
                    end
                endcase
            end
            // Load from RAM into register 3
            4'b0011: begin
                case(instr_count)
                    3'b011: begin                               // Aici incepe execute phase
                        assign addr_RAM = instr_reg[3:0];       // Se da adresa de unde se citeste din RAM valoarea (ultimi 4 biti din instr_reg)
                        assign reg_dest_1 = 2'b10;              // Se da adresa registrului in care se va scrie din RAM
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registri activ
                    end
                    3'b100: begin
                        wr_reg_data <= RAM_data;                // Scrierea valorii din RAM in registru
                    end
                    3'b101: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        assign re_en_RAM = 0;
                        wr_reg_data <= 8'dx;
                    end
                endcase
            end
            // Load from RAM into register 4
            4'b0100: begin
                case(instr_count)
                    3'b011: begin                               // Aici incepe execute phase
                        assign addr_RAM = instr_reg[3:0];       // Se da adresa de unde se citeste din RAM valoarea (ultimi 4 biti din instr_reg)
                        assign reg_dest_1 = 2'b11;              // Se da adresa registrului in care se va scrie din RAM
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registri activ
                    end
                    3'b100: begin
                        wr_reg_data <= RAM_data;                // Scrierea valorii din RAM in registru
                    end
                    3'b101: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        assign re_en_RAM = 0;
                        wr_reg_data <= 8'dx;
                    end
                endcase
            end

/*                                      Scriere in RAM                                                  */
            // Write from reg1 to RAM
            4'b0101: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv
                        assign addr_RAM = instr_reg[3:0];       // Se da adresa unde se scrie in RAM valoarea (ultimi 4 biti din instr_reg) 
                        assign reg_dest_1 = 2'b00;              // Se da adresa registrului din care se va citi valoarea
                        assign wr_en_RAM = 1;                   // Se face semnalul de write in RAM activ
                        assign re_en_reg = 1;                   // Se face semnalul de read din registri activ
                    end
                    3'b100: begin
                        wr_RAM_data <= reg_data_1;              // Scrierea valorii din registru in RAM
                    end
                    3'b101:begin                                // Resetarea semnalelor
                        assign wr_en_RAM = 0;
                        assign re_en_reg = 0;
                        wr_RAM_data <= 8'dx;
                    end
                endcase
            end
            // Write from reg2 to RAM
            4'b0110: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv
                        assign addr_RAM = instr_reg[3:0];       // Se da adresa unde se scrie in RAM valoarea (ultimi 4 biti din instr_reg) 
                        assign reg_dest_1 = 2'b01;              // Se da adresa registrului din care se va citi valoarea
                        assign wr_en_RAM = 1;                   // Se face semnalul de write in RAM activ
                        assign re_en_reg = 1;                   // Se face semnalul de read din registri activ
                    end
                    3'b100: begin
                        wr_RAM_data <= reg_data_1;                // Scrierea valorii din registru in RAM
                    end
                    3'b101:begin                                // Resetarea semnalelor
                        assign wr_en_RAM = 0;
                        assign re_en_reg = 0;
                        wr_RAM_data <= 8'dx;
                    end
                endcase
            end
            // Write from reg3 to RAM
            4'b0111: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv
                        assign addr_RAM = instr_reg[3:0];       // Se da adresa unde se scrie in RAM valoarea (ultimi 4 biti din instr_reg) 
                        assign reg_dest_1 = 2'b10;              // Se da adresa registrului din care se va citi valoarea
                        assign wr_en_RAM = 1;                   // Se face semnalul de write in RAM activ
                        assign re_en_reg = 1;                   // Se face semnalul de read din registri activ
                    end
                    3'b100: begin
                        wr_RAM_data <= reg_data_1;                // Scrierea valorii din registru in RAM
                    end
                    3'b101:begin                                // Resetarea semnalelor
                        assign wr_en_RAM = 0;
                        assign re_en_reg = 0;
                        wr_RAM_data <= 8'dx;
                    end
                endcase
            end
            // Write from reg4 to RAM
            4'b1000: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv
                        assign addr_RAM = instr_reg[3:0];       // Se da adresa unde se scrie in RAM valoarea (ultimi 4 biti din instr_reg) 
                        assign reg_dest_1 = 2'b11;              // Se da adresa registrului din care se va citi valoarea
                        assign wr_en_RAM = 1;                   // Se face semnalul de write in RAM activ
                        assign re_en_reg = 1;                   // Se face semnalul de read din registri activ
                    end
                    3'b100: begin
                        wr_RAM_data <= reg_data_1;                // Scrierea valorii din registru in RAM
                    end
                    3'b101:begin                                // Resetarea semnalelor
                        assign wr_en_RAM = 0;
                        assign re_en_reg = 0;
                        wr_RAM_data <= 8'dx;
                    end
                endcase
            end

/*                                      Instructiunea de JUMP                                                  */
            4'b1001: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv
                        assign jump = 1;                        // Se face semnalul de enable JUMP activ
                        new_count <= instr_reg[3:0];            // Se da adresa din RAM la care se va face JUMP
                    end
                    3'b100: begin                               // Resetarea semnalelor
                        assign jump = 0;
                    end
                endcase
            end

/*                                      Instructiunnile pentru ALU                                                  */
            // Adunarea a doua numere
            4'b1010: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv
                        assign reg_dest_1 = instr_reg[3:2];     // Se da prima adresa de registru din care se va lua valoarea
                        assign reg_dest_2 = instr_reg[1:0];     // Se da a doua adresa de registru din care se va lua valoarea
                        assign re_en_reg = 1;                   // Se face semnalul de read din registru activ
                        assign ALU_instr = 3'b000;              // Se da codul de instructiune pentru ALU
                    end
                    3'b100: begin
                        ALU_val_1 <= reg_data_1;                // Se da valoarea din registrul 1 pentru registrul a din ALU
                        ALU_val_2 <= reg_data_2;                // Se da valoarea din registrul 2 pentru registrul b din ALU
                    end
                    3'b101: begin
                        assign re_en_reg = 0;                   // Se face semnalul de read din registru inactiv
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registru activ
                    end
                    3'b110: begin
                        wr_reg_data <= ALU_res;                 // Se scrie rezultatul in primul registru dat
                    end
                    3'b111: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        ALU_val_1 <= 8'dx;
                        ALU_val_2 <= 8'dx;
                        wr_reg_data <= 8'dx;
                    end
                endcase
            end
            // Scaderea a doua numere
            4'b1011: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv    
                        assign reg_dest_1 = instr_reg[3:2];     // Se da prima adresa de registru din care se va lua valoarea
                        assign reg_dest_2 = instr_reg[1:0];     // Se da a doua adresa de registru din care se va lua valoarea
                        assign re_en_reg = 1;                   // Se face semnalul de read din registru activ
                        assign ALU_instr = 3'b001;              // Se da codul de instructiune pentru ALU
                    end
                    3'b100: begin
                        ALU_val_1 <= reg_data_1;                // Se da valoarea din registrul 1 pentru registrul a din ALU
                        ALU_val_2 <= reg_data_2;                // Se da valoarea din registrul 2 pentru registrul b din ALU
                    end
                    3'b101: begin
                        assign re_en_reg = 0;                   // Se face semnalul de read din registru inactiv
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registru activ
                    end
                    3'b110: begin
                        wr_reg_data <= ALU_res;                 // Se scrie rezultatul in primul registru dat
                    end
                    3'b111: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        ALU_val_1 <= 8'dx;
                        ALU_val_2 <= 8'dx;
                        wr_reg_data <= 8'dx;
                    end
                endcase
            end
            // Si logic dintre doua numere
            4'b1100: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv    
                        assign reg_dest_1 = instr_reg[3:2];     // Se da prima adresa de registru din care se va lua valoarea
                        assign reg_dest_2 = instr_reg[1:0];     // Se da a doua adresa de registru din care se va lua valoarea
                        assign re_en_reg = 1;                   // Se face semnalul de read din registru activ
                        assign ALU_instr = 3'b010;              // Se da codul de instructiune pentru ALU
                    end
                    3'b100: begin
                        ALU_val_1 <= reg_data_1;                // Se da valoarea din registrul 1 pentru registrul a din ALU
                        ALU_val_2 <= reg_data_2;                // Se da valoarea din registrul 2 pentru registrul b din ALU
                    end
                    3'b101: begin
                        assign re_en_reg = 0;                   // Se face semnalul de read din registru inactiv
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registru activ
                    end
                    3'b110: begin
                        wr_reg_data <= ALU_res;                 // Se scrie rezultatul in primul registru dat
                    end
                    3'b111: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        ALU_val_1 <= 8'dx;
                        ALU_val_2 <= 8'dx;
                        wr_reg_data <= 8'dx;
                    end
                endcase
            end
            // Sau logic dintre doua numere
            4'b1101: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv    
                        assign reg_dest_1 = instr_reg[3:2];     // Se da prima adresa de registru din care se va lua valoarea
                        assign reg_dest_2 = instr_reg[1:0];     // Se da a doua adresa de registru din care se va lua valoarea
                        assign re_en_reg = 1;                   // Se face semnalul de read din registru activ
                        assign ALU_instr = 3'b011;              // Se da codul de instructiune pentru ALU
                    end
                    3'b100: begin
                        ALU_val_1 <= reg_data_1;                // Se da valoarea din registrul 1 pentru registrul a din ALU
                        ALU_val_2 <= reg_data_2;                // Se da valoarea din registrul 2 pentru registrul b din ALU
                    end
                    3'b101: begin
                        assign re_en_reg = 0;                   // Se face semnalul de read din registru inactiv
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registru activ
                    end
                    3'b110: begin
                        wr_reg_data <= ALU_res;                 // Se scrie rezultatul in primul registru dat
                    end
                    3'b111: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        ALU_val_1 <= 8'dx;
                        ALU_val_2 <= 8'dx;
                        wr_reg_data <= 8'dx;
                    end
                endcase
            end
            // Verificare a < b
            4'b1110: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv    
                        assign reg_dest_1 = instr_reg[3:2];     // Se da prima adresa de registru din care se va lua valoarea
                        assign reg_dest_2 = instr_reg[1:0];     // Se da a doua adresa de registru din care se va lua valoarea
                        assign re_en_reg = 1;                   // Se face semnalul de read din registru activ
                        assign ALU_instr = 3'b100;              // Se da codul de instructiune pentru ALU
                    end
                    3'b100: begin
                        ALU_val_1 <= reg_data_1;                // Se da valoarea din registrul 1 pentru registrul a din ALU
                        ALU_val_2 <= reg_data_2;                // Se da valoarea din registrul 2 pentru registrul b din ALU
                    end
                    3'b101: begin
                        assign re_en_reg = 0;                   // Se face semnalul de read din registru inactiv
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registru activ
                    end
                    3'b110: begin
                        wr_reg_data <= ALU_res;                 // Se scrie rezultatul in primul registru dat
                    end
                    3'b111: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        ALU_val_1 <= 8'dx;
                        ALU_val_2 <= 8'dx;
                        wr_reg_data <= 8'd0;
                    end
                endcase
            end
            // Verificare a = b
            4'b1111: begin
                case(instr_count)
                    3'b011: begin
                        assign re_en_RAM = 0;                   // Se face semnalul de read din RAM inactiv    
                        assign reg_dest_1 = instr_reg[3:2];     // Se da prima adresa de registru din care se va lua valoarea
                        assign reg_dest_2 = instr_reg[1:0];     // Se da a doua adresa de registru din care se va lua valoarea
                        assign re_en_reg = 1;                   // Se face semnalul de read din registru activ
                        assign ALU_instr = 3'b101;              // Se da codul de instructiune pentru ALU
                    end
                    3'b100: begin
                        ALU_val_1 <= reg_data_1;                // Se da valoarea din registrul 1 pentru registrul a din ALU
                        ALU_val_2 <= reg_data_2;                // Se da valoarea din registrul 2 pentru registrul b din ALU
                    end
                    3'b101: begin
                        assign re_en_reg = 0;                   // Se face semnalul de read din registru inactiv
                        assign wr_en_reg = 1;                   // Se face semnalul de enable pentru scriere in registru activ
                    end
                    3'b110: begin
                        wr_reg_data <= ALU_res;                 // Se scrie rezultatul in primul registru dat
                    end
                    3'b111: begin                               // Resetarea semnalelor
                        assign wr_en_reg = 0;
                        ALU_val_1 <= 8'dx;
                        ALU_val_2 <= 8'dx;
                        wr_reg_data <= 8'd0;
                    end
                endcase
            end
        endcase
    end
    
endmodule