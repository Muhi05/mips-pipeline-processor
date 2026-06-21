module if_id_reg (
    input clk, rst, stall, flush,
    input  [31:0] if_pc, if_instr,
    output reg [31:0] id_pc, id_instr
);
    always @(posedge clk or posedge rst) begin
        if (rst||flush) begin id_pc<=0; id_instr<=0; end
        else if (!stall) begin id_pc<=if_pc; id_instr<=if_instr; end
    end
endmodule

module id_ex_reg (
    input clk, rst, flush,
    input        reg_dst_in, alu_src_in, mem_to_reg_in,
    input        reg_write_in, mem_read_in, mem_write_in,
    input [1:0]  alu_op_in,
    input [31:0] read_data1_in, read_data2_in, sign_ext_in,
    input [4:0]  rs_in, rt_in, rd_in,
    input [5:0]  funct_in,
    output reg        reg_dst_out, alu_src_out, mem_to_reg_out,
    output reg        reg_write_out, mem_read_out, mem_write_out,
    output reg [1:0]  alu_op_out,
    output reg [31:0] read_data1_out, read_data2_out, sign_ext_out,
    output reg [4:0]  rs_out, rt_out, rd_out,
    output reg [5:0]  funct_out
);
    always @(posedge clk or posedge rst) begin
        if (rst||flush) begin
            reg_dst_out<=0; alu_src_out<=0; mem_to_reg_out<=0;
            reg_write_out<=0; mem_read_out<=0; mem_write_out<=0;
            alu_op_out<=0; read_data1_out<=0; read_data2_out<=0;
            sign_ext_out<=0; rs_out<=0; rt_out<=0; rd_out<=0;
            funct_out<=0;
        end
        else begin
            reg_dst_out<=reg_dst_in; alu_src_out<=alu_src_in;
            mem_to_reg_out<=mem_to_reg_in; reg_write_out<=reg_write_in;
            mem_read_out<=mem_read_in; mem_write_out<=mem_write_in;
            alu_op_out<=alu_op_in; read_data1_out<=read_data1_in;
            read_data2_out<=read_data2_in; sign_ext_out<=sign_ext_in;
            rs_out<=rs_in; rt_out<=rt_in; rd_out<=rd_in;
            funct_out<=funct_in;
        end
    end
endmodule

module ex_mem_reg (
    input clk, rst,
    input        mem_to_reg_in, reg_write_in,
    input        mem_read_in, mem_write_in, zero_in,
    input [31:0] alu_result_in, write_data_in,
    input [4:0]  write_reg_in,
    output reg        mem_to_reg_out, reg_write_out,
    output reg        mem_read_out, mem_write_out, zero_out,
    output reg [31:0] alu_result_out, write_data_out,
    output reg [4:0]  write_reg_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_to_reg_out<=0; reg_write_out<=0; mem_read_out<=0;
            mem_write_out<=0; zero_out<=0; alu_result_out<=0;
            write_data_out<=0; write_reg_out<=0;
        end
        else begin
            mem_to_reg_out<=mem_to_reg_in; reg_write_out<=reg_write_in;
            mem_read_out<=mem_read_in; mem_write_out<=mem_write_in;
            zero_out<=zero_in; alu_result_out<=alu_result_in;
            write_data_out<=write_data_in; write_reg_out<=write_reg_in;
        end
    end
endmodule

module mem_wb_reg (
    input clk, rst,
    input        mem_to_reg_in, reg_write_in,
    input [31:0] read_data_in, alu_result_in,
    input [4:0]  write_reg_in,
    output reg        mem_to_reg_out, reg_write_out,
    output reg [31:0] read_data_out, alu_result_out,
    output reg [4:0]  write_reg_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_to_reg_out<=0; reg_write_out<=0;
            read_data_out<=0; alu_result_out<=0; write_reg_out<=0;
        end
        else begin
            mem_to_reg_out<=mem_to_reg_in; reg_write_out<=reg_write_in;
            read_data_out<=read_data_in; alu_result_out<=alu_result_in;
            write_reg_out<=write_reg_in;
        end
    end
endmodule
