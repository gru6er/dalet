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

        QuitEXT=("avi" "asf" "wmv" "flv" "mkv" "mov" "mp4" "m4v" "bdmv" "mxf" "webm" "bik" "divx" "mpg" "mpeg" "ts" "m2ts" "mts" "vob" "ifo" "m2v" "3gp" "3g2" "3gp2" "3gpp" "ogm" "ogv" "rm" "rmvb" "mp3" "aac" "wma" "flac" "m4a" "mka" "mp2" "mpa" "mpc" "ape" "ofr" "ogg" "ac3" "dts" "ra" "wv" "tta" "mid" "wav" "cda" "amr" "mod" "xm" "opus" "m2p")

        if echo "${QuitEXT[@]}" | grep -qw "$ext"; then

                :

        else

        zenity --error --text="Смотри, что выделяешь!!! Это не видео!" --title="RIKRZ СООБЩАЕТ" --timeout=5

                exit 1

        fi

        if [ $ext == "m2p" ] ; then

                file_name=${file_name//m2p/mpg}

        fi

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

        e=$Folder$folder_name

        AudioEXT=("mp3" "aac" "wma" "flac" "m4a" "mka" "mp2" "mpa" "mpc" "ape" "ofr" "ogg" "ac3" "dts" "ra" "wv" "tta" "mid" "wav" "cda" "amr" "mod" "xm" "opus")

        if echo "${AudioEXT[@]}" | grep -qw "$ext"; then

                new_filename=${new_filename//$ext/mp4}

                ffmpeg -loop 1 -i /home/$USER/Videos/gcp.jpg -i $var  -s 1920x1080 -c:v libx264 -c:a aac -b:a 192k -shortest -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" $e$new_filename

        else

                cp "$var" "$e"$new_filename

        fi

#        echo $(date +%x%t%T) \< "$new_filename" \> >> $Folder/quant_log.txt

done

zenity --info --text="Ты скопировал в QUANTEL: \n$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" --title="RIKRZ СООБЩАЕТ" --timeout=5

