vlib work
vlog $env(HFHOME)/apps/aes/step6/rtl/*.v
vlog $env(HFHOME)/common/regchain.v
vlog $env(HFHOME)/apps/aes/step6/testbench/test_aes_256.v
cp $env(HFHOME)/apps/aes/step6/testcase_generator/plaintext.txt ./
cp $env(HFHOME)/apps/aes/step6/testcase_generator/cipher.txt ./
cp $env(HFHOME)/apps/aes/step6/testcase_generator/key.txt ./
vsim test_aes_256
run -all
quit -code 1
