vlib work
vlog $env(HFHOME)/apps/sha1/baseline/rtl/*.v
vlog $env(HFHOME)/apps/sha1/baseline/tb/tb_sha1_core.v
vsim tb_sha1_core
run -all
quit -code 1
