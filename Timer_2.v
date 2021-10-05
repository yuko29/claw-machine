module Timer_2(clk, En_T2, R_TR, Timeout2);
    input   clk;
    input   En_T2;
    input   R_TR;
    output  Timeout2;

    reg[1:0]    counter;

    assign Timeout2 = (counter == 2) ? 1'b1 : 1'b0;
    
    always @(clk or En_T2) 
    begin
        if (En_T2 == 1'b1)
        begin
            @(posedge clk)
            counter <= counter + 1;
        end
    end

    always @(posedge R_TR)       //positive edge trigger reset
    begin
        counter <= 2'b00;
    end


endmodule // Timer2