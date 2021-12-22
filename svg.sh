TOP=top
ghdl -a --std=08 ${TOP}.vhdl
yosys -p "ghdl --std=08 ${TOP}; prep -top ${TOP}; write_json -compat-int svg.json"
netlistsvg svg.json -o svg/${TOP}.svg
