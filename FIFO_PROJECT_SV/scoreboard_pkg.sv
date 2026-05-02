package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::* ;
import shared_pkg::* ;
class FIFO_scoreboard;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);
logic [FIFO_WIDTH-1:0] data_out_ref;
logic full_ref, almostfull_ref, empty_ref, almostempty_ref, overflow_ref, underflow_ref, wr_ack_ref ;
reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

//Check data
function void check_data(input FIFO_transaction fifotrans_obj_checkdata);
 reference_model(fifotrans_obj_checkdata);
 if (data_out_ref == fifotrans_obj_checkdata.data_out && full_ref == fifotrans_obj_checkdata.full && almostfull_ref == fifotrans_obj_checkdata.almostfull && empty_ref == fifotrans_obj_checkdata.empty && almostempty_ref == fifotrans_obj_checkdata.almostempty && overflow_ref == fifotrans_obj_checkdata.overflow && underflow_ref == fifotrans_obj_checkdata.underflow && wr_ack_ref == fifotrans_obj_checkdata.wr_ack ) begin
     correct_count=correct_count+1;
     $display("Correct in FIFO");
    end
 else begin
     error_count=error_count+1;
     $display("Error in FIFO");
     $display("rst_n=%0d",fifotrans_obj_checkdata.rst_n); 
     $display("data_in=%0d",fifotrans_obj_checkdata.data_in);
     $display("data_out=%0d",fifotrans_obj_checkdata.data_out); 
     $display("data_out_ref=%0d",data_out_ref); 
     $display("wr_ack=%0d",fifotrans_obj_checkdata.wr_ack); 
     $display("wr_ack_ref=%0d",wr_ack_ref);
     $display("overflow=%0d",fifotrans_obj_checkdata.overflow); 
     $display("overflow_ref=%0d",overflow_ref); 
     $display("full=%0d",fifotrans_obj_checkdata.full); 
     $display("full_ref=%0d",full_ref);
     $display("empty=%0d",fifotrans_obj_checkdata.empty); 
     $display("empty_ref=%0d",empty_ref); 
     $display("almostfull=%0d",fifotrans_obj_checkdata.almostfull); 
     $display("almostfull_ref=%0d",almostfull_ref);
     $display("almostempty=%0d",fifotrans_obj_checkdata.almostempty); 
     $display("almostempty_ref=%0d",almostempty_ref); 
     $display("underflow=%0d",fifotrans_obj_checkdata.underflow); 
     $display("underflow_ref=%0d",underflow_ref);
     $display("wr_en=%0d",fifotrans_obj_checkdata.wr_en); 
     $display("rd_en=%0d",fifotrans_obj_checkdata.rd_en); 
     $display("count=%0d",count);
 end
endfunction 

//Reference model
function void reference_model(input FIFO_transaction fifotrans_obj_refmodel);
 //Write data
     if (! fifotrans_obj_refmodel.rst_n) begin
		  wr_ptr = 0;
          wr_ack_ref = 0;
          overflow_ref = 0;
	end

	else if (fifotrans_obj_refmodel.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] = fifotrans_obj_refmodel.data_in;
	     wr_ack_ref = 1;
		wr_ptr = wr_ptr + 1;
        overflow_ref = 0;
	end

	else begin 
		wr_ack_ref = 0; 
		if (full_ref && fifotrans_obj_refmodel.wr_en)
			overflow_ref = 1;
		else
			overflow_ref = 0;
	end

 //Read data
     if (!fifotrans_obj_refmodel.rst_n) begin
		  rd_ptr = 0;
          underflow_ref = 0;
          data_out_ref = 0;
	end
    
	else if (fifotrans_obj_refmodel.rd_en && !empty_ref) begin
		data_out_ref = mem[rd_ptr];
		rd_ptr = rd_ptr + 1;
        underflow_ref = 0;
	end

     else begin
          if ( fifotrans_obj_refmodel.rd_en && empty_ref)
          underflow_ref = 1;
          else
          underflow_ref = 0;
     end
 //Handle count
     if (!fifotrans_obj_refmodel.rst_n) begin
		count = 0;
	end
	else begin
		if	( ({fifotrans_obj_refmodel.wr_en, fifotrans_obj_refmodel.rd_en} == 2'b10) && ! full_ref) 
			count = count + 1;
		else if ( ({fifotrans_obj_refmodel.wr_en, fifotrans_obj_refmodel.rd_en} == 2'b01) && ! empty_ref)
			count = count - 1;
          else if ( ({ fifotrans_obj_refmodel.wr_en,  fifotrans_obj_refmodel.rd_en} == 2'b11) && full_ref) //read ->decrement
			count = count - 1;
          else if ( ({ fifotrans_obj_refmodel.wr_en,  fifotrans_obj_refmodel.rd_en} == 2'b11) && empty_ref) //write ->increment
			count = count + 1;
	end
 //Handle flags
     full_ref = (count == FIFO_DEPTH)? 1 : 0;
     empty_ref = (count == 0)? 1 : 0; 
     almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
     almostempty_ref = (count == 1)? 1 : 0;
endfunction

endclass

endpackage
