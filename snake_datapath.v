module snake_datapath(clk, reset, key_out, key_data, snake_x_count, snake_y_count, snake_x_out, snake_y_out, fruit_en, spider_en, size);
	//clk_9kHz
	input clk, reset, key_out, fruit_en, spider_en;
	input [15:0] key_data;
	input [11:0] snake_x_count, snake_y_count;
	output [11:0] snake_x_out, snake_y_out;
	output [3:0] size;

	wire clk, reset, key_out, eat;
	//wire [7:0] key_data;
	wire [11:0] snake_x_count, snake_y_count;
	//wire [7:0] key_data;
	reg [11:0] snake_head_x, snake_head_y;
	reg [11:0] x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14;
	reg [11:0] y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14;
	//reg [11:0] snake_x_out, snake_y_out;
	reg [3:0] size;
	reg [11:0] snake_x_out, snake_y_out;
	
	reg speed;
	reg [12:0] speed_count;
	reg [7:0] pre_data;
	
	parameter left = 8'h1D;
	parameter up = 8'h1B;
	parameter right = 8'h23;
	parameter down = 8'h1C;
	//parameter esc = 8'h76;
	//parameter enter = 8'h5A;
	 
	//add food datapath function for eat
	always@(negedge clk) 
	begin
		if (reset == 1'b0)
		begin
			size <= 4'd4;
		end 
		else 
		begin 
		//eat enable
			if (fruit_en == 1'b1)
				size <= size + 4'd1;
			else
				size <= size;
		end
	end
	
		//collides with spider
	/*always@(posedge clk)
	begin
		if (reset == 1'b0)
		begin
			snake_x_out <= 12'd2;
			snake_y_out <= 12'd238;
		end
		else 
		begin
			if (spider_en == 1'b1)
			begin
				snake_x_out <= 12'd500;
				snake_y_out <= 12'd500;
			end
		end
	end*/

	always@(posedge clk) 
	begin
		if (reset == 1'b0) 
			snake_head_y <= 12'd150;
		else if (snake_y_count - y1 >= 12'd0 && snake_y_count - y1 <= 12'd200)
			snake_head_y <= snake_y_count - y1;
		else
			snake_head_y <= 12'd150;
	end
	
	always@(posedge clk) 
	begin
		if (reset == 1'b0) 
			snake_head_x <= 12'd2;
		else if (snake_x_count - x1 >= 12'd0 && snake_x_count - x1 <= 12'd200)
			snake_head_x <= snake_x_count - x1;
		else
			snake_head_x <= 12'd2;
	end
	
	//initialize reg [6:0] x1, x2, x3, x4, x5, x6, x7;
	//initialize reg [6:0] y1, y2, y3, y4, y5, y6, y7;

	initial
	begin
	//initial position
		x1 <= 12'd2;
		y1 <= 12'd150;
		x2 <= 12'd3;
		y2 <= 12'd150;
		x3 <= 12'd4;
		y3 <= 12'd150;
		x4 <= 12'd5;
		y4 <= 12'd150;
		x5 <= 12'd500;
		y5 <= 12'd500;
		x6 <= 12'd500;
		y6 <= 12'd500;
		x7 <= 12'd500;
		y7 <= 12'd500;
		x8 <= 12'd500;
		y8 <= 12'd500;
		x9 <= 12'd500;
		y9 <= 12'd500;
		x10 <= 12'd500;
		y10 <= 12'd500;
		x11 <= 12'd500;
		y11 <= 12'd500;
		x12 <= 12'd500;
		y12 <= 12'd500;
		x13 <= 12'd500;
		y13 <= 12'd500;
		x14 <= 12'd500;
		y14 <= 12'd500;
	end
	
	always@(posedge clk or negedge reset) //9khzclk_9kHz
	begin
		if (reset == 1'b0)
			speed_count <= 13'd0;
		else 
		begin
			if (speed_count > 13'd4531)
			begin
				speed_count <= 13'd0;
				speed <= 1'b1;
			end
			else 
			begin
				speed_count <= speed_count + 13'd1;
				speed <= 1'b0;
			end
		end
	end
	
	always@(posedge clk or negedge reset)
	begin
		if (reset == 1'b0)
			pre_data <= right;
		else 
		begin
			if (key_out == 1'b1)
				pre_data <= key_data;
			else
				pre_data <= pre_data;
		end
	end 
	
	always@(posedge clk)//9kHz
	begin 
		if(reset == 1'b0)
		begin
			x1 <= 12'd2;
		end 
		else 
		begin
			if (key_out == 1'b1)
			begin
				if (key_data == right)
					x1 <= x1 + 12'd1;
				else if (key_data == left)
					x1 <= x1 - 12'd1;
				else if (key_data == up)
					y1 <= y1 + 12'd1;
				else if (key_data == down)
					y1 <= y1 - 12'd1;
			end
			
			else if (key_out == 1'b0 && speed == 1'b1)
			begin
				if (pre_data == right)
					x1 <= x1 + 12'd1;
				else if (pre_data == left)
					x1 <= x1 - 12'd1;
				else if (pre_data == up)
					y1 <= y1 + 12'd1;
				else if (pre_data == down)
					y1 <= y1 - 12'd1;
			end
		end
	end
	
	//12'd500 signals game over --> add to the fsm
	always@(posedge clk or negedge reset)
	begin
		if (reset == 1'b0)
		begin 
			snake_x_out <= 12'd2;
			snake_y_out <= 12'd150;
		end
		//hits wall
		//x = 0 or x = 319
		//y = 0 or y = 239
		/*else if ((snake_x_out <= 12'd0 && snake_y_out <= 12'd0) || (snake_x_out <= 12'd0 && snake_y_out >= 12'd239) || 
			(snake_x_out >= 12'd319 && snake_y_out >= 12'd0) || (snake_x_out >= 12'd319 && snake_y_out >= 12'd239))
		begin
			snake_x_out <= 12'd500;
			snake_y_out <= 12'd500;
			//lose game
		//snake head collides with body
		end 
		//collides with spider
		else if (spider_en == 1'b1)
			begin
				snake_x_out <= 12'd500;
				snake_y_out <= 12'd500;
				//reset == 1'b0;
			end
		else if ((x1 == x2 && y1 == y2) || (x1 == x3 && y1 == y3) || (x1 == x4 && y1 == y4) || (x1 == x5 && y1 == y5) || (x1 == x6 && y1 == y6) || 
			(x1 == x7) && (y1 == y7) || (x1 == x8) && (y1 == y8) || (x1 == x9) && (y1 == y9) || (x1 == x10) && (y1 == y10) || (x1 == x11) && (y1 == y11) || 
			(x1 == x12) && (y1 == y12) || (x1 == x13) && (y1 == y13) || (x1 == x14) && (y1 == y14))
		begin
			snake_x_out <= 12'd500;
			snake_y_out <= 12'd500;
			//lose game
		end*/
		else 
		begin
			snake_x_out <= x1;
			snake_y_out <= y1;
		end
	end
	
	always@(posedge clk)
	begin
		if(x1 != snake_x_out || y1 != snake_y_out)
		begin
			if (size >= 4'd14)
			begin
				x14 <= x13;
				y14 <= y13;
				x13 <= x12;
				y13 <= y12;
				x12 <= x11;
				y12 <= y11;
				x11 <= x10;
				y11 <= y10;
				x10 <= x9;
				y10 <= y9;
				x9 <= x8;
				y9 <= y8;
				x8 <= x7;
				y8 <= y7;
				x7 <= x6;
				y7 <= y6;
				x6 <= x5;
				y6 <= y5;
			end
			else if (size >= 4'd13)
			begin
				x13 <= x12;
				y13 <= y12;
				x12 <= x11;
				y12 <= y11;
				x11 <= x10;
				y11 <= y10;
				x10 <= x9;
				y10 <= y9;
				x9 <= x8;
				y9 <= y8;
				x8 <= x7;
				y8 <= y7;
				x7 <= x6;
				y7 <= y6;
				x6 <= x5;
				y6 <= y5;
			end
			else if (size >= 4'd12)
			begin
				x12 <= x11;
				y12 <= y11;
				x11 <= x10;
				y11 <= y10;
				x10 <= x9;
				y10 <= y9;
				x9 <= x8;
				y9 <= y8;
				x8 <= x7;
				y8 <= y7;
				x7 <= x6;
				y7 <= y6;
				x6 <= x5;
				y6 <= y5;
			end
			else if (size >= 4'd11)
			begin
				x11 <= x10;
				y11 <= y10;
				x10 <= x9;
				y10 <= y9;
				x9 <= x8;
				y9 <= y8;
				x8 <= x7;
				y8 <= y7;
				x7 <= x6;
				y7 <= y6;
				x6 <= x5;
				y6 <= y5;
			end
			else if (size >= 4'd10)
			begin
				x10 <= x9;
				y10 <= y9;
				x9 <= x8;
				y9 <= y8;
				x8 <= x7;
				y8 <= y7;
				x7 <= x6;
				y7 <= y6;
				x6 <= x5;
				y6 <= y5;
			end
			else if (size >= 4'd9)
			begin
				x9 <= x8;
				y9 <= y8;
				x8 <= x7;
				y8 <= y7;
				x7 <= x6;
				y7 <= y6;
				x6 <= x5;
				y6 <= y5;
			end
			else if (size >= 4'd8)
			begin
				x8 <= x7;
				y8 <= y7;
				x7 <= x6;
				y7 <= y6;
				x6 <= x5;
				y6 <= y5;
			end
			else if (size >= 4'd7)
			begin
				x7 <= x6;
				y7 <= y6;
				x6 <= x5;
				y6 <= y5;
			end
			else if (size >= 4'd6)
			begin
				x6 <= x5;
				y6 <= y5;
				x5 <= x4;
				y5 <= y4;
			end
			else if (size >= 4'd5)
			begin
				x5 <= x4;
				y5 <= y4;
			end
			else 
			begin
				x14 <= x14;
				y14 <= y14;
				x13 <= x13;
				y13 <= y13;
				x12 <= x12;
				y12 <= y12;
				x11 <= x11;
				y11 <= y11;
				x10 <= x10;
				y10 <= y10;
				x9 <= x9;
				y9 <= y9;
				x8 <= x8;
				y8 <= y8;
				x7 <= x7;
				y7 <= y7;
				x6 <= x6;
				y6 <= y6;
				x5 <= x5;
				y5 <= y5;
			end
		end
	end
	
	always@(posedge clk or negedge reset) //or negedge reset
	begin
		if (reset == 1'b0)
		begin
			x2 <= 12'd2;
			x3 <= 12'd3;
			x4 <= 12'd4;
			
			y2 <= 12'd150;
			y3 <= 12'd150;
			y4 <= 12'd150;
		end
		else if (x1 != snake_x_out || y1 != snake_y_out)
		begin
			x2 <= snake_x_out;
			x3 <= x2;
			x4 <= x3;
			y2 <= snake_y_out;
			y3 <= y2;
			y4 <= y3;
		end
	end
 
endmodule

