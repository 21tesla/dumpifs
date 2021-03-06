#!/bin/sh
ucltool=`dirname $0`/uuu
lzotool=`dirname $0`/zzz
compressUse=$ucltool

fixdecifs=`dirname $0`/fixdecifs
fixencifs=`dirname $0`/fixencifs

tempBody=__temp__B
tempBody2=__temp__B2

if [ $# -lt 3 ];then
cat << EOF
Usage: $0 <head offset(dec)> <decompressed.ifs> <destination ifs> [format: ucl|lzo]
head offset could be found when dump a ifs file.
EOF
exit
fi

if [ $1 -lt 260 ];then
echo "Invalid offset. Atleast 260"
exit
fi

offsetH=$1
srcIfs=$2
dstIfs=$3

if [ -e $tempBody ];then
echo "Temperate file $tempBody exist!"
exit
fi

if [ -e $tempBody2 ];then
echo "Temperate file $tempBody2 exist!"
exit
fi

if [ -e $dstIfs ];then
echo "Destination file $dstIfs exist!"
exit
fi


if [ "x$4" = "xucl" ]
then
packuse=1
echo "Pack using ucl"
elif [ "x$4" = "xlzo" ]
then
packuse=2
echo "Pack using lzo"
else

cat << EOF
Compress method?
1. ucl
2. lzo
EOF

read packuse

fi

if [ "$packuse" -lt 1 -o "$packuse" -gt 2 ];then
	echo "Invalid option $packuse"
	exit
fi


if [ $packuse -eq 1 ];then
	compressUse=$ucltool
fi

if [ $packuse -eq 2 ];then
	compressUse=$lzotool
fi


echo "Fix checksum of decompressed"
$fixdecifs $srcIfs Y

echo "Select $packuse . Use compress tool $compressUse"

dd if=$srcIfs of=$dstIfs bs=$offsetH count=1
dd if=$srcIfs of=$tempBody bs=$offsetH skip=1
$compressUse $tempBody $tempBody2

echo "Add padding"
echo -n "0000" | xxd -r -p >> $tempBody2

echo "Compress using $compressUse done."
echo "Packing $dstIfs"
dd of=$dstIfs if=$tempBody2 bs=$offsetH seek=1

finalSize=`du -b $dstIfs | awk '{print($1)}'`
if [ 0 != $(($finalSize %4)) ]
then
	padlen=$((4 - ($finalSize %4) + 4))
else
	padlen=4
fi
echo "finalSize is $finalSize  padlen is $padlen"

finalSize=`du -b $dstIfs | awk '{print($1)}'`
dd if=/dev/zero of=$dstIfs bs=1 count=$padlen seek=$finalSize

$fixencifs $dstIfs Y

echo "Done"
rm $tempBody
rm $tempBody2
ls -l $dstIfs
