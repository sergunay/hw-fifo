set_property SRC_FILE_INFO {cfile:/home/serg/Dropbox/ws/eda/freak_mean_intensity/VIVADO/CONSTR/top.xdc rfile:../../../../CONSTR/top.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:1 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 10.000 -name clk_100 -waveform {0.000 5.000} [get_ports iClk]
