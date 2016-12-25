#!/usr/bin/env bash

#Set the following variables as associative arrays
declare -A translateFrom
declare -A wordToTranslate
declare -A translationsFound
declare -A inputLang
declare -A outputLang

defaultFromLang="en"
defaultToLang="it"
defaultIntfLang="en" # Default language for interface

# Location of the scripts
LOCATION="${HOME}/.config/scripts/wordreference/"

interfaceLanguage[1]="en"   # English
interfaceLanguage[2]="it"   # Italian
interfaceLanguage[3]="fr"   # French
interfaceLanguage[4]="es"   # Spanish


# Translation strings
#inputLang["en"]="English"
#inputLang["it"]="Italiano"
#inputLang["fr"]="Français"
#inputLang["es"]="Español"
#outputLang["en"]="English"
#outputLang["it"]="Italiano"
#outputLang["fr"]="Français"
#outputLang["es"]="Español"

translateFrom["en"]="Translate from: "
translateFrom["it"]="Traduci da: "
translateFrom["fr"]="Traduire de: "
translateFrom["es"]="Traducir de: "

wordToTranslate["en"]="Word to translate: "
wordToTranslate["it"]="Parola da tradurre: "
wordToTranslate["fr"]="Mot à traduire: "
wordToTranslate["es"]="Palabra para traducir: "

translationsFound["en"]="Translations: "
translationsFound["it"]="Traduzioni: "
translationsFound["fr"]="Traductions: "
translationsFound["es"]="Traducciones: "

for i in "${!translateFrom[@]}"; do
    if [[ $i == $1 ]]; then
        defaultIntfLang=$i
    fi
done

# If no source language is selected, use the default one
if [[ $2 == "" ]]; then
    fromLang=$defaultFromLang
else
    fromLang=$2
fi

# If no destination language is selected, use the default one
if [[ $3 == "" ]]; then
    tolang=$defaultToLangP
else
    tolang=$3
fi

#Menu language selection to/from - still to code
#lang=$(echo -e "English|Italian" | rofi -fuzzy -i -markup-rows -sep '|' -dmenu -p "${translateFrom[$defaultIntfLang]}")
toTranslate=$(echo -e " " | rofi -dmenu -p "${wordToTranslate[$defaultIntfLang]}")
"$LOCATION/./wordreference.py" "$fromLang$tolang" "$toTranslate" | rofi -markup-rows -i -dmenu -p "${translationsFound[$defaultIntfLang]}"
