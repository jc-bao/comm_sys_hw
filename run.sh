rm -r results
mkdir results
iverilog -o results/test.vvp test.v
vvp results/test.vvp