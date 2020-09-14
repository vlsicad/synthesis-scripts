#!/bin/sh
echo "createing dirs"

cp ./* /usr/synopsys/code_temp/
rm ./*

mkdir ./code
cp /usr/synopsys/code_temp/* ./code/
rm /usr/synopsys/code_temp/*

mkdir ./dc45
mkdir ./dc90
mkdir ./enc
mkdir ./icc
mkdir ./ncl
mkdir ./pt
mkdir ./rtl
mkdir ./temp
mkdir ./WORK
mkdir ./results

cp /home/vlsi/libfortech/scripts/dc45/*  ./dc45/
cp /home/vlsi/libfortech/scripts/dc90/*  ./dc90/
cp /home/vlsi/libfortech/scripts/enc/*   ./enc/
cp /home/vlsi/libfortech/scripts/icc/*   ./icc/
cp /home/vlsi/libfortech/scripts/ncl/*   ./ncl/
cp /home/vlsi/libfortech/scripts/pt/*    ./pt/
cp /home/vlsi/libfortech/scripts/rtl/*   ./rtl/


echo " all done ! "

#design_vision
