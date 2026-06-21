module tb_mips_pipeline;
    reg clk, rst;
    mips_pipeline DUT (.clk(clk),.rst(rst));
    always #5 clk = ~clk;
    initial begin
        clk=0; rst=1;
        #20 rst=0;
        $display("=== MIPS Pipeline Test ===");
        repeat(20) @(posedge clk);
        $display("R1=%0d (exp 15) %s", DUT.RF.registers[1],
                  DUT.RF.registers[1]==15?"PASS":"FAIL");
        $display("R4=%0d (exp 25) %s", DUT.RF.registers[4],
                  DUT.RF.registers[4]==25?"PASS":"FAIL");
        $display("R5=%0d (exp 20) %s", DUT.RF.registers[5],
                  DUT.RF.registers[5]==20?"PASS":"FAIL");
        $finish;
    end
endmodule
