vlib work
vlog $env(HFHOME)/apps/aes/step7/rtl/*.v
vlog $env(HFHOME)/common/regchain.v
vlog $env(HFHOME)/apps/aes/step7/testbench/test_aes_256.v
cp $env(HFHOME)/apps/aes/step7/testcase_generator/plaintext ./
cp $env(HFHOME)/apps/aes/step7/testcase_generator/cipher ./
cp $env(HFHOME)/apps/aes/step7/testcase_generator/key ./
vsim test_aes_256
run -all
quit -code 1
