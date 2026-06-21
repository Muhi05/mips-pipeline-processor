module hazard_detection (
    input        id_ex_mem_read,
    input  [4:0] id_ex_rt, if_id_rs, if_id_rt,
    output reg   stall
);
    always @(*) begin
        if (id_ex_mem_read &&
           ((id_ex_rt==if_id_rs)||(id_ex_rt==if_id_rt)))
            stall=1;
        else stall=0;
    end
endmodule

module forwarding_unit (
    input  [4:0] ex_rs, ex_rt,
    input  [4:0] ex_mem_rd, mem_wb_rd,
    input        ex_mem_reg_write, mem_wb_reg_write,
    output reg [1:0] forward_a, forward_b
);
    always @(*) begin
        if (ex_mem_reg_write&&ex_mem_rd!=0&&ex_mem_rd==ex_rs)
            forward_a=2'b10;
        else if (mem_wb_reg_write&&mem_wb_rd!=0&&mem_wb_rd==ex_rs)
            forward_a=2'b01;
        else forward_a=2'b00;

        if (ex_mem_reg_write&&ex_mem_rd!=0&&ex_mem_rd==ex_rt)
            forward_b=2'b10;
        else if (mem_wb_reg_write&&mem_wb_rd!=0&&mem_wb_rd==ex_rt)
            forward_b=2'b01;
        else forward_b=2'b00;
    end
endmodule
