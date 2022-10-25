`include "RAM.v"
`include "registers.v"
`include "control_unit.v"
`include "program_counter.v"
`include "ALU.v"

// CPU (Central Processing Unit) -> aici se vor lega toate modulele create in o intregime pentru a face procesorul

module CPU (
    input clk,  // Semnalul de clock
    input rst   // Semnalul de reset
);

    // Counter
    reg [3:0] new_count;            // Noul count pentru program counter (adresa la care vom face jump)
    reg count_en;                   // Semnalul de permisiune pentru incrementarea program counterului
    reg jump;                       // Semnalul de permisiune pentru jump
    wire [3:0] pc;                  // Valoarea program counterului

    // Scriere si citire RAM 
    reg wr_en_RAM;                  // Semnalul de permisiune pentru scrierea datelor in RAM
    reg re_en_RAM;                  // Semnalul de permisiune pentru citirea datelor din RAM
    reg [3:0] addr_RAM;             // Adresa unde se vor scrie datele in RAM (pe 4 biti -> 16 adrese posibile)

    // Scriere si citire registri
    reg wr_en_reg;                  // Semnalul de permisiune pentru scrierea datelor in registri
    reg re_en_reg;                  // Semnalul de permisiune pentru citirea datelor din registri
    reg [1:0] addr_reg_1;           // Adresa unde se vor scrie datele in registru (pe 2 biti -> 4 adrese posibile)
    reg [1:0] addr_reg_2;           // Adresa unde se vor scrie datele in registru (pe 2 biti -> 4 adrese posibile)

    // Datele de scriere si datele citite
    reg [7:0] data_RAM;             // Datele care se vor scrie in RAM (pe 8 biti -> numar max de scriere 255)
    reg [7:0] data_reg;             // Datele care se vor scrie in registri (pe 8 biti -> numar max de scriere 255)
    wire [7:0] RAM_read_data;       // Datele citite din ram (pe 8 biti -> numar max de scriere 255)
    wire [7:0] reg_read_data_1;     // Datele citite din registri (pe 8 biti -> numar max de scriere 255)
    wire [7:0] reg_read_data_2;     // Datele citite din registri (pe 8 biti -> numar max de scriere 255)

    // ALU

    reg [7:0] num_a;
    reg [7:0] num_b;
    reg [2:0] ALU_instr;
    wire [7:0] ALU_res;
    wire zero;
    wire negative;
    wire ovr;

    // Fire auxiliare pentru stocare unor valori care se vor folosi pentru assign
    wire pc_en_aux;                 // Pentru semnalul de enable program counter
    wire [3:0] RAM_addr_aux;        // Pentru semnalul cu adresa de citire/scriere in RAM
    wire [1:0] reg_dest_1_aux;      // Pentru semnalul cu adresa de citire/scriere in registri
    wire [1:0] reg_dest_2_aux;      // Pentru semnalul cu adresa de citire/scriere in registri
    wire wr_en_RAM_aux;             // Pentru semnalul de enable write in RAM
    wire re_en_RAM_aux;             // Pentru semnalul de enable read din RAM
    wire wr_en_reg_aux;             // Pentru semnalul de enable write in registri
    wire re_en_reg_aux;             // Pentru semnalul de enable read din registri
    wire [7:0] reg_data_aux;        // Pentru semnalul cu date de scriere in registri
    wire [7:0] RAM_data_aux;        // Pentru semnalul cu date de scriere in RAM
    wire [3:0] new_count_aux;       // Pentru semnalul cu adresa unde se va face JUMP
    wire jump_aux;                  // Pentru semnalul de JUMP enable
    wire [7:0] ALU_val_1_aux;       // Pentru semnalul cu valoarea din registrul a pentru ALU
    wire [7:0] ALU_val_2_aux;       // Pentru semnalul cu valoarea din registrul b pentru ALU
    wire [2:0] ALU_instr_aux;       // Pentru semnalul cu instructiunea pentru ALU

    always @(*) begin
        count_en = pc_en_aux;
        re_en_RAM = re_en_RAM_aux;
        addr_RAM = RAM_addr_aux;

        addr_reg_1 = reg_dest_1_aux;
        addr_reg_2 = reg_dest_2_aux;
        data_reg = reg_data_aux;
        wr_en_reg = wr_en_reg_aux;
        re_en_reg = re_en_reg_aux;

        wr_en_RAM = wr_en_RAM_aux;
        data_RAM = RAM_data_aux;

        new_count = new_count_aux;
        jump = jump_aux;

        num_a = ALU_val_1_aux;
        num_b = ALU_val_2_aux;
        ALU_instr = ALU_instr_aux;
    end

    // Instantierea RAM-ului
    RAM ram(
        .clk(clk),
        .wr_en(wr_en_RAM),
        .read_en(re_en_RAM),
        .addr(addr_RAM),
        .data(data_RAM),
        .data_read(RAM_read_data)
    );

    // Instantierea registrilor
    registers registri(
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en_reg),
        .read_en(re_en_reg),
        .dest_1(addr_reg_1),
        .dest_2(addr_reg_2),
        .data(data_reg),
        .data_read_1(reg_read_data_1),
        .data_read_2(reg_read_data_2)
    );

    // Instantierea program counterului
    program_counter prog_c(
        .clk(clk),
        .set_count(new_count),
        .jump(jump),
        .count_en(count_en),
        .count(pc)
    );

    // Instantierea ALU
    ALU alu(
        .a(num_a),
        .b(num_b),
        .ALU_instr(ALU_instr),
        .result(ALU_res),
        .zero(zero),
        .ovr(ovr)
    );

    // Instantierea control unitului
    control_unit control(
        .clk(clk),
        .pc(pc),
        .RAM_data(RAM_read_data),
        .wr_reg_data(reg_data_aux),
        .pc_en(pc_en_aux),
        .re_en_RAM(re_en_RAM_aux),
        .wr_en_reg(wr_en_reg_aux),
        .addr_RAM(RAM_addr_aux),
        .reg_dest_1(reg_dest_1_aux),
        .reg_dest_2(reg_dest_2_aux),
        .re_en_reg(re_en_reg_aux),
        .wr_en_RAM(wr_en_RAM_aux),
        .reg_data_1(reg_read_data_1),
        .reg_data_2(reg_read_data_2),
        .wr_RAM_data(RAM_data_aux),
        .new_count(new_count_aux),
        .jump(jump_aux),
        .ALU_val_1(ALU_val_1_aux),
        .ALU_val_2(ALU_val_2_aux),
        .ALU_instr(ALU_instr_aux),
        .ALU_res(ALU_res)
    );

    initial begin
        
    end

    always @(posedge clk) begin
        
    end


endmodule