# WR-translator
A set of scripts to quickly translate words from/to english to your native language and vice versa inside Rofi launcher.

# Disclaimer
I am by no means a Bash or Python scripting guru. The code can be improved for sure in some ways.

This is a home-made project I did to have quick access to translations from english to italian (my own language), and was further extended to support the main other languages available on Wordreference.

Feel free to fork, modify and suggest improvements.

**No guarantees on keeping this project up to date are given** as this is done during my free time.

# Requirements

  + Rofi
  + Bash >= 4.0
  + Python 3
  + BeautifulSoup 4

# Usage
The shell script takes as input 3 parameters (default ones in bold):

  + *Language Interface*: it, **en**, fr, es
  + *Source Language*: it, **en**, fr, es
  + *Target Language:* en (if **it**/fr/es is chosen) or it/fr/es (if en is chosen) 

You can translate quickly, using **Rofi**, any word in the given language to the other target language.

# Examples
**Translate from default source language to default target language, use default interface language:**

    # The word to translate will be input through Rofi
    bash wordreference.sh

**Translate from spanish to english, spanish interface language:**

    bash wordreference.sh es es en

**Translate from italian to spanish, italian interface language:**

    bash wordreference.sh it it es

This produces an *error* as *non-english to non-english* language translation is not supported:

    wordreference.sh <interfaceLanguage> <sourceLanguage> <targetLanguage>

    <interfaceLanguage> can be:
        - 'en' 'it' 'fr' 'es'
    <sourceLanguage> can be:
        - 'en' 'it' 'fr' 'es'
    <targetLanguage> can be:
        - 'en' (if 'it' 'fr' or 'es' is selected as sourceLanguage)
        - 'it' 'fr' 'es' (if 'en' is selected as sourceLanguage)
