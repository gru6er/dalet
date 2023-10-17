#!/bin/bash

# Copy this script into /home/$USER/.local/share/nautilus/scripts/

set -E

MEDIA_FOLDER="/home/$USER/Videos/"

IFS=$'\n'

for VAR in $(echo "${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}")

    do

        FOLDER_NAME=$(basename $(dirname "${VAR}"))_

        FILENAME=$(basename "${VAR}" | sed 's/[[:upper:]]*/\L&/g')

        FILENAME="${FILENAME// /_}"

        if [[ -z $(echo "${FILENAME}" | grep '\.') ]]; then

            zenity --error --text="Смотри, что выделяешь! Я тебе не Ванга! Где расширение файла?!" --title="RIKRZ СООБЩАЕТ" --timeout=5

            exit 1

        fi

        EXT="${VAR##*.}"

        QUIT_EXT=("avi" "asf" "wmv" "flv" "mkv" "mov" "mp4" "m4v" "bdmv" "mxf" "webm" "bik" "divx" "mpg" "mpeg" "ts" "m2ts" "mts" "vob" "ifo" "m2v" "3gp" "3g2" "3gp2" "3gpp" "ogm" "ogv" "rm" "rmvb" "mp3" "aac" "wma" "flac" "m4a" "mka" "mp2" "mpa" "mpc" "ape" "ofr" "ogg" "ac3" "dts" "ra" "wv" "tta" "mid" "wav" "cda" "amr" "mod" "xm" "opus" "m2p")

        if echo "${QUIT_EXT[@]}" | grep -qw "${EXT}"; then

                :

        else

        zenity --error --text="Смотри, что выделяешь!!! Это не видео!" --title="RIKRZ СООБЩАЕТ" --timeout=5

                exit 1

        fi

        if [ "${EXT}" == "m2p" ] ; then

                FILENAME="${FILENAME//m2p/mpg}"

        fi

        NEW_FILENAME=`echo $FILENAME | sed "y/абвгдезийклмнопрстуфхцы/abvgdezijklmnoprstufhcy/"`
        NEW_FILENAME=${NEW_FILENAME//ч/ch};
        NEW_FILENAME=${NEW_FILENAME//ш/sh};
        NEW_FILENAME=${NEW_FILENAME//ё/jo};
        NEW_FILENAME=${NEW_FILENAME//ж/zh};
        NEW_FILENAME=${NEW_FILENAME//щ/shch};
        NEW_FILENAME=${NEW_FILENAME//э/je};
        NEW_FILENAME=${NEW_FILENAME//ю/ju};
        NEW_FILENAME=${NEW_FILENAME//я/ja};
        NEW_FILENAME=${NEW_FILENAME//ъ/};
        NEW_FILENAME=${NEW_FILENAME//ь/}

        E="${MEDIA_FOLDER}""${FOLDER_NAME}"

        AUDIO_EXT=("mp3" "aac" "wma" "flac" "m4a" "mka" "mp2" "mpa" "mpc" "ape" "ofr" "ogg" "ac3" "dts" "ra" "wv" "tta" "mid" "wav" "cda" "amr" "mod" "xm" "opus")

        if echo "${AUDIO_EXT[@]}" | grep -qw "${EXT}"; then

                NEW_FILENAME="${NEW_FILENAME//$EXT/mp4}"

                ffmpeg -loop 1 -i /home/$USER/Videos/gcp.jpg -i "${VAR}"  -s 1920x1080 -c:v libx264 -c:a aac -b:a 192k -shortest -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" "${E}""${NEW_FILENAME}"

        else

                cp "${VAR}" "${E}""${NEW_FILENAME}"

        fi

#        echo $(date +%x%t%T) \< "$NEW_FILENAME" \> >> $MEDIA_FOLDER/quant_log.txt

done

zenity --info --text="Ты скопировал в QUANTEL: \n${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}" --title="RIKRZ СООБЩАЕТ" --timeout=5

