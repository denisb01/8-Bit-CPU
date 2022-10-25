// RAM (Random Access Memory) -> aici se vor stoca datele sau de aici se vor citi datele

module RAM (
    input clk,                      // Semnalul de clk
    // Adresa
    input [3:0] addr,               // Adresa unde se vor stoca, sau de unde se vor citi datele
    // Inputuri pentru scriere
    input wr_en,                    // Semnalul de permisiune pentru scrierea datelor
    input [7:0] data,               // Datele care se vor scrie (pe 8 biti -> 2^8 (255) numar max de scriere)
    // Inputuri si outputuri pentru citire
    input read_en,                  // Semnalul de permisiune pentru citirea datelor
    output reg [7:0] data_read      // Datele care sau citit (pe 8 biti -> 2^8-1 (255) numar max de citire)
);

    reg [7:0] RAM_reg [15:0];       // 16 registri de RAM (0 -> 15) pe 8 biti (valoarea max de stocare 2^8-1 -> 255)

    initial begin
        $readmemb("ram_data.txt",RAM_reg);    // Se citestc datele de 8 biti in binar din ram_data.txt
    end

    always @(posedge clk) begin
        if (wr_en) begin                        // Daca semnalul de write enable este activ, se vor scrie datele
            RAM_reg[addr] <= data;              // Datele se scriu in adresa data ca parametru
        end
        else if(read_en) begin                  // Daca semnalul de write enable nu este activ si semnalul de read enable este activ, se vor citi datele
            data_read <= RAM_reg[addr];         // Datele se citesc din adresa data ca parametru
        end

        if(!read_en) begin
            data_read <= 8'dx;                  // Daca read enable nu este activ nu se citeste nimic (valoarea citita se actualizeaza cu 8 biti de x)
        end
    end
    
endmodule