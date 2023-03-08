#!/bin/bash -eu

# URL sample: "https://meetia.net/column/arismukaide-column-3/2/"
ORG_IFS=$IFS

function get_html_path(){
    refpg_url=$1
    to_page=(${refpg_url//\//\ })
    to_page=${to_page[-1]}
    # ジャンプ先htmlのローカルパス取得
    IFS="\n"
    to_html=(`ls ../page$to_page | grep .html`)
    IFS=$ORG_IFS
    if [ ${#to_html[@]} -gt 1 ]; then
        echo There should be no more than one html.
        exit 1
    else
        to_html="${to_html[0]}"
    fi
    echo $to_page*$to_html
}

for vol in `seq 1 11`
do
    cd $vol
    pages=`ls | grep page | wc -l`
    if [ $pages -ge 2 ]; then
        for page in `seq 1 $pages`
        do
            cd page$page
            echo vol. $vol, page $page

            now_html=`ls | grep .html`
            echo $now_html

            # 次のページへ ボタン
            nextpg_url=`cat non-img_list.txt | grep -xE "https://meetia.net/column/arismukaide-column-$vol/./"`
            next_info=`get_html_path $nextpg_url`
            IFS="*"
            next_info=($next_info)
            IFS=$ORG_IFS
            next_pg=${next_info[0]}
            next_html="${next_info[1]}"
            echo "$nextpg_url -> ../page$next_pg/$next_html"
            #sed -i -e "s;$nextpg_url;../page$next_pg/$next_html;g" "$now_html"

            # 前のページへ ボタン
            prepg_url=`cat non-img_list.txt | grep -xE "https://meetia.net/column/arismukaide-column-$vol/"`
            pre_info=`get_html_path ${prepg_url}1/`
            IFS="*"
            pre_info=($pre_info)
            IFS=$ORG_IFS
            pre_pg=${pre_info[0]}
            pre_html=${pre_info[1]}
            echo "$prepg_url -> ../page$pre_pg/$pre_html"
            #sed -i -e "s;$prepg_url;../page$pre_pg/$pre_html;g" "$now_html"

            # それ以外のボタン
            for i in `seq 1 11`
            do
                url="https://meetia.net/column/arismukaide-column-$i/"
                html=`ls ../../$i/page1/. | grep .html`
                echo "$url -> ../../$i/page1/$html"
                #sed -i -e "s;$url;../../$i/page1/$html;g" "$now_html"
                doll="https://meetia.net/fashion/atashi_doll_project/"
                to="../../pre11/page1/「あたしをドールにしてください」叶わなかった卒展・ショー作品をここに。 _ ミーティア(MEETIA).html"
                sed -i -e "s;$doll;$to;g" "$now_html"

                index="https://meetia.net/author/arismukaide/"
                to="../../index/arismukaide, ミーティア(MEETIA) 投稿者.html"
                sed -i -e "s;$index;$to;g" "$now_html"
            done

            cd ..
        done
    else
        cd page1
        now_html=`ls | grep .html`
        echo $now_html
        # それ以外のボタン
        for i in `seq 1 11`
        do
            url="https://meetia.net/column/arismukaide-column-$i/"
            html=`ls ../../$i/page1/. | grep .html`
            echo "$url -> ../../$i/page1/$html"
            sed -i -e "s;$url;../../$i/page1/$html;g" "$now_html"
            doll="https://meetia.net/fashion/atashi_doll_project/"
            to="../../pre11/page1/「あたしをドールにしてください」叶わなかった卒展・ショー作品をここに。 _ ミーティア(MEETIA).html"
            sed -i -e "s;$doll;$to;g" "$now_html"

            index="https://meetia.net/author/arismukaide/"
            to="../../index/arismukaide, ミーティア(MEETIA) 投稿者.html"
            sed -i -e "s;$index;$to;g" "$now_html"
        done
        cd ..
    fi
    cd ..
done

exit 0
