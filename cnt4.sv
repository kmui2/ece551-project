module cnt4(en, rst_n, clk, cnt);

input en, rst_n, clk;

output logic [3:0] cnt;

always @(posedge clk, negedge rst_n) begin
	if (!rst_n)
		cnt <= 4'b 0;
	else if (en)
		cnt <= cnt + 1;
	else
		cnt <= cnt;
end

endmodule 