module fruit_datapath(clk, reset, snake_x, snake_y, food_x, food_y, fruit_en); //food_x_count, food_y_count
	//clk_9kHz
	input clk, reset;
	//input [11:0] food_x_count, food_y_count;
	input [11:0] snake_x, snake_y;

	//output [11:0] food_x, food_y;
	output fruit_en;
	output reg [11:0] food_x, food_y;

	reg fruit_en;
	reg [11:0] dist_snake_x, dist_snake_y;
	reg [11:0] rand_x, rand_y;
	
	always@(posedge clk)//9kHz
	begin
		if (reset == 1'b0)
			rand_x <= 12'd140;
		else
		begin
			if (rand_x >= 12'd900)
			rand_x <= 12'd140;
			else 
			rand_x <= rand_x + 12'd32;
		end
	end

	always@(posedge clk)//9kHz
	begin
		if (reset == 1'b0)
			rand_y <= 12'd140;
		else
		begin
			if (rand_y >= 12'd850)
			rand_y <= 12'd140;
			else 
			rand_y <= rand_y + 12'd64;
		end
	end

	always@(posedge clk) begin
		if (reset == 1'b0) 
		begin
			food_x <= 12'd600;
			food_y <= 12'd600;
		end
		else 
		begin
			food_x <= rand_x;
			food_y <= rand_y;
		end
	//end 

	//always@(posedge clk)
	//begin
		if (snake_x == food_x && snake_y == food_y)
		begin
			fruit_en <= 1'b1;
			food_x <= rand_x;
			food_y <= rand_y;	
		end
		else
		begin
			fruit_en <= 1'b0;
			//food_x <= rand_x;
			//food_y <= rand_y;
		end
	end
	
endmodule