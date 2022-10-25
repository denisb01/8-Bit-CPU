// Registri -> aici se vor stoca datele temporar pentru un access mai usor la efectuarea de operatiuni

module registers (
    input clk,                      // Semnalul de clock
    input rst,                      // Semnalul de reset
    // Destinatia
    input [1:0] dest_1,             // Destinatia unde se vor scrie datele sau de unde se vor citi datele (pe 2 biti -> 2^2 (4) registri)
    input [1:0] dest_2,             // Destinatia unde se vor scrie datele sau de unde se vor citi datele (pe 2 biti -> 2^2 (4) registri)
    // Inputuri pentru scriere
    input wr_en,                    // Semnalul de permisiune pentru scrierea datelor 
    input [7:0] data,               // Datele care se vor scrie (pe 8 biti -> 2^8 (255) numar max de scriere)
    // Inputuri si outputuri pentru citire
    input read_en,                  // Semnalul de permisiune a citirii datelor 
    output reg [7:0] data_read_1,   // Datele care sau citit (pe 8 biti -> 2^8-1 (255) numar max de citire)
    output reg [7:0] data_read_2    // Datele care sau citit (pe 8 biti -> 2^8-1 (255) numar max de citire)
);

    reg [7:0] registri[0:3];        // 4 registri (0 -> 3) pe 8 biti (valoarea max de stocare 2^8-1 -> 255)

    always @(posedge clk, posedge rst) begin
        if(rst) begin               // Daca semnalul de rst este activ, se vor reseta toti registri pe 0

            for (integer i = 0; i < 8; i = i+1) begin
                registri[i] <= 8'd0;
            end

        end
        else if (wr_en) begin                   // Daca semnalul de reset nu este activ si semnalul de write enable este activ, se vor scrie datele
            registri[dest_1] <= data;           // Datele se scriu in destinatia de registru data ca parametru
        end
        else if(read_en) begin                  // Daca semnalele de reset si de write enable nu sunt active si semnalul de read enable este activ, se vor citi datele
            data_read_1 <= registri[dest_1];    // Datele se citesc din destinatia de registru data ca parametru
            data_read_2 <= registri[dest_2];    // Datele se citesc din destinatia de registru data ca parametru
        end

        if(!read_en) begin                      
            data_read_1 <= 8'dx;                  // Daca read enable nu este activ nu se citeste nimic (valoarea citita se actualizeaza cu 8 biti de x)
            data_read_2 <= 8'dx;                  // Daca read enable nu este activ nu se citeste nimic (valoarea citita se actualizeaza cu 8 biti de x)
        end
    end
    
endmodule