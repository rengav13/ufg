onerror {quit -f}
vlib work
vlog -work work teste_GSM.vo
vlog -work work teste_GSM.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.teste_GSM_vlg_vec_tst
vcd file -direction teste_GSM.msim.vcd
vcd add -internal teste_GSM_vlg_vec_tst/*
vcd add -internal teste_GSM_vlg_vec_tst/i1/*
add wave /*
run -all
