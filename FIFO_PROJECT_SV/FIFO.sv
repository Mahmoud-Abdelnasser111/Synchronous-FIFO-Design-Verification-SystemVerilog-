module FIFO(FIFO_if.DUT fifoif);

localparam max_fifo_addr = $clog2(fifoif.FIFO_DEPTH); 

reg [fifoif.FIFO_WIDTH-1:0] mem [fifoif.FIFO_DEPTH-1:0];  

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr; 
reg [max_fifo_addr:0] count;

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin

	if (! fifoif.rst_n) begin
		wr_ptr <= 0;
		fifoif.wr_ack <=0; //missing after reset 
		fifoif.overflow <= 0; //missing after reset 
	end
	else if (fifoif.wr_en && count < fifoif.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifoif.data_in;
		fifoif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		fifoif.overflow <= 0;
	end
	else begin 
		fifoif.wr_ack <= 0; 
		if (fifoif.full & fifoif.wr_en)
			fifoif.overflow <= 1;
		else
			fifoif.overflow <= 0;
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (! fifoif.rst_n) begin
		rd_ptr <= 0;
	    fifoif.data_out <= 0;   //missing after reset 
		fifoif.underflow <= 0;  //missing after reset 
	end
	else if (fifoif.rd_en && count != 0) begin
		fifoif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		fifoif.underflow <= 0;
	end
	else begin
	if (fifoif.empty & fifoif.rd_en)            
			fifoif.underflow <= 1;
		else
			fifoif.underflow <= 0;
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b10) && ! fifoif.full) 
			count <= count + 1;
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && ! fifoif.empty)
			count <= count - 1;
		else if ( ({ fifoif.wr_en,  fifoif.rd_en} == 2'b11) && fifoif.full) //missing cade
			count <= count - 1;
        else if ( ({ fifoif.wr_en,  fifoif.rd_en} == 2'b11) && count==0) //missing case 
			count <= count + 1;
	end
end

assign fifoif.full = (count == fifoif.FIFO_DEPTH)? 1 : 0;
assign fifoif.empty = (count == 0)? 1 : 0;
assign fifoif.almostempty = (count == 1)? 1 : 0;
//assign fifoif.underflow = (fifoif.empty && fifoif.rd_en)? 1 : 0;     // its mentioned in pdf its a sequential
assign fifoif.almostfull = (count == fifoif.FIFO_DEPTH-1)? 1 : 0;     // bug in -2



//assertions
`ifdef SIM

// RESET CHECK 
always_comb begin
	if(!fifoif.rst_n) begin
		reset_state_ap: assert final(
			count == 0 &&
			rd_ptr == 0 &&
			wr_ptr == 0 &&
			fifoif.data_out == 0 &&
			fifoif.underflow == 0 &&
			fifoif.overflow == 0 &&
			fifoif.wr_ack == 0
		);

		reset_state_cp: cover final(
			count == 0 &&
			rd_ptr == 0 &&
			wr_ptr == 0 &&
			fifoif.data_out == 0 &&
			fifoif.underflow == 0 &&
			fifoif.overflow == 0 &&
			fifoif.wr_ack == 0
		);
	end
end


//  FLAG CHECKS
always_comb begin
	if(count == fifoif.FIFO_DEPTH) begin
		full_flag_ap: assert final(fifoif.full == 1);
		full_flag_cp: cover final(fifoif.full == 1);
	end
end

always_comb begin
	if(count == 0) begin
		empty_flag_ap: assert final(fifoif.empty == 1);
		empty_flag_cp: cover final(fifoif.empty == 1);
	end
end

always_comb begin
	if(count == fifoif.FIFO_DEPTH-1) begin
		almost_full_flag_ap: assert final(fifoif.almostfull == 1);
		almost_full_flag_cp: cover final(fifoif.almostfull == 1);
	end
end

always_comb begin
	if(count == 1) begin
		almost_empty_flag_ap: assert final(fifoif.almostempty == 1);
		almost_empty_flag_cp: cover final(fifoif.almostempty == 1);
	end
end


//  PROPERTIES 

// Overflow behavior
property overflow_behavior_p;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n)
	(fifoif.full && fifoif.wr_en) |=> (fifoif.overflow == 1);
endproperty

// Underflow behavior
property underflow_behavior_p;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n)
	(fifoif.empty && fifoif.rd_en) |=> (fifoif.underflow == 1);
endproperty

// Write acknowledge behavior
property write_ack_behavior_p;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n)
	(count < fifoif.FIFO_DEPTH && fifoif.wr_en) |=> (fifoif.wr_ack == 1);
endproperty

// Pointer boundary check
property pointer_limit_p;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n)
	(count <= fifoif.FIFO_DEPTH &&
	 wr_ptr <= fifoif.FIFO_DEPTH &&
	 rd_ptr <= fifoif.FIFO_DEPTH);
endproperty


// ASSERT 
overflow_behavior_ap: assert property (overflow_behavior_p);
underflow_behavior_ap: assert property (underflow_behavior_p);
write_ack_behavior_ap: assert property (write_ack_behavior_p);
pointer_limit_ap: assert property (pointer_limit_p);


// COVER 
overflow_behavior_cp: cover property (overflow_behavior_p);
underflow_behavior_cp: cover property (underflow_behavior_p);
write_ack_behavior_cp: cover property (write_ack_behavior_p);
pointer_limit_cp: cover property (pointer_limit_p);

`endif
endmodule