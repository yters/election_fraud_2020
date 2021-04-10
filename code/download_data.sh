#!/bin/sh
grep zip info/ncvhis_zip_urls.txt | sed 's/.*\(http.*zip\)".*$/\1/g' | xargs -I {} wget -P data/ {}
grep zip info/ncvoter_zip_urls.txt | sed 's/.*\(http.*zip\)".*$/\1/g' | xargs -I {} wget -P data/ {}
