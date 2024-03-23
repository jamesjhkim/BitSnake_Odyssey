/*module ps2_keyboard(input [3:0] KEY, inout PS2_CLK, inout PS2_DAT, input [9:0] SW, input clock, output [9:0] LEDR);
	
	keyboard k0(clock, KEY[0], PS2_CLK, PS2_DAT, LEDR[0], LEDR[9:1]);
	
endmodule*/

module keyboard(
	input clk, reset, 
	inout ps2_clk, ps2_data,
	output key_out, //output indicating valid key release
	output reg [15:0] key_data,
	output reg left, up, right, down, esc, enter);
	
	reg [4:0] ps2_count; //counts number of clock cycles for a valid input
   reg [7:0] key_shift; //stores current ps2 data
   reg ps2_key_press; //valid key press
	reg ps2_key_release; //valid key release
	reg ps2_key_change; //change in key press/release
	
	//Count number of clock cycles for valid ps2 data (only last clock cycle is considered for updating key_data register)
	always@(negedge ps2_clk or negedge reset)
	begin 
		if (reset == 1'b0)
			ps2_count <= 5'd0; 
		else 
		begin
			if (ps2_count == 5'd10) //register reaches value of 9 (system has read 11 bits of ps2 data)
				ps2_count <= 5'd0; //reset 
			else 
				ps2_count <= ps2_count + 5'd1; //system is reading data
		end 
	end 
	
	//Shift register
	always@(negedge ps2_clk or negedge reset) 
	begin
		if (reset == 1'b0) 
			key_shift <= 8'b0;
		else 
		begin
			key_shift[7] <= ps2_data; //update last bit of register with current value of ps2 data
			key_shift[6:0] <= key_shift[7:1];
		end 
	end 
	
	always@(posedge ps2_clk) 
	begin 
		if(ps2_count == 5'd9) //register reaches value of 9 
			key_data <= key_shift; //update data register with current data of shift register
	end 
	
	//Detect when ps2_count reaches 9 (implement keyboard key press or release detection)
	always@(posedge ps2_clk) 
	begin
		if(ps2_count == 5'd9)
			ps2_key_press <= 1'b1;
		else 
			ps2_key_press <= 1'b0;
	end 
	
	always@(posedge ps2_key_press) 
	begin
		ps2_key_release <= ps2_key_press;
		ps2_key_change <= ps2_key_release;
	end 
	
	assign key_out = ps2_key_press & ps2_key_change; 
	
	//Left (A)
	always@(posedge ps2_key_press)
	begin
		if(ps2_count == 5'd9 && key_data == 8'h1D)
			left <= 1'b1;
		else 
			left <= 1'b0;
	end 
	
	//Up (W)
	always@(posedge ps2_key_press)
	begin
		if(ps2_count == 5'd9 && key_data == 8'h1B)
			up <= 1'b1;
		else 
			up <= 1'b0;
	end 
	
	//Right (D)
	always@(posedge ps2_key_press)
	begin
		if(ps2_count == 5'd9 && key_data == 8'h23)
			right <= 1'b1;
		else 
			right <= 1'b0;
	end 
	
	//Down (S)
	always@(posedge ps2_key_press)
	begin
		if(ps2_count == 5'd9 && key_data == 8'h1C)
			down <= 1'b1;
		else 
			down <= 1'b0;
	end 
	
	/*//Esc key 
	always@(posedge ps2_key_press)
	begin
		if(ps2_count == 5'd9 && key_data == 16'h76)
			esc <= 1'b1;
		else 
			esc <= 1'b0;
	end 
	
	//Enter key 
	always@(posedge ps2_key_press)
	begin
		if(ps2_count == 5'd9 && key_data == 16'h5A)
			enter <= 1'b1;
		else 
			enter <= 1'b0;
	end*/
	
endmodule