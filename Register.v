module Register(Sensor, Reset, En);
    input   Sensor;
    input   Reset;
    output reg  En;

    initial 
    begin
        En = 1'b0;
    end


    always @(negedge Sensor) //negtive edge trigger sensor
    begin
        En <= 1'b1;
    end

    always @(posedge Reset) //positive edge trigger reset
    begin
        En <= 1'b0;
    end

endmodule // Register