package FIFO_transaction_pkg; 
parameter FIFO_WIDTH =16; 
parameter FIFO_DEPTH =8; 
class FIFO_transaction; 
rand logic wr_en, rd_en, rst_n; 
rand logic [FIFO_WIDTH-1:0] data_in; 
logic [FIFO_WIDTH-1:0] data_out; 
logic wr_ack, overflow; 
logic full, empty, almostfull, almostempty, underflow; 
int RD_EN_ON_DIST; 
int WR_EN_ON_DIST; 
constraint rst_n_dist { rst_n dist {1:=95, 0:=5};} 
constraint wr_en_dist { wr_en dist {1:=WR_EN_ON_DIST, 0:=(100-WR_EN_ON_DIST)};} 
constraint rd_en_dist { rd_en dist {1:=RD_EN_ON_DIST, 0:=(100-RD_EN_ON_DIST)};} 
 
function new(int RD_EN_ON_DIST=30, int WR_EN_ON_DIST = 70); 
this.RD_EN_ON_DIST= RD_EN_ON_DIST; 
this.WR_EN_ON_DIST= WR_EN_ON_DIST; 
endfunction 
endclass 
endpackage 