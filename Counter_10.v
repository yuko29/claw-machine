module Counter_10(clk, Add, Reset, Cnt_10);
    input   clk;
    input   Add;
    input   Reset;
    output  Cnt_10;

    reg[3:0]    C;

    initial
    begin
        C = 0;
    end

    assign  Cnt_10 = (C == 9) ? 1'b1 : 1'b0;

    always @(posedge clk) 
    begin
        @(negedge Add)      //negtive edge trigger Add
        C <= C + 1;
    end

    always @(posedge clk) 
    begin
        @(posedge Reset)    //positive edge trigger Reset
        C <= 0;
    end

endmodule // Counter10