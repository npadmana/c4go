#!/bin/bash

mkdir -p tmp
cp $2 tmp/
cd tmp
ar x $2
$1 $4 $5 $6 $7 $8 $9  -o $3 *.o*
mv $3 ..
cd ..
rm -rf tmp
