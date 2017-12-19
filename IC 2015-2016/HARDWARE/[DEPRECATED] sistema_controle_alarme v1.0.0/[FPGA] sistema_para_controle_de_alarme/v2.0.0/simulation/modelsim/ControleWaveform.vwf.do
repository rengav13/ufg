vlog -work work C:/Users/Wagner/Documents/ufg/iniciação cientifica -2015-1 - FPGA/Projeto/Sistema para controle de alarme/simulation/modelsim/ControleWaveform.vwf.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.controle_vlg_vec_tst
onerror {resume}
add wave {controle_vlg_vec_tst/i1/clk}
add wave {controle_vlg_vec_tst/i1/button}
add wave {controle_vlg_vec_tst/i1/comunication}
add wave {controle_vlg_vec_tst/i1/crianca}
add wave {controle_vlg_vec_tst/i1/state}
add wave {controle_vlg_vec_tst/i1/state[4]}
add wave {controle_vlg_vec_tst/i1/state[3]}
add wave {controle_vlg_vec_tst/i1/state[2]}
add wave {controle_vlg_vec_tst/i1/state[1]}
add wave {controle_vlg_vec_tst/i1/state[0]}
run -all
