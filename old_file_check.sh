#!/bin/bash

# ダウンロードフォルダを指定
dirs=`ls ~/Downloads/*.*`

# ダウンロードフォルダ内の最古のファイルを検索する
old_file=$(ls -lt ~/Downloads/*.* | tail -n 1 | gawk '{print $9}')
old_time_stamp=$(date '+%Y-%m-%d %H:%M ' -r $old_file)

echo -e '最古のファイルは' $old_file $old_time_stamp'です！\n' 

# 削除するファイルの年月を入力（不正な値をチェックする）
echo -n 'ダウンロードフォルダで削除するファイルの年月を入力して下さい(yyyymm):'

while read now
do
    expr "$now" + 1 >&/dev/null
    if [ $? -eq 2 ]; then
        echo '入力エラー数字以外の文字が入力されました'
        echo -n 'ダウンロードフォルダで削除するファイルの年月を入力して下さい(yyyymm):'
        continue
    fi
    if [ ${#now} -ne 6 ]; then
        echo '文字数エラー'
        echo -n 'ダウンロードフォルダで削除するファイルの年月を入力して下さい(yyyymm):'
        continue
    fi
    check=$(echo ${now} | cut -c 5-)
    if [ $((check)) -gt 12 ]; then
        echo '入力エラー不正な月です'
        echo -n 'ダウンロードフォルダで削除するファイルの年月を入力して下さい(yyyymm):'
        continue
    fi
    break
done

# 指定年月のファイルを１ファイルずつ表示し、削除するか、削除しないかを問い合わせる
for file in $dirs;
do
    time_stamp=$(date '+%Y%m' -r $file)
    if [ $((time_stamp)) -ne $((now)) ]; then
        continue
    fi
    time_stamp=$(date '+%Y-%m-%d %H:%M' -r $file)
    echo -e '\n' $file $time_stamp
    echo -n '削除しますか(y or n)？'
    read yes_or_no
    if [ $yes_or_no = 'y' ]; then
        rm $file
        echo -e '削除しました！\n'
    fi
done

echo -e '\n削除するファイルはありません！'
