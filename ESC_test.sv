module ESC_test(clk,RST_n,inc,sel_speed,OFF,SPEED,PWM);

	input clk;		// our 50MHz clock from DE0-Nano
	input RST_n;	// from push button, goes to our rst_synch block
	input inc;		// from push button, goes to our PB_release detector
	input sel_speed;		// from slide switch, selects between speed and offset

	output [9:0] OFF;		// offset term to ESC_interface
	output [10:0] SPEED;	// speed term to ESC_interface
	output PWM;				// goes to speed control of ESC

	////////////////////////////////////////
	// Declare any internal signals here //
	//////////////////////////////////////
	wire rst_n;		// global reset to all other blocks, produced by rst_synch
	wire released;	// from PB_release unit, goes high 1 clock with button release

	/////////////////////////////////////
	// Instantiate reset synchronizer //
	///////////////////////////////////
	rst_synch iRST(.RST_n(RST_n), .clk(clk), .rst_n(rst_n));

	///////////////////////////////////////////////
	// Instantiate push button release detector //
	/////////////////////////////////////////////
	PB_release iPB(.clk(clk), .rst_n(rst_n), .PB(inc), .released(released));

	///////////////////////////////////////////////////////////
	// Instantiate your two 4-bit counter here and also     //
	// hook up their enable inputs.  You may have to infer //
	// some internal signals to make the enable logic     //
	///////////////////////////////////////////////////////
	
	assign en1 = released & !sel_speed;
	assign en2 = released & sel_speed;
	
	cnt4 count1(.clk(clk), .rst_n(rst_n), .en(en1), .cnt(OFF[8:5]));
	cnt4 count2(.clk(clk), .rst_n(rst_n), .en(en2), .cnt(SPEED[10:7]));

    ///////////////////////////////////////////////////////////////////////////
	// Use assigns to create OFF and SPEED from output of your two counters //
	/////////////////////////////////////////////////////////////////////////
	assign OFF = {1'b0,OFF[8:5], 5'h00};
	assign SPEED = {SPEED[10:7], 7'b0};
	
	///////////////////////////////////////////////////
	// Instantiate ESC_interface (which is the DUT) //
	/////////////////////////////////////////////////
	ESC_interface iDUT(.clk(clk), .rst_n(rst_n), .OFF(OFF), .SPEED(SPEED), .PWM(PWM));

endmodule

