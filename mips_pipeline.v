module mips_pipeline (
    input clk, rst
);
    wire        stall;
    wire [31:0] pc, pc_plus4, pc_next, if_instr;
    wire [31:0] id_pc, id_instr;
    wire [5:0]  id_opcode, id_funct;
    wire [4:0]  id_rs, id_rt, id_rd;
    wire [31:0] id_read1, id_read2, id_signext;
    wire        id_reg_dst, id_alu_src, id_mem_to_reg;
    wire        id_reg_write, id_mem_read, id_mem_write, id_branch;
    wire [1:0]  id_alu_op;
    wire        ex_reg_dst, ex_alu_src, ex_mem_to_reg;
    wire        ex_reg_write, ex_mem_read, ex_mem_write;
    wire [1:0]  ex_alu_op;
    wire [31:0] ex_read1, ex_read2, ex_signext;
    wire [4:0]  ex_rs, ex_rt, ex_rd, ex_write_reg;
    wire [5:0]  ex_funct;
    wire [3:0]  alu_ctrl;
    wire [1:0]  fwd_a, fwd_b;
    wire [31:0] alu_a, alu_b, alu_b_mux, alu_result;
    wire        alu_zero;
    wire        mem_mem_to_reg, mem_reg_write;
    wire        mem_mem_read, mem_mem_write, mem_zero;
    wire [31:0] mem_alu_result, mem_write_data;
    wire [4:0]  mem_write_reg;
    wire        wb_mem_to_reg, wb_reg_write;
    wire [31:0] wb_read_data, wb_alu_result, wb_write_data;
    wire [4:0]  wb_write_reg;
    wire [31:0] mem_read_data;

    assign pc_plus4 = pc + 4;
    assign pc_next  = pc_plus4;

    program_counter PC (.clk(clk),.rst(rst),.stall(stall),
        .pc_next(pc_next),.pc(pc));
    instr_memory IMEM (.pc(pc),.instruction(if_instr));
    if_id_reg IF_ID (.clk(clk),.rst(rst),.stall(stall),.flush(1'b0),
        .if_pc(pc_plus4),.if_instr(if_instr),
        .id_pc(id_pc),.id_instr(id_instr));

    assign id_opcode  = id_instr[31:26];
    assign id_rs      = id_instr[25:21];
    assign id_rt      = id_instr[20:16];
    assign id_rd      = id_instr[15:11];
    assign id_funct   = id_instr[5:0];
    assign id_signext = {{16{id_instr[15]}},id_instr[15:0]};

    control_unit CTRL (.opcode(id_opcode),.reg_dst(id_reg_dst),
        .alu_src(id_alu_src),.mem_to_reg(id_mem_to_reg),
        .reg_write(id_reg_write),.mem_read(id_mem_read),
        .mem_write(id_mem_write),.branch(id_branch),.alu_op(id_alu_op));
    reg_file RF (.clk(clk),.rst(rst),.reg_write(wb_reg_write),
        .read_reg1(id_rs),.read_reg2(id_rt),
        .write_reg(wb_write_reg),.write_data(wb_write_data),
        .read_data1(id_read1),.read_data2(id_read2));
    hazard_detection HDU (.id_ex_mem_read(ex_mem_read),
        .id_ex_rt(ex_rt),.if_id_rs(id_rs),.if_id_rt(id_rt),.stall(stall));
    id_ex_reg ID_EX (.clk(clk),.rst(rst),.flush(stall),
        .reg_dst_in(id_reg_dst),.alu_src_in(id_alu_src),
        .mem_to_reg_in(id_mem_to_reg),.reg_write_in(id_reg_write),
        .mem_read_in(id_mem_read),.mem_write_in(id_mem_write),
        .alu_op_in(id_alu_op),.read_data1_in(id_read1),
        .read_data2_in(id_read2),.sign_ext_in(id_signext),
        .rs_in(id_rs),.rt_in(id_rt),.rd_in(id_rd),.funct_in(id_funct),
        .reg_dst_out(ex_reg_dst),.alu_src_out(ex_alu_src),
        .mem_to_reg_out(ex_mem_to_reg),.reg_write_out(ex_reg_write),
        .mem_read_out(ex_mem_read),.mem_write_out(ex_mem_write),
        .alu_op_out(ex_alu_op),.read_data1_out(ex_read1),
        .read_data2_out(ex_read2),.sign_ext_out(ex_signext),
        .rs_out(ex_rs),.rt_out(ex_rt),.rd_out(ex_rd),.funct_out(ex_funct));

    assign ex_write_reg = ex_reg_dst ? ex_rd : ex_rt;
    forwarding_unit FWD (.ex_rs(ex_rs),.ex_rt(ex_rt),
        .ex_mem_rd(mem_write_reg),.mem_wb_rd(wb_write_reg),
        .ex_mem_reg_write(mem_reg_write),.mem_wb_reg_write(wb_reg_write),
        .forward_a(fwd_a),.forward_b(fwd_b));

    assign alu_a = (fwd_a==2'b10)?mem_alu_result:
                   (fwd_a==2'b01)?wb_write_data:ex_read1;
    assign alu_b_mux = (fwd_b==2'b10)?mem_alu_result:
                       (fwd_b==2'b01)?wb_write_data:ex_read2;
    assign alu_b = ex_alu_src ? ex_signext : alu_b_mux;

    alu_control ALUCTRL (.alu_op(ex_alu_op),.funct(ex_funct),
        .alu_ctrl(alu_ctrl));
    alu ALU (.a(alu_a),.b(alu_b),.alu_ctrl(alu_ctrl),
        .result(alu_result),.zero(alu_zero));

    ex_mem_reg EX_MEM (.clk(clk),.rst(rst),
        .mem_to_reg_in(ex_mem_to_reg),.reg_write_in(ex_reg_write),
        .mem_read_in(ex_mem_read),.mem_write_in(ex_mem_write),
        .zero_in(alu_zero),.alu_result_in(alu_result),
        .write_data_in(alu_b_mux),.write_reg_in(ex_write_reg),
        .mem_to_reg_out(mem_mem_to_reg),.reg_write_out(mem_reg_write),
        .mem_read_out(mem_mem_read),.mem_write_out(mem_mem_write),
        .zero_out(mem_zero),.alu_result_out(mem_alu_result),
        .write_data_out(mem_write_data),.write_reg_out(mem_write_reg));

    data_memory DMEM (.clk(clk),.mem_read(mem_mem_read),
        .mem_write(mem_mem_write),.address(mem_alu_result),
        .write_data(mem_write_data),.read_data(mem_read_data));

    mem_wb_reg MEM_WB (.clk(clk),.rst(rst),
        .mem_to_reg_in(mem_mem_to_reg),.reg_write_in(mem_reg_write),
        .read_data_in(mem_read_data),.alu_result_in(mem_alu_result),
        .write_reg_in(mem_write_reg),.mem_to_reg_out(wb_mem_to_reg),
        .reg_write_out(wb_reg_write),.read_data_out(wb_read_data),
        .alu_result_out(wb_alu_result),.write_reg_out(wb_write_reg));

    assign wb_write_data = wb_mem_to_reg ? wb_read_data : wb_alu_result;
endmodule
