onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Sim
add wave -noupdate -label clk /fifo_dclk_tb/sim_clk
add wave -noupdate -label {fifo in} -radix unsigned /fifo_dclk_tb/sim_fifo_in_data
add wave -noupdate -label {fifo wr en} /fifo_dclk_tb/sim_fifo_wr_en
add wave -noupdate -label {fifo rd en} /fifo_dclk_tb/sim_fifo_rd_en
add wave -noupdate -divider {fifo out}
add wave -noupdate -label full /fifo_dclk_tb/fifo_full
add wave -noupdate -label empty /fifo_dclk_tb/fifo_empty
add wave -noupdate -color {Slate Blue} -label {out data} -radix unsigned /fifo_dclk_tb/fifo_out_data
add wave -noupdate -label {rd addr} -radix unsigned /fifo_dclk_tb/I_FIFO/rd_addr
add wave -noupdate -label {wr addr} -radix unsigned /fifo_dclk_tb/I_FIFO/wr_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {180 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {137 ns} {230 ns}
