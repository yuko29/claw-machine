`timescale 1ns/100ps
module t_Claw_Machine;
    reg   clk;
    reg   Coin;
    reg   Mov_l, Mov_r, Mov_f, Mov_b;
    reg   Grab;
    reg   Touch;
    reg   Top;
    reg   Origin;
    reg   Drop;
    wire    Claw_l, Claw_r, Claw_f, Claw_b;
    wire    Return;
    wire    Down;
    wire    Rise;
    wire    Open;
    wire    Tight;
    wire    Loose;
    wire    Release;
    integer i;
    parameter N = 11;


    initial
    begin
        $dumpfile("Claw_Machine.vcd");
        $dumpvars;
    end

    always
    begin
        #10 clk = ~clk;
    end

    initial
    begin
        clk = 1'b0;
        Coin = 1'b1;
        Grab = 1'b0;
        Drop = 1'b1;
        Mov_l = 1'b0;
        Mov_r = 1'b0;
        Mov_f = 1'b0;
        Mov_b = 1'b0;
        Touch = 1'b0;
        Top = 1'b0;
        Origin = 1'b0;
    end

    always @(posedge clk) 
    begin
        //第一次：測Register1, Grab按鈕
        #30 Coin = 1'b0;
        #20 Mov_l = 1'b0; Mov_r = 1'b0; Mov_f = 1'b0; Mov_b = 1'b1; Coin = 1;
        #20 Mov_l = 1'b0; Mov_r = 1'b1; Mov_f = 1'b0; Mov_b = 1'b0;
        #20 Grab = 1'b1; Mov_r = 1'b0;
        @(posedge Down)
        #10 Grab = 1'b0;
        #40 Touch = 1'b1;
        @(posedge clk)
        Touch = 1'b0;
        #60 Top = 1'b1;
        @(posedge clk)
        @(negedge clk)
        Top = 1'b0;
        #50 Origin = 1'b1;
        #20 Origin = 1'b0;
        #20 Mov_l = 1'b1; Mov_r = 1'b0; Mov_f = 1'b0; Mov_b = 1'b0;
        #20 Mov_l = 1'b0; Mov_r = 1'b1; Mov_f = 1'b0; Mov_b = 1'b0;
        #20 Mov_l = 1'b0; Mov_r = 1'b0; Mov_f = 1'b1; Mov_b = 1'b0;
        #20 Mov_l = 1'b0; Mov_r = 1'b0; Mov_f = 1'b0; Mov_b = 1'b1;
        //第二次：測Timer1, Timer2, Register2, counter_10
        #20 Coin = 1'b0;
        #20 Mov_l = 1'b0; Mov_r = 1'b1; Mov_f = 1'b0; Mov_b = 1'b0; Coin = 1'b1; 
        #80 Mov_l = 1'b0; Mov_r = 1'b0; Mov_f = 1'b0; Mov_b = 1'b1;
        #40 Mov_l = 1'b0; Mov_r = 1'b0; Mov_f = 1'b1; Mov_b = 1'b0;
        #20 Mov_l = 1'b1; Mov_r = 1'b0; Mov_f = 1'b0; Mov_b = 1'b0;
        @(posedge Down)
        Mov_f = 1'b0;
        #50 Touch = 1'b1;
        @(posedge clk)
        Touch = 1'b0;
        #50 Top = 1'b1;
        @(posedge clk)
        Top = 1'b0;
        #50 Origin = 1'b1;
        #20 Drop = 1'b0; Origin = 1'b0;
        #20 Drop = 1'b1;
        //第三次到第十三次：測保夾、Counter_10重置
        for (i = 1; i <= N; i = i+1) 
        begin
            #100 Coin = 1'b0;
            #20 Mov_l = 1'b0; Mov_r = 1'b1; Mov_f = 1'b0; Mov_b = 1'b0; Coin = 1;
            #20 Mov_r = 1'b0;
            #20 Grab = 1'b1;
            @(posedge Down)
            Grab = 1'b0;
            #50 Touch = 1'b1;
            @(posedge clk)
            Touch = 1'b0;
            #50 Top = 1'b1;
            @(posedge clk)
            Top = 1'b0;
            #50 Origin = 1'b1;
            #20 Origin = 1'b0;
        end
    end


    initial #5000 $finish;

    Claw_Machine    M(clk, Coin, Mov_l, Mov_r, Mov_f, Mov_b, 
                    Grab, Touch, Top, Origin, Drop, 
                    Claw_l, Claw_r, Claw_f, Claw_b, 
                    Return, Down, Rise, Open, 
                    Tight, Loose, Release);

endmodule // t_Claw_Machine