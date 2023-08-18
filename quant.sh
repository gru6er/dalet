#!/bin/bash

# Copy this script into /home/$USER/.local/share/nautilus/scripts/

set -e

Folder="/home/$USER/Videos/"

IFS=$'\n'

for var in $(echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS")
    do
        folder_name=$(basename $(dirname "$var"))_

        file_name=$(basename "$var" | sed 's/[[:upper:]]*/\L&/g')

        file_name=${file_name// /_}

        if [[ -z $(echo $file_name | grep '\.') ]]; then

            zenity --error --text="Смотри, что выделяешь! Я тебе не Ванга! Где расширение файла?!" --title="RIKRZ СООБЩАЕТ" --timeout=5
            exit 1
        fi

        ext=${var##*.}

        QuitEXT=("doc" "exe" "rar" "zip" "rtf" "pdf" "txt" "docx" "inf" "xls" "xmp" "pek" "cfa" "index" "html" "xlsx" "tar" "7z" "gzip" "htm" "iso" "torrent" "djvu" "fb2")

        for i in ${QuitEXT[@]}; do

            if [ $ext = $i ]; then

                zenity --error --text="Смотри, что выделяешь!!! Это не видео!" --title="RIKRZ СООБЩАЕТ" --timeout=5
                exit 1
            fi
        done

        new_filename=`echo $file_name | sed "y/абвгдезийклмнопрстуфхцы/abvgdezijklmnoprstufhcy/"`
        new_filename=${new_filename//ч/ch};
        new_filename=${new_filename//ш/sh};
        new_filename=${new_filename//ё/jo};
        new_filename=${new_filename//ж/zh};
        new_filename=${new_filename//щ/shch};
        new_filename=${new_filename//э/je};
        new_filename=${new_filename//ю/ju};
        new_filename=${new_filename//я/ja};
        new_filename=${new_filename//ъ/};
        new_filename=${new_filename//ь/}

        e=$Folder$folder_name$new_filename

        cp "$var" "$e"

        echo $(date +%x%t%T) \< "$new_filename" \> >> $Folder/quant_log.txt

done

zenity --info --text="Ты скопировал в QUANTEL: \n$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" --title="RIKRZ СООБЩАЕТ" --timeout=5

