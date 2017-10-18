module ESC_interface(clk, rst_n, SPEED, OFF, PWM);

input clk, rst_n;
input[10:0] SPEED;
input[9:0] OFF;

output logic PWM;

wire[11:0] compensated_speed;
wire[16:0] setting;
wire Rst, Set;

logic[19:0] cnt;

// determine Rst (reset) and Set for PWM motor speed signal
// Set is asserted when count becomes max (all ones) else Rst
assign compensated_speed = SPEED + OFF;
assign setting =  16'd50000 + (compensated_speed << 4);
assign Rst = cnt[16:0] >= setting;
assign Set = &cnt;

// keep counting (incrementing cnt) for each clk cycle
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n)
		cnt <= 0;
	else
		cnt <= cnt + 1;
end

// set and reset PWM based on conditions set above
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n)
		PWM <= 1'b0;
	else if (Set)
		PWM <= 1'b1;
	else if (Rst)
		PWM <= 1'b0;
end 

endmodule 