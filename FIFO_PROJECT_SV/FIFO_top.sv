module FIFO_top(); 
 
bit clk; 
 initial begin 
    clk=0; 
    forever #1 clk=~clk; 
  end 
FIFO_if fifoif (clk); 
FIFO DUT (fifoif); 
FIFO_tb TEST (fifoif); 
FIFO_monitor MONITOR (fifoif);
endmodule
