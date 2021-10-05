module Timer_1(clk, En_T1, R_TR, Timeout1);
    input   clk;
    input   En_T1;
    input   R_TR;
    output  Timeout1;

    reg[3:0]    counter;

    assign Timeout1 = (counter == 10) ? 1'b1 : 1'b0;
    
    always @(clk or En_T1) 
    begin
        if (En_T1 == 1'b1)
        begin
            @(posedge clk)
            counter <= counter + 1;
        end
    end

    always @(posedge R_TR)      //positive edge trigger reset
    begin
        counter <= 4'b0000;
    end


endmodule // Timer1