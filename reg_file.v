module reg_file (
    input clk, rst,
    input        reg_write,
    input  [4:0] read_reg1, read_reg2, write_reg,
    input  [31:0] write_data,
    output [31:0] read_data1, read_data2
);
    reg [31:0] registers [0:31];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
        registers[2] = 32'd10;
        registers[3] = 32'd5;
    end
    always @(posedge clk) begin
        if (reg_write && write_reg != 0)
            registers[write_reg] <= write_data;
    end
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
endmodule
