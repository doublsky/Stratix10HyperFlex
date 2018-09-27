vlib work
vlog $env(HFHOME)/apps/aes/step5/rtl/*.v
vlog $env(HFHOME)/common/regchain.v
vlog $env(HFHOME)/apps/aes/step5/testbench/test_aes_256.v
cp $env(HFHOME)/apps/aes/step5/testcase_generator/plaintext ./
cp $env(HFHOME)/apps/aes/step5/testcase_generator/cipher ./
cp $env(HFHOME)/apps/aes/step5/testcase_generator/key ./
vsim test_aes_256
run -all
quit -code 1
