module instr_memory (
    input  [31:0] pc,
    output [31:0] instruction
);
    reg [31:0] mem [0:63];
    initial begin
        mem[0] = 32'b000000_00010_00011_00001_00000_100000;
        mem[1] = 32'b000000_00001_00010_00100_00000_100000;
        mem[2] = 32'b000000_00100_00011_00101_00000_100010;
        mem[3] = 32'b0; mem[4] = 32'b0;
    end
    assign instruction = mem[pc[31:2]];
endmodule
