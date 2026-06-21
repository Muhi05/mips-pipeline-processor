module data_memory (
    input clk,
    input mem_read, mem_write,
    input  [31:0] address, write_data,
    output [31:0] read_data
);
    reg [31:0] mem [0:63];
    integer i;
    initial begin
        for (i=0; i<64; i=i+1) mem[i]=32'b0;
        mem[0]=32'd100; mem[1]=32'd200; mem[2]=32'd300;
    end
    always @(posedge clk) begin
        if (mem_write) mem[address[31:2]] <= write_data;
    end
    assign read_data = mem_read ? mem[address[31:2]] : 32'b0;
endmodule
