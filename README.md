# Reference
The original code is from
https://github.com/vocho/openqnx

Forked from 
https://github.com/askac/dumpifs

# Methods
Please refer to https://github.com/askac/dumpifs

# Libraries required for Linux
sudo apt-get install liblzo2-2

sudo apt-get install libucl-dev

sudo apt-get install liblz4-dev

# Typical usage
decompress an ifs image

./dumpifs compressed.ifs -u uncompressed.ifs

decompress and dump an ifs image into a directory

./dumpIfs.sh compressed.ifs uncompressed-ifs-directory/

compress an ifs image 

./packifs 260 uncompressed.ifs compresseed.ifs lzo


