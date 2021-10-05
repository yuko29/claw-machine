module Claw_Machine(
    input   clk,
    input   Coin,
    input   Mov_l, Mov_r, Mov_f, Mov_b,
    input   Grab,
    input   Touch,
    input   Top,
    input   Origin,
    input   Drop,
    output  Claw_l, Claw_r, Claw_f, Claw_b,
    output   Return,
    output   Down,
    output   Rise,
    output   Open,
    output   Tight,
    output   Loose,
    output   Release
);

    wire   En_claw;     //允許操控搖桿（使Move訊號有效）
    wire   Timeout1;    //當timer1超過10clock
    wire   Timeout2;    //timer超過2clock
    wire   Cnt_10;      //當counter數到10
    wire   Success; 
    wire    En_T1;
    wire    En_T2;
    wire    Add;
    wire    R_C;
    wire    R_TR;
    wire    Un_claw;

    assign Claw_l = (En_claw & ~Un_claw) ? Mov_l : 1'b0;
    assign Claw_r = (En_claw & ~Un_claw) ? Mov_r : 1'b0;
    assign Claw_f = (En_claw & ~Un_claw) ? Mov_f : 1'b0;
    assign Claw_b = (En_claw & ~Un_claw) ? Mov_b : 1'b0;


    Main_control    Main_control(.clk(clk), .Mov_l(Mov_l), .Mov_r(Mov_r), .Mov_f(Mov_f), .Mov_b(Mov_b), 
                                .Grab(Grab), .Touch(Touch), .Top(Top), .Origin(Origin),
                                .En_claw(En_claw), .Timeout1(Timeout1), .Timeout2(Timeout2), .Cnt_10(Cnt_10), .Success(Success),  
                                .Return(Return), .Down(Down), .Rise(Rise), .Open(Open), 
                                .Tight(Tight), .Loose(Loose), .Release(Release), .En_T1(En_T1), .En_T2(En_T2), .Add(Add), .R_C(R_C), .R_TR(R_TR),
                                .Un_claw(Un_claw));
                                
    Timer_1     T1(clk, En_T1, R_TR, Timeout1);
    Timer_2     T2(clk, En_T2, R_TR, Timeout2);
    Register    R1(.Sensor(Coin), .Reset(R_TR), .En(En_claw));
    Register    R2(.Sensor(Drop), .Reset(R_TR), .En(Success));
    Counter_10  C(clk, Add, R_C, Cnt_10);
endmodule