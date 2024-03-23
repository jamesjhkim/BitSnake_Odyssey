module spider_datapath(clk, reset, snake_x, snake_y, spider_en, spider_x_1, spider_y_1, spider_x_2, 
	spider_y_2, spider_x_3, spider_y_3, spider_x_4, spider_y_4, spider_x_5, spider_y_5
	);

	input clk, reset;
	input [11:0] snake_x, snake_y;

	//output [11:0] snake_x_reset, snake_y_reset;
	output spider_en;

	reg spider_en;
	//reg [11:0] snake_x_reset, snake_y_reset;
	output reg [11:0] spider_x_1, spider_y_1, spider_x_2, spider_y_2, spider_x_3, spider_y_3, 
		spider_x_4, spider_y_4, spider_x_5, spider_y_5;
		
	//reg [11:0] rand_x, rand_y;

	/*initial 
	begin
		spider_x <= 12'd700;
		spider_y <= 12'd700;
	end*/

	/*always@(posedge clk)
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

	always@(posedge clk)
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
	end*/

	always@(posedge clk) begin
		if (reset == 1'b0) 
		begin
			spider_x_1 <= 12'd700;
			spider_y_1 <= 12'd700;
			spider_x_2 <= 12'd700;
			spider_y_2 <= 12'd700;
			spider_x_3 <= 12'd700;
			spider_y_3 <= 12'd700;
			spider_x_4 <= 12'd700;
			spider_y_4 <= 12'd700;
			spider_x_5 <= 12'd700;
			spider_y_5 <= 12'd700;
		end
		else 
		begin
			spider_x_1 <= 12'd120;
			spider_y_1 <= 12'd220;
			spider_x_2 <= 12'd50;
			spider_y_2 <= 12'd80;
			spider_x_3 <= 12'd5;
			spider_y_3 <= 12'd32;
			spider_x_4 <= 12'd100;
			spider_y_4 <= 12'd15;
			spider_x_5 <= 12'd200;
			spider_y_5 <= 12'd47;
		end
	end 
	
	//120, 220
	//50, 80
	//5, 32
	//100, 15
	//200, 47
	
	always@(posedge clk)
	begin
		if ((snake_x == spider_x_1 && snake_y == spider_y_1) || (snake_x == spider_x_2 && snake_y == spider_y_2) ||
		(snake_x == spider_x_3 && snake_y == spider_y_3) || (snake_x == spider_x_4 && snake_y == spider_y_4) || 
		(snake_x == spider_x_5 && snake_y == spider_y_5))
		begin
			spider_en <= 1'b1;
		end
		else
		begin
			spider_en <= 1'b0;
		end
	end

endmodule