// Program counter -> aici se va incrementa semnalul de count (adresa din RAM de la care se va lua intstructiunea) pe 4 biti la fiecare palier pozitiv de clock
 
module program_counter (
    input clk,                                  // Semnalul de clock
    input [3:0] set_count,                      // Noul semnal de count pe 4 biti (la care adresa din RAM facem jump)
    input jump,                                 // Semnalul de jump (pe 1 se schimba adresa de executie a insctructiuni din RAM cu cea de la set_count)
    input count_en,                             // Semnalul de enable pentru count
    output reg [3:0] count                      // Semnalul de count 
); 
    initial begin
        assign count = 4'b0000;                 // Se initializeaza cu 4 biti de 0
    end

    always @(posedge clk) begin                
        if(count_en) begin                      
            assign count = count + 1;           // La fiecare palier pozitiv de clk, daca este count enable 1 se incrementeaza semnalul de count cu 1
        end

        if(jump) begin                          
            assign count = set_count;           // La fiecare palier pozitiv de clk, daca este jump 1 semnalul de count sare la semnalul nou de count
        end
    end

endmodule