vlib work
vlog $env(HFHOME)/apps/aes/baseline/rtl/*.v
vlog $env(HFHOME)/apps/aes/baseline/testbench/test_aes_256.v
cp $env(HFHOME)/apps/aes/baseline/testcase_generator/plaintext.txt ./
cp $env(HFHOME)/apps/aes/baseline/testcase_generator/cipher.txt ./
cp $env(HFHOME)/apps/aes/baseline/testcase_generator/key.txt ./
vsim test_aes_256
run -all
quit -code 1
