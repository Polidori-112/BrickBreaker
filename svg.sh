#!/bin/sh

PROGRAM_NAME=brick
set -ex

export PATH=/home/polidori/.local/FPGA/bin/:$PATH

ghdl -a --std=08 *.vhdl

yosys -p "ghdl --std=08 ${PROGRAM_NAME}; prep -top ${PROGRAM_NAME}; write_json svg.json"

~/node_modules/.bin/netlistsvg svg.json -o ${PROGRAM_NAME}.svg
