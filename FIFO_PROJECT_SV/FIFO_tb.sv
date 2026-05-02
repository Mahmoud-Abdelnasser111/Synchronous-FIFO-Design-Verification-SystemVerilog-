import shared_pkg::* ;
import FIFO_transaction_pkg::* ;
import FIFO_scoreboard_pkg::* ;
import FIFO_coverage_pkg::* ;
module FIFO_tb(FIFO_if.TEST fifoif);
FIFO_transaction obj_transs ; 
initial begin
obj_transs=new();
   fifoif.rst_n=0; 
   fifoif.wr_en=0;
   fifoif.rd_en=0;
   fifoif.data_in=0;
   -> trigger;
   @(negedge fifoif.clk);
    fifoif.rst_n=1; 

repeat(10000) 
begin
  assert(obj_transs.randomize());
  fifoif.rst_n = obj_transs.rst_n;
  fifoif.data_in = obj_transs.data_in;
  fifoif.wr_en = obj_transs.wr_en;
  fifoif.rd_en = obj_transs.rd_en;
  -> trigger;
  @(negedge fifoif.clk);
 end

 test_finished=1;
-> trigger;
end 

endmodule