package FIFO_coverage_pkg; 
import FIFO_transaction_pkg::* ; 
class FIFO_coverage; 
FIFO_transaction F_cvg_txn = new(); 
 
covergroup FIFOcg ; 
 
 wr_en_cp: coverpoint F_cvg_txn.wr_en;   
 rd_en_cp: coverpoint F_cvg_txn.rd_en; 
 full_cp: coverpoint F_cvg_txn.full; 
 almostfull_cp: coverpoint F_cvg_txn.almostfull; 
 empty_cp: coverpoint F_cvg_txn.empty; 
 almostempty_cp: coverpoint F_cvg_txn.almostempty; 
 overflow_cp: coverpoint F_cvg_txn.overflow; 
 underflow_cp: coverpoint F_cvg_txn.underflow; 
 wr_ack_cp: coverpoint F_cvg_txn.wr_ack; 
 
//ignored when rd_en =1 with full not important 
full_cross: cross wr_en_cp, rd_en_cp, full_cp{ 
    ignore_bins rd_full = binsof(rd_en_cp)intersect{1} && 
binsof(full_cp)intersect{1}  
;} 
almostfull_cross: cross wr_en_cp, rd_en_cp, almostfull_cp; 
empty_cross: cross wr_en_cp, rd_en_cp, empty_cp; 
almostempty_cross: cross wr_en_cp, rd_en_cp, almostempty_cp; 
 
//ignored when wr_en =0 and overflow =1 not important 
overflow_cross: cross wr_en_cp, rd_en_cp, overflow_cp{ 
    ignore_bins not_wr_overflow = binsof(wr_en_cp)intersect{0} && 
binsof(overflow_cp)intersect{1} 
;} 
 
//ignored when rd_en =0 and underflow =1 not important 
underflow_cross: cross wr_en_cp, rd_en_cp, underflow_cp{ 
    ignore_bins not_rd_overflow = binsof(rd_en_cp)intersect{0} && 
binsof(underflow_cp)intersect{1} 
;} 
 
//ignored when wr_en=0 with wr_ack =1 not important 
wr_ack_cross: cross wr_en_cp, rd_en_cp, wr_ack_cp{ 
    ignore_bins not_wren_wrack = binsof(wr_en_cp)intersect{0} && 
binsof(wr_ack_cp)intersect{1} 
;} 
 
endgroup     
 
function new(); 
 FIFOcg =new(); 
endfunction 
 
function void sample_data(input FIFO_transaction F_txn); 
 F_cvg_txn=F_txn; 
 FIFOcg.sample(); 
endfunction 
endclass 
endpackage