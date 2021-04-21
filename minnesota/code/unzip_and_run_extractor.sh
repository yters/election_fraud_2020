#!/bin/sh

county=`grep -B 1 ncvoter$1.zip info/ncvoter_zip_urls.txt | head -n 1 | sed 's/<..>//' | sed 's/<...>//'`
echo unzipping $county
unzip -o data/ncvoter$1.zip -d data/
unzip -o data/ncvhis$1.zip -d data/
RScript code/extract_features.r $county $1
echo cleaning up datafiles
rm data/ncvoter$1.txt
rm data/ncvhis$1.txt
