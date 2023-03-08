#!/bin/bash -eu

# URL sample: "https://meetia.net/column/arismukaide-column-3/2/"
now_html=`ls | grep .html`
echo $now_html

index="https://meetia.net/author/arismukaide/"
to="../../index/arismukaide, ミーティア(MEETIA) 投稿者.html"
sed -i -e "s;$index;$to;g" "$now_html"

cd ..

exit 0
