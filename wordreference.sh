#!/usr/bin/env bash

#Set the following variables as associative arrays
declare -A translateFrom
declare -A wordToTranslate
declare -A translationsFound
declare -A inputLang
declare -A outputLang

# Location of the python script
LOCATION="${HOME}/.config/scripts/wordreference/"

function printHelp {
    echo -e "wordreference.sh <interfaceLanguage> <sourceLanguage> <targetLanguage>\n"
    echo -e "<interfaceLanguage> can be:\n\t- 'en' 'it' 'fr' 'es'"
    echo -e "<sourceLanguage> can be:\n\t- 'en' 'it' 'fr' 'es'"
    echo -e "<targetLanguage> can be:\n\t- 'en' (if 'it' 'fr' or 'es' is selected as sourceLanguage)\n\t- 'it' 'fr' 'es' (if 'en' is selected as sourceLanguage)"
}

function checkAllowedLanguages {
        for arg in "$@"; do
            if [[ "$arg" != "en" && "$arg" != "it" && "$arg" != "fr" && "$arg" != "es" ]]; then
                printHelp
                exit
            fi
        done    
}

function checkFromToLangs {
    # Deny translation:
    #   - from non-english to non-english language
    #   - when source language is equal to target language 
    if [[ ( ( "$1" == 'it' || "$1" == 'fr' || "$1" == 'es' ) && "$2" != 'en' ) || ( "$1" == "$2" )  ]]; then
        printHelp
        exit
    fi
}

function setLanguages {

    # If all 3 params (interface language, source language, target language) are provided
    if [[ ! -z "$1" && ! -z "$2" && ! -z "$3" ]]; then
        checkAllowedLanguages $1 $2 $3
        DEF_INTF_LANG="$1"
        DEF_FROM_LANG="$2"
        DEF_TO_LANG="$3"
    # If only 2 params (interface language, source language) are provided
    elif [[ ! -z "$1" && ! -z "$2" && -z "$3" ]]; then
        checkAllowedLanguages $1 $2
        DEF_INTF_LANG="$1"
        DEF_FROM_LANG="$2"
    # If only 1 params (interface language) is provided
    elif [[ ! -z "$1" && -z "$2" && -z "$3" ]]; then
        checkAllowedLanguages $1
        DEF_INTF_LANG="$1"
    # Check anyway the default settings, might have been changed by end-user
    elif [[ ! -z "$1" && ! -z "$2" && -z "$3" ]]; then
        checkAllowedLanguages $1 $2 $3
        DEF_INTF_LANG="$1"
        DEF_FROM_LANG="$2"
    fi
    checkFromToLangs $DEF_FROM_LANG $DEF_TO_LANG
}

DEF_FROM_LANG="en"    # Default source language
DEF_TO_LANG="it"      # Default target language
DEF_INTF_LANG="en"    # Default language for interface

#interfaceLanguage[1]="en"   # English
#interfaceLanguage[2]="it"   # Italian
#interfaceLanguage[3]="fr"   # French
#interfaceLanguage[4]="es"   # Spanish

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

setLanguages "$1" "$2" "$3"

# Translation strings
#inputLang["en"]="English"
#inputLang["it"]="Italiano"
#inputLang["fr"]="Français"
#inputLang["es"]="Español"
#outputLang["en"]="English"
#outputLang["it"]="Italiano"
#outputLang["fr"]="Français"
#outputLang["es"]="Español"


fromLang=$DEF_FROM_LANG
toLang=$DEF_TO_LANG

toTranslate=$(echo -e " " | rofi -dmenu -p "${wordToTranslate[$DEF_INTF_LANG]}")
"$LOCATION/./wordreference.py" "$fromLang$toLang" "$toTranslate" | rofi -markup-rows -i -dmenu -p "${translationsFound[$DEF_INTF_LANG]}"
