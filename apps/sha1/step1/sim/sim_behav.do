vlib work
vlog $env(HFHOME)/apps/sha1/step1/rtl/*.v
vlog $env(HFHOME)/common/regchain.v
vlog $env(HFHOME)/apps/sha1/step1/tb/tb_sha1_core.v
vsim tb_sha1_core
run -all
quit -code 1
