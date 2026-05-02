 import shared_pkg::* ; 
import FIFO_transaction_pkg::* ; 
import FIFO_scoreboard_pkg::* ; 
import FIFO_coverage_pkg::* ; 
module FIFO_monitor(FIFO_if.MONITOR fifoif); 
FIFO_transaction obj_trans=new(); 
FIFO_coverage obj_cvr=new(); 
FIFO_scoreboard obj_sb=new(); 
 
initial begin 
 
forever begin 
 wait(trigger.triggered);     
  @(negedge fifoif.clk); 
obj_trans.rst_n = fifoif.rst_n; 
obj_trans.wr_en = fifoif.wr_en; 
obj_trans.rd_en = fifoif.rd_en; 
obj_trans.data_in = fifoif.data_in; 
obj_trans.overflow = fifoif.overflow; 
obj_trans.underflow = fifoif.underflow; 
obj_trans.empty = fifoif.empty; 
obj_trans.almostempty = fifoif.almostempty; 
obj_trans.full = fifoif.full; 
obj_trans.almostfull = fifoif.almostfull; 
obj_trans.data_out = fifoif.data_out; 
obj_trans.wr_ack = fifoif.wr_ack; 
 
fork 
//first  
begin 
obj_cvr.sample_data(obj_trans); 
end 
 
//second 
begin 
obj_sb.check_data(obj_trans); 
end 
join 
 
if (test_finished==1) begin 
    $display("Correct count = %d", correct_count); 
    $display("Error count = %d", error_count); 
    $stop; 
  end 
 end 
end 
endmodule