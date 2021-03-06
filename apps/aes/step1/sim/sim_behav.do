vlib work
vlog $env(HFHOME)/apps/aes/step1/rtl/*.v
vlog $env(HFHOME)/common/regchain.v
vlog $env(HFHOME)/apps/aes/step1/testbench/test_aes_256.v
cp $env(HFHOME)/apps/aes/step1/testcase_generator/plaintext ./
cp $env(HFHOME)/apps/aes/step1/testcase_generator/cipher ./
cp $env(HFHOME)/apps/aes/step1/testcase_generator/key ./
vsim test_aes_256
run -all
quit -code 1
