module Main_control(
    input   clk,
    input   Mov_l, Mov_r, Mov_f, Mov_b,
    input   Grab,
    input   Touch,
    input   Top,
    input   Origin,
    input   En_claw,
    input   Timeout1,
    input   Timeout2,
    input   Cnt_10,
    input   Success,
    output reg  Return,
    output reg  Down,
    output reg  Rise,
    output reg  Open,
    output reg  Tight,
    output reg  Loose,
    output reg  Release,
    output  En_T1,
    output  En_T2,
    output  Add,
    output  R_C,
    output  R_TR,
    output  Un_claw
);
    //control signal    
    reg     Un_claw;     //鎖住搖桿（使Move訊號無效）
    reg     En_T1;       //啟動timer1
    reg     En_T2;       //啟動timer2
    reg     Add;         //使counter+1
    reg     R_C;         //使counter歸零
    reg     R_TR;        //重設Timer1、Timer2、Register1、Register2

    reg[3:0]    State;
    reg[3:0]    Nextstate;


    initial
    begin
        State = 0;
    end
    


       
    always @(*) 
    begin : main_control
        case (State)
            0:
                    begin
                        En_T1 = 1'b0;
                        En_T2 = 1'b0;
                        Un_claw = 1'b0;
                        Add = 1'b0;
                        R_C = 1'b1;
                        R_TR = 1'b1;
                        Return = 1'b0;
                        Down = 1'b0;
                        Rise = 1'b0;
                        Open = 1'b0;
                        Tight = 1'b0;
                        Loose = 1'b0;
                        Release = 1'b0; 
                        if (En_claw == 1'b1)
                        begin
                            Nextstate = 1;
                        end
                        else
                        begin
                            Nextstate = 0;
                        end
                    end
            1:
                    begin
                        R_TR = 1'b0;
                        if (Mov_l || Mov_r || Mov_f || Mov_b)
                        begin
                            Nextstate = 2;
                        end
                        else
                        begin
                            Nextstate = 1;
                        end
                    end
            2:
                    begin
                        En_T1 = 1'b1;
                        if (Grab == 1'b1 || Timeout1 == 1'b1)
                        begin
                            Nextstate = 3; 
                        end 
                        else
                        begin
                            Nextstate = 2;
                        end
                    end
            3:
                    begin
                        En_T1 = 1'b0;
                        Un_claw = 1'b1;
                        Down = 1'b1;
                        Open = 1'b1;
                        if (Touch == 1'b1 && Cnt_10 == 1'b0)
                        begin
                            Nextstate = 4;
                        end
                        else if (Touch == 1'b1 && Cnt_10 == 1'b1)
                        begin
                            Nextstate = 5;
                        end
                    end
            4:
                    begin
                        Loose = 1'b1;
                        Down = 1'b0;
                        Open = 1'b0;
                        Nextstate = 6; 
                    end
            5:
                    begin
                        Tight = 1'b1;
                        Down = 1'b0;
                        Open = 1'b0; 
                        Nextstate = 7;
                    end
            6:
                    begin
                        Loose = 1'b1;
                        Rise = 1'b1;
                        if (Top == 1'b1)
                        begin
                            Nextstate = 8;
                        end
                        else
                        begin
                            Nextstate = 6; 
                        end 
                    end
            7:
                    begin
                        Tight = 1'b1;
                        Rise = 1'b1;
                        if (Top == 1'b1)
                        begin
                            Nextstate = 9;
                        end
                        else
                        begin
                            Nextstate = 7; 
                        end 
                    end
            8:
                    begin
                        Rise = 1'b0;
                        Loose = 1'b1;
                        Return = 1'b1;
                        if (Origin == 1'b1)
                        begin
                            Nextstate = 10;
                        end
                        else
                        begin
                            Nextstate = 8;
                        end 
                    end
            9:
                    begin
                        Rise = 1'b0;
                        Tight = 1'b1;
                        Return = 1'b1;
                        if (Origin == 1'b1)
                        begin
                            Nextstate = 10;
                        end
                        else
                        begin
                            Nextstate = 9;
                        end 
                    end
            10:
                    begin
                        Return = 1'b0;
                        Loose = 1'b0;
                        Tight = 1'b0;
                        Release = 1'b1;
                        En_T2 = 1'b1;
                        if (Timeout2 == 1'b1 && Cnt_10 == 1'b1)
                        begin
                            R_C = 1'b0;
                            Nextstate = 0;
                        end
                        else if (Timeout2 == 1'b1 && Cnt_10 == 1'b0 && Success == 1'b1)
                        begin
                           R_C = 1'b0;
                           Nextstate = 0; 
                        end
                        else if (Timeout2 == 1'b1 && Cnt_10 == 1'b0 && Success == 1'b0)
                        begin
                           Add = 1'b1;
                           Nextstate = 0; 
                        end
                        else
                        begin
                            Nextstate = 10;
                        end
                    end       
            default: 
                    begin
                        Nextstate = 0;
                    end
        endcase 
    end

    always @(posedge clk) 
    begin
        State <= Nextstate;
    end

    



endmodule // Claw_machine