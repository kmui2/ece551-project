module rst_synch(RST_n, clk, rst_n);

input RST_n, clk;

output logic rst_n;

logic FF1;

always_ff @(negedge clk) begin
	if (!RST_n) begin
		FF1 <= 1'b0;
		rst_n <= 0;
	end
	else begin
		FF1 <= 1'b1;
		rst_n <= FF1;
	end
end

endmodule 