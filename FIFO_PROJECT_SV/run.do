vlib work
vlog  +define+SIM -f src_files.list +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover

add wave *  
run 0 
add wave -position insertpoint sim:/FIFO_top/fifoif/* 
add wave -position insertpoint sim:/FIFO_top/DUT/* 
coverage save fifo.ucdb -onexit   
run -all 