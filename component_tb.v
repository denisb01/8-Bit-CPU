`timescale 1ns/1ns
`include "CPU.v"

module component_tb;

    reg clk;
    reg rst;
        
    CPU uut(.clk(clk),.rst(rst));
    
    reg [7:0] mem [127:0];

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, component_tb);

        clk = 0;
        rst = 0;

        for(integer k=1; k < 100; k = k+1)
            #5  clk = ~clk;
    end

endmodule